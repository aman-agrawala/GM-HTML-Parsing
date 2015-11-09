% The purpose of this code is to plot the rank data from the get_graphData
% excel files and save it in a folder. 
% get_graphs.m created for HTML Parsing/Automation Project by Aman Agrawala
% 6/6
function done = get_graphs(der)
currentFolder = pwd;
warning off
folders = dir([currentFolder,'\Final Html Calcs']);
folders = folders(3:length(folders));
x = [];
y = [];
legendNames = {};
mkdir(fullfile(currentFolder,'Final Graphs'))
close all
set(0,'DefaulttextInterpreter','none')

for folderCount = 1:length(folders)
    folderDirectory = fullfile(currentFolder,'Final Html Calcs',folders(folderCount).name);
    excelDocs = dir(folderDirectory);
    excelDocs = excelDocs(3:length(excelDocs));
    for excelCount = 1:length(excelDocs)
        [status,sheets] = xlsfinfo(fullfile(folderDirectory,excelDocs(excelCount).name));
        [num,txt,raw] = xlsread(fullfile(folderDirectory,excelDocs(excelCount).name),'Rank Calcs');
        RawSize = size(raw);
        RawR = RawSize(1);
        RawC = RawSize(2);
                       
        for rawColCount = 2:RawC
            y(rawColCount-1,excelCount) = raw{5,rawColCount};
            x = [x,{raw{1,rawColCount}}];
            %x(1,rawColCount-1) = raw{1,rawColCount}
        end
        legStart = regexp(excelDocs(excelCount).name,'_(');
        legEnd = regexp(excelDocs(excelCount).name,'_!');
        legendNames{1,excelCount} = excelDocs(excelCount).name(legStart+2:legEnd-1);        
    end
        for lCount = 1:length(legendNames)
            legendNames{1,lCount} = strrep(legendNames{1,lCount},'_',' ');
        end
%     figure
%     hold on
      X = unique(x,'stable');
      
      
      hold on;
      x0=2;y0=2;width=12;height=5;
      set(gcf,'units','inches','position',[x0,y0,width,height]);
      YSize = size(y);
      YR = YSize(1);
      YC = YSize(2);
      bar(y);
      set(gca,'XTick',1:length(X),'XTickLabel',X); 
      legend(legendNames,'Location','eastoutside','Orientation','vertical');
      
      ylabel('Rank')
      xlabel('Parameters')
      title(folders(folderCount).name)
      save_name = strcat(fullfile(currentFolder,'Final Graphs',folders(folderCount).name),'.fig');
      savefig(save_name);
      close all
      
      hold on;
      x0=2;y0=2;width=12;height=5;
      set(gcf,'units','inches','position',[x0,y0,width,height]);
      YSize = size(y);
      YR = YSize(1);
      YC = YSize(2);
      bar(y,'stacked');
      set(gca,'XTick',1:length(X),'XTickLabel',X); 
      legend(legendNames,'Location','eastoutside','Orientation','vertical');
      
      ylabel('Rank')
      xlabel('Parameters')
      title(folders(folderCount).name)
      save_name = strcat(fullfile(currentFolder,'Final Graphs',[folders(folderCount).name,'_STACKED']),'.fig');
      savefig(save_name);
      close all
end
done = 'Graphs Produced';
warning on
set(0,'DefaulttextInterpreter','tex')
end