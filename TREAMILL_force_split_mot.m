function TREATMILL_force_split_mot(path,OPTIONS)
pathmot = 'C:\Users\adpatrick\Downloads\HSO_TRUNK\Trunk_Lean_15_hinten\ID01/Trunk_Lean_15_hinten 1.mot'
[out] = ReadMotFile(pathmot);
%% I assume that the first strike is gone be a right foot strike!
threshold = 50;
v = (out.data(:,3)>50);
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

GRF1= out.data; 
GRF1(odd_streak_indices',2:10)= 0;
GRF2= out.data; 
GRF2(even_streak_indices',2:10)= 0;
writeMot(GRF1(:,2:end),GRF1(:,1),'C:\Users\adpatrick\Downloads\HSO_TRUNK\Trunk_Lean_15_hinten\ID01/Trunk_Lean_15_hinten 1_seiteL.mot')
writeMot(GRF2(:,2:end),GRF2(:,1),'C:\Users\adpatrick\Downloads\HSO_TRUNK\Trunk_Lean_15_hinten\ID01/Trunk_Lean_15_hinten 1_seiteR.mot')

end