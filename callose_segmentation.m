function [seg_img,block4,block16] = callose_segmentation(t_ca_1,t_ca_2,t_cb_1,t_cb_2,t_fa_1,t_fa_2,t_fb_1,t_fb_2)

    %% Importing image files

    files = uigetfile('*.tif', 'Choose files', '', 'Multiselect', 'on'); % Import tiff image file
    if class(files)=='char' 
        files={files};
    end

    for a=1:size(files,2)
        t = Tiff(files{1,a},'r');
        img = read(t);
        sz = [size(img,1) size(img,2)]; % Store the image spatial dimensions

        %% Coarse refining
        
        num_colors_c = 2;
        L_c = imsegkmeans(img,num_colors_c); % k-means segmentation for image binarization (k = 2)
        L_c(L_c==1) = 0;
        L_c(L_c==2) = 1;

        % Find all callose regions
        cc_ca = bwconncomp(L_c); % Count the number of connected pixels
        f_pix_ca = cc_ca.PixelIdxList;
        for k=1:size(f_pix_ca,2)
            f_pixcount_ca(k,1) = size(f_pix_ca{1,k},1);
        end
        
        seg_img_ca = zeros(sz); % Create image for ca coarse refining
        seg_img_ca = uint8(seg_img_ca);
        
        good_idx_ca = find(and(f_pixcount_ca>t_ca_1,f_pixcount_ca<=t_ca_2)); %Extract callose (connected pixels) according to the set threshold
        for l=1:size(good_idx_ca,1)
            pxl_idx_ca = f_pix_ca{1,good_idx_ca(l,1)};

            for m=1:size(pxl_idx_ca,1)
                [sub_ca(m,1), sub_ca(m,2)] = ind2sub(sz,pxl_idx_ca(m,1)); % Convert pixel index to image subscript 
            end
            
            for n=1:size(sub_ca,1)
                seg_img_ca(sub_ca(n,1),sub_ca(n,2)) = 1; % Assign the threshold connected pixels to ca coarse-refined image
            end
        end

        clear num_colors_c cc_ca f_pix_ca f_pixcount_ca good_idx_ca pxl_idx_ca sub_ca

        % Ignore large callose regions
        seg_img_cb = L_c-seg_img_ca; % Calculate cb coarse-refined image
        
        cc_cb = bwconncomp(seg_img_cb); % Count the number of connected pixels
        f_pix_cb = cc_cb.PixelIdxList;
        for k=1:size(f_pix_cb,2)
            f_pixcount_cb(k,1) = size(f_pix_cb{1,k},1);
        end

        seg_img_c = zeros(sz); % Create image for final coarse refining
        seg_img_c = uint8(seg_img_c);
        
        good_idx_cb = find(and(f_pixcount_cb>t_cb_1,f_pixcount_cb<=t_cb_2)); %Extract callose (connected pixels) according to the set threshold
        for l=1:size(good_idx_cb,1)
            pxl_idx_cb = f_pix_cb{1,good_idx_cb(l,1)};
            
            for m=1:size(pxl_idx_cb,1)
                [sub_cb(m,1), sub_cb(m,2)] = ind2sub(sz,pxl_idx_cb(m,1)); % Convert pixel index to image subscript 
            end
            
            for n=1:size(sub_cb,1)
                seg_img_c(sub_cb(n,1),sub_cb(n,2)) = 1; % Assign the threshold connected pixels to final coarse-refined image
            end
        end

        clear cc_cb f_pix_cb f_pixcount_cb good_idx_cb pxl_idx_cb sub_cb

        %% Fine refining

        num_colors_f = 3;
        L_f = imsegkmeans(img,num_colors_f);
        L_f(L_f==1) = 1;
        L_f(L_f==2) = 1;
        L_f(L_f==3) = 0;

        % Find all callose regions
        cc_fa = bwconncomp(L_f); % Count the number of connected pixels
        f_pix_fa = cc_fa.PixelIdxList;
        for k=1:size(f_pix_fa,2)
            f_pixcount_fa(k,1) = size(f_pix_fa{1,k},1);
        end
        
        seg_img_fa = zeros(sz); % Create image for fa fine refining
        seg_img_fa = uint8(seg_img_fa);

        good_idx_fa = find(and(f_pixcount_fa>t_fa_1,f_pixcount_fa<=t_fa_2)); %Extract callose (connected pixels) according to the set threshold
        for l=1:size(good_idx_fa,1)
            pxl_idx_fa = f_pix_fa{1,good_idx_fa(l,1)};
            
            for m=1:size(pxl_idx_fa,1)
                [sub_fa(m,1), sub_fa(m,2)] = ind2sub(sz,pxl_idx_fa(m,1)); % Convert pixel index to image subscript
            end
            
            for n=1:size(sub_fa,1)
                seg_img_fa(sub_fa(n,1),sub_fa(n,2)) = 1; % Assign the threshold connected pixels to fa fine-refined image
            end
        end

        clear num_colors_f cc_fa f_pix_fa f_pixcount_fa good_idx_fa pxl_idx_fa sub_fa

        % Retaining desirable callose features missed out during coarse
        % refining process
        seg_img_fb = L_f-seg_img_fa; % Calculate fb fine-refined image
        
        cc_fb = bwconncomp(seg_img_fb); % Count the number of connected pixels
        f_pix_fb = cc_fb.PixelIdxList;
        for k=1:size(f_pix_fb,2)
            f_pixcount_fb(k,1) = size(f_pix_fb{1,k},1);
        end

        seg_img_f = zeros(sz); % Create image for final fine refining
        seg_img_f = uint8(seg_img_f);
        
        good_idx_fb = find(and(f_pixcount_fb>t_fb_1,f_pixcount_fb<=t_fb_2)); %Extract callose (connected pixels) according to the set threshold
        for l=1:size(good_idx_fb,1)
            pxl_idx_fb = f_pix_fb{1,good_idx_fb(l,1)};
            
            for m=1:size(pxl_idx_fb,1)
                [sub_fb(m,1), sub_fb(m,2)] = ind2sub(sz,pxl_idx_fb(m,1)); % Convert pixel index to image subscript 
            end
            
            for n=1:size(sub_fb,1)
                seg_img_f(sub_fb(n,1),sub_fb(n,2)) = 1; % Assign the threshold connected pixels to final fine-refined image
            end
        end

        clear cc_fb f_pix_fb f_pixcount_fb good_idx_fb pxl_idx_fb sub_fb

        %% Determining callose-segmented image

        seg_img = max(seg_img_c,seg_img_f); % Define the final callose-segmented image
        
        seg_img(950:end,1:200) = 0; % Remove image annotations
        
        seg_img_resize = imresize(seg_img, [1024 1024]); %Resize image to original image dimensions (i.e., 1024 by 1024 pixels)
        
        seg_img_rgb = 255 * repmat(uint8(seg_img_resize), 1, 1, 3); % Convert final callose-segmented binarized image to RGB image

        %Save the callose-segmented RGB image
        imwrite(seg_img_rgb,'testimg.tif');

        ext = ".tif";   %change to whatever is appropriate
        src = compose("testimg") + ext;
        dst = compose(strcat("seg_",files{1,a}));

        if exist(src, 'file')
            movefile(src, dst);
        else
            fprintf('expected file "%s" not found\n', src);
        end

        delete testimg.tif;

        %% Count number of spots in each 4 by 4 section

        block_4 = array2grids(seg_img,[sz(1)/4,sz(2)/4]);
        for i=1:size(block_4,1)
            for j=1:size(block_4,2)
                block_4_pxlcount(i,j) = size(find(block_4{i,j}==1),1);
            end
        end
        block4{1,a} = block_4_pxlcount;

        %% Count number of spots in each 16 by 16 section

        block_16 = array2grids(seg_img,[sz(1)/16,sz(2)/16]);
        for i=1:size(block_16,1)
            for j=1:size(block_16,2)
                block_16_pxlcount(i,j) = size(find(block_16{i,j}==1),1);
            end
        end
        block16{1,a} = block_16_pxlcount;
    end
end