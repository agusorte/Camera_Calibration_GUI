

%calibration laser by points

function  [x,fval,exitflag,output]=calibration_laser(cam0,options,optim_search)

%only optimize extric parameters

%cam0 =[omc T]

global  CALIB_;

switch optim_search
    case 1
        [x,fval,exitflag,output] = fminsearch('dist_Points2D',cam0,options);   %%%%<--- optimise
        %     [x,fval,exitflag,output] =  fsolve('calibr_urus_cam_angle', x0, opt);
    case 2
        [x,fval,exitflag,output] =  fsolve('dist_Points2D', cam0,options);
    case 3
        [x,fval,exitflag,output] = fminunc('dist_Points2D', cam0,options);   %%%%<--- optimise
    case 4
       % [x,fval,exitflag,output] = fmincon(@dist2lines2D_angle_cond,cam0, [], [], [], [], [], [],'nonlconstr',options);   %%%%<--- optimise

end