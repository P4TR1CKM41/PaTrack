function [S] = rmov_from_struct(s, index)
alle_namen = fieldnames(s);

for l = 1: length (alle_namen)

    s.(alle_namen{l, 1})
end
end