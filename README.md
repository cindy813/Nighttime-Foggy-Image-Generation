# Nighttime-Foggy-Image-Generation
### Realistic Nighttime Foggy Image Generation using a Semi-Analytic Model and Gradient Sparse Prior
#### Introduction

Generating realistic nighttime foggy images remains a challenging task due to the distinct lighting conditions and halo effects present in such scenes. To address this issue, we propose a novel algorithm that utilizes a semi-analytic model tailored for nighttime fog and an intrinsic image decomposition method based on gradient sparse prior. The semi-analytic model accounts for the dominant artificial light sources and halo phenomena in night scenes. We decompose the night image into an illumination map and a reflection map to obtain the model parameters. The atmospheric modulation function and point spread function are then employed to simulate the halo effect, with the extinction coefficient determined using Allard's law. 
Experimental results, including subjective and quantitative evaluations, demonstrate that our method outperforms existing approaches in simulating the halo effect of artificial light sources under nighttime fog conditions. Specifically, our method achieves lower AuthESI values and higher volunteer preference ratings, indicating more realistic and natural fog simulations. The proposed algorithm has potential applications in virtual simulation systems, film and game rendering, and the evaluation of image dehazing algorithms. 

![image](https://github.com/user-attachments/assets/16066bff-d946-46c6-ba50-953da796ff75)

#### Application Scenarios:

This is the demo code for the manuscript entitled "Realistic Nighttime Foggy Image Generation using a Semi-Analytic Model and Gradient Sparse Prior", which we wish to be considered for publication in “The Visual Computer”.

If you use this code, you just click on the **NightHazeSim.m** in your home directory. The **TestImg** file provides the original nighttime fog-free images and the corresponding depth maps for algorithm testing. 
