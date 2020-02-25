% This is first version of wave image processing by using spline fitting 
% Second version modified by Liu on 6/15/2017
% Subtract the background by using a reference image
% The logic is modified;

% clear all
close all; clc;

%prefix = '../images/20200107_ndl14_h6_r1/ndl14_h6_r1_';
prefix = '../images/20200107_ndl14_h1_r1/ndl14_h1_r1_';
ext = '.bmp';
ext_out = '.txt';


ref_a = imread(strcat(prefix,num2str(-1102, '%05g'),ext),'bmp'); %max_4

FirstIm = input('Please enter the number of the wave image (FirstIm =?):  '); %6160
go_on = 'Y';
i= 0;

% the parameters for sobel function;
thresh = 0.25;

while go_on == 'Y' || go_on == 'y'

   ii = FirstIm+i;
   disp('The present image number:');
   disp(ii);
%    redo = 'Y';
%    while redo == 'Y' | redo == 'y'   
   filename = strcat(prefix, num2str(ii, '%05g'),ext);
  %  filename = 'zoom60_f2.8_testpic1.bmp';
    [a, map] = imread(filename, 'bmp');
    
%     for i0=1:512
%         a0(:,i0)= a(:,513-i0);
%     end

%     a0 = imcrop(a,[371 1000 2189 600]); % sometimes, 750 or 900 for the vertial length

  %  a0 = imcrop(a,[371 700 1500 900]); % Marco comment 10/20/10

    a0 =ref_a-a;
    a1 = imadjust(a0, [0.2 0.7], [0 1]);
  
%     figure(1); imshow(a0, map);
%    redo = 'Y';
%    while redo == 'Y' | redo == 'y'   
    
    %a1 = imadjust(a0);
%     imshow(a1)
%    bw = edge(a0,'sobel', thresh);
    bw = edge(a0,'canny', thresh);
    a2 = combine_image(a, bw);
    
%=======    answr = input('Do you want to adjust the image? Y/N [N]: ','s');
answr='';
%=======
        if isempty(answr)
        answr = 'N';
        end
    if answr == 'Y' | answr == 'y'
        inner_answr = 'N';
        while inner_answr == 'N' | inner_answr == 'n'
            xy = area_select;
            a1 = roifill(a1, xy(1,:),xy(2,:));
            bw = edge(a0, 'canny', thresh);
            a2 = combine_image(a, bw);
            inner_answr = input('Is enough? Y/N [Y];  ','s');
             if isempty(inner_answr)
                 inner_answr = 'Y';
             end
         end
    end
    
    aa = trace_image(a1,bw);
    
   %x1 = 330; %max_run1, 116in, 76in
   x1 = 1000; %96in_run2
   %x1 = 10; %56in_run2
   %x1 = 500; %28in
   y1 = 900;
   x_limit = 1000+x1;


%     x1 = 43;
%     y1 = 240;
    figure(2), imshow(a2); % command from marco to see better
    
    while ~bw(y1,x1)
        y1 = y1+1;
        if y1> 200 %730 when the vertical range is 750, 850 for 900
            [x1,y1] = ginput(1);
            break;
        end
    end

%     [x1,y1] = ginput(1);
%     hold on
%     plot(x1,y1, 'ro');
%     hold off;

  profile_x(1) = x1;
  profile_y(1) = y1;
  j = 2;

%find the second point of the profile
    x1 = fix(x1);
    y1 = fix(y1);
    nighbr_x = [x1-1 x1 x1+1 x1+1 x1+1 x1 x1-1 x1-1];
    nighbr_y = [y1-1 y1-1 y1-1 y1 y1+1 y1+1 y1+1 y1];
    
    for k=1:8,
        if bw(nighbr_y(k), nighbr_x(k))
            x1 = nighbr_x(k);
            y1 = nighbr_y(k);
            profile_x(j) = x1;
            profile_y(j) = y1;
            j = j+1;
            break;
        end
    end
    if k==8
        hold on
        plot(x1,y1,'m+','MarkerSize',20);
        plot(profile_x, profile_y,'r','Linewidth',2);
        sound(sin(1:1000));
        set(gca,'XLim',[x1-80 x1+80],'YLim',[y1-38 y1+38]) 
        pause;
        [xys, k1]= spline_fitting(profile_x, profile_y);
            % add the repeated point profilel check here
            %k1= overlap_point(k1, profile_x, profile_y, xys);
        for jj=1:length(xys)
            profile_x(k1+jj-1) = round(xys(1,jj));
            profile_y(k1+jj-1) = round(xys(2,jj));
        end
            j=k1+length(xys)-1;
            clear xys;
        end       

 while (j<2000 && x1<x_limit && y1 <899) %y1<749 when the range is 750, 899 for 900 
    
%     if x1 == profile_x(j-2) && y1 == profile_y(j-2)
        dx = profile_x(j-1)-profile_x(j-2);
        dy = profile_y(j-2)-profile_y(j-1);
        [x1, y1] = nighbor_search(profile_x(j-1), profile_y(j-1), dx, dy, bw);
        profile_x(j) = x1;
        profile_y(j) = y1;
%    end
    
    for k1=1:j-1
        if profile_x(j)==profile_x(k1) && profile_y(j) == profile_y(k1)
            hold on
            plot(x1,y1,'g+','MarkerSize',20);
            plot(profile_x, profile_y,'r','Linewidth',2);
        %sound(sin(1:1000));  
        set(gca,'XLim',[x1-80 x1+80],'YLim',[y1-38 y1+38]) 
            pause;
            [xys, k1]= spline_fitting(profile_x, profile_y);
            % check the repeated points in profile here
            k1= overlap_point(k1, profile_x, profile_y, xys);
            for jj=1:length(xys)
                profile_x(k1+jj-1) = round(xys(1,jj));
                profile_y(k1+jj-1) = round(xys(2,jj));
            end
            j=k1+length(xys)-1;
            clear xys;
            break;
        end
    end
    x1 = profile_x(j);
    y1 = profile_y(j);
    j=j+1;
end

imshow(a);
hold on
%plot(513-profile_x, profile_y,'r')
plot(profile_x, profile_y,'r')

hold off

redo = 'Y';
while redo == 'Y' | redo == 'y'

redo = input('Redo the curve? Y/N [Y]: ', 's');
%redo='';
  if isempty(redo)
      redo = 'Y';
  end
  if redo == 'Y' || redo == 'y'
      profile_x1 = profile_x;
      profile_y1 = profile_y;
      clear profile_x profile_y;
      imshow(a2)
      hold on
      plot(profile_x1, profile_y1,'r');
      pause;
      [xys, k1]= spline_fitting(profile_x1, profile_y1);
      profile_x(1:k1-1) = profile_x1(1:k1-1);
      profile_y(1:k1-1) = profile_y1(1:k1-1);
      for jj=1:length(xys)
          profile_x(k1+jj-1) = round(xys(1,jj));
          profile_y(k1+jj-1) = round(xys(2,jj));
      end
      j=k1+length(xys)-1;
      clear xys;
      
      while (j<2000 && profile_x(j-1)<x_limit && profile_y(j-1) < 899) % the same standards
          
          dx = profile_x(j-1)-profile_x(j-2);
          dy = profile_y(j-2)-profile_y(j-1);
          [x1, y1] = nighbor_search(profile_x(j-1), profile_y(j-1), dx, dy, bw);
          profile_x(j) = x1;
          profile_y(j) = y1;
          
          for k1=1:j-1
              if profile_x(j)==profile_x(k1) && profile_y(j) == profile_y(k1)
                  hold on
                  plot(x1,y1,'g+','MarkerSize',20);
                  plot(profile_x, profile_y,'r','Linewidth',2);
                  %sound(sin(1:1000));
                  set(gca,'XLim',[x1-80 x1+80],'YLim',[y1-38 y1+38])
                  pause;
                  [xys, k1]= spline_fitting(profile_x, profile_y);
                  % check the repeated points in profile here
                  k1= overlap_point(k1, profile_x, profile_y, xys);
                  for jj=1:length(xys)
                      profile_x(k1+jj-1) = round(xys(1,jj));
                      profile_y(k1+jj-1) = round(xys(2,jj));
                  end
                  j=k1+length(xys)-1;
                  clear xys;
                  break;
              end
          end
          x1 = profile_x(j);
          y1 = profile_y(j);
          j=j+1;
      end
%       clear profile_x profile_y;
%       thresh = input('Please enter a new thresh value (current value 0.1):  ')
  
    imshow(a);
    hold on
    %plot(513-profile_x, profile_y,'r')
    plot(profile_x, profile_y,'r')

    hold off
  end
  
end

filename_out = strcat(prefix, num2str(ii, '%04g'),ext_out);
fid = fopen(filename_out,'w');
fprintf(fid, '%8.2f \t %8.2f\n',[profile_x; 1000-profile_y]);
fclose(fid);
clear profile_x profile_y

go_on = input('Continue to process NEXT image? Y/N [Y]: ','s');
%go_on ='';
    if isempty(go_on)
        go_on = 'Y';
    end
    i = i+1;

end












