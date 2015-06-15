

%calibration laser by points
%Agustin Ortega 
%abril 2011

function [D_all]= dist_Points2D(X0)


global CALIB_;
global DATA_;

%only otimiee extrisic parameters
om = X0(1:3);
T = X0(4:6);

% om = x(11:13)';
% T   = x(14:16)';
f   =  CALIB_.fc;
c  = CALIB_.cc;
k  = CALIB_.kc;
alpha =CALIB_.alpha_c;


X=DATA_.P3D';
x2d=DATA_.P2D';
xp = project_points3(X, om', T', f, c, k, alpha);


D_all=sum(sum(sqrt((xp-x2d).^2)));
%rest points
%P1-P0

% square poinst
%(P1-P0)^2

% for i=1;NPoints,
%     
%     P2D=
%     P3DProy=
%     err=sqrt((P2D(:,1)
% end;