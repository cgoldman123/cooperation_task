% Claire Lavalley, 2023 (based off SMT scripts)
if ispc
    root = 'L:/';
elseif isunix
    root = '/media/labs/';
end

addpath([root 'rsmith/all-studies/core/spm12']);
addpath([root 'rsmith/all-studies/core/spm12/toolbox/DEM']);
addpath([root 'rsmith/lab-members/clavalley/MATLAB/Cooperation']);

subject = getenv('SUBJECT');   % Subject ID
input_directory = getenv('INPUT_DIRECTORY'); % NPC/DataSink/StimTool_Online/WBMTURK_Cooperation_Task[ 2 3]
res_dir = getenv('RESULTS');
run = getenv('RUN');

[subdat, cb] = Coop_parse_file(subject, input_directory, run);

for pnb=1:length(subdat)
 data = subdat{pnb};
 fit_results = Coop_fit(subject, data);

 alpha       = fit_results{3}(1);
 cr          = fit_results{3}(2);
 eta_win     = fit_results{3}(3);
 eta_loss    = fit_results{3}(4);
 prior_a     = fit_results{3}(5);
 F           = fit_results{1,4}.F;

        avg_action_prob = [];
        model_percent_acc = [];
        for i=1:size(fit_results{1,5},1)
            bandit_choice = fit_results{1,5}(i).u;
            avg_action_prob = [avg_action_prob fit_results{1,5}(i).P(bandit_choice)];
        
            max_prob = find(ismember(fit_results{1,5}(i).P, max(fit_results{1,5}(i).P)));
            if fit_results{1,5}(i).P(2)~=fit_results{1,5}(i).P(3) && fit_results{1,5}(i).P(3)~=fit_results{1,5}(i).P(4) && sum(bandit_choice == max_prob)==1
                model_percent_acc = [model_percent_acc 1];
            elseif fit_results{1,5}(i).P(2)==fit_results{1,5}(i).P(3) && fit_results{1,5}(i).P(3)==fit_results{1,5}(i).P(4)
                continue
            else
                model_percent_acc = [model_percent_acc 0];
            end
        
        end
        avg_action_prob = sum(avg_action_prob)/size(fit_results{1,5},1);
        model_percent_acc = sum(model_percent_acc)/size(fit_results{1,5},1);
    if pnb==1
        block_type = 'POS';
    else 
        block_type = 'NEG';
    end
    
 params      = table({subject}, {block_type}, {run}, {cb}, alpha, cr, eta_win, eta_loss, prior_a, F, avg_action_prob, model_percent_acc);
 if pnb==1
    save([res_dir '/output_POS_' subject '_T' run], 'fit_results');
    writetable(params, [res_dir '/fit_POS_' subject '_T' run '.csv']);
 else
    save([res_dir '/output_NEG_' subject '_' run], 'fit_results');
    writetable(params, [res_dir '/fit_NEG_' subject '_T' run '.csv']);
 end

 fprintf('Fit: \n\tAlpha =\t%.3f\n\tCR =\t%.3f\n\tEta Win =\t%.3f\n\tEta Loss =\t%.3f\n\tPrior A =\t%.3f\n\tF =\t%.3f\n\tAverage Action Prob =\t%.3f\n\tModel Accuracy =\t%.3f\n', ...
        fit_results{3}(1), fit_results{3}(2), fit_results{3}(3), fit_results{3}(4), fit_results{3}(5), fit_results{1,4}.F, avg_action_prob, model_percent_acc);
end