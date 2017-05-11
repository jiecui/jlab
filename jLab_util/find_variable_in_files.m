function out = find_variable_in_files(variable, file_filter)

% Search for a variable in a list of *.mat files
% Inputs:
%    variable    - The variable name to search for. Can be an exact name or just 
%                  the beginning of a name. In the latter case put a * at the end.
%    file filter - Filter for the file names to search (Optional). A .mat
%                  is added to the filter if it does not already exist
%
% Output:
%    If no output has been assigned, the function will print all the files
%    that contain the variable. Otherwise, a structure containing the file
%    name and the variable name is output.
%
% Elad Yom-Tov, 2004.


if (nargin == 1)
    file_filter = '*.mat';
elseif ~strcmp(file_filter(max(1, end-3:end):end), '.mat')
    file_filter = [file_filter, '.mat'];
end

if (nargout == 0)
    printout = 1;
end

wildcard = strcmp(variable(end), '*');
if (wildcard)
    variable = variable(1:end-1);
end

d = dir(file_filter);

match_count = 0;
for i = 1:length(d)
    vars = whos('-file', d(i).name);
    for j = 1:length(vars)
        if (wildcard & strfind(vars(j).name, variable)) | strcmp(vars(j).name, variable)
            match_count = match_count + 1;
            if (printout)
                disp(['File: ' d(i).name ': ' vars(j).name])
            else
                out(match_count).file     = d(i).name;
                out(match_count).variable = vars(j).name;
            end
        end
    end
end

if (match_count == 0)
    disp('No matfch found')
end
