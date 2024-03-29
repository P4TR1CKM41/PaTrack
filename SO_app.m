function [activations, force] = SO_app(OPTIONS,pathtopfolder, tempfolder, trialname,initial_time, final_time)

tic
import org.opensim.modeling.*

%%copy the files to the folder

%% load the generic setup file
analyeTool = AnalyzeTool([pathtopfolder, '\', OPTIONS.GENERIC.so_setup]);
analyeTool.setModelFilename([tempfolder, '\', OPTIONS.PATHS.ajusted_model.(trialname)]);
analyeTool.setName(trialname);
analyeTool.setResultsDir(tempfolder)
analyeTool.setInitialTime(initial_time);
analyeTool.setFinalTime(final_time);
copyfile([pathtopfolder, '\',OPTIONS.GENERIC.so_Actuators],[tempfolder, '\', OPTIONS.GENERIC.so_Actuators]);
analyeTool.setExternalLoadsFileName([OPTIONS.PATHS.Exload.(trialname)]);
analyeTool.setCoordinatesFileName([tempfolder, '\', OPTIONS.PATHS.Kinematics_q.(trialname)]);
analyeTool.print([tempfolder,  '\','Setup_SO_' ,trialname, '.xml']);

setup_path = [tempfolder,  '\','Setup_SO_' ,trialname, '.xml'];
command = ['opensim-cmd run-tool "', setup_path, '"'];
[status, cmdout] = system(command)

% analyeTool.run();
toc

activations = [trialname, '_StaticOptimization_activation.sto'];
force = [trialname, '_StaticOptimization_force.sto'];

end