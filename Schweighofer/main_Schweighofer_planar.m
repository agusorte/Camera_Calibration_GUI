clear all; close all;

addpath data;

%generate simulated input data
load_points=1;
if ~load_points
    n=10; %number of points
    [A,point,Rt]=generate_noisy_input_data2(n,5);
    save('data\input_data_noise.mat','A','point','Rt');
else
    load('data\input_data_noise.mat','A','point','Rt');
    n=size(point,2);
    draw_noisy_input_data(point);
end


%change of coordinates: we express the world points in a normalized
%coordinate system with z=0
A=A(:,1:3);
for i=1:n
   X(i,:)=point(i).Xworld';
   img(i,:)=(inv(A)*point(i).Ximg)';
end
m=mean(X);
X_=X-repmat(m,[n,1]);
[u,s,v]=svd(X);
v1=v(:,1); v1=v1/norm(v1);
v2=v(:,2); v2=v2/norm(v2);
%express the points in the plane parameterized by v1,v2
C=inv(v);
Xv=C*X_';
Xv(3,:)=0;

%compute pose using Schweighofer method
[pose,po2]=rpp(Xv,img');

%extract results
R=pose.R;
T=pose.t;
for i=1:n
    pi=Xv(:,i);
    point(i).Xcam_est=R*pi+T;
end

