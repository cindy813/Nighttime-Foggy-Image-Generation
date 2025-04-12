# Nighttime-Foggy-Image-Generation
### Realistic Nighttime Foggy Image Generation using a Semi-Analytic Model and Gradient Sparse Prior
#### Introduction

Generating realistic nighttime foggy images remains a challenging task due to the distinct lighting conditions and halo effects present in such scenes. To address this issue, we propose a novel algorithm that utilizes a semi-analytic model tailored for nighttime fog and an intrinsic image decomposition method based on gradient sparse prior. The semi-analytic model accounts for the dominant artificial light sources and halo phenomena in night scenes. We decompose the night image into an illumination map and a reflection map to obtain the model parameters. The atmospheric modulation function and point spread function are then employed to simulate the halo effect, with the extinction coefficient determined using Allard's law.   
Experimental results, including subjective and quantitative evaluations, demonstrate that our method outperforms existing approaches in simulating the halo effect of artificial light sources under nighttime fog conditions. Specifically, our method achieves lower AuthESI values and higher volunteer preference ratings, indicating more realistic and natural fog simulations. The proposed algorithm has potential applications in virtual simulation systems, film and game rendering, and the evaluation of image dehazing algorithms. 

![image](https://github.com/user-attachments/assets/16066bff-d946-46c6-ba50-953da796ff75)

#### Application Scenarios
•	**Autonomous driving systems:** create synthetic foggy datasets with varying densities for training the target detection capability of the vehicle perception system under low visibility conditions.  
•	**Film and game production:**  simulate natural fog effects in CGI or game engines to create an atmosphere and enhance the sense of immersion.  
•	**Military simulation training:** simulate battlefield environment to provide soldiers with training scenarios that closely resemble real foggy combat conditions.  
•	**UAV testing:** evaluate the obstacle avoidance and positioning algorithm performance of UAVs under complex meteorological conditions.

#### Key Algorithm Description and Implementation
•	**NightHazeSim:** The main function that obtains the generated nighttime foggy images by using the semi-analytic model-based method and the widely used atmospheric scattering model-based method. For semi-analytic model-based method, the main function first uses the function ***Intrinsic_Relsmo*** to decompose the input image into the reflection image and illumination image. Here, the reflection image is used for image color correction and the illumination image is used for producing halo effects of the night scenes. Then, the function ***glow_Gen*** is used to produce a new illumination image that realizes the diffuse redistribution of the scene light source energy in a large range. Experimental results show that the new illumination image can better reflect the main light path characteristics of fog-night scenes with more distance and more obvious halo. Therefore, the new illumination image can be regarded as the result of the main light path terms in the expression of the improved semi-analytic model. Finally, the main light path terms, combined with the reflection image, airlight, original input image and corresponding depth image, are taken into the semi-analytic model expression to produce our final simulation results. For the atmospheric scattering model-based way, the haze simulation method proposed by Zhang’s team is adopted here for comparison. Detailed information for Zhang’s method is given by the paper: HAZERD: an outdoor scene dataset and benchmark for single image dehazing (IEEE International Conference on Image Processing).   
•	**Intrinsic_Relsmo:** decomposes the input image into the reflection image and illumination image. The main idea of the decomposition method is layer separation using relative smoothness. More detailed information for the method is given by the paper: Single Image Layer Separation using Relative Smoothness (IEEE Conference on Computer Vision and Pattern Recognition).  
•	**glow_Gen:** describes the attenuation of the main light path and generate glow and halo effects. The effect can be represented by the convolution of the point light source diffusion function PSF, which is related to the distance. Since the illumination image represents the illumination condition, thus it can be used to realize the diffuse redistribution of the scene light source energy in a large range. As reflected in the visual effect, the greater the depth value, the higher the blurring degree of the illumination map. Function ***glow_Gen*** produces a new illumination image that reflects the main light path characteristics of nighttime foggy scenes with obvious halo.   
• **generateLaplacian2f:** used for computing the laplacian to produce a mask. The ***generateLaplacian2f*** is called in function ***glow_Gen***.  
•	**psfweight:** used for the computation of point light source diffusion function (PSF). The ***psfweight*** is called in function ***glow_Gen***.  
•	**curve:** used for the produce of a mask. The ***curve*** is called in function ***glow_Gen***.  
•	**get2Drot:** used for the computation of two-dimensional point light source diffusion function (PSF). The ***get2Drot*** is called in function ***glow_Gen***.  
•	**perlin_noise:** add perlin noise for visual vividness. The noise is added to the depth map, which is equivalent to change the optic distance. This function is used in Zhang’s atmospheric scattering model-based method (HazeRD).



#### Requirements
•	MATLAB  
•	Image Processing Toolbox


#### It was run in following environment:
•	Intel(R) Core(TM) i7-8700 CPU, 3.20GHz, 32G memory  
•	MATLAB R2021b


#### Preparing Data
•	Testing image: Please put the original no-fog image that you want add fog effects in **TestImg** file.  
•	Depth image: Please put the depth image that corresponds to the original no-fog image in **TestImg** file. The depth image can be obtained by DINOv2 vision large model published by MetaAI or the AdaBins algorithm proposed by Bhat’s team and many other methods.


#### Getting Started:
#### Usage Example
If you want to run this code, please provide the original no-fog image that you want add fog effects and its corresponding depth image in main function ***NightHazeSim***. For example, if the test no-fog image is t1.png and its corresponding depth image is t1_d.png in **TestImg** file, then you need just input the following two statements in function ***NightHazeSim***. The code will provide the simulation results of the proposed semi-analytic model-based method and the atmospheric scattering model-based method for comparison.  

I=imread('TestImg/t1.png');  
depth=imread('TestImg/t1_d.png');

