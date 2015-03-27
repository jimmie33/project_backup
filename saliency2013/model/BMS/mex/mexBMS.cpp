/*****************************************************************************
*	Implemetation of the saliency detction method described in paper
*	"Saliency Detection: A Boolean Map Approach", Jianming Zhang, 
*	Stan Sclaroff, ICCV, 2013
*	
*	Copyright (C) 2013 Jianming Zhang
*
*	This program is free software: you can redistribute it and/or modify
*	it under the terms of the GNU General Public License as published by
*	the Free Software Foundation, either version 3 of the License, or
*	(at your option) any later version.
*
*	This program is distributed in the hope that it will be useful,
*	but WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*	GNU General Public License for more details.
*
*	You should have received a copy of the GNU General Public License
*	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*	If you have problems about this software, please contact: jmzhang@bu.edu
*******************************************************************************/

#include <iostream>
#include <ctime>

#include "mexopencv.hpp"
#include "opencv2/opencv.hpp"
#include "BMS.h"
#include "fileGettor.h"

using namespace cv;
using namespace std;

void doWork(
	const string in_path,
	const string out_path,
	const int sample_step,
	const int opening_width,
	const int dilation_width_1,
	const int dilation_width_2,
	const float blur_std,
	const bool use_normalize,
	const bool handle_border
	)
{
	if (in_path.compare(out_path)==0)
		mexErrMsgIdAndTxt("mexopencv:error","output path must be different from input path!");
	FileGettor fg(in_path.c_str());
	vector<string> file_list=fg.getFileList();
	clock_t ttt;
	double avg_time=0;

	for (int i=0;i<file_list.size();i++)
	{
		/* get file name */
		string ext=getExtension(file_list[i]);
		if (!(ext.compare("jpg")==0 || ext.compare("jpeg")==0 || ext.compare("JPG")==0 || ext.compare("tif")==0 || ext.compare("png")==0 || ext.compare("bmp")==0))
			continue;
		mexPrintf("%s ...",file_list[i].c_str());

		/* Preprocessing */
		Mat src=imread(in_path+file_list[i]);
		Mat src_small;
		resize(src,src_small,Size(600,src.rows*(600.0/src.cols)),0.0,0.0,INTER_AREA);// standard: width: 600 pixel
		GaussianBlur(src_small,src_small,Size(3,3),1,1);// removing noise

		/* Computing saliency */
		ttt=clock();

		BMS bms(src_small,dilation_width_1,opening_width,use_normalize,handle_border);
		bms.computeSaliency((float)sample_step);
		
		Mat result=bms.getSaliencyMap();

		/* Post-processing */
		if (dilation_width_2>0)
			dilate(result,result,Mat(),Point(-1,-1),dilation_width_2);
		if (blur_std > 0)
		{
			int blur_width = MIN(floor(blur_std)*4+1,51);
			GaussianBlur(result,result,Size(blur_width,blur_width),blur_std,blur_std);
		}			
		
		ttt=clock()-ttt;
		float process_time=(float)ttt/CLOCKS_PER_SEC;
		avg_time+=process_time;
		mexPrintf("average_time: %f \n",avg_time/(i+1));

		/* Save the saliency map*/
		resize(result,result,src.size());
		imwrite(out_path+rmExtension(file_list[i])+".png",result);		
	}
}

void mexFunction (int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
    if (nlhs > 0 || nrhs < 9)
        mexErrMsgIdAndTxt("mexopencv:error","Wrong number of arguments");
    vector<MxArray> rhs(prhs,prhs+nrhs);
    
    /* initialize system parameters */
	string INPUT_PATH		=	rhs[0].toString();
	string OUTPUT_PATH		=	rhs[1].toString();
	int SAMPLE_STEP			=	rhs[2].toInt();//8: delta

	/*Note: we transform the kernel width to the equivalent iteration 
	number for OpenCV's **dilate** and **erode** functions**/
	int OPENING_WIDTH		=	(rhs[3].toInt()-1)/2;//2: omega_o	
	int DILATION_WIDTH_1	=	(rhs[4].toInt()-1)/2;//3: omega_d1
	int DILATION_WIDTH_2	=	(rhs[5].toInt()-1)/2;//11: omega_d2

	float BLUR_STD			=	rhs[6].toDouble();//20: sigma	
	bool NORMALIZE			=	rhs[7].toInt();//1: whether to use L2-normalization
	bool HANDLE_BORDER		=	rhs[8].toInt();//0: to handle the images with artificial frames
	

	doWork(INPUT_PATH,OUTPUT_PATH,SAMPLE_STEP,OPENING_WIDTH,DILATION_WIDTH_1,DILATION_WIDTH_2,BLUR_STD,NORMALIZE,HANDLE_BORDER);
}
