% Model free work for the Cooperation Task in the Wellbeing Study

% We are looking for
% Average reaction time for positive block
% Average reaction time for negative block
% Number of times they chose left, right, middle in both blocks
% Number of times they chose the bandit with highest probability


sub = 'A1EX0MEOPF8AHT';
cb = '';
%df = Invitation_mf(sub, cb);

subdat = readtable('cooperation_task_A1EX0MEOPF8AHT_T1_Pilot_R1_2023-05-26_20h28.31.919.xlsx');
rts = cellfun(@str2num, subdat.response_time, 'UniformOutput', false);

% The positive block is recorded in the rows between
% trial_type=='MAIN_START' and trial_type=='MAIN_SWITCH'. The negative
% block is recorded in the rows after trial_type=='MAIN_SWITCH'
% the participant response, result they see, and reaction time is recorded
% in rows with event_type=='5'

% Assuming you have a table 'subdat' with columns 'trial_type', 'response_time', and 'event_type'

% Find the row indices for the positive block
positiveStartIdx = find(subdat.trial_type == "MAIN_START", 1);
positiveSwitchIdx = find(subdat.trial_type == "MAIN_SWITCH", 1);
positiveEndIdx = positiveSwitchIdx - 1;

% Find the row indices for the negative block
negativeStartIdx = positiveSwitchIdx + 1;
negativeEndIdx = height(subdat);

% Filter the positive and negative blocks
positiveBlock = subdat(positiveStartIdx:positiveEndIdx, :);
negativeBlock = subdat(negativeStartIdx:negativeEndIdx, :);

% Convert response_time column to numeric array
responseTimePositive = str2double(positiveBlock.response_time);
responseTimeNegative = str2double(negativeBlock.response_time);

% Convert event_type column to logical array
actionEventPositive = positiveBlock.event_type == 5;
actionEventNegative = negativeBlock.event_type == 5;

% Exclude missing values (NaN) when calculating average reaction time
positiveReactionTime = mean(responseTimePositive(~isnan(responseTimePositive) & actionEventPositive));
negativeReactionTime = mean(responseTimeNegative(~isnan(responseTimeNegative) & actionEventNegative));

% Display the results
disp("Average reaction time for positive block: " + positiveReactionTime);
disp("Average reaction time for negative block: " + negativeReactionTime);



%%%%%%%%%%%%%%%
%Finding how many times they chose left, right, and middle
posResponseCol = positiveBlock.response;
negResponseCol = negativeBlock.response;

% Convert the columns to cell arrays
posResponseCol = cellstr(posResponseCol);
negResponseCol = cellstr(negResponseCol);

% Filter the rows where the cell value is "left" and eventTypePositive is true
pos_occurrences = sum(strcmp(posResponseCol, 'left') & actionEventPositive);
neg_occurrences = sum(strcmp(negResponseCol, 'left') & actionEventNegative);
total_left = pos_occurrences + neg_occurrences;
disp("Total times selected left: " + total_left);

% Filter the rows where the cell value is "right" and eventTypePositive is true
pos_occurrences = sum(strcmp(posResponseCol, 'right') & actionEventPositive);
neg_occurrences = sum(strcmp(negResponseCol, 'right') & actionEventNegative);
total_right = pos_occurrences + neg_occurrences;
disp("Total times selected right: " + total_right);

% Filter the rows where the cell value is "up" and eventTypePositive is true
pos_occurrences = sum(strcmp(posResponseCol, 'up') & actionEventPositive);
neg_occurrences = sum(strcmp(negResponseCol, 'up') & actionEventNegative);
total_up = pos_occurrences + neg_occurrences;
disp("Total times selected center: " + total_up);


%%%%%%%%%%%%%%%
%Finding the number of times they chose the bandit with the highest
%probability
% Bandit probabilities are listed in trial_type under format
% '16_{left_prob of being positive}_{mid_prob of being
% positive}_{right_prob of being positive}'

% subset the table to only look at rows where the event_type is 5,
% signaling a participant response. Remember to not look at practice
% trials!
start_index = find(subdat.trial_type == "MAIN_START", 1);
response_table = subdat(start_index:end, :);
response_table = response_table(response_table.event_type == 5, :);



% Using the trial_type and response columns...
trialTypes = response_table.trial_type;
participantChoices = response_table.response;

% Counter variable for when participant chose highest probability option
num_correct_choice = 0;

% Iterate over each row of the table
for i = 1:height(response_table)
    % Parse the trial_type cell to obtain the probabilities
    probabilities = sscanf(trialTypes{i}, '%*d_%f_%f_%f');
    
    % Determine the option with the highest probability
    [~, maxIdx] = max(probabilities);
    options = {'left', 'up', 'right'};
    best_option = options{maxIdx};
    
    % Compare the chosen option with the option with the highest probability
    
    if strcmp(participantChoices{i}, best_option)
        num_correct_choice = num_correct_choice + 1;
    end
end

disp(['Number of trials where the participant chose the option with the highest probability: ', num2str(num_correct_choice)]);



%function subtab = Invitation_mf(subject, counterbalance)
%dirnam = ['L:/NPC/DataSink/StimTool_Online/WBMTURK_Cooperation_TaskCB' counterbalance];
%datasink = dir(dirnam);
%subidx = find(arrayfun(@(n) contains(datasink(n).name, ['cooperation_task_' subject]),1:numel(datasink)));
%subdat = readtable([dirnam '/' datasink(subidx).name]);


%subdat = readtable('cooperation_task_A1EX0MEOPF8AHT_T1_Pilot_R1_2023-05-26_20h28.31.919.xlsx');
%end