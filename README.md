# Root callose segmentation (MATLAB implementation)

The MATLAB function "callose_segmentation" features the root callose segments from images of 1024 by 1024 pixels. Provided an input image file (tiff format) and segmentation thresholding parameters, the outputs are: 

(1) Binarized callose-segmented array variable (of size of 1024 by 1024- same as the input image dimensions), The array is saved in the working directory as an RGB tiff image file (.tif);

(2) Array of size 4 by 4, with each element counting the number of pixels segmented for its corresponding grid in the binarized image. Each grid depicts a region of 256 by 256 pixels in the image;

(3) Array of size 16 by 16, with each element counting the number of pixels segmented for its corresponding grid in the binarized image. Each grid depicts a region of 64 by 64 pixels in the image;

The input image is processed by two stages of coarse refining (ca and cb) followed by two stages of fine refining (fa and fb). ca has two threshold parameters: t_ca_1 and t_ca_2. cb has two threshold parameters: t_cb_1 and t_cb_2. Similarly, fa and fb have threshold parameters of: t_fa_1, t_fa_2, t_fb_1, and t_fb_2 respectively. These input threshold parameters is set by the user that varies the final segmented image output.

The "readme_callose_segmentation.txt" file provides information regarding the input parameter values and describes the outputs obtained.
