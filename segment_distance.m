function A_aux=segment_distance(scan,th1,th2,th3,th4)

    dist_sq = sqrt(scan(:,1).*scan(:,1)+scan(:,2).*scan(:,2));
    
    %comments
%     x/1000 ernesto data
%     normal teo data
    
    %%distance segmentation
    
    indx=find((th1<=dist_sq & dist_sq<=th2)  | (th3<=dist_sq & dist_sq <=th4)  );
    
    
    A_aux=[ scan(indx,1),scan(indx,2),scan(indx,3)];