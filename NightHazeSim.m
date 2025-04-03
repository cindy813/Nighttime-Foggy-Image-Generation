clear
close all
clc

%%
% 针对夜晚室外图像的雾气模拟
I=imread('TestImg/t8.png');
%depth=imread('image001.png');
depth=imread('TestImg/t8_d.png');
if size(depth,3)==3
    depth=rgb2gray(depth);
end
subplot(1,3,1),imshow(I);
%figure,imshow(I);
title('Original Fog-free Image');

%subplot(2,2,2),imshow(depth);
%title('深度图');

%% 
% Intrinsic Image Decomposition
I1 = im2double(I); 
[R S] = Intrinsic_Relsmo(I1, 2);
% subplot(2,2,3),imshow(R);
% title('反射图');

% subplot(2,2,4),imshow(S);
% title('照度图');

%% 
pert_perlin = 0;
airlight=0.75; % The default value is 0.76
% Default beta parameter corresponding to visual range of 1000m
beta_param = 6.18; 
A = zeros(1,1,3);
A(1,1,1) = airlight; 
A(1,1,2) = airlight; 
A(1,1,3) = airlight;
% The visual range that can be adjusted.
% visual_range = [0.001-1]; % The visual range in km
% For single value, the samller the value, the larger the fog density. Visual_range = [0.001-1]
% visual_range = [0.05,0.1,0.2,0.5,1]; % km为单位，可选择的取值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VR = 0.01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I0 = im2double(I);

%%
%for VR = visual_range
    fprintf('Simulating hazy image by using atmospheric sacttering model\n');
    fprintf('Viusal range: %.3f km\n',VR);
    %I0 = im2double(I);
    %convert sRGB to linear RGB
    I = srgb2lrgb(I0);
    
    depth=1-im2double(depth);
    %imwrite(depth,'t15_d2.jpg');
    %convert meter to kilometer
    d = depth/1000;
        
    %Set regions where depth value is set to 0 to indicate no valid depth to
    %a distance of two times the visual range. These regions typically
    %correspond to sky areas
    d(d==0) = 2*VR; 
    
    %	Add perlin noise for visual vividness. The noise is added to the depth 
    %	map, which is equivalent to change the optic distance. 
    if pert_perlin
        d= d.*((perlin_noise(zeros(size(d)))-0.5)+1);
    end
    
     %convert depth map to transmission
     beta = [beta_param/VR,beta_param/VR,beta_param/VR];
     beta = reshape(beta,[1,1,3]);
     transmission = exp(bsxfun(@times,-beta,d));
        
     % Obtain simulated linear RGB hazy image. Eq. 3 in the HazeRD paper
     Ic = bsxfun(@times,transmission,I)+bsxfun(@times,1-transmission,A);
    
     % convert linear RGB to sRGB
     I2 = lrgb2srgb(Ic);

     %figure,imshow(I2);
     subplot(1,3,2),imshow(I2);
     title('Simulation Result Based on ASM');
     %imwrite(I2,'TestImg/t20_HazeRD_0.01.png');
%%
    fprintf('Simulating hazy image by using semi-analytic model\n');
    fprintf('Viusal range: %.3f km\n',VR);
    LumComp1=S;
    
    LumComp2 = glow_Gen(LumComp1);
%     figure,imshow(LumComp2);
%     title('点扩散处理后的照射图');
    %imwrite(LumComp2,'t1_LumComp.png');

    pa=0.7; % 值越大，图像越亮。
    L2=im2double(LumComp2);
    L2_max=max(L2(:));L2_min=min(L2(:));
    L3=(L2-L2_min)*(L2_max-L2_min);
    L_Final = L3*(1-pa)+bsxfun(@times,transmission,((pa*R).*I1))+bsxfun(@times,1-transmission,A);

    subplot(1,3,3),imshow(L_Final);
    title('Our Nighttime Fog Effect');
    %imwrite(L_Final,'TestImg/t20_Oursim2_0.01.png');
%end

%%
% 颜色空间变换。linear RGB颜色空间中的颜色值是线性的，而sRGB颜色空间中的颜色值经过了伽马校正，以更好地适应人眼的感知特性。
function I = srgb2lrgb(I0)
    I = ((I0+0.055)/1.055).^(2.4);  
    I(I0<=0.04045) = I0(I0<=0.04045)/12.92;
end

function I2 = lrgb2srgb(I1)
    I2 = zeros(size(I1));
    for k = 1:3
        temp = I1(:,:,k);
        I2(:,:,k) = 12.92*temp.*(temp<=0.0031308)+(1.055*temp.^(1/2.4)-0.055).*(temp>0.0031308);
    end
end