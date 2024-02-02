function [PARAMETER] = values_at_IC(ARRAY, IC, dy)


for i = 1 : length(ARRAY.Properties.VariableNames)
    PARAMETER.(['IC_',ARRAY.Properties.VariableNames{i} ])(1,dy)  = table2array(ARRAY(IC,ARRAY.Properties.VariableNames{i}));
end

end