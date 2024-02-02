function [MERGED] = on_merge_data_main(top_folder)
close all
[conditions] = get_subfolders(top_folder);
hoch = 1;
co = 1;
for c = 1 : length(conditions)
    S = dir(fullfile([conditions(c).folder,'/',conditions(c).name],'*.mat'));
    for s = 1 : length (S)
        dat = load([S(s).folder, '/', S(s).name]);
        if strcmp(conditions(c).name, 'left') ==1
            OPTIONS.LEG ='L';
            col = 'b';
        else
            OPTIONS.LEG ='R';
            col = 'r';
        end
        for p = 1: length(dat.NORMAL.(OPTIONS.LEG).KAM(1,:))
            normnaes = fieldnames (dat.NORMAL.(OPTIONS.LEG));
            for pn = 1 : length (normnaes)
            % figure(100)
            (normnaes{pn, 1});
            MERGED.TIMECURVES.(normnaes{pn, 1})(hoch,:) = (dat.NORMAL.(OPTIONS.LEG).(normnaes{pn, 1})(:,p))';
            end
            % plot(MERGED.TIMECURVES.KAM(hoch,:), 'Color',col);
            % hold on
            MERGED.INFO.NAME2{hoch,1} = [conditions(c).name, '_', dat.NORMAL.HEADER{1, p}];
            MERGED.INFO.NAME_for_discrete{s,c} =S(s).name;
            MERGED.DISCRETE.KAM(s,c) = mean(dat.PARAMETERS.(OPTIONS.LEG).KAM);
            %P(s,c) = std(dat.PARAMETERS.(OPTIONS.LEG).KAM);
            MERGED.DISCRETE.VEL(s,c) = mean(sqrt(dat.PARAMETERS.(OPTIONS.LEG).IC_BKVEL_center_of_mass_X.^2+dat.PARAMETERS.(OPTIONS.LEG).IC_BKVEL_center_of_mass_Z.^2));
            MERGED.INFO.NAME{1,hoch} = S(s).name;
            MERGED.INFO.NAME{2,hoch} = conditions(c).name;
            MERGED.DISCRETE.torsolean(s,c)=mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_tilt-dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_lumbar_bending);
            MERGED.DISCRETE.hiprotatIC(s,c)=   mean(dat.PARAMETERS.(OPTIONS.LEG).(['IC_ANGLES_hip_rotation_',lower((OPTIONS.LEG))]));
            MERGED.DISCRETE.fsa(s,c) = mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_knee_angle_r+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_ankle_angle_r+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_list+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_hip_flexion_r);
            % if MERGED.DISCRETE.fsa(s,c) >= 40
            %     MERGED.INFO.NAME2{hoch,1}
            % else
            % 
            % end

            %% get normals
            trnames = fieldnames(dat.MOMENT_TABLE);
            
            for tr = 1 : length(trnames)
            
               jpnames = (dat.MOMENT_TABLE.(trnames{tr, 1}).Properties.VariableNames);
                for jp = 2:length(jpnames)
                 MERGED.NORMAL.TIMECURVES.(jpnames{1, jp})(:,co)   = normalize_vector(dat.MOMENT_TABLE.(trnames{tr, 1}).(jpnames{1, jp})(dat.CONTACT_KINEMATIC.(trnames{tr, 1})), 0.5)';
                end
                 MERGED.INFO.NAME_Long{co,1} = [conditions(c).name, '_', dat.NORMAL.HEADER{1, p}];
                co = co+1;
            end
            hoch = hoch+1;
        end
        clearvars dat
    end
end


end