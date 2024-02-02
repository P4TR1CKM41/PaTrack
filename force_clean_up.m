function [GRF1] = force_clean_up(GRF1,FP_Stance_Threshold)
vector = GRF1(:,3);
above_threshold = vector > FP_Stance_Threshold;
diffs = [0; diff(above_threshold)];
starts = find(diffs == 1);
ends = find(diffs == -1);
use_stance = find(ends-starts(1:end-1)>100);
for u = 1 : length(use_stance)
    % starts(use_stance(u))
    % ends(use_stance(u))
    V{1,u} = [starts(use_stance(u)):ends(use_stance(u))];
end
all = [1:length(GRF1(:,1))];
combines = [all'; cell2mat(V)']';
[vals,~,ic] = unique(combines);
counts = accumarray(ic,1);
dup_vals = vals(counts == 2);
combines(ismember(combines,dup_vals)) = [];
GRF1(combines,[2:end]) = 0;
end