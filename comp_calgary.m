clc
clear all
close all
[~, ~, raw] = xlsread('C:\Users\adpatrick\Downloads\OneDrive_1_1-2-2024\Pivot_Turn_Topfolder\right\Curves_R_Pivot_Turn_All_Subjects.xlsx','NORM_R_Knee_Moment_Fron');

%%

namesv3d = {raw{2,:}};

top_folder = 'C:\Users\adpatrick\Downloads\OneDrive_1_1-2-2024\Pivot_Turn_Topfolder'; %changed
[MERGED] = on_merge_data_main(top_folder);


[conditions] = get_subfolders(top_folder);

for c = 2 : length(conditions)
    S = dir(fullfile([conditions(c).folder,'/',conditions(c).name],'*.mat'));
    for s = 1 : length (S)
        dat = load([S(s).folder, '/', S(s).name]);
        clearname = erase (S(s).name, 'OpenSim.mat');
        clearname = erase(clearname ,'P_')

        indices = [];
        for i = 1:numel(namesv3d)
            try
                if contains(namesv3d{i}, clearname)
                    indices(end+1) = i;
                end
            catch
                a = 2;
            end
        end
        try
        VISUAL(:,s) = (normalize_vector(mean(cell2mat(raw(3:103,[indices])),2), 0.5))';
        catch
        end
        trnames = fieldnames (dat.MOMENT_TABLE);
        for ll = 1 : length (trnames)
dummy (:,ll) = normalize_vector(dat.MOMENT_TABLE.(trnames{ll, 1}).knee_valgus_lat_r_moment(dat.CONTACT_KINEMATIC.(trnames{ll, 1}))/dat.OPTIONS.ANTRO.mass, 0.5)';
        end
        OSIM(:,s) = mean(dummy,2); 

    end

end