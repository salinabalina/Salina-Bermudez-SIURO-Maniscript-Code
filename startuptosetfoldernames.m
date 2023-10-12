function startuptosetfoldernames
%% 
% This generates the paths for the images and functions
% Inputs    : none
% Outputs : none
%
% Update October 8, 2023.
% Copyright: Salina Bermudez and Rosemary Renaut
%
fprintf('Starting up learning project...\n')
directory = pwd;
functions_directory='/Functions';
image_directory = '/Images';
functions_directory=strcat(directory,functions_directory);
image_directory =strcat(directory,image_directory);
fprintf('  Current directory:    %s \n', directory)
fprintf('  Setting path to images: %s \n', image_directory)
addpath(genpath(image_directory))
fprintf('  Setting path to functions: %s \n', functions_directory)
addpath(genpath(functions_directory))
fprintf('done.\n\n')
end