% This script generates latex format tables for the publication,
% directly from the matlab processed results.
close all
clear all

models = {'New model for Cell \\#7','\\citet{wang1997}','\\citet{diveroli2013}','\\citet{mazhari2001}','\\citet{tentusscher2004}','\\citet{zeng1995}'};

fits = [
0.0825 0.1343 0.2060 0.3167 0.1239;
0.1914 0.2176 0.2506 0.2358 0.2726;
0.1994 0.2654 0.2827 0.4101 0.2605;
0.2361 0.2987 0.2597 0.5102 0.2637;
0.3966 0.4124 0.4205 0.5287 0.5326;
0.4147 0.5013 0.5597 0.6246 0.5357];

% Scalings to use in the colouring
% 0 = 0
% largest error = 100
column_scalings = max(fits);

assert(size(fits,1)==length(models))

% Make a colormap of 100 colours
colours = colormap(autumn(101));

high = colours(1,:);
low = colours(end,:);

% Print out LaTeX code for the table to screen
fprintf('%% This table was auto-generated by table_D2/results_to_latex_tables.m, so don''t edit it here, edit that instead!\n')
fprintf('\\begin{table}[htb]\n')
fprintf('\\begin{center}\n')
fprintf('\\caption{Table quantifying square root of mean square difference (units nA) between experimental\n')
fprintf('current traces and simulation predictions for the validation protocols shown\n')
fprintf('in Figures~\\ref{fig:traditional_protocols} and \\ref{fig:ap_protocol}.\n')
fprintf('Here the colour scale is set so that \\colorbox[rgb]{%g,%g,%g}{\\textcolor[rgb]{%g,%g,%g}{T}} represents zero error\n',low(1),low(2),low(3),low(1),low(2),low(3))
fprintf('and \\colorbox[rgb]{%g,%g,%g}{\\textcolor[rgb]{%g,%g,%g}{T}} represents the highest error for each protocol/column.}\n',high(1),high(2),high(3),high(1),high(2),high(3))
fprintf('\\begin{small}\n')
fprintf('\\begin{tabular}{l*{5}{c}}\\cline{2-6}\n')
fprintf('\\toprule\n')
fprintf('Model & Sine Wave (Pr7) & AP (Pr6) & Steady Act. (Pr3) &  Deact. (Pr4) &  Inact. (Pr5) \\\\ \n')
fprintf('\\midrule\n')
for i=1:size(fits,1)
    fprintf([models{i} ])
    for j = 1:size(fits,2)
        scaled_data = 100.0.*(1.0 - fits(i,j)./column_scalings(j));
        rgb1=colours(floor(scaled_data)+1,:);
        fprintf(' & \\cellcolor[rgb]{%f,%f,%f} %5.4f',rgb1(1),rgb1(2),rgb1(3),fits(i,j))
    end
    fprintf('\\\\\n')
end
fprintf('\\bottomrule\n')
fprintf('\\end{tabular}\n')
fprintf('\\label{tab:quantifying_predictions}\n')
fprintf('\\end{small}\n')
fprintf('\\end{center}\n')
fprintf('\\end{table}\n')


