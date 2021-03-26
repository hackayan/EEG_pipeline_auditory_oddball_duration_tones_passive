clear variables 
eeglab

% This defines the set of subjects
subject_list = {'all_ids' 'next_to_eachother'};
nsubj = length(subject_list); % number of subjects

% Path to the parent folder, which contains the data folders for all subjects
home_path  = 'filepath_to_the_data\';

% Loop through all subjects
for s=1:nsubj
    fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{s});

    % Path to the folder containing the current subject's data
    data_path  = [home_path subject_list{s} '\\'];

        % Load original dataset
    fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject_list{s});
    EEG = pop_loadset('filename', [subject_list{s} '_exext.set'], 'filepath', data_path);
    EEG = eeg_checkset( EEG );
    EEG = pop_rejchan(EEG ,'threshold',5,'norm','on','measure','kurt');
    EEG = pop_saveset( EEG, 'filename',[subject_list{s} '_exchn.set'],'filepath', data_path);
end;
