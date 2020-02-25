    function [x,y] = nighbor_search(x1, y1, dx, dy, bw)
    nighbr_x =[x1-1 x1 x1+1 x1+1 x1+1 x1 x1-1 x1-1];
    nighbr_y = [y1-1 y1-1 y1-1 y1 y1+1 y1+1 y1+1 y1];
%     hold on
%     plot(nighbr_x, nighbr_y, 'rs');
%     hold off;
    if dy >0 & dx >=0
        kk = 0;
    elseif dy <=0 & dx >=0
        kk = 2;
    elseif dy <=0 & dx <=0
        kk = 4;
    else
        kk = 6;
    end
    
    count = 0;
    for k=1:8,
        k1 = k-1+kk;
        k1 = k1-fix(k1/8)*8+1;
        if bw(nighbr_y(k1), nighbr_x(k1))
            x = nighbr_x(k1);
            y = nighbr_y(k1);
            count = 1;
            break;
        end
    end
    
    if count ==0
        disp('There is a bug in the program')
        x = 0;
        y = 0;
    end