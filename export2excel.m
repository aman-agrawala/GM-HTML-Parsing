% The purpose of this code is to take the data created form analyze.m and
% output a Raw Html version of it along with excel docs separated for each
% component of interest for each profile. 
% export2excel.m created for HTML Parsing/Automation Project by Aman Agrawala
% 4/6
function excel = export2excel(der,excelData,filename,comps)
dimensions = size(excelData);
row = dimensions(1);
col = dimensions(2);
relevant = {};
specData = {};
export = 0;
excelRowStart = 1;
currentFolder = pwd;

%Need to define a flexible procedure for deciding this
filename = 'HTML_RawData';
mkdir(filename)

% This code will create a Raw Excel Data folder
for n=1:row 
    sheetname = excelData{1,n}(1:length(excelData{1,n})-4); % the name of the specific sheet, unfortunately we can only select the first 31 characters
    xlswrite(fullfile(currentFolder,filename),excelData{2,n},sheetname,'A1');
end

%Now we will create excel files for the specific compnent inputs
sizeComps = size(comps);
rComps = sizeComps(1);
cComps = sizeComps(2);

for k = 1:rComps % this loop goes through the rows of comps
    name = comps{k,1};
    for t = 1:length(comps{k,2}) % this loop goes through the columns of the cells embedded in the second column of comps
        var = comps{k,2}{1,t}; %this selects the variable that we will be looking for through every iteration of the loop
        for q = 1:col % this for loop goes through the columns of excelData
            htmlDataFile = excelData{1,q}; %sets the html file name
            dataSize = size(excelData{2,q});
            dataRow = dataSize(1);
            dataCol = dataSize(2);
            rowLocation = 1;
            for e = 1:dataRow %this loop goes line by line through our data looking for the data corresponding to the name in htmlDataFile
                if isequal(excelData{2,q}{e,1},'Signal')
                    for x = 1:dataCol 
                        relevant{rowLocation,x} = excelData{2,q}{e,x};
                    end
                    rowLocation = rowLocation + 1;
                else ~isempty(strfind(excelData{2,q}{e,1},var)); % this checks if the name in excelData contains the variable name as well
                    if(isequal('DaBSER_cmp_BatStCov',var)); % if we are looking at DaBSER_cmp_BatStCov then we only want the diagonal values
                        o = [1,10,19,28,37,46,55,64]; % this are the diagonal values
                        for oloop = 1:length(o) % this loops through all the diagonal o values
                            if isequal(excelData{2,q}{e,1},['DaBSER_cmp_BatStCov[', num2str(o(oloop)), ']']);
                                relevant{rowLocation,1} = excelData{2,q}{e,1};
                                export = 1;
                                for y = 2:dataCol % this loop goes line by line through our data and extracts numerical data to relevant
                                    relevant{rowLocation,y} = excelData{2,q}{e,y};
                                    export = 1;
                                end
                                rowLocation = rowLocation + 1;
                            end
                        end
                    elseif ~isempty(strfind(excelData{2,q}{e,1},var));
                            relevant{rowLocation,1} = excelData{2,q}{e,1};
                            export = 1;
                            for y = 2:dataCol % this loop goes line by line through our data and extracts numerical data to relevant
                                relevant{rowLocation,y} = excelData{2,q}{e,y};
                                export = 1;
                            end
                            rowLocation = rowLocation + 1;
                    end
                end
            end
%             specData = [specData;relevant];
                if (export)                    
                    xlswrite(fullfile(der,[name,'_(',htmlDataFile(1:length(htmlDataFile)-4),'.xls']),relevant,var,'A1');
%                     excelSize = size(relevant);
%                     excelRow = excelSize(1);
%                     excelRowStart = excelRow + excelRowStart;
                    relevant = {};
                    rowNum = 1;
                    export = 0;
                    % ['A',num2str(excelRowStart)]
                end
            end
            
    end
end
excel = 'Done'
    