clc
clear all
close all

import org.opensim.modeling.*
modelpath = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\HSO_TRUNK_EXTENDED\Trunk_Lean_15_hinten\ID01\ajusted_Trunk_Lean_15_hinten1.osim'


model = Model(modelpath); % location of the scaled model
mystate = model.initSystem();
model.setName("_probed")
fileID = fopen(fullfile(cd, 'metabolicsSlowTwitchRatios_Gait2392.txt'), 'r');
data = textscan(fileID, '%s %f');
fclose(fileID);

muscleNames = data{1};
twitchRatios = data{2};

% The following booleans are constructor arguments for the Umberger probe.
% These settings are used for all probes.
activationMaintenanceRateOn = true;
shorteningRateOn = true;
basalRateOn = false;
mechanicalWorkRateOn = true;
reportTotalMetabolicsOnly = false;


% The slow-twitch ratio used for muscles that either do not appear in the
% file, or appear but whose proportion of slow-twitch fibers is unknown.
defaultTwitchRatio = 0.5;


% Define a whole-body probe that will report the total metabolic energy
% consumption over the simulation.
wholeBodyProbe = Umberger2010MuscleMetabolicsProbe(activationMaintenanceRateOn, shorteningRateOn, basalRateOn, mechanicalWorkRateOn);
wholeBodyProbe.setOperation("value");
wholeBodyProbe.set_report_total_metabolics_only(reportTotalMetabolicsOnly);

% Add the probe to the model and provide a name.
model.addProbe(wholeBodyProbe);
wholeBodyProbe.setName("metabolics");

% Loop through all muscles, adding parameters for each into the whole-body
% probe.
try
for iMuscle = 1:model.getMuscles().getSize()
    iMuscle
    model.getMuscles().getSize() 
    thisMuscle = model.getMuscles().get(iMuscle)
    
    % Get the slow-twitch ratio from the data we read earlier. Start with
    % the default value.
    slowTwitchRatio = defaultTwitchRatio;
     try  
    % Set the slow-twitch ratio to the physiological value, if it is known.
    for i = 1:length(muscleNames)
        if startsWith(thisMuscle.getName(), muscleNames{i}) && twitchRatios(i) ~= -1
            slowTwitchRatio = twitchRatios(i);
        end
    end
     end
    % Add this muscle to the whole-body probe. The arguments are muscle
    % name, slow-twitch ratio, and muscle mass. Note that the muscle mass
    % is ignored unless we set useProvidedMass to True.
    try
    wholeBodyProbe.addMuscle(thisMuscle.getName(), slowTwitchRatio);
    end
end
end
% Save the new model to a file with the suffix "_probed".

newPathName = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\HSO_TRUNK_EXTENDED\Trunk_Lean_15_hinten\ID01\ajusted_Trunk_Lean_15_hinten1_probe.osim'
model.print(newPathName);

% Add the new model to the GUI.



