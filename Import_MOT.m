function Cutting6 = Import_MOT(filename, dataLines)
%IMPORTFILE Import data from a text file
%  CUTTING6 = IMPORTFILE(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  CUTTING6 = IMPORTFILE(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  Cutting6 = importfile("C:\Users\adpatrick\OneDrive - nih.no\Desktop\Oslo2021\Intensity1\P001\Cutting6.mot", [8, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 04-Oct-2023 20:15:41

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [8, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 28);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["time", "ground_force_1_vx", "ground_force_1_vy", "ground_force_1_vz", "ground_force_1_px", "ground_force_1_py", "ground_force_1_pz", "ground_moment_1_mx", "ground_moment_1_my", "ground_moment_1_mz", "ground_force_2_vx", "ground_force_2_vy", "ground_force_2_vz", "ground_force_2_px", "ground_force_2_py", "ground_force_2_pz", "ground_moment_2_mx", "ground_moment_2_my", "ground_moment_2_mz", "ground_force_3_vx", "ground_force_3_vy", "ground_force_3_vz", "ground_force_3_px", "ground_force_3_py", "ground_force_3_pz", "ground_moment_3_mx", "ground_moment_3_my", "ground_moment_3_mz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
Cutting6 = readtable(filename, opts);

end