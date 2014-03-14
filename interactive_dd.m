clear;
clc;

% Run the distributed diagram script
fprintf('DistributedDiagram v. 0.0\n');
fprintf('-------------------------\n');
filename_ = input('Diagram Full Path Name: ','s');

% Get diagram file name
if isempty(filename_)
    error('You need to input a file name...\n');
end

% Attempt to locate diagram...
append_mode = 0;
if exist(filename_,'file')
    fprintf('Located digram file <%s>\n',filename_);
    append_mode = 1;
else
    fprintf('No diagram file. Creating new diagram\n');
end

% Open the file
if append_mode
    fid = fopen(filename_,'a');
else
    fid = fopen(filename_,'w');    
end

% Load point generating module list
module_list = dir(fullfile('./point_modules/','*.m'));
for i=1:length(module_list)
    modules{i} = module_list(i).name(1:end-2);
end

% Print the module list
fprintf('Select the point generating module...\n');
for i=1:length(modules)
    description_text = help(modules{i});
    fprintf('  [%d] %s:\n',i,modules{i});
    fprintf('      %s\n',description_text);
end
module_id = input('Selection: ');


% Load this module into the anon function "gen_points"
eval(sprintf('gen_point = @(N_) %s(N_);',modules{module_id}));

% Get the test function
test_func_ = input('Give name of DD specific test function:','s');
eval(sprintf('test_func = @(x_,y_) %s(x_,y_);',test_func_));

% Ask how many points to run for
N = input('How many test points: ');

run_dd(N,fid,gen_point,test_func);


view_dd(filename_,1000);



