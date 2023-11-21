% CAL, 2023
root='L:/';
addpath([root 'rsmith/lab-members/clavalley/MATLAB/spm12/toolbox/DEM/'])
addpath([root 'rsmith/lab-members/clavalley/MATLAB/spm12/'])
addpath([root 'rsmith/lab-members/clavalley/MATLAB/Cooperation/'])


FIT_SUBJECT = 'A1EX0MEOPF8AHT';   % Subject ID
INPUT_DIRECTORY = [root 'rsmith/lab-members/clavalley/studies/development/wellbeing/cooperation/round3mturk/CB1/'];  % Where the subject file is located
run = '1';

[subdat, cb] = Coop_parse_file(FIT_SUBJECT, INPUT_DIRECTORY, run);
subject = FIT_SUBJECT;

for pnb=1:length(subdat)
    data = subdat{pnb};
    fit_results = Coop_fit(subject, data);
        
        avg_action_prob = [];
        model_percent_acc = [];
        for i=1:size(fit_results{1,5},1)
            bandit_choice = fit_results{1,5}(i).u;
            avg_action_prob = [avg_action_prob fit_results{1,5}(i).P(bandit_choice)];
        
            max_prob = find(ismember(fit_results{1,5}(i).P, max(fit_results{1,5}(i).P)));
            if mod(i,16) ==1
                continue
            elseif bandit_choice == max_prob
               model_percent_acc = [model_percent_acc 1];
            else
                model_percent_acc = [model_percent_acc 0];
            end
        
        end
        avg_action_prob = sum(avg_action_prob)/size(fit_results{1,5},1);
        model_percent_acc = sum(model_percent_acc)/length(model_percent_acc);

    fprintf('Fit: \n\tAlpha =\t%.3f\n\tCR =\t%.3f\n\tEta Win =\t%.3f\n\tEta Loss =\t%.3f\n\tPrior A =\t%.3f\n\tF =\t%.3f\n\tAverage Action Prob =\t%.3f\n\tModel Accuracy =\t%.3f\n', ...
        fit_results{3}(1), fit_results{3}(2), fit_results{3}(3), fit_results{3}(4), fit_results{3}(5), fit_results{1,4}.F, avg_action_prob, model_percent_acc);
end