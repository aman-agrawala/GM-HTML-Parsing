% The purpose of this function is to make a backup copy of all of our html
% files. Then convert the originals to txt
% html2txt.m created for HTML Parsing/Automation Project by Aman Agrawala
% 1/6

function html2txt(der,comps)

copyfile(fullfile(der,'*.html'), fullfile(der,'HTML Copy')) % Make a copy of your html files

% now we convert all html files to txt files
d =dir(fullfile(der,'*.html'));
for k = 1:length(d)
    fname = d(k).name;
    [pathstr,name,ext] = fileparts(fname); %pathstr is the path name, name is the file name, ext is the extension of the file
    movefile(fullfile(der,fname),fullfile(der,[name,'.txt']));
end
