clc
clear all
close all


load('C:\Users\adpatrick\Downloads\HSO_TRUNK\Trunk_Lean_25_vor\ID01OpenSim.mat')
% plot(GRF_TABLE.R.Trunk_Lean_15_hinten1_Copy.ground_force1_vy)
% hold on
% for l = 1 : length (CONTACT_ANALOG.R.Trunk_Lean_15_hinten1_Copy.TD)
% xline(CONTACT_ANALOG.R.Trunk_Lean_15_hinten1_Copy.TD(l))
%
% end

tr_names = fieldnames(CONTACT_KINEMATIC.R);
for tr =1:length (tr_names)
    no_steps = length(CONTACT_KINEMATIC.R.(tr_names{1, tr}).TD)
    for r = 1 : no_steps
        header = MOMENT_TABLE.R.(tr_names{1, tr}).Properties.VariableNames;
        for j = 1 : length (header)
            NORMAL.R.(header{1, j})(:,r) =  normalize_vector (MOMENT_TABLE.R.(tr_names{1, tr}).(header{1, j})(CONTACT_KINEMATIC.R.(tr_names{1, tr}).TD(r):CONTACT_KINEMATIC.R.(tr_names{1, tr}).TO(r)),0.5);
        end
    end
end

tr_names = fieldnames(CONTACT_KINEMATIC.L);
for tr =1:length (tr_names)
    no_steps = length(CONTACT_KINEMATIC.L.(tr_names{1, tr}).TD)
    for r = 1 : no_steps
        header = MOMENT_TABLE.L.(tr_names{1, tr}).Properties.VariableNames;
        for j = 1 : length (header)
            NORMAL.L.(header{1, j})(:,r) =  normalize_vector (MOMENT_TABLE.L.(tr_names{1, tr}).(header{1, j})(CONTACT_KINEMATIC.L.(tr_names{1, tr}).TD(r):CONTACT_KINEMATIC.L.(tr_names{1, tr}).TO(r)),0.5);
        end
    end
end


for tr =1:length (tr_names)
    header = MOMENT_TABLE.R.(tr_names{1, tr}).Properties.VariableNames;
    for j = 1 : length (header)
        figure(j)
        plot(mean(NORMAL.R.(header{1, j}),2)./OPTIONS.ANTRO.mass, 'LineWidth',5)
        hold on
        plot((NORMAL.R.(header{1, j}))./OPTIONS.ANTRO.mass, 'k', 'LineWidth',1)
        title ((header{1, j}), 'Interpreter','none')

        plot(mean(NORMAL.L.(header{1, j}),2)./OPTIONS.ANTRO.mass, 'LineWidth',5, 'Color','g')
        hold on
        plot((NORMAL.L.(header{1, j}))./OPTIONS.ANTRO.mass, 'g', 'LineWidth',1)
        title ((header{1, j}), 'Interpreter','none')

    end
end
