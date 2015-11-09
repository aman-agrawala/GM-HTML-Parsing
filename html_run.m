% The purpose of this script is to run the individual scripts in order to
% properly output all excel files and graphs. Do not change this order.
% html_run.m created for HTML Parsing/Automation Project by Aman Agrawala

function progress = html_run(der,comps,LX, SNOpt)
html2txt(der,comps) %First convert html to txt
[data,filename] = opentxt(der); % Now we access the txt file
finalData = analyzeL11(data,filename); % Now we parse the data and create final form of the data
excel = export2excel(der,finalData,filename,comps); %Now we export to excel
get_graphDataL11(der,LX, SNOpt) % this will produce the excel data formatted for easy graph production
done = get_graphs(der) % this will plot the ranks data and save it.