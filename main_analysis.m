clc
clear all
close all
% use to print opensim log in matlab command window
% import org.opensim.modeling.*
% myMatlabLog = JavaLogSink()
% Logger.addSink(myMatlabLog)

pathtopfolder = cd; %% location of the app
setup_Folder = 'OSLO'; %changed 'MARKERLESS_25B'
RRA =1;
SO =1;
PROBE =1;
[DATA.OPTIONS] = get_set_up_files(setup_Folder,pathtopfolder, RRA, SO, PROBE);
DATA.OPTIONS.RRA = RRA;% 0 or 1
DATA.OPTIONS.SO = SO;% 0 or 1
DATA.OPTIONS.HAS_PROBE =PROBE; % 0 or 1
DATA.OPTIONS.CORRECT_BODYMASS_FROM_FP =1;% 0 or 1
DATA.OPTIONS.top_folder = "C:\Users\adpatrick\OneDrive - nih.no\Desktop\HSO_TRUNK_EXTENDED";%'C:\Users\adpc\OneDrive - nih.no\Desktop\OneDrive_1_1-2-2024\Pivot_Turn_Topfolder'; %changed
DATA.OPTIONS.MOTION = 'Overground'; %string 'Treadmill' or 'Overground'
DATA.OPTIONS.Ref_Identifier = 'Static'; % string
DATA.OPTIONS.MARKERLESS = 0; % 0 or 1
DATA.OPTIONS.FP_used = 1; %changed
DATA.OPTIONS.cutting_c3d =1; % changed
DATA.OPTIONS.FP_Stance_Threshold = 30; % 50
DATA.OPTIONS.convert_type = 1; % 0 war motack gleich
%OPTIONS.SETTINGS = "OSLO";
DATA.OPTIONS.remove_unwanted_markers = 0; %changed
% OPTIONS.SETTINGS = "CALGARY";
DATA.OPTIONS.SETTINGS = "OSLO";
DATA.OPTIONS.ajusted_scaled_model =1; % 0 or 1
% OPTIONS.SETTINGS = "JOHNATAN";
[~, ~, DATA.OPTIONS.MARKER_SETUP.HIP] = xlsread('Marker_for_segments_v3.xlsx','HIP');
[~, ~, DATA.OPTIONS.MARKER_SETUP.KNEE] = xlsread('Marker_for_segments_v3.xlsx','KNEE');
[~, ~, DATA.OPTIONS.MARKER_SETUP.ANKLE] = xlsread('Marker_for_segments_v3.xlsx','ANKLE');
[~, ~, DATA.OPTIONS.MARKER_SETUP.FOOT] = xlsread('Marker_for_segments_v3.xlsx','FOOT');
[~, ~, DATA.OPTIONS.MARKER_SETUP.MTP] = xlsread('Marker_for_segments_v3.xlsx','MTP');
[~, ~, DATA.OPTIONS.MARKER_SETUP.DISTAL] = xlsread('Marker_for_segments_v3.xlsx','DISTAL_Marker');
DATA.OPTIONS.Leg_2_Analyze ='Right'; % string 'Left' or 'Right'
if DATA.OPTIONS.Leg_2_Analyze == "Left"
    multi = -1;
    DATA.OPTIONS.LEG = 'L';
elseif DATA.OPTIONS.Leg_2_Analyze == "Right"
    multi = 1;
    DATA.OPTIONS.LEG = 'R';
else
    DATA.OPTIONS.LEG = 'B';
end

%% remove all previous opensim files (but keep the mat file)
[conditions] = get_subfolders(DATA.OPTIONS.top_folder);
startcon = 1
endcon = length(conditions)
if DATA.OPTIONS.MARKERLESS ==0
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

%% manin analysis for OPENSIM
tic
for c = startcon: endcon
    [subjects] =  get_subfolders([conditions(c).folder,'/',conditions(c).name]);
    for s = 1: length(subjects)
        if DATA.OPTIONS.MARKERLESS==0
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
                static_c3d_path = [fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},DATA.OPTIONS.Ref_Identifier)))).folder, '/',fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},OPTIONS.Ref_Identifier)))).name];
                [DATA.OPTIONS.ANTRO.mass,  DATA.OPTIONS.ANTRO.height,DATA.OPTIONS.ANTRO.age ] = read_antro_from_static_c3d(static_c3d_path, ((OPTIONS.MARKER_SETUP.DISTAL(find(~cellfun(@isempty,(strfind((OPTIONS.MARKER_SETUP.DISTAL(:,1)), OPTIONS.SETTINGS)))),end))));
                x = [{DATA.OPTIONS.ANTRO.mass},  {DATA.OPTIONS.ANTRO.height},{DATA.OPTIONS.ANTRO.age}]';
                writecell (x, [subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv']);
                anthro_file = readmatrix([subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv']);
                aa =2;
            catch
                x = inputdlg({'Body height [cm]','Body mass [kg]','Age [years]'},...
                    subjects(s).name, [1 50; 1 12; 1 7]);
                DATA.OPTIONS.ANTRO.mass = str2num(x{1, 1});
                DATA.OPTIONS.ANTRO.height = str2num(x{2, 1});
                DATA.OPTIONS.ANTRO.age = str2num(x{3, 1});
                writecell (x, [subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv'])
                anthro_file = readmatrix([subjects(s).folder,'/',subjects(s).name, '/', subjects(s).name, '.csv']);
            end
        end
        % only because c3d files have been messed up for one project
        if anthro_file(2) >120
            DATA.OPTIONS.ANTRO.mass = anthro_file(1);
            DATA.OPTIONS.ANTRO.height = anthro_file(2);
            DATA.OPTIONS.ANTRO.age = anthro_file(end);
        else
            DATA.OPTIONS.ANTRO.mass = anthro_file(2);
            DATA.OPTIONS.ANTRO.height = anthro_file(1);
            DATA.OPTIONS.ANTRO.age = anthro_file(end);
        end
        %% static
        static_c3d_path = [fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},DATA.OPTIONS.Ref_Identifier)))).folder, '/',fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},DATA.OPTIONS.Ref_Identifier)))).name];
        %% get bodymass from c3d static trial
        if DATA.OPTIONS.CORRECT_BODYMASS_FROM_FP ==1
        [DATA.OPTIONS.ANTRO.mass] = get_bodymaxx_from_c3d(static_c3d_path)
        end
        %% convert trc
        disp(static_c3d_path)
        if DATA.OPTIONS.MARKERLESS==0 % becuase for markerless I already have trc files no need to convert
            static_c3d_to_trc_Motrack(static_c3d_path, DATA.OPTIONS)
        else
        end
        %% scale
        if DATA.OPTIONS.MARKERLESS==0
            [DATA.OPTIONS.PATH.SCALED_MODEL, DATA.OPTIONS.STATIC_PATH.IK_res_static, DATA.OPTIONS.STATIC_ANGLES.IK_res_static]=scaling_OLE(replace (static_c3d_path, '.c3d', '.trc'),  subjects(s).name, [subjects(s).folder,'/',subjects(s).name], erase(fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},DATA.OPTIONS.Ref_Identifier)))).name, '.c3d'), DATA.OPTIONS.PATH.GENERIC_MODEL, DATA.OPTIONS.GENERIC.markersetname, DATA.OPTIONS.GENERIC.scalesetupname, DATA.OPTIONS);
        else % only some function input change when markerless
            [DATA.OPTIONS.PATH.SCALED_MODEL, DATA.OPTIONS.STATIC_PATH.IK_res_static, DATA.OPTIONS.STATIC_ANGLES.IK_res_static]=scaling_OLE(replace (static_c3d_path, '.c3d', '.trc'),  subjects(s).name, [subjects(s).folder,'/',subjects(s).name], erase(fileListc3d(find(~cellfun(@isempty,strfind({fileListc3d.name},DATA.OPTIONS.Ref_Identifier)))).name, '.trc'), DATA.OPTIONS.PATH.GENERIC_MODEL, DATA.OPTIONS.GENERIC.markersetname, DATA.OPTIONS.GENERIC.scalesetupname, DATA.OPTIONS);
        end
        %% %% Read in the  Model and change the coordinate values to ones from IK
        if DATA.OPTIONS.ajusted_scaled_model ==1
            ajust_scaled_model_joint_angles(DATA.OPTIONS.PATH.SCALED_MODEL, DATA.OPTIONS.STATIC_PATH.IK_res_static, DATA.OPTIONS.STATIC_ANGLES.IK_res_static)
        end
        trials = find( ~cellfun(@(c) any(strfind(c,DATA.OPTIONS.Ref_Identifier)), {fileListc3d.name}) ==1);
        for dy = 1: length(trials) % loop through all files that are not static!
            temp_c3d = [fileListc3d(trials(dy)).folder, '/', fileListc3d(trials(dy)).name];
            trialname =  matlab.lang.makeValidName(erase(fileListc3d(trials(dy)).name, '.c3d'));
            disp (['Working on...: ' ,conditions(c).name, ' ', subjects(s).name, ' ', trialname ])
            if DATA.OPTIONS.MARKERLESS==0 % convert c3ds to opensim formats when haveing marker-based and run IK
                [DATA.OPTIONS.ftkratio, DATA.OPTIONS.PATHS.TRC.(trialname), DATA.OPTIONS.PATHS.MOT.(trialname), DATA.CONTACT_ANALOG.(trialname), DATA.CONTACT_KINEMATIC.(trialname), DATA.MARKERS.(trialname), DATA.GRF.(trialname), DATA.OPTIONS.FREQ_KINEMATIC, DATA.OPTIONS.FREQ_ANALOG]=dynamic_c3d_to_try([fileListc3d(trials(dy)).folder, '/', fileListc3d(trials(dy)).name], DATA.OPTIONS.cutting_c3d, DATA.OPTIONS.FP_used, DATA.OPTIONS.FP_Stance_Threshold, DATA.OPTIONS.convert_type, DATA.OPTIONS.remove_unwanted_markers);
                [DATA.OPTIONS.PATHS.IK.(trialname), initial_time, final_time]=IK_app(DATA.OPTIONS.PATHS.TRC.(trialname),[subjects(s).folder,'\',subjects(s).name], DATA.OPTIONS.GENERIC.setupIKname);
            else % IK on markerless no need to convert c3d files
                DATA.OPTIONS.PATHS.TRC.(trialname) = temp_c3d;
                dummy = split(fileListc3d(trials(dy)).name, '_');
                try
                    yu = find(~isletter(dummy{3}),1);
                    corrospondingc3d_file = [fileListc3d(trials(dy)).folder, '/',dummy{3}(1:yu(1)-1) ' ' dummy{3}(yu(1):length(dummy{3})), '.c3d'];
                    [DATA.OPTIONS.ftkratio, ~, DATA.OPTIONS.PATHS.MOT.(trialname), DATA.CONTACT_ANALOG.(trialname), DATA.CONTACT_KINEMATIC.(trialname), DATA.MARKERS.(trialname), DATA.GRF.(trialname), DATA.OPTIONS.FREQ_KINEMATIC, DATA.OPTIONS.FREQ_ANALOG]=dynamic_c3dMarkerless_to_trc(corrospondingc3d_file, 0, DATA.OPTIONS.FP_used, DATA.OPTIONS.FP_Stance_Threshold, DATA.OPTIONS.convert_type, 0);
                catch
                end
                [DATA.OPTIONS.PATHS.IK.(trialname), initial_time, final_time]=IK_app(DATA.OPTIONS.PATHS.TRC.(trialname),[subjects(s).folder,'\',subjects(s).name], DATA.OPTIONS.GENERIC.setupIKname);
            end
            pause(0.0000001)
            if DATA.OPTIONS.MOTION == "Treadmill" && DATA.OPTIONS.MARKERLESS==0
                %% perpare force data by creating two mot files one for the left and one for the right foot contact
                [DATA.OPTIONS.PATHS.MOT_LEFT.(trialname), DATA.OPTIONS.PATHS.MOT_RIGHT.(trialname)]= TREATMILL_force_split_mot(DATA.OPTIONS.PATHS.MOT.(trialname), OPTIONS);
                %% run ID for L and R seperate
                [DATA.OPTIONS.PATHS.ID_L.(trialname)]=ID_app_treadmill(DATA.OPTIONS.PATHS.MOT_LEFT.(trialname),DATA.OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], DATA.OPTIONS.PATHS.IK.(trialname), 'Left', DATA.OPTIONS.FP_used, DATA.OPTIONS.GENERIC.setupIDname);
                [DATA.OPTIONS.PATHS.ID_R.(trialname)]=ID_app_treadmill(DATA.OPTIONS.PATHS.MOT_RIGHT.(trialname),DATA.OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], DATA.OPTIONS.PATHS.IK.(trialname), 'Right', DATA.OPTIONS.FP_used, DATA.OPTIONS.GENERIC.setupIDname);
                [~,~,DATA.MOMENT_TABLE.L.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.ID_L.(trialname)(1:find((DATA.OPTIONS.PATHS.ID_L.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.ID_L.(trialname)(find((DATA.OPTIONS.PATHS.ID_L.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.MOMENT_TABLE.R.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.ID_R.(trialname)(1:find((DATA.OPTIONS.PATHS.ID_R.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.ID_R.(trialname)(find((DATA.OPTIONS.PATHS.ID_R.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.GRF_TABLE.L.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.MOT_LEFT.(trialname)(1:find((DATA.OPTIONS.PATHS.MOT_LEFT.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.MOT_LEFT.(trialname)(find((DATA.OPTIONS.PATHS.MOT_LEFT.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.GRF_TABLE.R.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.MOT_RIGHT.(trialname)(1:find((DATA.OPTIONS.PATHS.MOT_RIGHT.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.MOT_RIGHT.(trialname)(find((DATA.OPTIONS.PATHS.MOT_RIGHT.(trialname)) == '\', 1, 'last')+1:end)));
                DATA.CONTACT_ANALOG.L.(trialname) = getContact_FP_app_treatmill(DATA.GRF_TABLE.L.(trialname).(DATA.GRF_TABLE.L.(trialname).Properties.VariableNames{find(string(DATA.GRF_TABLE.L.(trialname).Properties.VariableNames) == ['ground_force', num2str(DATA.OPTIONS.FP_used), '_vy'])})', DATA.OPTIONS.FP_Stance_Threshold) ;
                DATA.CONTACT_KINEMATIC.L.(trialname).TD = fix(DATA.CONTACT_ANALOG.L.(trialname).TD/DATA.OPTIONS.ftkratio);
                DATA.CONTACT_KINEMATIC.L.(trialname).TO = fix(DATA.CONTACT_ANALOG.L.(trialname).TO/DATA.OPTIONS.ftkratio);
                DATA.CONTACT_ANALOG.R.(trialname) = getContact_FP_app_treatmill(DATA.GRF_TABLE.R.(trialname).(DATA.GRF_TABLE.R.(trialname).Properties.VariableNames{find(string(DATA.GRF_TABLE.R.(trialname).Properties.VariableNames) == ['ground_force', num2str(DATA.OPTIONS.FP_used), '_vy'])})', DATA.OPTIONS.FP_Stance_Threshold) ;
                DATA.CONTACT_KINEMATIC.R.(trialname).TD = fix(DATA.CONTACT_ANALOG.R.(trialname).TD/DATA.OPTIONS.ftkratio);
                DATA.CONTACT_KINEMATIC.R.(trialname).TO = fix(DATA.CONTACT_ANALOG.R.(trialname).TO/DATA.OPTIONS.ftkratio);
            elseif DATA.OPTIONS.MOTION == "Overground" && DATA.OPTIONS.MARKERLESS==0
                [DATA.OPTIONS.PATHS.ID.(trialname), DATA.OPTIONS.PATHS.Exload.(trialname)]=ID_app(DATA.OPTIONS.PATHS.MOT.(trialname),DATA.OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], DATA.OPTIONS.PATHS.IK.(trialname), DATA.OPTIONS.Leg_2_Analyze, DATA.OPTIONS.FP_used, DATA.OPTIONS.GENERIC.setupIDname, initial_time, final_time);
                [~,~,DATA.MOMENT_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.ID.(trialname)(1:find((DATA.OPTIONS.PATHS.ID.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.ID.(trialname)(find((DATA.OPTIONS.PATHS.ID.(trialname)) == '\', 1, 'last')+1:end)));
                [~,~,DATA.GRF_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.MOT.(trialname)(1:find((DATA.OPTIONS.PATHS.MOT.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.MOT.(trialname)(find((DATA.OPTIONS.PATHS.MOT.(trialname)) == '\', 1, 'last')+1:end)));
                DATA.CONTACT_ANALOG.(trialname) = getContact_FP_app(DATA.GRF_TABLE.(trialname).(DATA.GRF_TABLE.(trialname).Properties.VariableNames{find(string(DATA.GRF_TABLE.(trialname).Properties.VariableNames) == ['ground_force_', num2str(DATA.OPTIONS.FP_used), '_vy'])})', DATA.OPTIONS.FP_Stance_Threshold) ;
                DATA.CONTACT_KINEMATIC.(trialname) = unique(fix(DATA.CONTACT_ANALOG.(trialname)/DATA.OPTIONS.ftkratio));
            end
            [DATA.OPTIONS.PATHS.BK_ACC.(trialname), DATA.OPTIONS.PATHS.BK_VEL.(trialname), DATA.OPTIONS.PATHS.BK_POS.(trialname)] = Bodykinematics_app(DATA.OPTIONS.PATHS.IK.(trialname),DATA.OPTIONS.PATH.SCALED_MODEL, [subjects(s).folder,'/',subjects(s).name], trialname, DATA.OPTIONS.GENERIC.setupBKname, initial_time, final_time);
            [~,~,DATA.ANGLES_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.IK.(trialname)(1:find((DATA.OPTIONS.PATHS.IK.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.IK.(trialname)(find((DATA.OPTIONS.PATHS.IK.(trialname)) == '\', 1, 'last')+1:end)));
            [~,~,DATA.BK_ACC_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.BK_ACC.(trialname)(1:find((DATA.OPTIONS.PATHS.BK_ACC.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.BK_ACC.(trialname)(find((DATA.OPTIONS.PATHS.BK_ACC.(trialname)) == '\', 1, 'last')+1:end)));
            [~,~,DATA.BK_VEL_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.BK_VEL.(trialname)(1:find((DATA.OPTIONS.PATHS.BK_VEL.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.BK_VEL.(trialname)(find((DATA.OPTIONS.PATHS.BK_VEL.(trialname)) == '\', 1, 'last')+1:end)));
            [~,~,DATA.BK_POS_TABLE.(trialname)] =  readMOTSTOTRCfiles((DATA.OPTIONS.PATHS.BK_POS.(trialname)(1:find((DATA.OPTIONS.PATHS.BK_POS.(trialname)) == '\', 1, 'last'))),(DATA.OPTIONS.PATHS.BK_POS.(trialname)(find((DATA.OPTIONS.PATHS.BK_POS.(trialname)) == '\', 1, 'last')+1:end)));
            pause(0.000001)
            %%RRA
            if DATA.OPTIONS.RRA ==1
                [DATA.OPTIONS.PATHS.actuation_force.(trialname), DATA.OPTIONS.PATHS.actuation_power.(trialname), DATA.OPTIONS.PATHS.actuation_speed.(trialname), DATA.OPTIONS.PATHS.avgResiduals.(trialname), DATA.OPTIONS.PATHS.controls.(trialname) , DATA.OPTIONS.PATHS.Kinematics_dudt.(trialname), DATA.OPTIONS.PATHS.Kinematics_q.(trialname), DATA.OPTIONS.PATHS.Kinematics_u.(trialname), DATA.OPTIONS.PATHS.pErr.(trialname), DATA.OPTIONS.PATHS.states.(trialname), DATA.OPTIONS.PATHS.ajusted_model.(trialname)]= RRA_app(pathtopfolder,DATA.OPTIONS,trialname, [subjects(s).folder,'\',subjects(s).name] ,initial_time, final_time);
                [~,~,DATA.RRA_TABLE.actuation_force.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.actuation_force.(trialname));
                [~,~,DATA.RRA_TABLE.actuation_power.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.actuation_power.(trialname));
                [~,~,DATA.RRA_TABLE.actuation_speed.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.actuation_speed.(trialname));
                [~,~,DATA.RRA_TABLE.controls.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.controls.(trialname));
                [~,~,DATA.RRA_TABLE.Kinematics_dudt.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.Kinematics_dudt.(trialname));
                [~,~,DATA.RRA_TABLE.Kinematics_q.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.Kinematics_q.(trialname));
                [~,~,DATA.RRA_TABLE.Kinematics_u.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.Kinematics_u.(trialname));
                [~,~,DATA.RRA_TABLE.pErr.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.pErr.(trialname));
                [~,~,DATA.RRA_TABLE.states.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.states.(trialname));
                DATA.RRA_TABLE.avgResiduals.(trialname) =readcell([subjects(s).folder,'/',subjects(s).name, '/', DATA.OPTIONS.PATHS.avgResiduals.(trialname)]);
                %%%[DATA.OPTIONS.PATHS.ID_AFTER_RRA.(trialname), DATA.OPTIONS.PATHS.Exload.(trialname)]=ID_app_afterRRA(DATA.OPTIONS.PATHS.MOT.(trialname),DATA.OPTIONS.PATHS.TRC.(trialname), [subjects(s).folder,'\',subjects(s).name], [subjects(s).folder,'/',subjects(s).name, '/',DATA.OPTIONS.PATHS.Kinematics_q.(trialname)], DATA.OPTIONS.Leg_2_Analyze, DATA.OPTIONS.FP_used, DATA.OPTIONS.GENERIC.setupIDname, initial_time, final_time, trialname);
            end
            pause(0.000001)
            if DATA.OPTIONS.ajusted_scaled_model ==1 && DATA.OPTIONS.RRA ==1
                ajust_scaled_model_joint_angles([subjects(s).folder,'/',subjects(s).name, '/' DATA.OPTIONS.PATHS.ajusted_model.(trialname)], DATA.OPTIONS.STATIC_PATH.IK_res_static, DATA.OPTIONS.STATIC_ANGLES.IK_res_static)
            end

            if DATA.OPTIONS.HAS_PROBE ==1
                [DATA.OPTIONS.PATH.SCALED_MODEL_AFTER_RRA_WITH_PROBE] = add_probe_to_model([subjects(s).folder,'/',subjects(s).name], trialname);
            else
            end
            if DATA.OPTIONS.SO ==1 && DATA.OPTIONS.HAS_PROBE==1
                [DATA.OPTIONS.PATHS.SO_activation.(trialname), DATA.OPTIONS.PATHS.SO_force.(trialname), DATA.OPTIONS.PATHS.SO_probe.(trialname)] = SO_app_with_probes(DATA.OPTIONS,pathtopfolder, [subjects(s).folder,'\',subjects(s).name], trialname, initial_time, final_time);
                [~,~,DATA.SO_TABLE.Activation.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.SO_activation.(trialname));
                [~,~,DATA.SO_TABLE.FORCE.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'] ,DATA.OPTIONS.PATHS.SO_force.(trialname));
                [~,~,DATA.SO_TABLE.PROBE.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'] ,DATA.OPTIONS.PATHS.SO_probe.(trialname));

            elseif DATA.OPTIONS.SO ==1 && DATA.OPTIONS.HAS_PROBE==0
                 [DATA.OPTIONS.PATHS.SO_activation.(trialname), DATA.OPTIONS.PATHS.SO_force.(trialname)] = SO_app(DATA.OPTIONS,pathtopfolder, [subjects(s).folder,'\',subjects(s).name], trialname, initial_time, final_time);
                [~,~,DATA.SO_TABLE.Activation.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'],DATA.OPTIONS.PATHS.SO_activation.(trialname));
                [~,~,DATA.SO_TABLE.FORCE.(trialname)]  = readMOTSTOTRCfiles([subjects(s).folder,'/',subjects(s).name, '/'] ,DATA.OPTIONS.PATHS.SO_force.(trialname));
            end


            ARRAY = DATA.ANGLES_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                DATA.PARAMETERS.(DATA.OPTIONS.LEG).(['IC_ANGLES_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(DATA.CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = DATA.MOMENT_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                DATA.PARAMETERS.(DATA.OPTIONS.LEG).(['IC_MOMENTS_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(DATA.CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = DATA.BK_ACC_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                DATA.PARAMETERS.(DATA.OPTIONS.LEG).(['IC_BKACC_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(DATA.CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = DATA.BK_VEL_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(DATA.OPTIONS.LEG).(['IC_BKVEL_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(DATA.CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = DATA.BK_POS_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                PARAMETERS.(DATA.OPTIONS.LEG).(['IC_BKPOS_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(DATA.CONTACT_KINEMATIC.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            ARRAY = DATA.GRF_TABLE.(trialname);
            for op = 1 : length(ARRAY.Properties.VariableNames)
                DATA.PARAMETERS.(DATA.OPTIONS.LEG).(['IC_GRF_',ARRAY.Properties.VariableNames{op} ])(1,dy)  = table2array(ARRAY(DATA.CONTACT_ANALOG.(trialname)(1),ARRAY.Properties.VariableNames{op}));
            end
            clearvars ARRAY
            %% 
            DATA.NORMAL.HEADER{1,dy} = trialname;
            try
                % % % %     %% only works for one specific model
                DATA.NORMAL.(DATA.OPTIONS.LEG).KAM(:,dy) = normalize_vector((DATA.MOMENT_TABLE.(trialname).(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames{string(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_valgus_lat_',lower(DATA.OPTIONS.Leg_2_Analyze(1)),'_moment']})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))/DATA.OPTIONS.ANTRO.mass), 0.5)*multi;
                DATA.NORMAL.(DATA.OPTIONS.LEG).KAM_LAT(:,dy) =  normalize_vector((DATA.MOMENT_TABLE.(trialname).(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames{string(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_valgus_lat_',lower(DATA.OPTIONS.Leg_2_Analyze(1)),'_moment']})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))/DATA.OPTIONS.ANTRO.mass), 0.5)';
                DATA.NORMAL.(DATA.OPTIONS.LEG).KAM_MED(:,dy) = normalize_vector((DATA.MOMENT_TABLE.(trialname).(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames{string(DATA.MOMENT_TABLE.(trialname).Properties.VariableNames) == ['knee_varus_med_',lower(DATA.OPTIONS.Leg_2_Analyze(1)),'_moment']})(DATA.CONTACT_KINEMATIC.(trialname)(1):DATA.CONTACT_KINEMATIC.(trialname)(1)+0.1/(1/DATA.OPTIONS.FREQ_KINEMATIC))/DATA.OPTIONS.ANTRO.mass), 0.5)';
                % % % %     % NORMAL.(OPTIONS.LEG).RESGRF(:,dy) =normalize_vector( RES_GRF.(trialname)(CONTACT_ANALOG.(trialname)(1):CONTACT_ANALOG.(trialname)(1)+0.1/(1/OPTIONS.FREQ_KINEMATIC)), 0.5);            NORMAL.(OPTIONS.LEG).KAM(:,dy) = NORMAL.(OPTIONS.LEG).KAM(:,dy) *multi;
                [DATA.PARAMETERS.(DATA.OPTIONS.LEG).KAM(1,dy), ~] = max (DATA.NORMAL.(DATA.OPTIONS.LEG).KAM(:,dy));
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
            save([subjects(s).folder,'/',subjects(s).name,'OpenSim.mat' ], '-struct', 'DATA');
            % % % % % % if OPTIONS.MARKERLESS==0 && RRA ==0
            % % % % % %     save([subjects(s).folder,'/',subjects(s).name,'OpenSim.mat' ], 'MOMENT_TABLE','ANGLES_TABLE', 'GRF_TABLE',  'MARKERS', 'OPTIONS', 'CONTACT_KINEMATIC', 'CONTACT_ANALOG', 'NORMAL', 'PARAMETERS', 'BK_ACC_TABLE', 'BK_VEL_TABLE', 'BK_POS_TABLE')
            % % % % % % 
            % % % % % % elseif OPTIONS.MARKERLESS==0 && RRA ==1
            % % % % % %     save([subjects(s).folder,'/',subjects(s).name,'OpenSim.mat' ], 'MOMENT_TABLE','ANGLES_TABLE', 'GRF_TABLE',  'MARKERS', 'OPTIONS', 'CONTACT_KINEMATIC', 'CONTACT_ANALOG', 'NORMAL', 'PARAMETERS', 'BK_ACC_TABLE', 'BK_VEL_TABLE', 'BK_POS_TABLE', 'RRA_TABLE', 'SO_TABLE')
            % % % % % % 
            % % % % % % elseif OPTIONS.MARKERLESS==1
            % % % % % %     save([subjects(s).folder,'/',subjects(s).name,'OpenSim.mat' ], 'ANGLES_TABLE', 'NORMAL', 'PARAMETERS', 'BK_ACC_TABLE', 'BK_VEL_TABLE', 'BK_POS_TABLE')
            % % % % % % end
        end
        % clear all varibles from the subject TODO
        clearvars anthro_file fileListc3d static_c3d_path temp_c3d trialname trials
        DATA.OPTIONS = rmfield (DATA.OPTIONS, 'PATHS');
        DATA.OPTIONS = rmfield (DATA.OPTIONS, 'ANTRO');
        DATA.OPTIONS = rmfield (DATA.OPTIONS, 'STATIC_PATH');
        DATA.OPTIONS = rmfield (DATA.OPTIONS, 'STATIC_ANGLES');
        % DATA.OPTIONS.PATH   = rmfield (DATA.OPTIONS.PATH  , 'SCALED_MODEL');
        % DATA.OPTIONS.PATH   = rmfield (DATA.OPTIONS.PATH  , 'SCALED_MODEL_AFTER_RRA_WITH_PROBE');
        % DATA = rmfield (DATA.CONTACT_ANALOG);
    end

end
% % % % % warning ("off")
% % % % % delete([pathtopfolder, '/', OPTIONS.PATH.GENERIC_MODEL])
% % % % % delete([pathtopfolder, '/', OPTIONS.GENERIC.markersetname])
% % % % % delete([pathtopfolder, '/', OPTIONS.GENERIC.scalesetupname])
% % % % % delete([pathtopfolder, '/', OPTIONS.GENERIC.setupIKname])
% % % % % delete( [pathtopfolder, '/', OPTIONS.GENERIC.setupIDname])
% % % % % delete([pathtopfolder, '/', OPTIONS.GENERIC.setupBKname])
% % % % % 
% % % % % try
% % % % %     delete([pathtopfolder, '/ExternalForce_Setup_FP1_Left.xml'])
% % % % %     delete([pathtopfolder, '/ExternalForce_Setup_FP2_Left.xml'])
% % % % %     delete([pathtopfolder, '/ExternalForce_Setup_FP1_Right.xml'])
% % % % %     delete([pathtopfolder, '/ExternalForce_Setup_FP2_Right.xml'])
% % % % % catch
% % % % % end
% % % % % toc
% % % % % disp('Finished')
% % % % % 
% % % % % %% MERGE
% % % % % clc
% % % % % 
% % % % % % OPTIONS.top_folder = 'C:\Users\adpatrick\Downloads\OneDrive_1_1-2-2024\Pivot_Turn_Topfolder'; %changed
% % % % % %
% % % % % % [MERGED] = on_merge_data_main(OPTIONS.top_folder);
% % % % % % MERGED.NORMAL.TIMECURVES.pelvis_tilt;
% % % % % % MERGED.TIMECURVES.KAM;
% % % % % % MERGED.INFO.NAME2;
% % % % % %
% % % % % % LineList = plot (MERGED.TIMECURVES.KAM', 'Color', [[0, 0, 0], 0.1],'LineWidth',0.2, 'LineStyle','-');
% % % % % % set(LineList, 'ButtonDownFcn', {@myLineCallback, LineList,MERGED.INFO.NAME_Long });
% % % % % % stan_plot_100ms
% % % % % 
% % % % % % figure(2)
% % % % % % plot(MERGED.TIMECURVES.KAM_LAT', 'color', 'red')
% % % % % % hold on
% % % % % % plot(MERGED.TIMECURVES.KAM_MED', 'color','green')
% % % % % 
% % % % % %
% % % % % % hoch = 1;
% % % % % % S = dir(fullfile([conditions(c).folder,'/',conditions(c).name],'*.mat'));
% % % % % % for s = 1 : length (S)
% % % % % %     dat = load([S(s).folder, '/', S(s).name]);
% % % % % %     for p = 1: length(dat.NORMAL.(OPTIONS.LEG).KAM(1,:))
% % % % % %         WERTE(hoch,:) = (dat.NORMAL.(OPTIONS.LEG).KAM(:,p))';
% % % % % %         namen{hoch,1} = dat.NORMAL.HEADER{1, p}  ;
% % % % % %         hoch = hoch+1;
% % % % % %         P(s,1) = mean(dat.PARAMETERS.(OPTIONS.LEG).KAM);
% % % % % %         P(s,2) = std(dat.PARAMETERS.(OPTIONS.LEG).KAM);
% % % % % %         VEL(s,1) = mean(sqrt(dat.PARAMETERS.(OPTIONS.LEG).IC_BKVEL_center_of_mass_X.^2+dat.PARAMETERS.(OPTIONS.LEG).IC_BKVEL_center_of_mass_Z.^2));
% % % % % %         torso(s,1) = mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_lumbar_bending);
% % % % % %         t{1,s} = S(s).name;
% % % % % %         try
% % % % % %             torso_lean(s,1)=mean(PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_tilt-dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_lumbar_bending);
% % % % % %             fsa(s,1) = mean(PARAMETERS.(OPTIONS.LEG).IC_ANGLES_knee_angle_r+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_ankle_angle_r+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_list+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_hip_flexion_r);
% % % % % %         catch
% % % % % %             a = 2;
% % % % % %             torso_lean(s,1)=mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_tilt(:,2)-dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_lumbar_bending(:,2))
% % % % % %             fsa(s,1) =mean(dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_knee_angle_r(:,2)+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_ankle_angle_r(:,2)+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_pelvis_list(:,2)+dat.PARAMETERS.(OPTIONS.LEG).IC_ANGLES_hip_flexion_r(:,2));
% % % % % %         end
% % % % % %     end
% % % % % %     clearvars dat
% % % % % % end
% % % % % % close all
% % % % % % LineList = plot (WERTE', 'Color', [[0, 0, 0], 0.1],'LineWidth',0.2, 'LineStyle','-');
% % % % % % set(LineList, 'ButtonDownFcn', {@myLineCallback, LineList,namen });
% % % % % % stan_plot_100ms
% % % % % % mean(max(WERTE'))
% % % % % % mean(torso)
% % % % % % plot(torso_lean)
% % % % % % mean(torso_lean)
% % % % % % mean(fsa)
% % % % % % plot(fsa)