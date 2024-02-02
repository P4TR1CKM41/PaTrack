function [IK_results_path, initial_time, final_time]=IK_app(TRC_FILE,path, setupIKname)
tic
import org.opensim.modeling.*
trialname = erase(erase(TRC_FILE, [path,'/']), '.trc');
model = Model([path,'\scaled_weighted_matlab.osim']);
model.initSystem();
markerPath = (TRC_FILE);
markerData = MarkerData(markerPath);
% Get initial and final time to compute
initial_time = markerData.getStartFrameTime();    %full dataset
final_time = markerData.getLastFrameTime();       %full dataset
ikTool = InverseKinematicsTool([cd, '/', setupIKname]);
ikTool.setModel(model);
% Setup the ikTool for this trial
ikTool.setName(trialname);
ikTool.setResultsDir(path)
ikTool.setMarkerDataFileName(markerPath);
ikTool.setStartTime(initial_time);
ikTool.setEndTime(final_time);
ikTool.setOutputMotionFileName([path,  '\IK_RESULTS_',trialname,'.mot']);
% Save the settings in a setup file
ikTool.print( [path,  '\','Setup_IK_' ,trialname, '.xml']);
ikTool.run();
IK_results_path = [path,  '\IK_RESULTS_',trialname,'.mot'];
toc
end