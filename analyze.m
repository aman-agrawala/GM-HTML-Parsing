% The purpose of this code is to access the tab delimited html code and
% find all the relevant information within the html code. It will output
% this data in its final form called finalData. analyze.m created fr 
% analyze.m created for HTML Parsing/Automation Project by Aman Agrawala
% This code is for L11 matricies.
% 3/6
function finalData = analyze(data,filename)
sizeD = size(data);
row = sizeD(1);
col = sizeD(2);
%rloc = 1; % remembers the location of the row you are on
%runNum = 1;
finalData = {};


%First we add the file names to finalData
for l = 1:length(filename)
    finalData{l} = filename{l};
end

for n = 1:col %go through all files
    val = data(n).n{1,1};
    runNum = 1;  % remembers what run you are looking at
    rloc = 1;% remembers the location of the row you are on
    for k = 1:length(val) %goes line by line through the html code
        if ~ isempty(val{k})
            
        if val{k}(1:4) == '<tr>' %checks to see if the html code is talking about a data table
%             while true %splits up the html line based on < and > so that you get everything between < and >
%                 remain =  val{k}
%                 [str,remain] = strtok(remain,'<>')
%                 if isempty(str)
%                       break;
%                 end
%                 code = vertcat(code,str)    %vertically combine all html code         
%             end
            str = val{k};
            nameStart = strfind(str, '<td class="failed">');
            % nameEnd = strfind(str,b'</td>') Same as close variable
            open = strfind(str,'<td>');
            close = strfind(str,'</td>');
            if isempty(nameStart) % If nameStart is empty than we are looking at the first row of the table
                for l = 1:length(open)% Fill out the first row of the table
                    excelData{rloc,l} = val{k}(open(l)+4:close(l)-1); % Puts the column names where they belong
                    nameStart = []; %Clear out namestart for the next iteration of the overarching for loop
                end
%                 if(runNum ~= 2)
                    excelData{rloc,l+1} = ['Run number: ', int2str(runNum)];
                    rloc = rloc + 1;
                    runNum = runNum + 1;
%                 else
%                     excelData{rloc,l+1} = ['Run number: Max Error'];
%                     rloc = rloc + 1;
%                     runNum = runNum + 1;
%                 end
            else
                open = [nameStart(1),open]; % Combine nameStart with open
                %for r = 2:length(open) % counts the row you are on
                    for c = 1:length(close) %counts the column you are on
                       if c == 1
                            excelData{rloc,c} = val{k}(open(1)+19:close(1)-1);%First put the name under signal column temporarily
                            Start = regexp(excelData{rloc,c},'">');
                            End = regexp(excelData{rloc,c},'</a>');
                            excelData{rloc,c} = excelData{rloc,c}(Start+2:End-1);
                            
                        else
                            excelData{rloc,c} = val{k}(open(c)+4:close(c)-1); %next we capture the data in the remaning columns
                        end
                    end
                % end            
            rloc = rloc+1;
        
            
            end
        end
        end
    end
   finalData{2,n} = excelData; %add data to the finalData as a cell matrix. Thus the filename is associated with its data.
   clear excelData %delete all old excelData because we are now going to go and parse a new html file so we don't want old data corrupting our memory or taking up unneccessary amount of memory.
end

end
%xmlread