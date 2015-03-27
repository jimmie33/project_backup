SBU-Gaze-Detection-Description dataset v0.1
================================================

This package contains the SBU-Gaze-Detection-Description dataset version 0.2 for Matlab. If you use this dataset in your work, please cite the following paper.

	Kiwon Yun, Yifan Peng, Dimitris Samaras, Gregory J. Zelinsky, and Tamara L. Berg, 
	Studying Relationships Between Human Gaze, Description, and Computer Vision, 
	Computer Vision and Pattern Recognition (CVPR) 2013.

For questions and comments, please email Kiwon Yun <kyun@cs.stonybrook.edu>
Data written: Apr 28, 2013	
Revision: v0.2, May 13, 2013 - codes and annotations are added.

================================================

Contents
	data/pascal_sentence	
		Data for the PASCAL dataset
		Images and descriptions are from http://vision.cs.uiuc.edu/pascal-sentences/
		Eye movements were recorded from three human observers
		20 object categories: 
            aeroplane, bicycle, bird, boat, bottle, bus, car, cat, chair, cow, diningtable, dog, horse, motorbike, person, pottedplant, sheep, sofa, train, tvmonitor
			
	data/sun09
		Data for the SUN09 dataset
		Images are from http://people.csail.mit.edu/myungjin/HContext.html
		Eye movements were recorded from eight human observers
		Description 'set 1' were collected from the same observers.
		Description 'set 2' were collected from Amazon's Mechanical Turk service
		8 selected scene categories:
			bar, bathroom, bedroom, kitchen, dinning room, classroom, living room, office
		22 selected object categories: 
			bathtub, bed, bouquet, box, carpet/rug, cabinet/cupboard, chair/stool, curtain, desk, dishwasher, drawer, door, microwave/oven, person, picture/painting, plant , refrigerator, sofa, tv/screen, toilet, window
	
    src/demo.m
        It shows an example with fixations, annotations, and descriptions

    src/helper
        It contains helper functions
================================================

Data format

The file `data/{dataset_name}/fixations/{filename}.mat` contains a struct array `fixations`. The struct has the following fields.

	filename			the name of image file.
	subject_ids			subject id.
	fixation
		fix_X			x coordinate of the fixation
		fix_Y			y coordinate of the fixation
		duration		fixation duration
		

The file `data/{dataset_name}/descriptions/{filename}.mat` contains a struct array `description_data`. The struct has the following fields.

	subject_ids		subject id.
	descriptions		described sentences
	extracted_objects	extracted object list by WordNet similarity
	extracted_scenes	extracted scene list by WordNet similarity
	
================================================

Additional information
    The resolution of screen for human experiments:
        PASCAL: 800 x 600
        SUN09: 1280 x 960
    The resolution of images for human experiments:
        PASCAL: the original images were used
        SUN09: the original images were resized to fit to the screen resolution (eg. On a vertical image set the height to 960 pixels max. On a horizontal image set the width to 1280 pixels max.)
    The final fixation location were recomputed to fit to the original images.
    The information of subject ID:
        PASCAL: fixations and descriptions are collected from different subjects. The subject id indicated in the fixation data does not match with the subject id indicated in the description data.
        SUN09: From S01 to S08, fixations and descriptions are collected from the same subjects. Eye movements were recorded on 104 images while subjects described the image they previously saw on the half of the dataset (52 images).