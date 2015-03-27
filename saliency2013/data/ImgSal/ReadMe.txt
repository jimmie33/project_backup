1£ºThe code is used to compute the ROC score for the ImgSal Database using fixation data as the ground truth. If you have any problem, please send email to lijian.nudt@gmail.com

2£ºIf you use this code, please cite the corresponding paper £¨see our homepage£©.

3£ºPlace your 235 saliency maps into the folder "YourSaliencyMap";

4£ºWe think that there are three post-processing effects will dramatically influence the ROC score, hence the these should be calibrated when making comparison.

%%%%%%% parameter 1: Border cut %%%%%%

We suggest setting a border cut if at least one model in comparison has a border cut. And the border cut to be set should be larger than all the border cut used in these models; If there is no any border cut used by the models in comparison, we suggest set a small border cut (H*0.025,W*0.025) to alleviate the influence of border effect (introduced by convolution-like operations).

%%%%%%% parameter 2: Blurring %%%%%%

We suggest finding the optimal blurring parameter for each model;

%%%%%%% parameter 3: Center Bias %%%%%%

An optimal center bias should be set if at least one model in comparison has a center bias setting. However, we prefer to suggest turning off the center bias setting in models. 
