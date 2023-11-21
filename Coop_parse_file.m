function [subdat, cb] = Coop_parse_file(subject, data_dir, run)
directory=dir([data_dir 'cooperation_task_*' '_T' run '_*']);

    good = [];
     for i=1:size(directory,1)
         if contains(directory(i).name, subject)
            good = [good i];
         end
     end
    
     if isempty(good)
         fprintf('Error in directory');
         return            
     end
    
     good_files={};
     dates={};
     for j=1:length(good)
        raw = readtable([data_dir directory(good(j),:).name], 'Format', 'auto');
        dates{end+1} = directory(good(j),:).date;
        for k=1:size(raw,1)
            if contains(raw.trial(k), 'BLOCK')
                raw.trial(k) = extractAfter(raw.trial(k), 'BLOCK=');
            end
        end
       raw.trial = str2double(raw.trial);
       if max(raw(raw.event_type==3,:).absolute_time) < 400
           fprintf('File too short')
            continue
       else 
           good_files{end+1}=raw;
       end
     end
    
    % Make sure runs are in the right order --
    if ~isempty(good_files)
        if length(good_files)==1
            runs_order = [1];
        else
            if sum(contains(good_files{1}.trial_type,"PRAC")) > 0
                runs_order = [1 2];
            else
                runs_order = [2 1];
            end
        end
    else
        return
    end
    
    good_files = good_files(runs_order);
    pos_blocks={};
    neg_blocks={};
    for j=1:length(good_files)
        start = max(find(ismember(good_files{j}.trial_type,'MAIN')))+1;
        good_files{j} = good_files{j}(start:end,:);

        ps = find(ismember(good_files{j}.result,'pleasant'))+2;
        ns = find(ismember(good_files{j}.result,'unpleasant'))+2;
        starts = [ps,ns];

        block1 = good_files{j}(min(starts):max(starts)-3,:);
        block2 = good_files{j}(max(starts):end,:);

        if ps < ns
            pos_blocks{end+1}=block1;
            neg_blocks{end+1}=block2;
            cb='1';
        else
            pos_blocks{end+1}=block2;
            neg_blocks{end+1}=block1;   
            cb='2';
        end
    
    end
    if length(good_files) > 1
        subdat_p = vertcat(pos_blocks{1}, pos_blocks{2});
        subdat_n = vertcat(neg_blocks{1}, neg_blocks{2});
    else
        subdat_p = pos_blocks{1};
        subdat_n = neg_blocks{1};
    end
    
    for blocks=1:2
      data = {subdat_p, subdat_n};
      data = data{blocks};

      data.response = strrep(data.response, "left", "1");
      data.response = strrep(data.response, "up", "2");
      data.response = strrep(data.response, "right", "3");
      data.trial_type = extractAfter(data.trial_type, "16_");

      if blocks == 1
        data.result = strrep(data.result, "positive", "1");
        data.result = strrep(data.result, "neutral", "0");
        subdat_p = data;
      elseif blocks == 2
        data.result = strrep(data.result, "neutral", "1");
        data.result = strrep(data.result, "negative", "0");
        subdat_n = data;
      end    
    end
subdat = {subdat_p, subdat_n}; 

end