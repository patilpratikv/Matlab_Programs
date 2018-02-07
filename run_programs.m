%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will run all the m files kept in folder or subfolder
% It will generate csv report of the run. It will contain all the list of
% files and weather they run successfully or not.
% INPUT : run_programs()
% OUTPUT: Run_Report.csv
% Written by : Pratik Patil
% Created On : 02/07/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_programs
clear all;
error_count = 0;
% Add current path with folders and subfolders.
addpath(genpath(pwd));
current_dir = dir;
% Function to process all files in folder
error_count = processThisDir(current_dir, error_count);
report_file = fopen('Run_Report.csv','w+');
if error_count == 0
    fprintf(report_file, 'All file executed successfully!');
else
    fprintf(report_file, '%s,%s,%s,%s\n','Sr. No.','FileName', ...
        'Error Message','Error Line');
    for i = 1:error_count
        error_struct = processThisDir(i);
        fprintf(report_file, '%d,%s,%s,%d\n', ...
            i, error_struct.file, error_struct.message, error_struct.line);
    end
end
fclose(report_file);
end

function error_count = processThisDir(in_1, in_2)
persistent status_struct;
if nargin == 1
    index = in_1;
    error_count = status_struct(index);
else
    Dir = in_1;
    error_count = in_2;
    for fileOrdir = 3:length(Dir)
        nameAndext = strsplit(Dir(fileOrdir).name, '.');
        nameOnly = cell2mat(nameAndext(1));
        if isdir(nameOnly) == 1
            current_Dir = dir(nameOnly);
            % If current file is directory then call recursive function
            % and follow the same process
            error_count = processThisDir(current_Dir, error_count);
        else
            extOnly = cell2mat(nameAndext(2));
            % Exclude this file and all other files except ".m" files
            if (strcmp(nameOnly, mfilename) == 1) || ...
                    (strncmp(extOnly, 'm', 1) ~= 1)
                continue
            else
                try
                    error_count = error_count +1;
                    status_struct(error_count).message = 'Run Successfully';
                    status_struct(error_count).file = nameOnly;
                    status_struct(error_count).line = 0;
                    run(Dir(fileOrdir).name);
                catch err
                    status_struct(error_count).message = err.message;
                    status_struct(error_count).line = err.stack(1).line;
                end
            end
        end
    end
end
end
% EOF
