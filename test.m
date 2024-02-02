clc
clear all
close all
path='C:\Users\adpatrick\OneDrive - nih.no\Desktop\Participant_121_180pivotturn01.c3d';

acq1 = btkReadAcquisition(path);
[markers, markersInfo, markersResidual] = btkGetMarkers(acq1);
[b_filt,a_filt] = butter(2,  20/(markersInfo.frequency/2), 'low');
markernames = fieldnames(markers);
[nframes,  ~] = size(markers.(markernames{1, 1}));
acq = btkNewAcquisition(length (markernames), nframes); % 20 points and 2000 frames
% Acquisition frequency was 200 Hz
btkSetFrequency(acq, markersInfo.frequency);

n1 = erase(path, '.c3d');
outputPath =[n1, '_filt.c3d'];
btkWriteAcquisition(acq, outputPath);

% Values setting
for i = 1:btkGetPointNumber(acq)
    btkSetPointLabel(acq, i, ['Filt_',(markernames{i, 1})]);
    for k = 1: 3
        markers.(markernames{i, 1})(:,k);
        try
            dummy(:,k) = filtfilt(b_filt,a_filt, markers.(markernames{i, 1})(:,k));
        catch
            dummy(:,k) =  fillmissing(markers.(markernames{i, 1})(:,k),'nearest');
            dummy(:,k) =  filtfilt(b_filt,a_filt, dummy(:,k));
        end
    end
    
    btkSetPoint(acq, i, dummy); % values: array of 20 by 3 by 2000
   try
    [points, pointsInfo] = btkAppendPoint(acq1, 'marker', ['Filt_',(markernames{i, 1})], dummy);
   end
    clearvars dummy
end

%%


%%

btkGetFirstFrame(acq1);
btkSetFirstFrame(acq1, btkGetFirstFrame(acq1))
btkWriteAcquisition(acq, [erase(path, '.c3d'), '_filt.c3d']);
btkWriteAcquisition(acq1, path);
btkCloseAcquisition(acq)
btkCloseAcquisition(acq1)

c3d = osimC3D(path,0); %1
c3d.rotateData('x' ,-90); %('x' ,-90); for goran ('z',90)
% % c3d.rotateData('y' ,270); %('x' ,-90); for goran ('z',90)
c3d.convertMillimeters2Meters();
%c3d.writeTRC([erase(path, '.c3d'), '.trc']);
c3d.writeMOT([erase(path, '.c3d'), '.mot']);

c3d = osimC3D(path,0); %1
c3d.rotateData('x' ,-90); %('x' ,-90); for goran ('z',90)
% % c3d.rotateData('y' ,270); %('x' ,-90); for goran ('z',90)
c3d.convertMillimeters2Meters();
c3d.writeTRC([erase([erase(path, '.c3d'), '_filt.c3d'], '.c3d'), '.trc']);
%c3d.writeMOT([erase(path, '.c3d'), '.mot']);
movefile([erase([erase(path, '.c3d'), '_filt.c3d'], '.c3d'), '.trc'], erase([erase([erase(path, '.c3d'), '_filt.c3d'], '.c3d'), '.trc'], '_filt'));

delete([erase(path, '.c3d'), '_filt.c3d'])