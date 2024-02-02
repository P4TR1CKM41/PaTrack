clc
clear all
close all
import org.opensim.modeling.*
modelpath = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\Oslo2021\Intensity1\P001\scaled_weighted_matlab.osim'

model = Model(modelpath);
model.initSystem();
model.get_BodySet