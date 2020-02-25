clc

prefix = 'C:\Users\lab-admin\Desktop\Lichen Wu\images\20200107_ndl14_h4_r1\ndl14_h4_r1_';
ext = '.bmp';
OutputDir = 'C:\Users\lab-admin\Desktop\Lichen Wu\images\Processed_20200107_ndl14_h4_r1\';

rgb = imread('ndl14_h4_r1_-0868.bmp');
imshow(rgb);
% rgb = imbinarize(rgb);

[centers,radii] = imfindcircles(rgb,[45 58],'ObjectPolarity','dark');

% imshow(rgb)
h = viscircles(centers,radii);
saveas(gcf,'circle.bmp');