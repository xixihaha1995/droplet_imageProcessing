close all; 
clc;

fileID = fopen('ndl14_h4_r1_-800.txt');
C = textscan(fileID, '%f %f');

yourImage = imread('ndl14_h4_r1_-0800.bmp');
imshow(yourImage);
hold on;

x = C{1};
y = 1000 - C{2};

plot(x,y);