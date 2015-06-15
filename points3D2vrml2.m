%% 3DPOINTS2VRML

%
%% Description
% Author - 	
%           Ernesto Homar Teniente Aviles
% 			CONACYT Fellow
%			Institut de Robotica i Informatica Industrial, CSIC-UPC
%           Last change: 06/2010
%
% Usage
%   points3D2vrml2(outfile,xyz,rgb)
%
% Variables:
%   Inputs:
%       outfile - a string, output filename 
%       xyz     - a n x 3 mat
%   Outputs: 
%      scans3D  - a n struct with fields
%                   data      - a n x 3  matrix,
%                   normal    - a 1 X 3 vector,
%                   error     - a 1 x 3 vector,
%
%      poses    - a n x 6 matrix 
%
%
%% Code:


function points3D2vrml2(outfile,xyz,rgb)
% Writes output vrml file corresponding to input xyz and rgb data

print_color = 1;
%
% Check that xyz and rgb have the same number of rows and 3 columns
if(size(xyz,1)~=size(rgb,1))
    error('Input xyz and rgb arguments should have same number of rows');
end
if(size(xyz,2)~=3 | size(rgb,2)~=3)
    error('Input xyz aand rgb arguments should have 3 columns');
end

%% Routines has a hacked way of writing formatted matrices to a file. 
%% If you have smarter ways, please let me know.
fid=fopen(outfile,'w');
% Write VRML header

fprintf(fid,'#VRML V2.0 utf8 \n');

fprintf(fid,'DEF InitView Viewpoint\n');
fprintf(fid,'{\n');
fprintf(fid,'position 0 0 10000\n');
fprintf(fid,'}\n');

fprintf(fid,'#Coordinate Axis\n');
fprintf(fid,'Shape {\n');
fprintf(fid,'geometry IndexedLineSet {\n');
fprintf(fid,' coord Coordinate {\n');
fprintf(fid,'point [\n');
fprintf(fid,'0.0 0.0 0.0,    #vertex 0 (0)\n');
fprintf(fid,'1000.0 0.0 0.0, #vertex 1 (x1)\n');
fprintf(fid,'0.0 1000.0 0.0, #vertex 2 (y1)\n');
fprintf(fid,' 0.0 0.0 1000.0, #vertex 3 (z1)\n');
fprintf(fid,']\n');
fprintf(fid,'}\n');
fprintf(fid,'colorPerVertex    FALSE\n');
fprintf(fid,'color Color {\n');
fprintf(fid,'color [\n');
fprintf(fid,'1.0 0.0 0.0,  #red\n');
fprintf(fid,'0.0 1.0 0.0,  #green\n');
fprintf(fid,'0.0 0.0 1.0,  #blue\n');
fprintf(fid,'0 0 0\n');
fprintf(fid,']\n');
fprintf(fid,'}\n');
fprintf(fid,'coordIndex [\n');
fprintf(fid,'# x (0x) red\n');
fprintf(fid,'0, 1, -1,\n');
fprintf(fid,'# y (0y) green\n');
fprintf(fid,'0, 2, -1,\n');
fprintf(fid,'# z (0z) blue)\n');
fprintf(fid,'0, 3, -1\n');
fprintf(fid,']\n');
fprintf(fid,'colorIndex [\n');
fprintf(fid,' 0, 1, 2, 0\n');
fprintf(fid,']\n');
fprintf(fid,'}\n');
fprintf(fid,'}\n');
fprintf(fid,'#3D POINT CLOUD\n');
fprintf(fid,'Shape\n');
fprintf(fid,'{\n');
fprintf(fid,'geometry PointSet\n');
fprintf(fid,'{\n');
fprintf(fid,'coord Coordinate\n');
fprintf(fid,' {\n');
fprintf(fid,'point\n');
fprintf(fid,'[\n');
fprintf(fid,'# begin points.\n');

for i=1:size(xyz,1)
    fprintf(fid,'%.4g %.4g %.4g,\n',xyz(i,:));
end

fprintf(fid,'# end points.\n');
fprintf(fid,']\n');
fprintf(fid,'}\n');

%% Print color    
if print_color
    fprintf(fid,'color Color\n');
    fprintf(fid,'{\n');
    fprintf(fid,'color\n');
    fprintf(fid,'[\n');
    % If range of rgb values is >1 divide by 255
    if(range(rgb(:))>1)
        rgb=rgb./255;
    end
    
    for i=1:size(xyz,1)
        fprintf(fid,'%.4g %.4g %.4g,\n',rgb(i,:));
    end

    fprintf(fid,']\n');
    fprintf(fid,'}\n');
end

fprintf(fid,'}\n');
fprintf(fid,'}\n');

fprintf('wrl file saved \n');
