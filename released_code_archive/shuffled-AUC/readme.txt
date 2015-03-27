By Jianming Zhang, 2014


This is the code for the computation of shuffled-AUC. This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY.

If you use any of this work in scientific research or as part of a larger software system, you are kindly requested to cite the use in any related publications or technical documentation. The work is based upon:
    
Jianming Zhang, and Stan Sclaroff, "Saliency Detection: A Boolean Map Approach," in the Proc. of the IEEE International Conference on Computer Vision (ICCV), 2013.



Usage:

> load MIT_GT
> results = computeMeanAUC(fixMaps, overallFixMap, 'your/saliency/map/dir', '.png', 0.01);



Note:

1. The returned variable is a vector of the length of the number of saliency maps.

2. If your names of the saliency maps have an appendix, e.g. <nameOfTestImage>_salmap.png, then you should type

> results = computeMeanAUC(fixMaps, overallFixMap, 'your/saliency/map/dir', '_salmap.png', 0.01);

3. This code is slightly different from the code used in our ICCV paper. The original code is flawed (See the comments in "calcAUCscore.m"). Therefore, the current version gives more precise results. This change does not affect the main conclusions of our paper. If you want to reproduce the results in our ICCV paper, please substitute "calcAUCscore_old.m" for "calcAUCscore.m".