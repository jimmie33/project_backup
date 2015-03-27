This is Saliency and Bounding Box sampling code by
Parthipan Siva
Queen Mary University of London

Please cite the following paper when using the code:
P. Siva, C. Russell, T. Xiang and L. Agapito "Looking Beyond the Image: Unsupervised Learning for Object Saliency and Detection", Conference on Computer Vision and Pattern Recognition, Portland, June 23-28 2013.

The project page: http://www.psiva.ca/Papers/CVPR2013/CVPR2013.html

Please email: psiva7@gmail.com regarding any questions about the code or paper.


Seting Up
======

1) Unzip file

External libs

2) Install flann (http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN). This code was tested with version 1.6.10 and the matlab binary for Linux is bundled with the code in /Code/libs/flan-1.6.10-Install_64bit

3) Install GIST (http://people.csail.mit.edu/torralba/code/spatialenvelope/). The library is bundled with the code in /Code/libs/GIST

4) Install Felzenswal Segmentation (http://cs.brown.edu/~pff/segment/). The library is comiled for liux and bundled with the code in /Code/libs/segment/

5) Mex the im2colstep.c in /Code/libs/smallbox1.9Util

6) Instal VLFeat (http://www.vlfeat.org/) The code was tested with version 0.9.14

7) Edit /Code/SaliencyToolbox/sal_setup.m to point to the correct location of all libraries

Image Dataset

8) Download Pascal VOC 2007 trainval set.

Run Code

9) Edit /Code/Scripts/SalDemo.m to point to folder with Pascal VOC 2007 images (alternatively use any folders with jpg images).

VOC07 TrainVal only
Point NNIParams.ImgLocDB{1} to location of all jpgs:
NNIParams.ImgLocDB{1} = '../../Data/VOC2007/JPEGImages/';   % images here

Point NNIParams.DB{1} to a tempary directory to compute and save image level features or point to following directory to use pre-computed image features provided with code.
NNIParams.DB{1} = '../../NNImgFeat/VOC2007/GISTLab/';       % feature files here

If you want to use Multiple Folders with images

NNIParams.ImgLocDB{1}  = /Path/To/Folder1/
NNIParams.DB{1} = /Path/To/Save/Img/Features/For/Folder1/
NNIParams.ImgLocDB{2}  = /Path/To/Folder2/
NNIParams.DB{2} = /Path/To/Save/Img/Features/For/Folder2/
etc

Note: SalDemo.m Line 28 to 30 will automatically compute needed image features for all folders.

10) Run /Code/Scripts/SalDemo.m 
