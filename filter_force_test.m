clc
clear all
close all
path = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\MuscleAnalysis2\Intensity1\P001\Cutting10.c3d'
convert_type = 1;
additional_rot = 0;
c3d = osimC3D(path,convert_type ); %1
c3d.rotateData('x' ,-90); %('x' ,-90); for goran ('z',90)
if additional_rot ==1
    c3d.rotateData('y' ,90); %('x' ,-90); for goran ('z',90)
else
end
% % c3d.rotateData('y' ,270); %('x' ,-90); for goran ('z',90)
c3d.convertMillimeters2Meters();
%c3d.writeTRC([erase(path, '.c3d'), '.trc']);
c3d.writeMOT([erase(path, '.c3d'), '.mot']);