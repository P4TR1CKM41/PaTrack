clc
clear all
close all
% use to print opensim log in matlab command window
% import org.opensim.modeling.*
% myMatlabLog = JavaLogSink()
% Logger.addSink(myMatlabLog)

pathtopfolder = cd; %% location of the app
% OPTIONS.top_folder = 'C:\Users\adpatrick\Downloads\Calgary_Data_all\CoD180';
% OPTIONS.top_folder = 'C:\Users\adpatrick\Downloads\Calgary_Data_all\Heading';
%OPTIONS.top_folder = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\Oslo2021';
%OPTIONS.top_folder ='C:\Users\adpatrick\Downloads\wetransfer_model-files_2023-11-24_1233\10k_c3d_Kopi\10k_c3d_Kopi';
% OPTIONS.top_folder = 'C:\Users\adpatrick\Downloads\Calgary_Data_all\Nineteendegree';
%OPTIONS.top_folder = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\TOPFOLDER_Markerless_Analysis';
%setup_Folder = 'MARKERLESS_25B';
setup_Folder = 'OSLO'; %changed
RRA = 1;
SO = 1;
[OPTIONS] = get_set_up_files(setup_Folder,pathtopfolder, RRA, SO);
%OPTIONS.top_folder = 'C:\Users\adpatrick\Downloads\HSO_TRUNK';
%OPTIONS.top_folder = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\TOPFOLDER_Markerless_Analysis';
OPTIONS.top_folder = 'C:\Users\adpc\OneDrive - nih.no\Desktop\OneDrive_1_1-2-2024\Pivot_Turn_Topfolder'; %changed
OPTIONS.top_folder = "C:\Users\adpatrick\OneDrive - nih.no\Desktop\HSO_TRUNK_EXTENDED";
OPTIONS.MOTION = 'Overground'; %changed
OPTIONS.HAS_PROBE =1;
% OPTIONS.MOTION = 'Treadmill';
OPTIONS.Ref_Identifier = 'Static';
% OPTIONS.Ref_Identifier = 'neutral'; %changed
%OPTIONS.MARKERLESS = 1;
OPTIONS.MARKERLESS = 0; %changed
OPTIONS.FP_used = 1; %changed
OPTIONS.cutting_c3d =1; % changed
OPTIONS.FP_Stance_Threshold = 30; % 50
OPTIONS.convert_type = 1; % 0 war motack gleich
%OPTIONS.SETTINGS = "OSLO";
OPTIONS.remove_unwanted_markers = 0; %changed
% OPTIONS.SETTINGS = "CALGARY";
OPTIONS.SETTINGS = "OSLO";
OPTIONS.ajusted_scaled_model =1;
% OPTIONS.SETTINGS = "JOHNATAN";
[~, ~, OPTIONS.MARKER_SETUP.HIP] = xlsread('Marker_for_segments_v3.xlsx','HIP');
[~, ~, OPTIONS.MARKER_SETUP.KNEE] = xlsread('Marker_for_segments_v3.xlsx','KNEE');
[~, ~, OPTIONS.MARKER_SETUP.ANKLE] = xlsread('Marker_for_segments_v3.xlsx','ANKLE');
[~, ~, OPTIONS.MARKER_SETUP.FOOT] = xlsread('Marker_for_segments_v3.xlsx','FOOT');
[~, ~, OPTIONS.MARKER_SETUP.MTP] = xlsread('Marker_for_segments_v3.xlsx','MTP');
[~, ~, OPTIONS.MARKER_SETUP.DISTAL] = xlsread('Marker_for_segments_v3.xlsx','DISTAL_Marker');
OPTIONS.Leg_2_Analyze ='Left';
OPTIONS.Leg_2_Analyze ='Right';
if OPTIONS.Leg_2_Analyze == "Left"
    multi = -1;
    OPTIONS.LEG = 'L';
elseif OPTIONS.Leg_2_Analyze == "Right"
    multi = 1;
    OPTIONS.LEG = 'R';
else
    OPTIONS.LEG = 'B';
end

% % % % % OPTIONS.PATH.GENERIC_MODEL = 'gait2392_frontHingesKnee.osim';
% % % % % OPTIONS.GENERIC.markersetname='Markerset_lowerExtrimities_Torso_wo_shoulder.xml' ;
% % % % % OPTIONS.GENERIC.scalesetupname = 'Scale_Setup_lowerExtrimities_Torso_wo_shoulder.xml';
% % % % % OPTIONS.GENERIC.setupIKname = 'Setup_IK_lowerExtrimities_Torso_wo_shoulder.xml';
% % % % % OPTIONS.GENERIC.setupIDname = 'ID_Setup.xml';
% % % % % OPTIONS.GENERIC.setupBKname = 'BODYKIN_Setup.xml';




% % % % % % OPTIONS.PATH.GENERIC_MODEL = 'gait2392_frontHingesKnee_without_Markers.osim';
% % % % % % OPTIONS.GENERIC.markersetname='Markerset_Calgary.xml' ;
% % % % % % OPTIONS.GENERIC.scalesetupname = 'Scale_Setup_lowerExtrimities_Calgary.xml';
% % % % % % OPTIONS.GENERIC.setupIKname = 'Setup_IK_lowerExtrimities_Calgary.xml';
% % % % % % OPTIONS.GENERIC.setupIDname = 'ID_Setup.xml';
% % % % % % OPTIONS.GENERIC.setupBKname = 'BODYKIN_Setup.xml';




% % % % % % %% full body hindge joint knee
% % % % % % OPTIONS.PATH.GENERIC_MODEL = 'gait2392_frontHingesKneeFullbody_wo_markers.osim';
% % % % % % OPTIONS.GENERIC.markersetname='Markerset_Calgary_Fullbody_v2.xml' ;
% % % % % % OPTIONS.GENERIC.scalesetupname = 'Setup_Scaling_fullbody_Calgary.xml';
% % % % % % OPTIONS.GENERIC.setupIKname = 'Setup_IK_Calgary_Fullbody.xml';
% % % % % % OPTIONS.GENERIC.setupIDname = 'ID_Setup.xml';
% % % % % % OPTIONS.GENERIC.setupBKname = 'BODYKIN_Setup.xml';


%% OLD HSO
% OPTIONS.PATH.GENERIC_MODEL = 'subject01_simbody_without_markers.osim';
% OPTIONS.GENERIC.markersetname='Markerset_HSO.xml' ;
% OPTIONS.GENERIC.scalesetupname = 'Scale_Setup_HSO.xml';
% OPTIONS.GENERIC.setupIKname = 'Setup_IK_HSO.xml';
% OPTIONS.GENERIC.setupIDname = 'ID_Setup.xml';
% OPTIONS.GENERIC.setupBKname = 'Setup_BODYKIN_HSO.xml';


%% NEW HSO

% % % OPTIONS.PATH.GENERIC_MODEL = 'subject01_simbody_without_markers_HSO.osim';
% % % OPTIONS.GENERIC.markersetname='Markerset_HSOv2.xml' ;
% % % OPTIONS.GENERIC.scalesetupname = 'Setup_Scaling_HSOv2.xml';
% % % OPTIONS.GENERIC.setupIKname = 'Setup_IK_HSO_v2.xml';
% % % OPTIONS.GENERIC.setupIDname = 'ID_Setup.xml';
% % % OPTIONS.GENERIC.setupBKname = 'Setup_BODYKIN_HSO.xml';

%% remove all opensim files (but keep the mat file)
[conditions] = get_subfolders(OPTIONS.top_folder);
startcon = 1;
endcon = 2%length(conditions);
% endcon = 1;
if OPTIONS.MARKERLESS ==0
    filetypes = {'*.osim', '*.sto', '*.xml', '*.mot', '*.trc', '*.txt'};
else
    filetypes = {'*.osim', '*.sto', '*.xml'};
end
for c = startcon: endcon
    [subjects] =  get_subfolders([conditions(c).folder,'/',conditions(c).name]);
    for s = 1: length(subjects)
        for ft = 1 : length (filetypes)
            fileList =  dir(fullfile([subjects(s).folder,'/',subjects(s).name], (filetypes{1, ft})));
            for del = 1:length(fileList)
                delete([fileList(del).folder, '/', fileList(del).name])
            end
        end
    end
end

tic
for c = startcon: endcon
    [subjects] =  get_subfolders([conditions(c).folder,'/',conditions(c).name]);
    for s = 1: length(subjects)

        if OPTIONS.MARKERLESS==0
            fileListc3d = dir(fullfile([subjects(s).folder,'/',subjects(s).name], '*.c3d'));
        else % search for trc files
            fileListc3d = dir(fullfile([subjects(s).folder,'/',subjects(s).name], '*.trc'));
        end
        anthro_file = dir(fullfile([subjects(s).folder,'/',subjects(s).name], '*.csv'));
        try % if antrhofiles not exists
            anthro_file = readmatrix([anthro_file.folder, '/', anthro_file.name]);
        catch % write a new antrofile based on user input
            try

                %% load a c3d a try to load body mass and body height
                static_c3d_path = [fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},OPTIONS.Ref_Identifier)))).folder, '/',fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},OPTIONS.Ref_Identifier)))).name];
                [OPTIONS.ANTRO.mass,  OPTIONS.ANTRO.height,OPTIONS.ANTRO.age ] = read_antro_from_static_c3d(static_c3d_path, ((OPTIONS.MARKER_SETUP.DISTAL(find(~cellfun(@isempty,(strfind((OPTIONS.MARKER_SETUP.DISTAL(:,1)), OPTIONS.SETTINGS)))),end))));
                x = [{OPTIONS.ANTRO.mass},  {OPTIONS.ANTRO.height},{OPTIONS.ANTRO.age}]';
                writecell (x, [subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv']);
                anthro_file = readmatrix([subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv']);
                aa =2;
            catch
                x = inputdlg({'Body height [cm]','Body mass [kg]','Age [years]'},...
                    subjects(s).name, [1 50; 1 12; 1 7]);
                OPTIONS.ANTRO.mass = str2num(x{1, 1});
                OPTIONS.ANTRO.height = str2num(x{2, 1});
                OPTIONS.ANTRO.age = str2num(x{3, 1});
                writecell (x, [subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv'])
                anthro_file = readmatrix([subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv']);
            end
        end
        % only because c3d files have been messed up for one project
        if anthro_file(2) >120
            OPTIONS.ANTRO.mass = anthro_file(1);
            OPTIONS.ANTRO.height = anthro_file(2);
            OPTIONS.ANTRO.age = anthro_file(end);
        else
            OPTIONS.ANTRO.mass = anthro_file(2);
            OPTIONS.ANTRO.height = anthro_file(1);
            OPTIONS.ANTRO.age = anthro_file(end);
        end
        %% static
        static_c3d_path = [fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},OPTIONS.Ref_Identifier)))).folder, '/',fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},OPTIONS.Ref_Identifier)))).name];
        %% convert trc
        disp(static_c3d_path)
        if OPTIONS.MARKERLESS==0 % becuase for markerless I already have trc files no need to convert
            static_c3d_to_trc_Motrack(static_c3d_path, OPTIONS)
        else
        end
        %% scale
        if OPTIONS.MARKERLESS==0
            [OPTIONS.PATH.SCALED_MODEL, OPTIONS.STATIC_PATH.IK_res_static, OPTIONS.STATIC_ANGLES.IK_res_static]=scaling_OLE(replace (static_c3d_path, '.c3d', '.trc'),  subjects(s).name, [subjects(s).folder,'/',subjects(s).name], erase(fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},OPTIONS.Ref_Identifier)))).name, '.c3d'), OPTIONS.PATH.GENERIC_MODEL, OPTIONS.GENERIC.markersetname, OPTIONS.GENERIC.scalesetupname, OPTIONS);
        else % only some function input change when markerless
            [OPTIONS.PATH.SCALED_MODEL, OPTIONS.STATIC_PATH.IK_res_static, OPTIONS.STATIC_ANGLES.IK_res_static]=scaling_OLE(replace (static_c3d_path, '.c3d', '.trc'),  subjects(s).name, [subjects(s).folder,'/',subjects(s).name], erase(fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},OPTIONS.Ref_Identifier)))).name, '.trc'), OPTIONS.PATH.GENERIC_MODEL, OPTIONS.GENERIC.markersetname, OPTIONS.GENERIC.scalesetupname, OPTIONS);
        end
        %% %% Read in the robot Model and change the coordinate values to computed ones.
        if OPTIONS.ajusted_scaled_model ==1
            ajust_scaled_model_joint_angles(OPTIONS.PATH.SCALED_MODEL, OPTIONS.STATIC_PATH.IK_res_static, OPTIONS.STATIC_ANGLES.IK_res_static)
        else
        end
        trials = find( ~cellfun(@(c) any(strfind(c,OPTIONS.Ref_Identifier)), {fileListc3d.name}) ==1);
        for dy = 1: length(trials) % loop through all files that are not static!
            temp_c3d = [fileListc3d(trials(dy)).folder, '/', fileListc3d(trials(dy)).name];
            trialname =  matlab.lang.makeValidName(erase(fileListc3d(trials(dy)).name, '.c3d'));
            disp (['Working on...: ' ,conditions(c).name, ' ', subjects(s).name, ' ', trialname ])
            if OPTIONS.MARKERLESS==0 % convert c3ds to opensim formats when haveing marker-based and run IK
                [OPTIONS.ftkratio, OPTIONS.PATHS.TRC.(trialname), OPTIONS.PATHS.MOT.(trialname), CONTACT_ANALOG.(trialname), CONTACT_KINEMATIC.(trialname), MARKERS.(trialname), GRF.(trialname), OPTIONS.FREQ_KINEMATIC, OPTIONS.FREQ_ANALOG]=dynamic_c3d_to_try([fileListc3d(trials(dy)).folder, '/', fileListc3d(trials(dy)).name], OPTIONS.cutting_c3d, OPTIONS.FP_used, OPTIONS.FP_Stance_Threshold, OPTIONS.convert_type, OPTIONS.remove_unwanted_markers);
                [OPTIONS.PATHS.IK.(trialname), initial_time, final_time]=IK_app(OPTIONS.PATHS.TRC.(trialname),[subjects(s).folder,'\',subjects(s).name], OPTIONS.GENERIC.setupIKname);
            else % IK on markerless no need to convert c3d files
                OPTIONS.PATHS.TRC.(trialname) = temp_c3d;
                dummy = split(fileListc3d(trials(dy)).name, '_');
                try
                    yu = find(~isletter(dummy{3}),1);
                    corrospondingc3d_file = [fileListc3d(trials(dy)).folder, '/',dummy{3}(1:yu(1)-1) ' ' dummy{3}(yu(1):length(dummy{3})), '.c3d'];
                    [OPTIONS.ftkratio, ~, OPTIONS.PATHS.MOT.(trialname), CONTACT_ANALOG.(trialname), CONTACT_KINEMATIC.(trialname), MARKERS.(trialname), GRF.(trialname), OPTIONS.FREQ_KINEMATIC, OPTIONS.FREQ_ANALOG]=dynamic_c3dMarkerless_to_trc(corrospondingc3d_file, 0, OPTIONS.FP_used, OPTIONS.FP_Stance_Threshold, OPTIONS.convert_type, 0);
                catch
                end
                [OPTIONS.PATHS.IK.(trialname), initial_time, final_time]=IK_app(OPTIONS.PATHS.TRC.(trialname),[subjects(s).folder,'\',subjects(s).name], OPTIONS.GENERIC.setupIKname);
            end
            pause(0.0000001)
            if OPTIONS.MOTION == "Treadmill" && OPTIONS.MARKERLESS==0
                %% perpare force data by creating two mot files one for the left and one for the right foot contact
                [OPTIONS.PATHS.MOT_LEFT.(trialname), OPTIONS.PATHS.MOT_RIGHT.(trialname)]= TREATMILL_force_split_mot(OPTIONS.PATHS.MOT.(trialname), OPTIONS);
                %% run ID for L and R seperate
                [OPTIONS.PATHS.ID_L.(trialname)]=ID_app_treadmill(OPTIONS.PATHS.MOT_LEFT.(trialname),OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], OPTIONS.PATHS.IK.(trialname), 'Left', OPTIONS.FP_used, OPTIONS.GENERIC.setupIDname);
                [OPTIONS.PATHS.ID_R.(trialname)]=ID_app_treadmill(OPTIONS.PATHS.MOT_RIGHT.(trialname),OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], OPTIONS.PATHS.IK.(trialname), 'Right', OPTIONS.FP_used, OPTIONS.GENERIC.setupIDname);
                [~,~,MOMENT_TABLE.L.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.ID_L.(trialname)(1:find((OPTIONS.PATHS.ID_L.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.ID_L.(trialname)(find((OPTIONS.PATHS.ID_L.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,MOMENT_TABLE.R.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.ID_R.(trialname)(1:find((OPTIONS.PATHS.ID_R.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.ID_R.(trialname)(find((OPTIONS.PATHS.ID_R.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,GRF_TABLE.L.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.MOT_LEFT.(trialname)(1:find((OPTIONS.PATHS.MOT_LEFT.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.MOT_LEFT.(trialname)(find((OPTIONS.PATHS.MOT_LEFT.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,GRF_TABLE.R.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.MOT_RIGHT.(trialname)(1:find((OPTIONS.PATHS.MOT_RIGHT.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.MOT_RIGHT.(trialname)(find((OPTIONS.PATHS.MOT_RIGHT.(trialname)) == '\', 1, 'last')+1:end)));
                CONTACT_ANALOG.L.(trialname) = getContact_FP_app_treatmill(GRF_TABLE.L.(trialname).(GRF_TABLE.L.(trialname).Properties.VariableNames{find(string(GRF_TABLE.L.(trialname).Properties.VariableNames) == ['ground_force', num2str(OPTIONS.FP_used), '_vy'])})', OPTIONS.FP_Stance_Threshold) ;
                CONTACT_KINEMATIC.L.(trialname).TD = fix(CONTACT_ANALOG.L.(trialname).TD/OPTIONS.ftkratio);
                CONTACT_KINEMATIC.L.(trialname).TO = fix(CONTACT_ANALOG.L.(trialname).TO/OPTIONS.ftkratio);
                CONTACT_ANALOG.R.(trialname) = getContact_FP_app_treatmill(GRF_TABLE.R.(trialname).(GRF_TABLE.R.(trialname).Properties.VariableNames{find(string(GRF_TABLE.R.(trialname).Properties.VariableNames) == ['ground_force', num2str(OPTIONS.FP_used), '_vy'])})', OPTIONS.FP_Stance_Threshold) ;
                CONTACT_KINEMATIC.R.(trialname).TD = fix(CONTACT_ANALOG.R.(trialname).TD/OPTIONS.ftkratio);
                CONTACT_KINEMATIC.R.(trialname).TO = fix(CONTACT_ANALOG.R.(trialname).TO/OPTIONS.ftkratio);
            elseif OPTIONS.MOTION == "Overground" && OPTIONS.MARKERLESS==0
                [OPTIONS.PATHS.ID.(trialname), OPTIONS.PATHS.Exload.(trialname)]=ID_app(OPTIONS.PATHS.MOT.(trialname),OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], OPTIONS.PATHS.IK.(trialname), OPTIONS.Leg_2_Analyze, OPTIONS.FP_used, OPTIONS.GENERIC.setupIDname, initial_time, final_time);
                [~,~,MOMENT_TABLE.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.ID.(trialname)(1:find((OPTIONS.PATHS.ID.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.ID.(trialname)(find((OPTIONS.PATHS.ID.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,GRF_TABLE.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.MOT.(trialname)(1:find((OPTIONS.PATHS.MOT.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.MOT.(trialname)(find((OPTIONS.PATHS.MOT.(trialname)) == '\', 1, 'last')+1:end)));
                CONTACT_ANALOG.(trialname) = getContact_FP_app(GRF_TABLE.(trialname).(GRF_TABLE.(trialname).Properties.VariableNames{find(string(GRF_TABLE.(trialname).Properties.VariableNames) == ['ground_force_', num2str(OPTIONS.FP_used), '_vy'])})', OPTIONS.FP_Stance_Threshold) ;
                CONTACT_KINEMATIC.(trialname) = unique(fix(CONTACT_ANALOG.(trialname)/OPTIONS.ftkratio));
            end
            [OPTIONS.PATHS.BK_ACC.(trialname), OPTIONS.PATHS.BK_VEL.(trialname), OPTIONS.PATHS.BK_POS.(trialname)] = Bodykinematics_app(OPTIONS.PATHS.IK.(trialname),OPTIONS.PATH.SCALED_MODEL, [subjects(s).folder,'/',subjects(s).name], trialname, OPTIONS.GENERIC.setupBKname, initial_time, final_time);
            [~,~,ANGLES_TABLE.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.IK.(trialname)(1:find((OPTIONS.PATHS.IK.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.IK.(trialname)(find((OPTIONS.PATHS.IK.(trialname)) == '\', 1, 'last')+1:end)));
            [~,~,BK_ACC_TABLE.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.BK_ACC.(trialname)(1:find((OPTIONS.PATHS.BK_ACC.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.BK_ACC.(trialname)(find((OPTIONS.PATHS.BK_ACC.(trialname)) == '\', 1, 'last')+1:end)));
            [~,~,BK_VEL_TABLE.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.BK_VEL.(trialname)(1:find((OPTIONS.PATHS.BK_VEL.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.BK_VEL.(trialname)(find((OPTIONS.PATHS.BK_VEL.(trialname)) == '\', 1, 'last')+1:end)));
            [~,~,BK_POS_TABLE.(trialname)] =  readMOTSTOTRCfiles((OPTIONS.PATHS.BK_POS.(trialname)(1:find((OPTIONS.PATHS.BK_POS.(trialname)) == '\', 1, 'last'))),(OPTIONS.PATHS.BK_POS.(trialname)(find((OPTIONS.PATHS.BK_POS.(trialname)) == '\', 1, 'last')+1:end)));
            %RES_GRF.(trialname) = sqrt(sum([GRF_TABLE.(trialname).(GRF_TABLE.(trialname).Properties.VariableNames{find(~cellfun('isempty', strfind(GRF_TABLE.(trialname).Properties.VariableNames, ['ground_force_', num2str(OPTIONS.FP_used), '_vx'])))}), GRF_TABLE.(trialname).(GRF_TABLE.(trialname).Properties.VariableNames{find(~cellfun('isempty', strfind(GRF_TABLE.(trialname).Properties.VariableNames, ['ground_force_', num2str(OPTIONS.FP_used), '_vy'])))}), GRF_TABLE.(trialname).(GRF_TABLE.(trialname).Properties.VariableNames{find(~cellfun('isempty', strfind(GRF_TABLE.(trialname).Properties.VariableNames, ['ground_force_', num2str(OPTIONS.FP_used), '_vz'])))})].^2, 2));
            pause(0.000001)
            %%RRA
            if RRA ==1
                [OPTIONS.PATHS.actuation_force.(trialname), OPTIONS.PATHS.actuation_power.(trialname), OPTIONS.PATHS.actuation_speed.(trialname), OPTIONS.PATHS.avgResiduals.(trialname), OPTIONS.PATHS.controls.(trialname) , OPTIONS.PATHS.Kinematics_dudt.(trialname), OPTIONS.PATHS.Kinematics_q.(trialname), OPTIONS.PATHS.Kinematics_u.(trialname), OPTIONS.PATHS.pErr.(trialname), OPTIONS.PATHS.states.(trialname), OPTIONS.PATHS.ajusted_model.(trialname)]= RRA_app(pathtopfolder,OPTIONS,trialname, [subjects(s).folder,'\',subjects(s).name] ,initial_time, final_time);
                [~,~,RRA_TABLE.actuation_force.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.actuation_force.(trialname));
                [~,~,RRA_TABLE.actuation_power.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.actuation_power.(trialname));
                [~,~,RRA_TABLE.actuation_speed.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.actuation_speed.(trialname));
                [~,~,RRA_TABLE.controls.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.controls.(trialname));
                [~,~,RRA_TABLE.Kinematics_dudt.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.Kinematics_dudt.(trialname));
                [~,~,RRA_TABLE.Kinematics_q.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.Kinematics_q.(trialname));
                [~,~,RRA_TABLE.Kinematics_u.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.Kinematics_u.(trialname));
                [~,~,RRA_TABLE.pErr.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.pErr.(trialname));
                [~,~,RRA_TABLE.states.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.states.(trialname));
                RRA_TABLE.avgResiduals.(trialname) =readcell([subjects(s).folder,'/',subjects(s).name, '/', OPTIONS.PATHS.avgResiduals.(trialname)]);
                [OPTIONS.PATHS.ID_AFTER_RRA.(trialname), OPTIONS.PATHS.Exload.(trialname)]=ID_app_afterRRA(OPTIONS.PATHS.MOT.(trialname),OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], [subjects(s).folder,'/',subjects(s).name, '/',OPTIONS.PATHS.Kinematics_q.(trialname)], OPTIONS.Leg_2_Analyze, OPTIONS.FP_used, OPTIONS.GENERIC.setupIDname, initial_time, final_time, trialname);

            else
            end
            pause(0.000001)
            %%make a new model with probe
            if OPTIONS.HAS_PROBE ==1
                %%%% [model_path_with_probe] = add_probe_to_model(OPTIONS.PATH.SCALED_MODEL)
            else
            end
            if SO ==1
                [OPTIONS.PATHS.SO_activation.(trialname), OPTIONS.PATHS.SO_force.(trialname)] = SO_app(OPTIONS,pathtopfolder, [subjects(s).folder,'\',subjects(s).name], trialname, initial_time, final_time);
                [~,~,SO_TABLE.Activation.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],OPTIONS.PATHS.SO_activation.(trialname));
                [~,~,SO_TABLE.FORCE.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'] ,OPTIONS.PATHS.SO_force.(trialname));
            else
            end


            ARRAY = ANGLES_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(OPTIONS.LEG).(['IC_ANGLES_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = MOMENT_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(OPTIONS.LEG).(['IC_MOMENTS_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = BK_ACC_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(OPTIONS.LEG).(['IC_BKACC_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = BK_VEL_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(OPTIONS.LEG).(['IC_BKVEL_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = BK_POS_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(OPTIONS.LEG).(['IC_BKPOS_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = GRF_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(OPTIONS.LEG).(['IC_GRF_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(CONTACT_ANALOG.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            clearvars ARRAY
            %%
            NORMAL.HEADER{1,dy} = trialname;
            % PARAMETERS.DUMMY(1,dy) = 0;

            try
                % % % %     %% only works for one specific model
                NORMAL.(OPTIONS.LEG).KAM(:,dy) = normalize_vector((MOMENT_TABLE.(trialname).(MOMENT_TABLE.(trialname).Properties.VariableNames{string(MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_valgus_lat_',lower(OPTIONS.Leg_2_Analyze(1)),'_moment']})(CONTACT_KINEMATIC.(trialname)(1):CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/OPTIONS.FREQ_KINEMATIC))/OPTIONS.ANTRO.mass), 0.5)*multi;
                NORMAL.(OPTIONS.LEG).KAM_LAT(:,dy) =  normalize_vector((MOMENT_TABLE.(trialname).(MOMENT_TABLE.(trialname).Properties.VariableNames{string(MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_valgus_lat_',lower(OPTIONS.Leg_2_Analyze(1)),'_moment']})(CONTACT_KINEMATIC.(trialname)(1):CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/OPTIONS.FREQ_KINEMATIC))/OPTIONS.ANTRO.mass), 0.5)';
                NORMAL.(OPTIONS.LEG).KAM_MED(:,dy) = normalize_vector((MOMENT_TABLE.(trialname).(MOMENT_TABLE.(trialname).Properties.VariableNames{string(MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_varus_med_',lower(OPTIONS.Leg_2_Analyze(1)),'_moment']})(CONTACT_KINEMATIC.(trialname)(1):CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/OPTIONS.FREQ_KINEMATIC))/OPTIONS.ANTRO.mass), 0.5)';
                % % % %     % NORMAL.(OPTIONS.LEG).RESGRF(:,dy) =normalize_vector( RES_GRF.(trialname)(CONTACT_ANALOG.(trialname)(1):CONTACT_ANALOG.(trialname)(1)+0.1/(1/OPTIONS.FREQ_KINEMATIC)), 0.5);            NORMAL.(OPTIONS.LEG).KAM(:,dy) = NORMAL.(OPTIONS.LEG).KAM(:,dy) *multi;
                [PARAMETERS.(OPTIONS.LEG).KAM(1,dy), ~] = max (NORMAL.(OPTIONS.LEG).KAM(:,dy));
                % % % %     figure(1)
                % % % %     plot(NORMAL.(OPTIONS.LEG).KAM(:,dy), 'k')
                % % % %     hold on
                % % % %     stan_plot_100ms
                % % % %     figure(2)
                % % % %     plot(MOMENT_TABLE.(trialname).(MOMENT_TABLE.(trialname).Properties.VariableNames{string(MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_valgus_lat_',lower(OPTIONS.Leg_2_Analyze(1)),'_moment']})/(OPTIONS.ANTRO.mass*multi))
                % % % %     hold on
                % % % % ylim ([-2 4])
            catch
            end


            %% save the output after every file
            if OPTIONS.MARKERLESS==0 && RRA ==0
                save([subjects(s).folder,'/',subjects(s).name,'OpenSim.mat' ], 'MOMENT_TABLE','ANGLES_TABLE', 'GRF_TABLE',  'MARKERS', 'OPTIONS', 'CONTACT_KINEMATIC', 'CONTACT_ANALOG', 'NORMAL', 'PARAMETERS', 'BK_ACC_TABLE', 'BK_VEL_TABLE', 'BK_POS_TABLE')

            elseif OPTIONS.MARKERLESS==0 && RRA ==1
                save([subjects(s).folder,'/',subjects(s).name,'OpenSim.mat' ], 'MOMENT_TABLE','ANGLES_TABLE', 'GRF_TABLE',  'MARKERS', 'OPTIONS', 'CONTACT_KINEMATIC', 'CONTACT_ANALOG', 'NORMAL', 'PARAMETERS', 'BK_ACC_TABLE', 'BK_VEL_TABLE', 'BK_POS_TABLE', 'RRA_TABLE', 'SO_TABLE')

            elseif OPTIONS.MARKERLESS==1
                save([subjects(s).folder,'/',subjects(s).name,'OpenSim.mat' ], 'ANGLES_TABLE', 'NORMAL', 'PARAMETERS', 'BK_ACC_TABLE', 'BK_VEL_TABLE', 'BK_POS_TABLE')
            end
        end
        % clear all varibles from the subject
        clearvars GRF MARKERS CONTACT_KINEMATIC CONTACT_ANALOG NORMAL PARAMETERS MOMENT_TABLE ANGLES_TABLE GRF_TABLE BK_ACC_TABLE BK_VEL_TABLE BK_POS_TABLE anthro_file fileListc3d static_c3d_path temp_c3d trialname trials RRA_TABLE
        OPTIONS = rmfield (OPTIONS, 'PATHS');
        OPTIONS = rmfield (OPTIONS, 'ANTRO');
    end

end
warning ("off")
delete([pathtopfolder, '/', OPTIONS.PATH.GENERIC_MODEL])
delete([pathtopfolder, '/', OPTIONS.GENERIC.markersetname])
delete([pathtopfolder, '/', OPTIONS.GENERIC.scalesetupname])
delete([pathtopfolder, '/', OPTIONS.GENERIC.setupIKname])
delete( [pathtopfolder, '/', OPTIONS.GENERIC.setupIDname])
delete([pathtopfolder, '/', OPTIONS.GENERIC.setupBKname])

try
    delete([pathtopfolder, '/ExternalForce_Setup_FP1_Left.xml'])
    delete([pathtopfolder, '/ExternalForce_Setup_FP2_Left.xml'])
    delete([pathtopfolder, '/ExternalForce_Setup_FP1_Right.xml'])
    delete([pathtopfolder, '/ExternalForce_Setup_FP2_Right.xml'])
catch
end
toc
disp('Finished')

%% MERGE
clc

% OPTIONS.top_folder = 'C:\Users\adpatrick\Downloads\OneDrive_1_1-2-2024\Pivot_Turn_Topfolder'; %changed
%
% [MERGED] = on_merge_data_main(OPTIONS.top_folder);
% MERGED.NORMAL.TIMECURVES.pelvis_tilt;
% MERGED.TIMECURVES.KAM;
% MERGED.INFO.NAME2;
%
% LineList = plot (MERGED.TIMECURVES.KAM', 'Color', [[0, 0, 0], 0.1],'LineWidth',0.2, 'LineStyle','-');
% set(LineList, 'ButtonDownFcn', {@myLineCallback, LineList,MERGED.INFO.NAME_Long });
% stan_plot_100ms

% figure(2)
% plot(MERGED.TIMECURVES.KAM_LAT', 'color', 'red')
% hold on
% plot(MERGED.TIMECURVES.KAM_MED', 'color','green')

%
% hoch = 1;
% S = dir(fullfile([conditions(c).folder,'/',conditions(c).name],'*.mat'));
% for s = 1 : length (S)
%     dat = load([S(s).folder, '/', S(s).name]);
%     for p = 1: length(dat.NORMAL.(OPTIONS.LEG).KAM(1,:))
%         WERTE(hoch,:) = (dat.NORMAL.(OPTIONS.LEG).KAM(:,p))';
%         namen{hoch,1} = dat.NORMAL.HEADER{1, p}  ;
%         hoch = hoch+1;
%         P(s,1) = mean(dat.PARAMETERS.(OPTIONS.LEG).KAM);
%         P(s,2) = std(dat.PARAMETERS.(OPTIONS.LEG).KAM);
%         VEL(s,1) = mean(sqrt(dat.PARAMETERS.(OPTIONS.LEG).IC_BKVEL_center_of_mass_X.^2+dat.PARAMETERS.(OPTIONS.LEG).IC_BKVEL_center_of_mass_Z.^2));
%         torso(s,1) = mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_lumbar_bending);
%         t{1,s} = S(s).name;
%         try
%             torso_lean(s,1)=mean(PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_tilt-dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_lumbar_bending);
%             fsa(s,1) = mean(PARAMETERS.(OPTIONS.LEG).IC_ANGLES_knee_angle_r+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_ankle_angle_r+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_list+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_hip_flexion_r);
%         catch
%             a = 2;
%             torso_lean(s,1)=mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_tilt(:,2)-dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_lumbar_bending(:,2))
%             fsa(s,1) =mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_knee_angle_r(:,2)+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_ankle_angle_r(:,2)+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_list(:,2)+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_hip_flexion_r(:,2));
%         end
%     end
%     clearvars dat
% end
% close all
% LineList = plot (WERTE', 'Color', [[0, 0, 0], 0.1],'LineWidth',0.2, 'LineStyle','-');
% set(LineList, 'ButtonDownFcn', {@myLineCallback, LineList,namen });
% stan_plot_100ms
% mean(max(WERTE'))
% mean(torso)
% plot(torso_lean)
% mean(torso_lean)
% mean(fsa)
% plot(fsa)