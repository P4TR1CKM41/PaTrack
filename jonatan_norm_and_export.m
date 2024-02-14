clc
clear all
close all



DATA.OPTIONS.top_folder = 'C:\Users\adpatrick\OneDrive - nih.no\Desktop\Jonatan2';
[conditions] = get_subfolders(DATA.OPTIONS.top_folder);
hoch = 1;
for c = 1: 2
    hoch = 1;
    n = 1;
    fileListmat = dir(fullfile([conditions(c).folder, '/', conditions(c).name], '*.mat'));
    for i = 1: length (fileListmat)
        n = 1;
        TEMP =load ([fileListmat(i).folder, '/', fileListmat(i).name]);
        trialnames = fieldnames (TEMP.MOMENT_TABLE);
        for tr = 1 : length (trialnames)

            TEMP.MOMENT_TABLE.(trialnames{tr, 1});
            %TEMP.CONTACT_KINEMATIC.(trialnames{tr, 1})
            tablenames = TEMP.MOMENT_TABLE.(trialnames{tr, 1}).Properties.VariableNames;

            for v = 1: length(tablenames)
                [b_filt,a_filt] = butter(2,  6/(1/((TEMP.MOMENT_TABLE.(trialnames{tr, 1}).time(2))-(TEMP.MOMENT_TABLE.(trialnames{tr, 1}).time(1)))/2), 'low');
                dummy = filtfilt(b_filt,a_filt, TEMP.MOMENT_TABLE.(trialnames{tr, 1}).(tablenames{1, v}));
                OUT.(conditions(c).name).(tablenames{1, v})(:,hoch) = normalize_vector (dummy(TEMP.CONTACT_KINEMATIC.(trialnames{tr, 1}),1), 0.5)';
                clearvars dummy
            end
            NAMES.(conditions(c).name){1,hoch} = (trialnames{tr, 1});

            hoch = hoch+1;
            n = n+1;
        end
        clearvars TEMP
    end
end
connames = fieldnames (OUT);
col(1,:) = [0,0,0];
col(2,:) = [1,0,1];
for r = 1 : length (connames)
    varnames = fieldnames(OUT.(connames{r, 1}));
    for v = 2: length (varnames)
        OUT.(connames{r, 1}).(varnames{v, 1});
        figure(v)
        % h(r) =  plot(mean( OUT.(connames{r, 1}).(varnames{v, 1}), 2), "color", col{r}, "LineWidth",4);
        % hold on
        % plot(( OUT.(connames{r, 1}).(varnames{v, 1})), "color", col{r}, "LineWidth",1);
        LineList = plot (OUT.(connames{r, 1}).(varnames{v, 1}), 'Color',col(r,:) ,'LineWidth',0.2, 'LineStyle','-');
        set(LineList, 'ButtonDownFcn', {@myLineCallback, LineList,NAMES.(connames{r, 1}) });
        title ((varnames{v, 1}), "interpreter", 'none')
        stan_plot
        hold on
        h(r) =  plot(mean( OUT.(connames{r, 1}).(varnames{v, 1}), 2), "color", col(r,:), "LineWidth",4);
        % hold on
        if r ==length (connames)
            saveas(gcf,[DATA.OPTIONS.top_folder , '/',(varnames{v, 1}), '.png' ])
        end
    end

end

