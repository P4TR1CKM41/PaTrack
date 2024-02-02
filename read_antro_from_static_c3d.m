function [BW, BH, age] = read_antro_from_static_c3d(static_c3d_path, most_distal_marker)

acq = btkReadAcquisition(static_c3d_path);

[forceplates, forceplatesInfo] = btkGetForcePlatforms(acq);
no_forcepl = length(forceplates);
for i = 1: no_forcepl

    fpchannlesnames = fieldnames (forceplates(i).channels );
    bwd(i,1) = nanmean(forceplates(i).channels.(fpchannlesnames{3, 1}));
end
if sum(bwd) <0
    BW = sum(bwd)*-1;
else
    BW = sum(bwd);
end
BW = BW/9.81;
[markers, ~,~] = btkGetMarkers(acq);

BH = nanmean(markers.(most_distal_marker{1, 1})(:,3));
btkCloseAcquisition(acq); % Release the memory of the C++ object associated with the handle 'acq'
age =99;
end