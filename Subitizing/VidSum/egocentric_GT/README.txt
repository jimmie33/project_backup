Each directory corresponds to a user video.  

pos_gtimages: contains mat files of binary masks ('GT(1).gt_im') that indicate the annotated important regions.

neg_gtimages: there are no mat files to load.  The file names correspond to frames that don't have any important regions (i.e., all objects are annotated as being *not* important).



Training/testing should be conducted in a leave-one-out fashion (i.e., train on 3 videos and test on 1 remaining video).  After all 4 videos are tested on, a single precision-recall curve can be plotted.  A region is considered to be a true positive (i.e., important object) if its overlap score (intersection over union) is greater than 0.5.

Note that the frames in both "pos_gtimages" and "neg_gtimages" should be used for training *and* testing.