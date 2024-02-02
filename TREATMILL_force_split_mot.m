function [L, R]=TREATMILL_force_split_mot(path,OPTIONS)
[out] = ReadMotFile(path);
%% I assume that the first strike is gone be a right foot strike!
if OPTIONS.FP_used   ==1
indexuse = 3;
forcevaluesindex = [2:10];
elseif OPTIONS.FP_used  ==2
indexuse = 12;
forcevaluesindex = [11:18];
end
v = (out.data(:,indexuse)>OPTIONS.FP_Stance_Threshold);
streaks = [];
streak_indices = {};
current_streak = 0;
start_index = 0;
for i = 1:length(v)
    if v(i) == 1
        if current_streak == 0 
           start_index = i; 
        end
        current_streak = current_streak + 1; 
    elseif current_streak > 0  
        streaks(end+1) = current_streak;
        streak_indices{end+1}= start_index:(i-1);
        current_streak = 0;
    end
end
if current_streak > 0
    streaks(end+1) = current_streak;
    streak_indices{end+1}= start_index:(i-1);
end
odd_streak_indices = [];
for i = 1:2:numel(streak_indices)
    odd_streak_indices = [odd_streak_indices streak_indices{i}];
end
even_streak_indices = [];
for d = 2:2:numel(streak_indices)
    even_streak_indices = [even_streak_indices streak_indices{d}];
end
[b_filt,a_filt] = butter(2,  20/(OPTIONS.FREQ_ANALOG/2), 'low');
inforce_moments = [forcevaluesindex(1:3), [forcevaluesindex(end-2):forcevaluesindex(end)]];
inforce_moments = [forcevaluesindex]; %% achtung <cop wird mit gefilyert
for y = 1 : length (inforce_moments)
    out.data(:,inforce_moments(y)) = filtfilt(b_filt,a_filt,out.data(:,inforce_moments(y)));
end


GRF1= out.data; 
GRF1(odd_streak_indices',forcevaluesindex)= 0;
GRF2= out.data; 
GRF2(even_streak_indices',forcevaluesindex)= 0;

[GRF1] = force_clean_up(GRF1,OPTIONS.FP_Stance_Threshold);
[GRF2] = force_clean_up(GRF2,OPTIONS.FP_Stance_Threshold);

L = [erase(path, '.mot'), '_LeftGroundContact.mot']; 
R = [erase(path, '.mot'), '_RightGroundContact.mot'];
writeMot(GRF1(:,2:end),GRF1(:,1),L);
writeMot(GRF2(:,2:end),GRF2(:,1),R);

end