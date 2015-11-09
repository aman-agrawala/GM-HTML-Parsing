% The purpose of this code is to open the html txt files and tab delimite
% the data such that html code with no tabs will be in the first column,
% html code with 1 tab will be in the second column, etc. 
% opentxt.m created for HTML Parsing/Automation Project by Aman Agrawala
% 2/6
function [data,filename] = opentxt(der)
    d =dir(fullfile(der,'*.txt'));
    sizeD = size(d);
    row = sizeD(1);
    formatSpec = '%*s%*s%*s%*s%s%[^\n\r]';
    data = struct;
    filename = {};
    for n = 1:row
        fileID = fopen(fullfile(der,d(n).name));
        filename{n} = [d(n).name];
        data(n).n = textscan(fileID,formatSpec,'Delimiter','\t');
        fclose(fileID);
    end
end