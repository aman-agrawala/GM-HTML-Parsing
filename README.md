# GM-HTML-Parsing
Code for Webscrapping data outputted by Mobius program

This code requires a basic understanding of MatLab in order to be used effectively. Please see https://www.mathworks.com/support/learn-with-matlab-tutorials.html?requestedDomain=www.mathworks.com for more information on using Matlab/Simulink.

## Instructions

To get this code up and running:

1. Put all the files in the same directory and change your matlab folder to that directory.
2. Then put all your Mobius HTML files into the same directory.
3. Create a variable called `der` that is set to the full location of the HTML files
4. Create a variable called `comps` that is an array specifying what components of the Mobius HTML files you want Webscrapped
5. Create a variable called `LX` that specifies the Taguichi matrix you are interested in. This Taguichi matrix must be created before hand. See https://www.york.ac.uk/depts/maths/tables/taguchi_table.htm for precreated Taguichi designs.
6. Finally, within the Matlab command line type `html_run(der, comps, LX)`, where der is the full location of the HTML files, comps is the comps is an array specifying what components of the Mobius HTML files you want Webscrapped, and LX is an array specifying the Taguichi matrix that you want to use,
7. After the program is finished a new folder called Final Html Calcs will have been created. Open this folder to find all the analyzed data and their respective graphs that summarize the results
