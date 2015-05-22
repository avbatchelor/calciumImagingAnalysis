function generateROIsAllTrials

set(0,'DefaultFigureWindowStyle','normal')
% folder = 'C:\Users\Alex\Documents\Data\CalciumImagingData\B1\150511\150511_F2_C1';
folder = uigetdir;
cd(folder)

rawfiles = dir(['*_Raw_*.mat']);
protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

for p = 1:length(protocols)
    
    % load files
    rawfiles = dir([protocols{p} '*_Raw_*']);
    for i = 1:length(rawfiles)
        trialNumStr = regexp(rawfiles(i).name,'(?<=_)\d*(?=.mat)','match');
        trialNums(i) = str2num(char(trialNumStr));
        [~,IX] = sort(trialNums);
    end
    for n = IX
        fprintf(['Processing protocol ',protocols{p},', trial ',num2str(trialNums(n)),'\n'])
        try
            data = load(rawfiles(n).name);
            if trialNums(n) == 1 || data.params.trialBlock ~= prevTrialBlock
                Masks = scimStackROI(data,data.params);
            else
                scimStackROI(data,data.params,'NewROI','No','Masks',Masks,'MakeMovie',false,'PlotFlag',true);
            end
        catch err 
            if (strcmp(err.message,'No Camera Input: Exiting scimStackROI routine'))
                fprintf(['No camera input for trial ',num2str(data.params.trial),'\n']);
            else 
               fprintf('Some other error\n')
            end
        end % end try/catch
        prevTrialBlock = data.params.trialBlock;
    end
end





% createDataFileFromRaw(folder);
%
% data = load('SpeakerChirp_Raw_150511_F2_C1_60.mat');
% scimStackROI(data,data.params)
%
% data = load('SpeakerChirp_Raw_150511_F2_C1_31.mat');
% scimStackROIBatch(data,data.params)