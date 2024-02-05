clc
clear all
close all
tic
command = 'opensim-cmd run-tool "C:\Users\adpatrick\OneDrive - nih.no\Desktop\HSO_TRUNK_EXTENDED\Trunk_Lean_15_hinten\ID01\Setup_SO_Trunk_Lean_15_hinten1.xml"';
[status, cmdout] = system(command);
display ('done')
toc