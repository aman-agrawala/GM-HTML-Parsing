% The purpose of this code is to prepare the component excel files for
% plotting. This code extracts the avg and stds for each variable plots,
% calculates the SN values, ranks and ranked averages and exports it all to
% excel.
% get_graphData.m created for HTML Parsing/Automation Project by Aman Agrawala
% 5/6
function get_graphDataL11(der,LX, SNOpt)
d=dir(fullfile(der,'*.xls'));
runNum = 0;
SignalCount = 1;
secondSignal = 0;
varFound = 0;
rankData = {};
LXSize = size(LX);
LXR = LXSize(1);
LXC = LXSize(2);
LXEmpty = 0;
currentFolder = pwd;
rankAvg = {};
warning off
sheetCount = 0;

%First we find out where the empty column is in LX
for start = 1:LXC
    if isempty(LX{1,start})
        LXEmpty = start;
    end
end

LXNums = LX(2:LXR-1,2:LXEmpty-1);
LXNumSize = size(LXNums);
LXNumR = LXNumSize(1);
LXNumC = LXNumSize(2);

% Now we find what the max value within the LX matrix will be
SingleColumnLX = cell2mat(LX(2:LXR,2:LXEmpty-1));
maxVal = max(SingleColumnLX(:));

for excel = 1:(length(d))
    [status,sheets] = xlsfinfo(fullfile(der,d(excel).name));
    numOfSheets = numel(sheets);
    for sheet = 2:numOfSheets % Start from 2 as the first sheet is always empty
        [num,txt,raw] = xlsread(fullfile(der,d(excel).name),sheet); % this will read all the data from a single sheet
        rawSize = size(raw);
        rawR = rawSize(1);
        rawC = rawSize(2);
        
        %we are trying to find out how far away the second signal is
        rowCount = 2;
        while (secondSignal == 0)
            if isequal(raw{rowCount,1},'Signal')
                secondSignal = rowCount;
            end
            rowCount = rowCount+1;
        end
        
        varNum = secondSignal - 2;
        interDataRow = 1;
        skip = 0;
        interData{1,1} = 'Start';
        maxDetected = 0;
       
       if varNum < 1
           SignalCounts = 0;
           sheetCount = 1;
           while (isequal(raw{sheetCount,1} ,'Signal'))
               SignalCounts = SignalCounts + 1;
               sheetCount = sheetCount + 1;
           end
           %for SignalCounts2 = 1:SignalCounts-1
%            interData{interDataRow,1} = 'NA';
%            interData{interDataRow,2} = 'NA';
%            interData{interDataRow,3} = 'NA';
%            interData{interDataRow,4} = ['Run Number: ', num2str(SignalCounts2)];
%            interDataRow = interDataRow + 1;
%            varFound = 0;
           %signalCounter = 1;
         %  end
        
           % now recalculate varNum
           secondSignal = 0;
           rowCount = sheetCount;
           while (secondSignal == 0)
            if isequal(raw{rowCount,1},'Signal')
                secondSignal = rowCount;
            end
            rowCount = rowCount+1;
           end
            varNum = secondSignal-sheetCount;
       %else
       end
        for varCount = 1:varNum
            if sheetCount ~= 0
                var = raw{sheetCount,1};
            else
            var = raw{varCount+1,1};
            end
            signalCounter = 0;
            for sheetRow = 1:rawR
%                 if isequal(raw{sheetRow,1},var)
%                     exists = 1;
%                 end
                  if (isequal(raw{sheetRow,1},'Signal'))
                    signalCounter = signalCounter + 1;
                    varFound = 0;
                    runNum = runNum + 1;
                    skip = 0;
                    maxDetected = 0;
                    
                    %if (isempty(interData{interDataRow-1,1}) % if we didn't have the variable then we just list the data as NA
                    if isequal(raw{sheetRow,10},'Run number: Max Error')
%                         runNum = runNum + 1 % we skip all data where the 10th column says max error
                        %skip = 1
                        signalCounter = 0;
                        maxDetected = 1;
                        interData{interDataRow,1} = 'Max Error';
                        interData{interDataRow,2} = 'Max Error';
                        interData{interDataRow,3} = 'Max Error';
                        interData{interDataRow,4} = ['Run Number: Max Error'];
                        interDataRow = interDataRow + 1;
%                         maxDetected = 0;
                    end
%                     if signalCounter >= 2 && maxDetected ~= 1
%                         interData{interDataRow,1} = 'NA';
%                         interData{interDataRow,2} = 'NA';
%                         interData{interDataRow,3} = 'NA';
%                         interData{interDataRow,4} = ['Run Number: ', num2str(runNum-1)]
%                         interDataRow = interDataRow + 1;
%                         signalCounter = 0
%                     elseif maxDetected == 1
%                         interData{interDataRow,1} = 'Max Error';
%                         interData{interDataRow,2} = 'Max Error';
%                         interData{interDataRow,3} = 'Max Error';
%                         interData{interDataRow,4} = ['Run Number: Max Error']
%                         interDataRow = interDataRow + 1;
%                         maxDetected = 0;
%                     end
                    
                elseif (isequal(raw{sheetRow,1},var) && maxDetected == 0)
                    varFound = 1;
                    interData{interDataRow,1} = raw{sheetRow,1};
                    interData{interDataRow,2} = raw{sheetRow,2};
                    interData{interDataRow,3} = raw{sheetRow,4};
                    interData{interDataRow,4} = ['Run Number: ', num2str(runNum)];
                    interDataRow = interDataRow + 1;
                    signalCounter = 0;
                   % interData{interDataRow,1} = [];
                end
                   if ((varFound == 0 && signalCounter >= 2) && maxDetected == 0)
                    interData{interDataRow,1} = 'NA';
                    interData{interDataRow,2} = 'NA';
                    interData{interDataRow,3} = 'NA';
                    interData{interDataRow,4} = ['Run Number: ', num2str(runNum-1)];
                    interDataRow = interDataRow + 1;
                    varFound = 0;
                    signalCounter = 1;
                   end
            end
            
            %added by Garrett
            if signalCounter == 1 && varFound ==0 && maxDetected == 0
                interData{interDataRow,1} = 'NA';
                interData{interDataRow,2} = 'NA';
                interData{interDataRow,3} = 'NA';
                interData{interDataRow,4} = ['Run Number: ', num2str(runNum-1)];
                interDataRow = interDataRow + 1;
            end
            
            %Now we remove the Max Error Portions
            interSize = size(interData);
            interR = interSize(1);
            interC = interSize(2);
            
            interRemove = interData(1,1:interC);
            interRemove = [interRemove;interData(3:interR,1:interC)];
            
            interData = interRemove;
            interSize = size(interData);
            interR = interSize(1);
            interC = interSize(2);
            
            
            for interRows = 1:interR % Construct the column of SN values
                if(~ischar(interData{interRows,2}))
                    interData{interRows,5} = 10*log10((abs(interData{interRows,2}^2))/(abs(interData{interRows,3})^4));
                else
                    interData{interRows,5} = 0; %if there is a character anywhere in that row then the SN value should be 0
                end
            end
            
            % Now we construct the data 
            for rankCol = 2:LXEmpty-1 %First we constrict the first row of variables
                rankData{1,rankCol} = LX{1,rankCol};
            end
            
            % Now we will construct the first column of increments
            for LXCol = 1:maxVal
                rankData{LXCol+1,1}=LXCol;
            end
            
            rankSize = size(rankData);
            rankRows = rankSize(1);
            rankCols = rankSize(2);
            
            %Now we will fill in the middle portions
            sumif = 0;
            sumCount = 0;
            
            excel;
            varCount;
            
           
            for rankC = 2:LXEmpty-1
                for rankR = 2:rankRows
                    for LXRows = 1:LXNumR
                        if(LXNums{LXRows,rankC-1} == rankData{rankR,1})
                            d(excel).name;
                            sheet;
                            LXRows;
                            rankR;
                            rankC;
                            sumif = sumif + (interData{LXRows,5});
                            if(interData{LXRows,5} ~= 0)
                                sumCount = sumCount+1;
                            end
                        end
                    end
                    rankData{rankR,rankC} = sumif/sumCount;
                    if (isnan(rankData{rankR,rankC}))
                        rankData{rankR,rankC} = 0;
                    end
                    sumif = 0;
                    sumCount = 0;
                end                           
            end
            
            %Now we calculate the final Rank Data
            rankData{rankRows+1,1} = 'Rank';
            for rankC = 2:rankCols
                rankData{rankRows+1,rankC} = max(cell2mat(rankData(2:rankRows,rankC)))-min(cell2mat(rankData(2:rankRows,rankC)));
            end
            
            
            %
            % Now we construct the data 
            for rankCol = 2:LXEmpty-1 %First we constrict the first row of variables
                rankAvg{1,rankCol} = LX{1,rankCol};
            end
                      
            % Now we will construct the first column of increments
            for LXCol = 1:maxVal
                rankAvg{LXCol+1,1}=LXCol;
            end
            
            AvgSize = size(rankAvg);
            AvgRows = AvgSize(1);
            AvgCols = AvgSize(2);
            
            %Now we will fill in the middle portions
            sumif = 0;
            sumCount = 0;
            
            excel;
            varCount;
            
            for rankC = 2:LXEmpty-1
                for rankR = 2:rankRows
                    for LXRows = 1:LXNumR
                        %for LXCol = 2:LXNumC
                            if(LXNums{LXRows,rankC-1} == rankAvg{rankR,1})
                                if (isequal(interData{LXRows,2},'NA'))
                                    sumif = sumif + 0;
                                else
                                    sumif = sumif + (interData{LXRows,2});
                                end
                                if(interData{LXRows,5} ~= 0)
                                    sumCount = sumCount+1;
                                end
                            end

                       % end
                    end
                    rankAvg{rankR,rankC} = sumif/sumCount;
                    if (isnan(rankAvg{rankR,rankC}))
                        rankAvg{rankR,rankC} = 0;
                    end
                    sumif = 0;
                    sumCount = 0;
                end                           
            end
           
            %Now we calculate the final Rank Data
            rankAvg{rankRows+1,1} = 'Rank';
            for rankC = 2:rankCols
                rankAvg{rankRows+1,rankC} = max(cell2mat(rankAvg(2:rankRows,rankC)))-min(cell2mat(rankAvg(2:rankRows,rankC)));
            end
            
            
            %Now we export to an excel file for each variable to its own
            %folder
           
            var = strrep(var,'[','');
            var = strrep(var,']','');
            
            mkdir('Final Html Calcs',var);
            xlswrite(fullfile(currentFolder,'Final Html Calcs',var,[var,'__',d(excel).name(1:length(d(excel).name)-4),'_!']),interData,['SN Calcs']);
            [~,computer] = system('hostname');
            [~,user] = system('whoami');
            [~,alltask] = system(['tasklist /S ', computer, ' /U ', user]);
            excelPID = regexp(alltask,'EXCEL.EXE\s*(\d+)\s', 'tokens');
            for i = 1:length(excelPID)
                killPID = cell2mat(excelPID{i});
                system(['taskkill /f /pid ', killPID]);
            end
            xlswrite(fullfile(currentFolder,'Final Html Calcs',var,[var,'__',d(excel).name(1:length(d(excel).name)-4),'_!']),rankAvg,['Avg Calcs']);
            [~,computer] = system('hostname');
            [~,user] = system('whoami');
            [~,alltask] = system(['tasklist /S ', computer, ' /U ', user]);
            excelPID = regexp(alltask,'EXCEL.EXE\s*(\d+)\s', 'tokens');
            for i = 1:length(excelPID)
                killPID = cell2mat(excelPID{i});
                system(['taskkill /f /pid ', killPID]);
            end
            xlswrite(fullfile(currentFolder,'Final Html Calcs',var,[var,'__',d(excel).name(1:length(d(excel).name)-4),'_!']),rankData,['Rank Calcs']);
            [~,computer] = system('hostname');
            [~,user] = system('whoami');
            [~,alltask] = system(['tasklist /S ', computer, ' /U ', user]);
            excelPID = regexp(alltask,'EXCEL.EXE\s*(\d+)\s', 'tokens');
            for i = 1:length(excelPID)
                killPID = cell2mat(excelPID{i});
                system(['taskkill /f /pid ', killPID]);
            end
            
            %Reset all variables for the next variable
            interData = {};
            interData{1,1} = 'Start';
            interDataRow = 1;
            rankData = {};
            secondSignal = 0;
            runNum = 0;
            rankAvg = {};
            sheetCount = 0;
        end
      % end
        end
end
    'get_graphData = Done'
    warning on
end

