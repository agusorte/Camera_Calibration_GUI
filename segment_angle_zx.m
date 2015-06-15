%segment angle xy

function A_aux=segment_angle_zx(scan,th1,th2,th3,th4)

    theta = atan2(scan(:,3),scan(:,1))*180/pi;
    
    indx_ang=find(scan(:,3)<0 );
    
    %angle segmentation
    theta(indx_ang)=360+(atan2(scan(indx_ang,3),scan(indx_ang,1))*180/pi);
    
    indx=find((th1<theta & theta<th2) | (th3<theta & theta<th4));
    
     A_aux=[ scan(indx,1),scan(indx,2),scan(indx,3)];