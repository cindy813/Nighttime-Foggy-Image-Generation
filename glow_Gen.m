function I = glow_Gen(clean_img)

%clean_img = im2double(imread('t1_shading.jpg'));
clean_img = cat(3,clean_img,clean_img,clean_img);
reH = 320; reW = 256;
addnoise = true;
[H,W]=size(clean_img);
W=W/3;

if size(clean_img,1) > size(clean_img,2)
    clean_img = imresize(clean_img,[reW, reH]); 
else
    clean_img = imresize(clean_img,[reH, reW]); 
end

%% mask
mask = max(clean_img,[],3)>0.8;
light_size = sum(mask(:))/numel(mask(:))*100;

sig=1e-5;
text_map_refined = generateLaplacian2f(clean_img, mask, sig);
thr = 0.3;
ff = curve(thr*255, 0.04);
text_map_refined2 = ff(text_map_refined*255)/255;

%% light source
light_sources = text_map_refined2.*clean_img;
%figure,imshow(light_sources);

%% APSF(kernel size, T, q)
ksize = 200;
theta = -180:360/ksize:180;
T = 1.0; 
q = 0.9;
APSF = psfweight(theta,T,q);  
APSF2D = get2Drot(APSF);

%%
img = imfilter(light_sources, APSF2D / sum(APSF2D(:)), 'conv', 'symmetric');

%%
param = 0.4196*light_size.^2 - 4.258 * light_size + 11.35;
if light_size>4 || param < 2
    param = 2;
end
param = param + 0.05*randn(1);
I = clean_img*0.99 + img*param;

clean_img = imresize(clean_img,[reH reW]);
I = imresize(I,[reH reW]);

if addnoise
    I = imnoise(I,'gaussian',0,1e-4);
end
% light_sources=imresize(light_sources,[H,W]);
% clean_img=imresize(clean_img,[H,W]);
I=imresize(I,[H,W]);

% figure,imshow(light_sources);
% figure,imshow([clean_img I]);