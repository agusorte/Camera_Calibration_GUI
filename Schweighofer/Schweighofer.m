function [R,T,rec]=Schweighofer(x3d_h,x2d_h,A,Rini)

addpath Schweighofer\objpose; % load path to LU
addpath Schweighofer\util;

n=size(x3d_h,1);

%change of coordinates: we express the world points in a normalized
%coordinate system with z=0
A=A(:,1:3);
for i=1:n
   X(i,:)=x3d_h(i,1:3)';
   img(i,:)=(inv(A)*x2d_h(i,:)')';
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
[pose,po2]=rpp(Xv,img',Rini);

%Estimate 3d position of the points in camera coordinates
rec=zeros(n,3); %recovered 3d positions
R=pose.R;
T=pose.t;
for i=1:n
    pi=Xv(:,i);
    rec(i,:)=R*pi+T;
end


%recompute R and T

[R,T]=getrotT(x3d_h(:,1:3),rec);  %solve exterior orientation





