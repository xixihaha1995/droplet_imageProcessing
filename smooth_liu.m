function f = smooth_liu(x, n)
n_half = fix(n);
x_l = length(x);

for i=1:n_half
    f(i) = x(i);
end

for i=n_half+1:x_l-n_half
%     m_x = 0;
%     for j=-n_half:n_half
%         m_x = m_x + x(i+j);
%     end
%     f(i) = m_x/(n+1);
      f(i) = mean(x(i-n_half:i+n_half));
end

for i=x_l-n_half+1:x_l
    f(i) = x(i);
end
%length(x)
%length(f)