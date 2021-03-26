%Created on 8/27/2018 By Douwe Horsthuis For Ana
%Script will take
%1) the means of oddball epoched data, in a defined time window, for a selected channel
%2)separates the conditions (450 900 1800)
%3)assign a trail number to every individual mean
%4)assign a number for what group the participants belong to
%5)put this in a matlab table
% use the script called trail_to_excel_2 to transfer this to an excel sheet

clear variable
eeglab
group = 'CYS'; % CYS or TD
path  = 'path_where_to_load_data'; 
save_path = 'path_where_to_store_data';

        
switch group
    case 'TD' %TD = controls
        subj    =  {'all_TD_ids' 'next_to_eachother'};%
    case 'CYS' %CYS = cystinosis
        subj    = {'all_CYS_ids' 'next_to_eachother'}
end

data_temp = [];
for subj_count = 1:length(subj)
    %% loading data and separating the epochs 
    % Path to the folder containing the current Subject's data
data_path  = [path subj{subj_count} '/'];
    %loading data set
    EEG  = pop_loadset('filename', [subj{subj_count} '_epoched.set'], 'filepath', data_path , 'loadmode', 'all');
    % separating the epochs 
    EEG450p3  = pop_selectevent( EEG, 'type',{'B1(450_std)'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    EEG900p3  = pop_selectevent( EEG, 'type',{ 'B3(900_std)' },'deleteevents','on','deleteepochs','on','invertepochs','off');
    EEG1800p3  = pop_selectevent( EEG, 'type',{ 'B5(1800_std)'},'deleteevents','on','deleteepochs','on','invertepochs','off');
  %% creating means for amplitude for a specific channel
  
%Fp1	=	1;
%AF7	=	2;
%AF3	=	3;
%F1	=	4;
%F3	=	5;
%F5	=	6;
%F7	=	7;
%FT7	=	8;
%FC5	=	9;
%FC3	=	10;
%FC1	=	11;
%C1	=	12;
%C3	=	13;
%C5	=	14;
%T7	=	15;
%TP7	=	16;
%CP5	=	17;
%CP3	=	18;
%CP1	=	19;
%P1	=	20;
%P3	=	21;
%P5	=	22;
%P7	=	23;
%P9	=	24;
%PO7	=	25;
%PO3	=	26;
%O1	=	27;
%Iz	=	28;
%Oz	=	29;
%POz	=	30;
%Pz	=	31;
%CPz	=	32;
%Fpz	=	33;
%Fp2	=	34;
%AF8	=	35;
%AF4	=	36;
%AFz	=	37;
%Fz	=	38;
%F2	=	39;
%F4	=	40;
%F6	=	41;
%F8	=	42;
%FT8	=	43;
%FC6	=	44;
%FC4	=	45;
%FC2	=	46;
FCz	=	47;
%Cz	=	48;
%C2	=	49;
%C4	=	50;
%C6	=	51;
%T8	=	52;
%TP8	=	53;
%CP6	=	54;
%CP4	=	55;
%CP2	=	56;
%P2	=	57;
%P4	=	58;
%P6	=	59;
%P8	=	60;
%P10	=	61;
%PO8	=	62;
%PO4	=	63;
%O2	=	64;
    %specify the begin and end points of the time window of interest
time_window = [200 260];

% find the samples within this time window for 450 condition
    samples450p3 = find(  EEG450p3.times>=time_window(1) &  EEG450p3.times<=time_window(2) );
% pull out the data from this range of samples, and average over samples
% for 450 condition
    means450p3 = squeeze( mean( EEG450p3.data( FCz, samples450p3, : ), 2 ) );
%do the same for 900 condition        
    samples900p3 = find( EEG900p3.times>=time_window(1) & EEG900p3.times<=time_window(2) );
    means900p3 = squeeze( mean( EEG900p3.data( FCz, samples900p3, : ), 2 ) );
%do the same for 1800 condition        
    samples1800p3 = find( EEG1800p3.times>=time_window(1) & EEG1800p3.times<=time_window(2) );
    means1800p3 = squeeze( mean( EEG1800p3.data( FCz, samples1800p3, : ), 2 ) );


  %% Condition
    p3450 = 0; p3900 = 0; p31800 = 0; 
    p3450(1:length(means450p3))     = 1
    p3900(1:length(means900p3))       = 2
    p31800(1:length(means1800p3))       = 3
    Condition      = [p3450, p3900, p31800]; 
    if isrow(Condition); Condition = Condition'; end
    
    %% Trial creating a counter for every trial
     
    p3450_tr = []; p3900_tr = []; p31800_tr = []; Trial = [];  
    p3450_tr = (1:length(means450p3))
    p3900_tr = (1:length(means900p3))
    p31800_tr = (1:length(means1800p3)) 
    Trial = [p3450_tr, p3900_tr, p31800_tr]; 
    if isrow(Trial); Trial = Trial'; end
        %% error related positivity (ERP)Erp -here we can combine the means of diff conditions
    Erp = [means450p3; means900p3; means1800p3]; % meansmiss;
           %% Subject - calls all of them the total n of subjects not individ ID
    subject = [];
    subject =1:length(Erp)      
    
    if strcmp(group,'TD')
        subject(1:length(Erp))      = subj_count;
    else 
        %+13 to go after first group of CYS
        subject(1:length(Erp))      = subj_count+13;
    end
    if isrow(subject); subject = subject'; end  
%% combining     
    data_subj                  = [];
    data_subj                  = [subject, Condition, Trial, Erp];
    data_temp                  = [data_temp; data_subj]; 
end

%% group

if strcmp(group,'TD')
    Group(1:length(data_temp)) = 1;
else %CYS group
    Group(1:length(data_temp)) = 2;
end
if isrow(Group); Group = Group'; end
   
data = [Group, data_temp];
%% saving the tables files
if strcmp(group,'TD')
    data_TD = data;
    save([save_path 'mmnstd-nt'])
else
    data_CYS = data;
    save([save_path 'mmnstd-cys'])
    
end

