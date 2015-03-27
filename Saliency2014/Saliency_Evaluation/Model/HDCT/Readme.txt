MATLAB demo code of Salient Region Detection via High-dimensional Color Transform of CVPR 2014

Written by Jiwhan Kim and Dongyoon Han (jhkim89@kaist.ac.kr, calintz@kaist.ac.kr).
Only for academic or other non-commercial purposes.

We tested our code in Matlab 2013a, Windows 7 environment.  Lower version of Matlab may cause several errors.

Our code is unoptimized, especially for the feature descriptor part for the initial salient region detection.  We are currently optimizing the code, and we will update it as soon as possible.


1. How to run :
1) Install required libraries and compile :
 1. VLfeat (http://www.vlfeat.org/)
 2. Histogram distance toolbox(http://www.mathworks.com/matlabcentral/fileexchange/39275-histogram-distances)
 3. SQBlib (http://sites.google.com/site/carlosbecker/)
2) Save the test images at 'images' folder.
3) Run main.m

2. Overview
main.m   : main script for salient region detection demo
CheckSp.m  : function for adjust superpixel segmentation. 
ColorFeatures.m  : function for extract color features, color histogram features, and color contrast features, which are described in our paper.
GenerateDictionarySp.m  : Implementation of generating high-dimensional color transform.
GetResult.m  : Implementation of final saliency map generation step via High-dimensional color transform.
HOGFeatures.m  : function for extract Histogram of Gradients (HOG) features.  It uses VLfeat library.
LocationFeatures.m  : function for extract Location Features and area of superpixel, which are described in our paper.
Refinement.m  : implementation of spatial refinement step.
SVF.m  : function for extract Singular value feature.