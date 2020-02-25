function y = logic2double(z)
[m, n]=size(z);
for i=1:m
    for j=1:n
        if z(i,j)
            y(i,j) = 1.0;
        else
            y(i,j) = 0.0;
        end
    end
end
