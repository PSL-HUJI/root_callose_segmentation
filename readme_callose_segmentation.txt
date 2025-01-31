ROOT CALLOSE SEGMENTATION implementation in MATLAB

Use the "callose_segmentation" function as:

[seg_img, block4stats, block16stats] = callose_segmentation(t_ca_1,t_ca_2,t_cb_1,t_cb_2,t_fa_1,t_fa_2,t_fb_1,t_fb_2)

[seg_img, block4stats, block16stats] = callose_segmentation(130,10e6,4,100,130,10e6,4,7);

where t_c's are the coarse refining thresholds for segmentation
and t_f's are the fine refining thresholds for segmentation.

E.g. INPUT parameter values:
t_ca_1 = 130
t_ca_2 = 10e6
t_cb_1 = 4
t_cb_2 = 100
t_fa_1 = 130
t_fa_2 = 10e6
t_fb_1 = 4
t_fb_2 = 7

OUTPUTS:

seg_img = root callose segmented binarized image. The seg_img array variable is also saved in the working directory as "seg_<input image filename>.tif" which is an RGB tiff image file.

block4stats = list of 4 x 4 array corresponding to each input image. Each element of the 4 x 4 array numerates the number of pixels segmented for that region (corresponding to 256 by 256 pixels)

block16stats = list of 16 x 16 array corresponding to each input image. Each element of the 16 x 16 array numerates the number of pixels segmented for that region (corresponding to 64 by 64 pixels)



