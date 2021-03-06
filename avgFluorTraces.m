% function avgFluorTraces

% For each protocol, find trials that have the same tag and plot the
% average of these trials
%
clear all
close all

ColorSet = varycolor(4);

traceStruct = struct;

% traceStruct = struct('channelOne',{},'channelTwo',{});
folder = 'C:\Users\Alex\Documents\Data\CalciumImagingData\B1\150511\150511_F2_C1';
% folder = uigetdir;
cd(folder)

rawfiles = dir(['*_Raw_*.mat']);
protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

for p = 1%:length(protocols)
    
    % Find out tag for each trial
    rawfiles = dir([protocols{p} '*_Raw_*']);
    for i = 1:length(rawfiles)
        trialNumStr = regexp(rawfiles(i).name,'(?<=_)\d*(?=.mat)','match');
        trialNums(i) = str2num(char(trialNumStr));
        [~,IX] = sort(trialNums);
    end
    for n = IX
        data = load(rawfiles(n).name);
        tagArray{n} = data.tags{1};
    end
    
    % Find unique tags
    [uniqueTags, ia, ic] = unique(tagArray);
    for m = 1:length(uniqueTags)
        idx = find(ic == m);
        for q = 1:length(idx)
            qS = idx(q);
            data = load(rawfiles(qS).name);
            if q == 1
                traceStruct(p).tag(m).tag = uniqueTags(m);
                traceStruct(p).tag(m).channelOne = [];
                traceStruct(p).tag(m).channelTwo = [];
                traceStruct(p).tag(m).block = [];
            end
            try
                if isfield(data,'roiScimStackTrace')
                    traceStruct(p).tag(m).channelOne(end+1,:) = data.roiScimStackTrace(:,1)';
                    traceStruct(p).tag(m).channelTwo(end+1,:) = data.roiScimStackTrace(:,2)';
                    traceStruct(p).tag(m).block(end+1) = data.params.trialBlock; 
                    figure(m)
                    subplot(10,2,q)
                    plot(data.roiScimStackTrace(:,2),'--')
                    title(['trial ',num2str(qS)])
                    spaceplots
                    ylim([50 150])
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
        
        %         figure(m)
        %         subplot(2,1,1)
        %         plot(traceStruct(p).tag(m).channelOne','--','Color', ColorSet(m,:))
        %         hold on
        %         plot(mean(traceStruct(p).tag(m).channelOne),'k--')
        %         hold on
        %         subplot(2,1,2)
        %         plot(traceStruct(p).tag(m).channelTwo','Color', ColorSet(m,:))
        %         hold on
        %         plot(mean(traceStruct(p).tag(m).channelTwo),'k')
        %         title(uniqueTags(m))
    end
    
    legend(uniqueTags)
    
    clearvars -except traceStruct protocols ColorSet
end






%     figure()
%     plot(nanmean(channelOneMat(tagTrials,:)),'r');
%     hold on
%     plot(nanmean(channelTwoMat(tagTrials,:)),'g');
