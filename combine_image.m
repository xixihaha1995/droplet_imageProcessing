function y = combine_image(a, bw)

   bw1 = logic2double(bw);
%         bw1 = double(bw);
    a2 = double(a) + bw1*255;
    y = uint8(a2);
    
    figure(1);
    imshow(y);
