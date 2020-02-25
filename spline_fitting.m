function [xys, kk]= spline_fitting(x,y)
hold on
% Initially, the list of points is empty.
xy = [];
n=0;

% Loop, picking up the points.
disp('Left mouse button picks points. Then press ENTER!!!!')
disp('.... First click should be on the RED LINE before "+" sign !!!')
disp('Right mouse button picks last point.')
disp('After selecting redo, zooming in or out and draging, press ENTER, and continue picking up the remaining points')
but = 1;
while but == 1
    [xi,yi,but] = ginput(1);
    plot(xi,yi,'ro')
    n = n+1;
    xy(:,n) = [xi;yi];
end

l_x = length(x);
kk = l_x;
dt = 10000.0;
for i=1:l_x
    dd = sqrt((xy(1,1)-x(i))^2+(xy(2,1)-y(i))^2);
    if dd < dt
        dt = dd;
        kk =i;
    end
end
xy(:,1) = [x(kk); y(kk)];
% Interpolate with a spline curve and finer spacing.
t = 1:n;
ts = [];
for i=1:n-1
    dd = sqrt((xy(1,i+1)-xy(1,i))^2+(xy(2,i+1)-xy(2,i))^2);
    dn = fix(dd+1);
    ts = [ts, i:1.0/dn:i+1-1.0/dn];
end

xys = spline(t,xy,ts);

% Plot the interpolated curve.
plot(xys(1,:),xys(2,:),'r-');
hold off