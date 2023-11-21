%% Model Free Script, written by SMT and adapted for Cooperation Task by CAL
dbstop if error
    if ispc
        root = 'L:/';
        subject = 'A2MPA5OAT635HG';
        data_dir = 'L:/NPC/DataSink/StimTool_Online/WBMTURK_Cooperation_TaskCB/';
        results_dir = 'L:/rsmith/lab-members/clavalley/studies/development/wellbeing/cooperation/half_data_mturk/model_free';
        run = '1';
    elseif isunix 
        root = '/media/labs/';
        subject = getenv('SUBJECT');   
        block_type = getenv('BLOCK_TYPE'); 
        data_dir = getenv('INPUT_DIRECTORY'); 
        results_dir = getenv('RESULTS');
        run = getenv('RUN');
    end

      
    TpB = 16; %trials per block

    NB  = 10; %number of blocks

    N   = TpB*NB; %trials per block * number of blocks
    %--------------------------------------------------------------------------

    %% Add Subj Data
    try
        [subdat, cb] = Coop_parse_file(subject, data_dir, run);
    catch
        return
    end
 for data = 1:numel(subdat)
     subjdata = subdat{data};

    sub.o = str2num(cell2mat(subjdata.result(subjdata.event_type == 5)));
    sub.u = str2num(cell2mat(subjdata.response(subjdata.event_type == 5)));

     if NB == 10
        % return
     end

    sub.u = sub.u+1;

        o_all = [];
        u_all = [];
        highest_block_prob = [];

    for n = 1:NB
        o_all = [o_all sub.o((n*TpB-(TpB-1)):TpB*n,1)];
        u_all = [u_all sub.u((n*TpB-(TpB-1)):TpB*n,1)];
        
        max_prob_n = max(cellfun(@str2num, strsplit(subjdata(subjdata.event_type==3,:).trial_type{n},"_")));
        highest_block_prob = [highest_block_prob find(ismember(cellfun(@str2num, strsplit(subjdata(subjdata.event_type==3,:).trial_type{n},"_")), max_prob_n))+1];
    end
    
    win_stay  = zeros(TpB-1,NB);
    win_shift  =zeros(TpB-1,NB);
    lose_stay = zeros(TpB-1,NB);
    lose_shift = zeros(TpB-1,NB);

    win_stay_2h  =zeros(TpB-1,NB);
    win_shift_2h  =zeros(TpB-1,NB);
    lose_stay_2h = zeros(TpB-1,NB);
    lose_shift_2h = zeros(TpB-1,NB);

    win_stay_1h  =zeros(TpB-1,NB);
    win_shift_1h  =zeros(TpB-1,NB);
    lose_stay_1h = zeros(TpB-1,NB);
    lose_shift_1h = zeros(TpB-1,NB);
    
    accuracy = zeros(TpB-1,NB);

    for j = 1:NB
    for i = 1:TpB-1
    if o_all(i,j) == 1
        if u_all(i,j) == u_all(i+1,j)

            win_stay(i,j) = 1;
        else
            win_shift(i,j) = 1;
        end
    elseif o_all(i,j) == 0
        if u_all(i,j) == u_all(i+1,j)

            lose_stay(i,j) = 1;
        else
            lose_shift(i,j) = 1;
        end
    end
    end
    end

    for j = 1:NB
    for i = 1:TpB
        if u_all(i,j) == highest_block_prob(j)
            accuracy(i,j) = 1;
        else
            accuracy(i,j) = 0;
        end
    end
    end

    for j = 1:NB
    for i = 8:TpB-1
    if o_all(i,j) == 1
        if u_all(i,j) == u_all(i+1,j)

            win_stay_2h(i,j) = 1;
        else
            win_shift_2h(i,j) = 1;
        end
    elseif o_all(i,j) == 0
        if u_all(i,j) == u_all(i+1,j)

            lose_stay_2h(i,j) = 1;
        else
            lose_shift_2h(i,j) = 1;
        end
    end
    end
    end

    for j = 1:NB
    for i = 1:TpB-9
    if o_all(i,j) == 1
        if u_all(i,j) == u_all(i+1,j)

            win_stay_1h(i,j) = 1;
        else
            win_shift_1h(i,j) = 1;
        end
    elseif o_all(i,j) == 0
        if u_all(i,j) == u_all(i+1,j)

            lose_stay_1h(i,j) = 1;
        else
            lose_shift_1h(i,j) = 1;
        end
    end
    end
    end

    final_choice_acc = sum(accuracy(TpB,:))/NB;
    win_stay_sum  = sum(win_stay);
    win_shift_sum  =sum(win_shift);
    lose_stay_sum = sum(lose_stay);
    lose_shift_sum = sum(lose_shift);

    win_stay_sum_2h  = sum(win_stay_2h);
    win_shift_sum_2h  =sum(win_shift_2h);
    lose_stay_sum_2h = sum(lose_stay_2h);
    lose_shift_sum_2h = sum(lose_shift_2h);

    win_stay_sum_1h  = sum(win_stay_1h);
    win_shift_sum_1h  =sum(win_shift_1h);
    lose_stay_sum_1h = sum(lose_stay_1h);
    lose_shift_sum_1h = sum(lose_shift_1h);

    win_stay_sum  = sum(win_stay_sum);
    win_shift_sum  =sum(win_shift_sum);
    lose_stay_sum = sum(lose_stay_sum);
    lose_shift_sum = sum(lose_shift_sum);

    win_stay_sum_2h  = sum(win_stay_sum_2h);
    win_shift_sum_2h  =sum(win_shift_sum_2h);
    lose_stay_sum_2h = sum(lose_stay_sum_2h);
    lose_shift_sum_2h = sum(lose_shift_sum_2h);

    win_stay_sum_1h  = sum(win_stay_sum_1h);
    win_shift_sum_1h  =sum(win_shift_sum_1h);
    lose_stay_sum_1h = sum(lose_stay_sum_1h);
    lose_shift_sum_1h = sum(lose_shift_sum_1h);

    wins = sum(o_all);
    wins = sum(wins);

    wins2h = sum(o_all(9:TpB,:));
    wins2h = sum(wins2h);

    overall_accuracy = sum(sum(accuracy))/(size(accuracy,1)*size(accuracy,2));
    wins_accuracy = wins/(size(accuracy,1)*size(accuracy,2));
    accuracy_by_trial = array2table(accuracy);

    number_right = length(find(u_all == 4));
    number_left = length(find(u_all == 2));
    number_up = length(find(u_all == 3));
    if data == 1
        block_type = 'POS';
    else 
        block_type = 'NEG';
    end
    tab = table({subject}, {block_type}, {run}, win_stay_sum, ...
        win_shift_sum, lose_stay_sum, lose_shift_sum, win_stay_sum_2h, ...
        win_shift_sum_2h, lose_stay_sum_2h, lose_shift_sum_2h, win_stay_sum_1h, ...
        win_shift_sum_1h, lose_stay_sum_1h, lose_shift_sum_1h, wins, wins2h, overall_accuracy, wins_accuracy, final_choice_acc, ...
        number_right, number_left, number_up);
    
    writetable(tab, [results_dir '/' subject '_' block_type '_T' run '_MF.csv']);
    writetable(accuracy_by_trial, [results_dir '/' subject '_' block_type '_T' run '_accuracy_table.csv']);
 end