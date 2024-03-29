function [activations, force, probe] = SO_app_with_probes(OPTIONS,pathtopfolder, tempfolder, trialname,initial_time, final_time)

tic
import org.opensim.modeling.*

%%copy the files to the folder

%% load the generic setup file
analyeTool = AnalyzeTool([pathtopfolder, '\', OPTIONS.GENERIC.probe_setup]);
analyeTool.setModelFilename(OPTIONS.PATH.SCALED_MODEL_AFTER_RRA_WITH_PROBE);
model = Model(OPTIONS.PATH.SCALED_MODEL_AFTER_RRA_WITH_PROBE); % location of the scaled model
state = model.initSystem();
analyeTool.setName(trialname);
analyeTool.setResultsDir(tempfolder)
analyeTool.setInitialTime(initial_time);
analyeTool.setFinalTime(final_time);
copyfile([pathtopfolder, '\',OPTIONS.GENERIC.so_Actuators],[tempfolder, '\', OPTIONS.GENERIC.so_Actuators]);
analyeTool.setExternalLoadsFileName([OPTIONS.PATHS.Exload.(trialname)]);
analyeTool.setCoordinatesFileName([tempfolder, '\', OPTIONS.PATHS.Kinematics_q.(trialname)]);
%analyeTool.loadModel([pathtopfolder, '\', OPTIONS.GENERIC.probe_setup])
analyeTool.setModel(model)
analyeTool.print([tempfolder,  '\','Setup_SO_' ,trialname, '.xml']);
%analyeTool.run();
% run it via command window and not matlab
setup_path = [tempfolder,  '\','Setup_SO_' ,trialname, '.xml'];
command = ['opensim-cmd run-tool "', setup_path, '"'];
[status, cmdout] = system(command)

% % % % % tool = AnalyzeTool([tempfolder,  '\','Setup_SO_' ,trialname, '.xml']);
% % % % % tool.setModel(model);
% % % % %
% % % % % tool.run();
toc

activations = [trialname, '_StaticOptimization_activation.sto'];
force = [trialname, '_StaticOptimization_force.sto'];
probe = [trialname, '_ProbeReporter_probes.sto'];
end