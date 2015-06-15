clc;
clear all
close all;

%convert to vrlm 2

cmd='vrml1tovrml2 rgbScan.wrl vrml2.wrl';

system(cmd);