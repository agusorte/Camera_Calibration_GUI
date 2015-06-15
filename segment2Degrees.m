%funtion that segments range data by angle
%by Agustin Ortega 
%setember 2010

function data=segment2Degrees(scan)

    
    % Compute angle swept by data in xy plane
    theta = atan2(scan(:,2),scan(:,1))*180/pi;
    
    indx_ang=find(scan(:,2)<0);
    
    theta(indx_ang)=360+(atan2(scan(indx_ang,2),scan(indx_ang,1))*180/pi);
    
    %%found point that are in an interval
    scan_aux=[];
   
    indx=find((0<theta & theta<90) | (290<theta & theta<360));
    %indx=find(90<theta & theta<270);
    
    %save new data
   data=[ scan(indx,1),scan(indx,2),scan(indx,3)];
    
