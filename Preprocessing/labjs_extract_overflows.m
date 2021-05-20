%MATLAB code for reading/parsing the labjs style qualtrics data

% The best way to export it from qualtrics is by using the XML output

% 1. Read in the XML. For some reason the standard xml2struct function
% doesn't work well, so it is better to use this: https://uk.mathworks.com/matlabcentral/fileexchange/28518-xml2struct

    datastruct=xml2struct('ACC3 - Animacy and carriers_May 10, 2021_05.20.xml');

% 2. Each response is stored in a sub-structure within the datastruct
% variable. The labjs data needs to be parsed further to extract the data
% from the JSON format.
 
    % datastruct.Responses.Response{1}; % the response data for first subject

    nResponses = length(datastruct.Responses.Response);

    % loop through each response, using the core MATLAB function to extract
    % the JSON data
    for i=1:nResponses
        
        % the name of the data field depends on embedded data in qualtrics
        trialdata=datastruct.Responses.Response{i}.labjsu_data;
        o1=datastruct.Responses.Response{i}.overflow1;
        o2=datastruct.Responses.Response{i}.overflow2;
        o3=datastruct.Responses.Response{i}.overflow3;
        o4=datastruct.Responses.Response{i}.overflow4;
        
        %now get the overflows as well
        
        Alltext = [trialdata.Text,o1.Text,o2.Text,o3.Text,o4.Text];
        
        % parse it
        % this will give a cell array of the trials from labjs
        
        parseddata=jsondecode(Alltext);
        
        
        % store it in the original struct %this is oldversion
        %datastruct.Responses.Response{i}.trialdata = parseddata;
        datastruct.Responses.Response{i}.Alltext = parseddata;
       
        
        
    end
    
% 3. Output a new data file which lists the trial data for each response.
% This needs to list the participant, then the results for each trial. You
% could output all the qualtrics variable here too.

    % output an easier-to-read text file
    fid=fopen('ACC3_dataformatted.txt','w');
    
    % write the column headings, which depend on the labjs data recorded
    h={'subindex';'recordId';'eventindex'};
    %oldcode
    %f=cellfun(@fieldnames,datastruct.Responses.Response{1}.trialdata,'UniformOutput',false);
    
    f=cellfun(@fieldnames,datastruct.Responses.Response{1}.Alltext,'UniformOutput',false);
    f=vertcat(f{:});
    h=[h;unique(f)];
    fprintf(fid,'%s\t',h{:});
    fprintf(fid,'\n');
    
    % for each response and trial, write the data, making sure to handle
    % different data types properly
    for i=1:nResponses
        
        for t=1:length(datastruct.Responses.Response{i}.Alltext) %originally it was trialdata instead of Alltext
            
            fprintf(fid,'%i\t',i);
            fprintf(fid,'%s\t',datastruct.Responses.Response{i}.u_recordId.Text);
            fprintf(fid,'%i\t',t);
            
            for f=4:length(h)
                %get the data if possible (some fields wont be present for
                %every event
                if isfield(datastruct.Responses.Response{i}.Alltext{t},h{f}) %originally these were trialdata instead of Alltext
                    x=datastruct.Responses.Response{i}.Alltext{t}.(h{f});
                    
                    if isnumeric(x)
                        fprintf(fid,'%i\t',x);
                    elseif ischar(x)
                        fprintf(fid,'%s\t',x);
                    else
                        fprintf(fid,'%s\t','.'); %missing data
                    end                    
                else
                    fprintf(fid,'%s\t','.'); %missing data
                end
                    
                
            end
            fprintf(fid,'\n');
         
        end
        
    end

    %close the file
    fclose(fid);
