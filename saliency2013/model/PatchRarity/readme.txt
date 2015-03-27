Instructions for running the code for the following paper:

Ali Borji and Laurent Itti, 
"Exploiting Local and Global Patch Rarities for Saliency Detection,",
IEEE CVPR 2012. 

-----------------------------------------------------------

1- I have written the code inside the SPAMS sparse coding toolbox:
It is freely available at: http://spams-devel.gforge.inria.fr/downloads.html

Make sure that mex files are correctly compiled. Some functions like mexLasso.m need the libararies in the SPAMS toolbox.

2- Download the GBVS model and add it to the path. (update the paths in the m-files)

3- A dictionary of patches is needed for image representation. I have already built several which are
named DS*.mat, here learned from images of the Bruce dataset. If you need to learn a new dictinary you should use the learnDic.m and 
save the results in a new .mat file.

3- Some of the pathes added at the beginning of the .m files might not be necessary. I sugguest you comment them.
You should not run into errors, otherwise uncomment the commented path and if needed either contact me or try to download the 
code from the web.


4 - If you want to run the code for just one image use this:       

PS = 3; InitScale = [512 512]; numScales = 1; comb  = 3;
[salMapLG salMapL salMapG] = myNewSaLModel4NSS(fileName,numScales, PS, InitScale, comb);


% Parameters: 
1 - numScales: Number of scales in the scale space
2 - PS: local window size
3 - InitScale: initial scale
4 - comb: Combination approach for integration of local and global maps (1=+, 2=*, 3= max, 4=min)


Note: You can change several other parameters inside myNewSaLModel4NSS.m function including: loading different dictionaries, 
weight vectors for color channels, blur raduis for bluring the final map, adding center-bias, number of bins in histograms, etc.
This might lead to significanlty better results. There are other versions of this file where I have used different 
parameter settings (e.g., myNewModifiedModel.m and myNewSaLModel.m).


5- There are four m files for calculating the saliency for all images of four datasets:
calcSal4JBruce.m
calcSal4Judd.m
calcSal4Kootstra.m
calcSal4NUSEF.m

You should change the input (images) and output directory accordingly.


Good Luck.
------------------------------------------------------------------------------------
please email me if you have any problem: borji@usc.edu

