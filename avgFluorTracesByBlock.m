function avgFluorTracesByBlock

% For each protocol, find trials that have the same tag and plot the
% average of these trials
%
clear all
close all

set(0,'DefaultFigureWindowStyle','docked')

ColorSet = varycolor(4);

traceStruct = struct;

% traceStruct = struct('channelOne',{},'channelTwo',{});
%folder = 'C:\Users\Alex\Documents\Data\CalciumImagingData\B1\150511\150511_F2_C1';
folder = uigetdir;
cd(folder)

rawfiles = dir(['*_Raw_*.mat']);
protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

for p = 1:length(protocols)
    
    % Find out tag for each trial
    rawfiles = dir([protocols{p} '*_Raw_*']);
    for i = 1:length(rawfiles)
        trialNumStr = regexp(rawfiles(i).name,'(?<=_)\d*(?=.mat)','match');
        trialNums(i) = str2num(char(trialNumStr));
        [~,IX] = sort(trialNums);
    end
    for n = IX
        data = load(rawfiles(n).name);
        loadedTrialNum = data.params.trial;
        trialArray(loadedTrialNum) = data.params.trial;
        blockArray(loadedTrialNum) = data.params.trialBlock;
    end
    
    % Find unique blocks
    [uniqueBlocks, ia, ic] = unique(blockArray);
    for m = 1:length(uniqueBlocks)
        idx = find(ic == m);
        for q = 1:length(idx)
            qS = idx(q);
            data = load(rawfiles(qS).name);
            if q == 1
                traceStruct(p).block(m).block = uniqueBlocks(m);
                traceStruct(p).block(m).channelOne = [];
                traceStruct(p).block(m).channelTwo = [];
            end
            try
                if isfield(data,'roiScimStackTrace')
                    traceStruct(p).block(m).channelOne(end+1,:) = data.roiScimStackTrace(:,1)';
                    traceStruct(p).block(m).channelTwo(end+1,:) = data.roiScimStackTrace(:,2)';

                end
            catch err
                fprintf(['Processing ',rawfiles(qS).name,'\n'])
                fprintf([err.message,'\n']);
            end
            
            %             elseif ~exist('tag(m).channelOne(q,:)','var')
            %                 tag(m).channelOne(q,:) = [];
            %                 tag(m).channelTwo(q,:) = [];
            %             else
            %                 tag(m).channelOne(q,:) = NaN(1,length(tag(m).channelOne));
            %                 tag(m).channelTwo(q,:) = NaN(1,length(tag(m).channelOne));
            
            
        end
        %         figure(p)
        %         subplot(2,1,1)
        %         plot(mean(traceStruct(p).tag(m).channelOne),'--','Color', ColorSet(m,:))
        %         hold on
        %         subplot(2,1,2)
        %         plot(mean(traceStruct(p).tag(m).channelTwo),'Color', ColorSet(m,:))
        %         hold on
        
                figure(m)
                subplot(2,1,1)
                plot(traceStruct(p).block(m).channelOne','--')
                hold on
                plot(mean(traceStruct(p).block(m).channelOne),'k--','LineWidth',3)
                hold on
                subplot(2,1,2)
                plot(traceStruct(p).block(m).channelTwo')
                hold on
                plot(mean(traceStruct(p).block(m).channelTwo),'k','LineWidth',3)
                suptitle(['Block ',num2str(uniqueBlocks(m))])
               
                legend(strsplit(num2str(1:qS)));
                
    end
    
%     legend(uniqueBlocks)
    
    clearvars -except traceStruct protocols ColorSet
end






%     figure()
%     plot(nanmean(channelOneMat(tagTrials,:)),'r');
%     hold on
%     plot(nanmean(channelTwoMat(tagTrials,:)),'g');
