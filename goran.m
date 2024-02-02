OPTIONS.FP_used = 2; %1
OPTIONS.cutting_c3d =0;
OPTIONS.FP_Stance_Threshold = 30;
OPTIONS.convert_type = 1; % 0 war motack gleich
OPTIONS.SETTINGS = "OSLO";

[~, ~, OPTIONS.MARKER_SETUP.HIP] = xlsread('Marker_for_segments_v3.xlsx','HIP');
[~, ~, OPTIONS.MARKER_SETUP.KNEE] = xlsread('Marker_for_segments_v3.xlsx','KNEE');
[~, ~, OPTIONS.MARKER_SETUP.ANKLE] = xlsread('Marker_for_segments_v3.xlsx','ANKLE');
[~, ~, OPTIONS.MARKER_SETUP.FOOT] = xlsread('Marker_for_segments_v3.xlsx','FOOT');
[~, ~, OPTIONS.MARKER_SETUP.MTP] = xlsread('Marker_for_segments_v3.xlsx','MTP');
OPTIONS.Leg_2_Analyze ='Right';
static_c3d_to_trc_Motrack(['C:\Users\adpatrick\OneDrive - nih.no\Desktop\Goran_Sprint_Analysis\Right_Leg_FP2\P00X','\Static_trial 2.c3d'], OPTIONS)


 [OPTIONS.ftkratio, OPTIONS.PATHS.TRC.(trialname), OPTIONS.PATHS.MOT.(trialname), CONTACT_ANALOG.(trialname), CONTACT_KINEMATIC.(trialname), MARKERS.(trialname), GRF.(trialname), OPTIONS.FREQ_KINEMATIC, OPTIONS.FREQ_ANALOG]=dynamic_c3d_to_try([fileListc3d(trials(dy)).folder, '/', fileListc3d(trials(dy)).name], OPTIONS.cutting_c3d, OPTIONS.FP_used, OPTIONS.FP_Stance_Threshold, OPTIONS.convert_type);
name = ['C:\Users\adpatrick\OneDrive - nih.no\Desktop\Goran_Sprint_Analysis\Right_Leg_FP2\P00X','\Sprinting9.c3d']
trialname = 'test'
      [OPTIONS.ftkratio, OPTIONS.PATHS.TRC.(trialname), OPTIONS.PATHS.MOT.(trialname), CONTACT_ANALOG.(trialname), CONTACT_KINEMATIC.(trialname), MARKERS.(trialname), GRF.(trialname), OPTIONS.FREQ_KINEMATIC, OPTIONS.FREQ_ANALOG]=dynamic_c3d_to_try(name, 0, 1, 30, 1);
