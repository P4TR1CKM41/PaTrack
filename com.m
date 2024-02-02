clc
clear all
close all

folder = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\Oslo2021\'

[conditions] =  get_subfolders(folder);

for c = 1 : 3%length (conditions)
    % [conditions] =  get_subfolders([conditions(c).folder,'/',conditions(c).name]);
    fileListc3d = dir(fullfile([conditions(c).folder,'/',conditions(c).name], '*.mat'));
    hoch = 1;
    hochmm=1;
    lauf = 1;
    for m = 1 : length (fileListc3d)

        if contains(fileListc3d(m).name, 'OpenSim') ==1;
           
            da =  load([fileListc3d(m).folder, '/' fileListc3d(m).name]);
            P(hoch,c) = mean(da.PARAMETERS.LEVERARM);
            I(lauf)= c;
            lauf=lauf+1;
            ARRAYo.(['CON', num2str(c)])(:, hoch) = mean(da.NORMAL.R.KAM,2);
            hoch = hoch+1;
        else
            % da =  load([fileListc3d(m).folder, '/' fileListc3d(m).name]);
            % PMotrack(hochmm,c) = mean(max(da.NORMAL.R.MOMENTS_100MS.RIGHT_KNEE_X));
            % ARRAYMOTRACK.(['CON', num2str(c)])(:, hochmm)   = mean(da.NORMAL.R.MOMENTS_100MS.RIGHT_KNEE_X,2);
            % hochmm = hochmm+1;
        end

    end
end
%%

close all
figure(100)
h1 = plot(mean(ARRAYo.CON1,2), 'r', 'LineStyle','--', LineWidth=3);
hold on
% plot((ARRAYo.CON1), 'r', 'LineStyle','--', LineWidth=0.5);

hold on
h2 = plot(mean(ARRAYo.CON2,2), 'r', 'LineStyle','-', LineWidth=3);
h11 = plot(mean(ARRAYo.CON3,2), 'r', 'LineStyle','-.', LineWidth=3);

h3 = plot(mean(ARRAYMOTRACK.CON1,2), 'g', 'LineStyle','--', LineWidth=3);
h4 = plot(mean(ARRAYMOTRACK.CON2,2), 'g', 'LineStyle','-', LineWidth=3);
h5 = plot(mean(ARRAYMOTRACK.CON3,2), 'g', 'LineStyle','-.', LineWidth=3);
stan_plot_100ms
title ('Mean curves of n=45')
legend([h1, h2, h11, h3, h4, h5], {'OpenSim Task 1', 'OpenSim Task 2', 'Motrack Task 1', 'Motrack Task 2', 'Motrack Task 3'})

[rhoo,pvalo] = corr(P(:,1), P(:,2),'Type','Spearman')
[rhom,pvalm] = corr(PMotrack(:,1), PMotrack(:,2),'Type','Spearman')
[ho,po,cio,statso] = ttest(P(:,1), P(:,2))
[h,p,ci,stats] = ttest(PMotrack(:,1), PMotrack(:,2))
o=mean(P)
m= mean(PMotrack)
figure(2)
b=bar([o(1), m(1), o(2), m(2), o(3), m(3)]);
b.FaceColor = 'flat';
b.CData(1,:) = [1 0 0 ];
b.CData(3,:) = [1 0 0 ];
b.CData(5,:) = [1 0 0 ];
b.CData(2,:) = [0 0.5 0 ];
b.CData(4,:) = [0 0.5 0 ];
b.CData(6,:) = [0 0.5 0 ];
xticks([1,2,3,4,5,6])
xticklabels({'OpenSim Task 1', 'MoTrack Task 1','OpenSim Task 2', 'MoTrack Task 2','OpenSim Task 3', 'MoTrack Task 3'})
xtickangle(45)
stan_plot_generell
ylabel ('Peak KAM first 100ms [Nm/kg]')
ylim ([0, 2])
hold on
plot([1,2], [1.6, 1.6], 'k')
plot([3,4], [1.8, 1.8], 'k')
plot([5,6], [1.8, 1.8], 'k')
text(1,1.7, ['delta=', num2str(round(o(1)-m(1),3))])
text(3,1.9, ['delta=', num2str(round(o(2)-m(2),3))])
text(5,1.9, ['delta=', num2str(round(o(3)-m(3),3))])
text(0.7, 1, num2str(round(o(1),2)))
text(1.7,1, num2str(round(m(1),2)))
text(2.7,1, num2str(round(o(2),2)))
text(3.7,1, num2str(round(m(2),2)))
text(4.7,1, num2str(round(o(3),2)))
text(5.7,1, num2str(round(m(3),2)))
title ('Mean values of n=45')
[T{2,1},pvalo] = corr(P(:,1), P(:,3),'Type','Spearman')
[T{2,2},pvalm] = corr(PMotrack(:,1), PMotrack(:,3),'Type','Spearman')
[ho,T{1,1},cio,statso] = ttest(P(:,1), P(:,3), "Alpha",0.0167)
[h,T{1,2},ci,stats] = ttest(PMotrack(:,1), PMotrack(:,3), "Alpha",0.0167)
