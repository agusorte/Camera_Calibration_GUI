function [R,T,rec,num_iter]=Hager(x3d_h,x2d_h,A,Rini)


n=size(x3d_h,1);

X2d=x2d_h';
X3d=x3d_h';

%normalize coordinates using the inverse of the intrinsic parameters matrix
X2dn=inv(A)*X2d;

if nargin>3
    opt.initR=Rini;
else
    %opt.initR=rpyMat(2*pi*(rand(3,1)));
end
%opt.initR=R;
opt.method='SVD';
[Rlu_, tlu_, it1_, obj_err1_, img_err1_] = objpose(X3d(1:3,:), X2dn(1:2,:),opt);
R=Rlu_;
T=tlu_;
num_iter=it1_;

%Estimate 3d position of the points in camera coordinates
rec=zeros(n,3); %recovered 3d positions
for i=1:n
   Xw=x3d_h(i,1:3)';
   Xcam=R*Xw+T;
   rec(i,:)=Xcam';
end

