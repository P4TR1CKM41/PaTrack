function [activations, force, probe] = SO_app_with_probes(OPTIONS,pathtopfolder, tempfolder, trialname,initial_time, final_time)

tic
import org.opensim.modeling.*

%%copy the files to the folder

%% load the generic setup file
analyeTool = AnalyzeTool([pathtopfolder, '\', OPTIONS.GENERIC.probe_setup]);
analyeTool.setModelFilename(OPTIONS.PATH.SCALED_MODEL_AFTER_RRA_WITH_PROBE);
analyeTool.setName(trialname);
analyeTool.setResultsDir(tempfolder)
analyeTool.setInitialTime(initial_time);
analyeTool.setFinalTime(final_time);
copyfile([pathtopfolder, '\',OPTIONS.GENERIC.rra_actuator],[tempfolder, '\', OPTIONS.GENERIC.rra_actuator]);
analyeTool.setExternalLoadsFileName([OPTIONS.PATHS.Exload.(trialname)]);
analyeTool.setCoordinatesFileName([tempfolder, '\', OPTIONS.PATHS.Kinematics_q.(trialname)]);
%analyeTool.loadModel([pathtopfolder, '\', OPTIONS.GENERIC.probe_setup])
analyeTool.print([tempfolder,  '\','Setup_SO_' ,trialname, '.xml']);
model = Model([pathtopfolder, '\', OPTIONS.GENERIC.so_setup]); % location of the scaled model
model.initSystem();
analyeTool.run();
toc

activations = [trialname, '_StaticOptimization_activation.sto'];
force = [trialname, '_StaticOptimization_force.sto'];
probe = [trialname, '_ProbeReporter_probes.sto'];
end