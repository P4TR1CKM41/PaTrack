opensim = load('C:\Users\adpatrick\OneDrive - nih.no\Desktop\Oslo2021\Intensity1\P002OpenSim.mat')
motrack =  load('C:\Users\adpatrick\OneDrive - nih.no\Desktop\Oslo2021\Intensity1\P002.mat')
% figure(1)
% plot(motrack.NORMAL.R.GRF.DATA100ms.Y  , 'g')
% hold on
% plot(((opensim.NORMAL.R.GRF_NEW.Y')) , 'r')

figure(2)
plot(motrack.NORMAL.R.MOMENTS_100MS.RIGHT_KNEE_X    , 'g')
hold on
plot(((opensim.NORMAL.R.RIGHT_KNEE.X')) , 'r')
plot(mean(motrack.NORMAL.R.MOMENTS_100MS.RIGHT_KNEE_X,2)    , 'g', linewidth=3)
plot(mean(opensim.NORMAL.R.RIGHT_KNEE.X',2)    , 'r', linewidth=3)
ylabel ('KAM')