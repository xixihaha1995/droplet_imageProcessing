function y = trace_image(a, bw)

    bw1 = logic2double(bw);
%     bw1 = double(bw);
    a2 = double(a) + bw1*255;
    y = uint8(a2);