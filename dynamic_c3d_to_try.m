function [ftkratio, TRC_FILE, MOT_FILE, Y, Y_kinematic, markerStruct, forcesStruct, pf, af]=dynamic_c3d_to_try(path, cut, FP_used, threshold, convert_type, removemarkers, additional_rot, cut_off_markers)
%% Cut
acq = btkReadAcquisition(path);
pf = btkGetPointFrequency(acq);
af = btkGetAnalogFrequency(acq);

ftkratio = af/pf;
fpw = btkGetForcePlatformWrenches(acq, 1);
verticalgrf = fpw(FP_used).F(:,3); %for goran 1
Y = getContact_FP_app(verticalgrf', threshold);
Y_kinematic = unique(fix(Y/ftkratio));
td_analog = Y(1);
to_analog = Y(end);
ff = btkGetFirstFrame(acq);
td_kinematic =fix( Y(1)/ftkratio);
to_kinematic =fix(Y(end)/ftkratio);
if cut ==1
    try
        btkCropAcquisition(acq, ff+(td_kinematic-10), (to_kinematic-(td_kinematic-20))+20)
        % btkWriteAcquisition(acq, path)
        % [markers, markersInfo, markersResidual] = btkGetMarkers(acq);
        % markernames = fieldnames (markers);
        % idxrm = sort(find(contains(markernames, 'C_')), 'descend');
        % for i = 1 : length(idxrm)
        %     [points, pointsInfo] = btkRemovePoint(acq, idxrm(i));
        % end
        % btkWriteAcquisition(acq, path)
    catch
        disp('file to short to crop')
    end
else
end
try %% add force plate corners as markers
    [forceplates, forceplatesInfo] = btkGetForcePlatforms(acq);
    for cp = 1 : length({forceplates.corners})
        for sp = 1 : length(forceplates(cp).corners)
            residuals = ones(1,length(markers.(markernames{1, 1})))';
            [points, pointsInfo] = btkAppendPoint(acq, 'marker' , ['V_FP_',num2str(cp), '_Corner', num2str(sp)], repmat([forceplates(cp).corners(:,sp)]',length(markers.(markernames{1, 1} )),1), residuals);
        end
    end
catch
end
if removemarkers ==1;
    try %% remove vicon random makers
        [markers, markersInfo, markersResidual] = btkGetMarkers(acq);
        markernames = fieldnames (markers);
        idxrm = sort(find(contains(markernames, 'C_')), 'descend');
        for i = 1 : length(idxrm)
            [points, pointsInfo] = btkRemovePoint(acq, idxrm(i));
        end
        % btkWriteAcquisition(acq, path)
    catch
    end
else
end

btkWriteAcquisition(acq, path)
clearvars fpw Y Y_kinematic
fpw = btkGetForcePlatformWrenches(acq, 1);
verticalgrf = fpw(FP_used).F(:,3);
Y = getContact_FP_app(verticalgrf', threshold);
Y_kinematic = unique(fix(Y/ftkratio));
btkCloseAcquisition(acq)

%% fill gaps (todo)


%% Foot on force plate checker (todo)

%% Convert to trc file
% % % % c3d = osimC3D(path,convert_type); %1
% % % % c3d.rotateData('x' ,-90); %('x' ,-90); for goran ('z',90)
% % % % % % c3d.rotateData('y' ,270); %('x' ,-90); for goran ('z',90)
% % % % c3d.convertMillimeters2Meters();

%% filter marker data 


 acq1 = btkReadAcquisition(path);
[markers, markersInfo, markersResidual] = btkGetMarkers(acq1);
[b_filt,a_filt] = butter(2,  cut_off_markers/(markersInfo.frequency/2), 'low');
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
    btkSetPointLabel(acq, i, (markernames{i, 1}));
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
    clearvars dummy
end

btkGetFirstFrame(acq1);
btkSetFirstFrame(acq, btkGetFirstFrame(acq1))
btkWriteAcquisition(acq, [erase(path, '.c3d'), '_filt.c3d']);

btkCloseAcquisition(acq)
btkCloseAcquisition(acq1)

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
[ ~, forcesStruct] = c3d.getAsStructs();
clearvars c3d
c3d = osimC3D([erase(path, '.c3d'), '_filt.c3d'],convert_type ); %1
c3d.rotateData('x' ,-90); %('x' ,-90); for goran ('z',90)
if additional_rot ==1
    c3d.rotateData('y' ,90); %('x' ,-90); for goran ('z',90)
else
end

% % c3d.rotateData('y' ,270); %('x' ,-90); for goran ('z',90)
c3d.convertMillimeters2Meters();
c3d.writeTRC([erase([erase(path, '.c3d'), '_filt.c3d'], '.c3d'), '.trc']);

[markerStruct ,~] = c3d.getAsStructs();
%c3d.writeMOT([erase(path, '.c3d'), '.mot']);
movefile([erase([erase(path, '.c3d'), '_filt.c3d'], '.c3d'), '.trc'], erase([erase([erase(path, '.c3d'), '_filt.c3d'], '.c3d'), '.trc'], '_filt'));

delete([erase(path, '.c3d'), '_filt.c3d'])


% % % % % % c3d.writeTRC([erase(path, '.c3d'), '.trc']);
% % % % % % c3d.writeMOT([erase(path, '.c3d'), '.mot']);
TRC_FILE = [erase(path, '.c3d'), '.trc'];
MOT_FILE = [erase(path, '.c3d'), '.mot'];
end