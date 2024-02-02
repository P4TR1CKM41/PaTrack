function [ftkratio, TRC_FILE, MOT_FILE, Y, Y_kinematic, markerStruct, forcesStruct, pf, af]=dynamic_c3dMarkerless_to_trc(path, cut, FP_used, threshold, convert_type, removemarkers)
%% Cut
acq = btkReadAcquisition(path);
pf = btkGetPointFrequency(acq);
af = btkGetAnalogFrequency(acq);
try
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
catch
end
if cut ==1
    try
        btkCropAcquisition(acq, ff+(td_kinematic-20), (to_kinematic-(td_kinematic-20))+20)
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
c3d = osimC3D(path,convert_type); %1
c3d.rotateData('x' ,-90); %('x' ,-90); for goran ('z',90)
c3d.rotateData('y' ,270); %('x' ,-90); for goran ('z',90)
c3d.convertMillimeters2Meters();
[markerStruct, forcesStruct] = c3d.getAsStructs();
try
%c3d.writeTRC([erase(path, '.c3d'), '.trc']);
TRC_FILE = [erase(path, '.c3d'), '.trc'];
catch
display('No marker-based trc file created')
%TRC_FILE= '0'; 
end
c3d.writeMOT([erase(path, '.c3d'), '.mot']);
MOT_FILE = [erase(path, '.c3d'), '.mot'];
end