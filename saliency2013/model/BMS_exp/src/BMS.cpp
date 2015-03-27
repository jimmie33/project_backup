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

#include "BMS.h"

#include <vector>
#include <cmath>
#include <ctime>

using namespace cv;
using namespace std;

#define COV_MAT_REG 50.0f

BMS::BMS(const Mat& src, int dw1, bool nm, bool hb, int colorSpace, bool whitening)
:mDilationWidth_1(dw1), mNormalize(nm), mHandleBorder(hb), mAttMapCount(0), mColorSpace(colorSpace), mWhitening(whitening)
{
	mSrc=src.clone();
	mSaliencyMap = Mat::zeros(src.size(), CV_32FC1);
	mBorderPriorMap = Mat::zeros(src.size(), CV_32FC1);

	if (CL_RGB & colorSpace)
		whitenFeatMap(mSrc, COV_MAT_REG);
	if (CL_Lab & colorSpace)
	{
		Mat lab;
		cvtColor(mSrc, lab, CV_RGB2Lab);
		whitenFeatMap(lab, COV_MAT_REG);
	}
	if (CL_Luv & colorSpace)
	{
		Mat luv;
		cvtColor(mSrc, luv, CV_RGB2Luv);
		whitenFeatMap(luv, COV_MAT_REG);
	}

	
	//computeBorderPriorMap(10.0f, 0.25);
	/*Mat lab;
	cvtColor(mSrc,lab,CV_RGB2Lab);

	vector<Mat> maps;
	maps.push_back(lab);

	for (int i=0;i<maps.size();i++)
	{
		vector<Mat> sp;
		split(maps[i],sp);
		mFeatureMaps.push_back(sp[0]);
		mFeatureMaps.push_back(sp[1]);
		mFeatureMaps.push_back(sp[2]);
	}*/

}

void BMS::computeSaliency(double step)
{
	for (int i=0;i<mFeatureMaps.size();++i)
	{
		Mat bm;
		double max_,min_;
		minMaxLoc(mFeatureMaps[i],&min_,&max_);
		//step = (max_ - min_) / 30.0f;
		for (double thresh = min_; thresh < max_; thresh += step)
		{
			bm=mFeatureMaps[i]>thresh;
			Mat am = getAttentionMap(bm, mDilationWidth_1, mNormalize, mHandleBorder);
			mSaliencyMap += am;
			mAttMapCount++;
			//bm=_feature_maps[i]<=thresh;
			//registerPosition(bm);
		}
	}
}


cv::Mat BMS::getAttentionMap(const cv::Mat& bm, int dilation_width_1, bool toNormalize, bool handle_border) 
{
	Mat ret=bm.clone();
	int jump;
	if (handle_border)
	{
		for (int i=0;i<bm.rows;i++)
		{
			jump= BMS_RNG.uniform(0.0,1.0)>0.99 ? BMS_RNG.uniform(5,25):0;
			if (ret.at<uchar>(i,0+jump)!=1)
				floodFill(ret,Point(0+jump,i),Scalar(1),0,Scalar(0),Scalar(0),8);
			jump = BMS_RNG.uniform(0.0,1.0)>0.99 ?BMS_RNG.uniform(5,25):0;
			if (ret.at<uchar>(i,bm.cols-1-jump)!=1)
				floodFill(ret,Point(bm.cols-1-jump,i),Scalar(1),0,Scalar(0),Scalar(0),8);
		}
		for (int j=0;j<bm.cols;j++)
		{
			jump= BMS_RNG.uniform(0.0,1.0)>0.99 ? BMS_RNG.uniform(5,25):0;
			if (ret.at<uchar>(0+jump,j)!=1)
				floodFill(ret,Point(j,0+jump),Scalar(1),0,Scalar(0),Scalar(0),8);
			jump= BMS_RNG.uniform(0.0,1.0)>0.99 ? BMS_RNG.uniform(5,25):0;
			if (ret.at<uchar>(bm.rows-1-jump,j)!=1)
				floodFill(ret,Point(j,bm.rows-1-jump),Scalar(1),0,Scalar(0),Scalar(0),8);
		}
	}
	else
	{
		for (int i=0;i<bm.rows;i++)
		{
			if (ret.at<uchar>(i,0)!=1)
				floodFill(ret,Point(0,i),Scalar(1),0,Scalar(0),Scalar(0),8);
			if (ret.at<uchar>(i,bm.cols-1)!=1)
				floodFill(ret,Point(bm.cols-1,i),Scalar(1),0,Scalar(0),Scalar(0),8);
		}
		for (int j=0;j<bm.cols;j++)
		{
			if (ret.at<uchar>(0,j)!=1)
				floodFill(ret,Point(j,0),Scalar(1),0,Scalar(0),Scalar(0),8);
			if (ret.at<uchar>(bm.rows-1,j)!=1)
				floodFill(ret,Point(j,bm.rows-1),Scalar(1),0,Scalar(0),Scalar(0),8);
		}
	}
	
	//double max_, min_;
	//minMaxLoc(ret,&min_,&max_);
	ret = ret != 1;
	
	Mat map1, map2;
	map1 = ret & bm;
	map2 = ret & (~bm);

	if (dilation_width_1 > 0)
	{
		dilate(map1, map1, Mat(), Point(-1, -1), dilation_width_1);
		dilate(map2, map2, Mat(), Point(-1, -1), dilation_width_1);
	}
		
	map1.convertTo(map1,CV_32FC1);
	map2.convertTo(map2,CV_32FC1);

	if (toNormalize)
	{
		normalize(map1, map1, 1.0, 0.0, NORM_L2);
		normalize(map2, map2, 1.0, 0.0, NORM_L2);
	}
	else
		normalize(ret,ret,0.0,1.0,NORM_MINMAX);
	return map1+map2;
}

Mat BMS::getSaliencyMap()
{
	Mat a,b,ret; 
	/*normalize(mSaliencyMap, a, 1.0, 0.0, NORM_MINMAX);
	normalize(mBorderPriorMap, b, 1.0, 0.0, NORM_MINMAX);
	ret = a + 0.1*b;*/
	normalize(mSaliencyMap, ret, 0.0, 255.0, NORM_MINMAX);
	ret.convertTo(ret,CV_8UC1);
	return ret;
}

void BMS::whitenFeatMap(const cv::Mat& img, float reg)
{
	assert(img.channels() == 3 && img.type() == CV_8UC3);
	
	vector<Mat> featureMaps;
	
	if (!mWhitening)
	{
		split(img, featureMaps);
		for (int i = 0; i < featureMaps.size(); i++)
		{
			normalize(featureMaps[i], featureMaps[i], 255.0, 0.0, NORM_MINMAX);
			medianBlur(featureMaps[i], featureMaps[i], 3);
			mFeatureMaps.push_back(featureMaps[i]);
		}
		return;
	}

	Mat srcF,meanF,covF;
	img.convertTo(srcF, CV_32FC3);
	Mat samples = srcF.reshape(1, img.rows*img.cols);
	calcCovarMatrix(samples, covF, meanF, CV_COVAR_NORMAL | CV_COVAR_ROWS | CV_COVAR_SCALE, CV_32F);

	covF += Mat::eye(covF.rows, covF.cols, CV_32FC1)*reg;
	SVD svd(covF);
	Mat sqrtW;
	sqrt(svd.w,sqrtW);
	Mat sqrtInvCovF = svd.u * Mat::diag(1.0/sqrtW);

	//srcF = srcF - Scalar(meanF.at<float>(0, 0), meanF.at<float>(0, 1), meanF.at<float>(0, 2));
	Mat whitenedSrc = srcF.reshape(1, img.rows*img.cols)*sqrtInvCovF;
	whitenedSrc = whitenedSrc.reshape(3, img.rows);
	//whitenedSrc.convertTo(whitenedSrc, CV_8U, 64.0, 127);
	
	split(whitenedSrc, featureMaps);

	for (int i = 0; i < featureMaps.size(); i++)
	{
		normalize(featureMaps[i], featureMaps[i], 255.0, 0.0, NORM_MINMAX);
		featureMaps[i].convertTo(featureMaps[i], CV_8U);
		medianBlur(featureMaps[i], featureMaps[i], 3);
		mFeatureMaps.push_back(featureMaps[i]);
	}
}

void BMS::computeBorderPriorMap(float reg, float marginRatio)
{
	assert(mSrc.channels() == 3);

	vector<Mat> sampleVec(4);
	Mat srcF;

	mSrc.convertTo(srcF, CV_64FC3);
	int rowMargin = (int)(marginRatio*mSrc.rows);
	int colMargin = (int)(marginRatio*mSrc.cols);
	
	sampleVec[0] = Mat(srcF,Range(0,rowMargin)).clone();
	sampleVec[1] = Mat(srcF,Range(mSrc.rows-rowMargin,mSrc.rows)).clone();
	sampleVec[2] = Mat(srcF,Range::all(),Range(0,colMargin)).clone();
	sampleVec[3] = Mat(srcF,Range::all(),Range(mSrc.cols-colMargin,mSrc.cols)).clone();

	for (int i = 0; i < 4; i++)
	{
		Mat meanF, covF;
		Mat samples = sampleVec[i].reshape(1, sampleVec[i].rows*sampleVec[i].cols);
		calcCovarMatrix(samples, covF, meanF, CV_COVAR_NORMAL | CV_COVAR_ROWS | CV_COVAR_SCALE);

		covF += Mat::eye(covF.rows, covF.cols, CV_64FC1)*reg;
		

		Mat srcFTemp = srcF - Scalar(meanF.at<double>(0, 0), meanF.at<double>(0, 1), meanF.at<double>(0, 2));
		srcFTemp = srcFTemp.reshape(1, mSrc.rows*mSrc.cols);
		Mat whitenedSrc = (srcFTemp*covF.inv()).mul(srcFTemp);
		whitenedSrc.convertTo(whitenedSrc, CV_32FC1);
		reduce(whitenedSrc, whitenedSrc, 1, CV_REDUCE_SUM);
		normalize(whitenedSrc.reshape(1, mSrc.rows), whitenedSrc, 1.0, 0.0, NORM_MINMAX);
		mBorderPriorMap += whitenedSrc;
	}
	normalize(mBorderPriorMap, mBorderPriorMap, 1.0, 0.0, NORM_MINMAX);
}

#ifdef USE_IPP
IppStatus ippiDilate32fWrapper(const Mat src, Mat& dst, int kernelWidth)
{
	int step = (int)src.cols*sizeof(float);
	Ipp32f *pSrc = (Ipp32f*)src.data, *pDst = (Ipp32f*)dst.data;
	IppStatus status;
	IppiSize roiSize = { src.cols, src.rows };
	IppiSize maskSize = { kernelWidth, kernelWidth };

	Mat kernel = Mat::ones(kernelWidth, kernelWidth, CV_8UC1);
	Ipp8u* pMask = kernel.data;
	IppiPoint anchor = { kernelWidth / 2, kernelWidth / 2 };

	status = ippiDilate_32f_C1R(pSrc, step, pDst, step, roiSize, pMask, maskSize, anchor);

	return status;
}

IppStatus ippiErode32fWrapper(const Mat& src, Mat& dst, int kernelWidth)
{
	int step = (int)src.cols*sizeof(float);
	Ipp32f *pSrc = (Ipp32f*)src.data, *pDst = (Ipp32f*)dst.data;
	IppStatus status;
	IppiSize roiSize = { src.cols, src.rows };
	IppiSize maskSize = { kernelWidth, kernelWidth };

	Mat kernel = Mat::ones(kernelWidth, kernelWidth, CV_8UC1);
	Ipp8u* pMask = kernel.data;
	IppiPoint anchor = { kernelWidth / 2, kernelWidth / 2 };

	status = ippiErode_32f_C1R(pSrc, step, pDst, step, roiSize, pMask, maskSize, anchor);

	cout << src.step << "," << dst.step << endl;

	return status;
}

IppStatus ippiRecDilateWrapper(const Mat& src, Mat& srcDst, int kernelWidth)
{
	int step = (int)src.cols*sizeof(float), buffSize;
	Ipp32f *pSrc = (Ipp32f*)src.data, *pSrcDst = (Ipp32f*)srcDst.data;
	IppStatus status;
	IppiSize roiSize = { src.cols, src.rows };
	IppiSize maskSize = { kernelWidth, kernelWidth };
	Ipp8u *pBuff = NULL;

	status = ippiMorphReconstructGetBufferSize_32f_C1(roiSize, &buffSize);
	if (status != ippStsNoErr) return status;

	pBuff = ippsMalloc_8u(buffSize);
	status = ippiMorphReconstructDilate_32f_C1IR(pSrc, step, pSrcDst, step, roiSize, (Ipp32f*)pBuff, ippiNormL1);

	ippsFree(pBuff);
	return status;
}
IppStatus ippiRecErodeWrapper(const Mat& src, Mat& srcDst, int kernelWidth)
{
	int step = (int)src.cols*sizeof(float), buffSize;
	Ipp32f *pSrc = (Ipp32f*)src.data, *pSrcDst = (Ipp32f*)srcDst.data;
	IppStatus status;
	IppiSize roiSize = { src.cols, src.rows };
	IppiSize maskSize = { kernelWidth, kernelWidth };
	Ipp8u *pBuff = NULL;

	status = ippiMorphReconstructGetBufferSize_32f_C1(roiSize, &buffSize);
	if (status != ippStsNoErr) return status;

	pBuff = ippsMalloc_8u(buffSize);
	status = ippiMorphReconstructErode_32f_C1IR(pSrc, step, pSrcDst, step, roiSize, (Ipp32f*)pBuff, ippiNormL1);

	ippsFree(pBuff);
	return status;
}



IppStatus ippiRecDilate8uWrapper(const Mat& src, Mat& srcDst, int kernelWidth)
{
	int step = (int)src.cols*sizeof(char), buffSize;
	Ipp8u *pSrc = (Ipp8u*)src.data, *pSrcDst = (Ipp8u*)srcDst.data;
	IppStatus status;
	IppiSize roiSize = { src.cols, src.rows };
	IppiSize maskSize = { kernelWidth, kernelWidth };
	Ipp8u *pBuff = NULL;

	status = ippiMorphReconstructGetBufferSize_8u_C1(roiSize, &buffSize);
	if (status != ippStsNoErr) return status;

	pBuff = ippsMalloc_8u(buffSize);
	status = ippiMorphReconstructDilate_8u_C1IR(pSrc, step, pSrcDst, step, roiSize, (Ipp8u*)pBuff, ippiNormL1);

	ippsFree(pBuff);
	return status;
}
IppStatus ippiRecErode8uWrapper(const Mat& src, Mat& srcDst, int kernelWidth)
{
	int step = (int)src.cols*sizeof(char), buffSize;
	Ipp8u *pSrc = (Ipp8u*)src.data, *pSrcDst = (Ipp8u*)srcDst.data;
	IppStatus status;
	IppiSize roiSize = { src.cols, src.rows };
	IppiSize maskSize = { kernelWidth, kernelWidth };
	Ipp8u *pBuff = NULL;

	status = ippiMorphReconstructGetBufferSize_8u_C1(roiSize, &buffSize);
	if (status != ippStsNoErr) return status;

	pBuff = ippsMalloc_8u(buffSize);
	status = ippiMorphReconstructErode_8u_C1IR(pSrc, step, pSrcDst, step, roiSize, (Ipp8u*)pBuff, ippiNormL1);

	ippsFree(pBuff);
	return status;
}
#endif

void postProcessByRec(cv::Mat& salmap, int kernelWidth)
{
	assert(salmap.type() == CV_32FC1);
#ifdef USE_IPP
	Mat temp(salmap.size(), CV_32FC1);
	IppStatus status;

	/*status = ippiErode32fWrapper(salmap, temp, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: Erosion: " << ippGetStatusString(status) << endl;*/
	erode(salmap, temp, Mat(), Point(-1, -1), kernelWidth / 2);

	status = ippiRecDilateWrapper(salmap, temp, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: DilationRec: " << ippGetStatusString(status) << endl;

	/*status = ippiDilate32fWrapper(temp, salmap, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: Dilation: " << ippGetStatusString(status) << endl;*/
	dilate(temp, salmap, Mat(), Point(-1, -1), kernelWidth / 2);

	status = ippiRecErodeWrapper(temp, salmap, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: ErosionRec: " << ippGetStatusString(status) << endl;
#else
	cerr << "IPP Not enabled." << endl;
#endif
}

void postProcessByRec8u(cv::Mat& salmap, int kernelWidth)
{
	assert(salmap.type() == CV_8UC1);
#ifdef USE_IPP
	Mat temp(salmap.size(), CV_8UC1);
	IppStatus status;

	/*status = ippiErode32fWrapper(salmap, temp, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: Erosion: " << ippGetStatusString(status) << endl;*/
	erode(salmap, temp, Mat(), Point(-1, -1), kernelWidth / 2);

	status = ippiRecDilate8uWrapper(salmap, temp, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: DilationRec: " << ippGetStatusString(status) << endl;

	/*status = ippiDilate32fWrapper(temp, salmap, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: Dilation: " << ippGetStatusString(status) << endl;*/
	dilate(temp, salmap, Mat(), Point(-1, -1), kernelWidth / 2);

	status = ippiRecErode8uWrapper(temp, salmap, kernelWidth);
	if (status != ippStsNoErr) cerr << "postProcessByRec: ErosionRec: " << ippGetStatusString(status) << endl;
#else
	cerr<<"IPP Not enabled."<<endl;
#endif
}