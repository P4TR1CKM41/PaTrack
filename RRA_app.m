function[actuation_force, actuation_power, actuation_speed, avgResiduals, controls, Kinematics_dudt, Kinematics_q, Kinematics_u, pErr, states, ajusted_model] = RRA_app(pathtopfolder,OPTIONS,trialname, tempfolder,initial_time, final_time )

tic
import org.opensim.modeling.*

%%copy the files to the folder

%% load the generic setup file
rraTool = RRATool([pathtopfolder, '\', OPTIONS.GENERIC.rra_setup]);
%% set subject specific settings
rraTool.setModelFilename(OPTIONS.PATH.SCALED_MODEL);
rraTool.setName(trialname)
rraTool.setExternalLoadsFileName(OPTIONS.PATHS.Exload.(trialname))
rraTool.setDesiredKinematicsFileName(OPTIONS.PATHS.IK.(trialname))
rraTool.setResultsDir(tempfolder)
rraTool.setOutputModelFileName([tempfolder, '\', 'ajusted_', trialname, '.osim'])
rraTool.setInitialTime(initial_time);
rraTool.setFinalTime(final_time);
rraTool.print( [tempfolder,  '\','Setup_RRA_' ,trialname, '.xml']);

%%copy contraints, actuators and task file
copyfile([pathtopfolder, '\',OPTIONS.GENERIC.rra_actuator],[tempfolder, '\', OPTIONS.GENERIC.rra_actuator])
copyfile([pathtopfolder, '\',OPTIONS.GENERIC.rra_controlconstraints],[tempfolder, '\', OPTIONS.GENERIC.rra_controlconstraints])
copyfile([pathtopfolder, '\',OPTIONS.GENERIC.rra_task],[tempfolder, '\', OPTIONS.GENERIC.rra_task])
rraTool.run();

actuation_force = [trialname,'_Actuation_force', '.sto'];
actuation_power = [trialname,'_Actuation_power', '.sto'];
actuation_speed = [trialname,'_Actuation_speed', '.sto'];
avgResiduals = [trialname,'_avgResiduals', '.txt'];
controls = [trialname,'_controls', '.sto'];
Kinematics_dudt = [trialname,'_Kinematics_dudt', '.sto'];
Kinematics_q = [trialname,'_Kinematics_q', '.sto'];
Kinematics_u = [trialname,'_Kinematics_u', '.sto'];
pErr = [trialname,'_pErr', '.sto'];
states = [trialname,'_states', '.sto'];
ajusted_model = ['ajusted_', trialname, '.osim'];

toc

end