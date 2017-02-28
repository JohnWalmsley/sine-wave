% This script generates latex format tables for the publication,
% directly from the matlab processed results.

close all
clear all

fits = [
1   0.0 0.0268 0.0650   0.0757 0.1195    0.0745 0.1369    0.2115 0.2334      0.1312  0.1250    ;
2   7.7 0.0262 0.0401     0.0549  0.0516    0.0481 0.0490      0.1421  0.1249    0.0478 0.0489   ; 
3   12.5 0.0348 0.0609   0.0997 0.1403    0.0917 0.1489      0.1320  0.1317    0.1106 0.1600    ;
4   16.7 0.0346 0.0497   0.0649 0.0690      0.0931  0.0797      0.1337  0.1301    0.0864 0.0959  ;  
5   20.0 0.0338 0.0374   0.1003 0.1149    0.0964 0.1274    0.2788 0.3358      0.5713  0.5668    ;
6   28.6 0.0149 0.0335     0.0419  0.0401      0.0482  0.0372      0.0883  0.0739      0.0443  0.0419  ;  
7   32.5 0.0825 0.1073   0.1343 0.1635      0.2060  0.1772    0.3167 0.3595    0.1239 0.1398   ; 
8   42.9 0.0426 0.0514   0.1331 0.1356    0.1302 0.1494    0.1796 0.2345    0.2222 0.2233    ;
9   58.3 0.0243 0.0266     0.1478  0.1472      0.1109  0.1068      0.1806  0.1766      0.2183  0.2174 ];

% Scalings to use in the colouring
% 0 = 0
% largest error = 100
column_minimums = min(fits);
column_maximums = max(fits);

row_minimums = min(fits(:,3:end),[],2);
row_maximums = max(fits(:,3:end),[],2);

% This scales across everything at once
overall_max = max(column_maximums(3:end));
overall_min = min(column_minimums(3:end)); % 1 and 2 not error measurements!

% Make a colormap of 100 colours
colours = colormap(autumn(101));

high = colours(1,:);
low = colours(end,:);

% Print out LaTeX code for the table to screen
fprintf('%% This table was auto-generated by table_F12/results_to_latex_tables.m, so don''t edit it here, edit that instead!\n')
fprintf('\\begin{table}[htb]\n')
fprintf('\\begin{center}\n')
fprintf('\\caption{Version of Table E4 with predictions of full traces --- \n')
fprintf('values are square root of mean square difference in nA. Now also updated so that average model conductance is scaled to the cell-specific sine wave experiment.\n')
fprintf('Here the colour scale is set so that \\colorbox[rgb]{%g,%g,%g}{\\textcolor[rgb]{%g,%g,%g}{T}} represents zero error\n',low(1),low(2),low(3),low(1),low(2),low(3))
fprintf('and \\colorbox[rgb]{%g,%g,%g}{\\textcolor[rgb]{%g,%g,%g}{T}} represents the highest error for each protocol/pair of columns.\n',high(1),high(2),high(3),high(1),high(2),high(3))
fprintf('Note that the cells with larger currents will show larger errors, but the left column cell-specific predictions tend to perform better than the average model, particularly for cells where the average model gives a larger error. }\n')
fprintf('\\begin{footnotesize}\n')
fprintf('\\begin{tabular}{lc|cc|cc|cc|cc|cc}\n')
fprintf('\\toprule\n')
fprintf('Cell & $\\Delta R_{\\textrm{leak}}$ & \\multicolumn{2}{c|}{Sine Wave (Pr 7)} & \\multicolumn{2}{c|}{APs (Pr 6)} & \\multicolumn{2}{c|}{Steady Act. (Pr 3)} & \\multicolumn{2}{c|}{Deact. (Pr 4)} & \\multicolumn{2}{c}{Inact. (Pr 5)}\\\\\n')
fprintf('\\# & (\\%%) &Specific& Average & Spec. & Aver. & Spec. & Aver. & Spec. & Aver. & Spec. & Aver. \\\\\n')
fprintf('\\midrule\n')
for i=1:size(fits,1)
    fprintf('%i & %3.1f', fits(i,1), fits(i,2))
     for p = 1:5 % Loop over protocols
         j = 2*p+1; % First index for this protocol
         columns_max = max([column_maximums(j) column_maximums(j+1)]);
         columns_min = min([column_minimums(j) column_minimums(j+1)]);
         
         % These scaled so zero is lowest value
%          scaled_data = 100.0.*(1.0 - fits(i,j)./columns_max);
%          scaled_data2 = 100.0.*(1.0 - fits(i,j+1)./columns_max);
         
         % These scaled so minimum is lowest value
         scaling_range = columns_max - columns_min;
         scaling_min = columns_min; % or zero worth looking at too.
         
%          % Try by row instead.
%          scaling_range = row_maximums(i)-row_minimums(i);
%          scaling_min = row_minimums(i);
         
         scaled_data = 100.0.*(1.0 - (fits(i,j)-scaling_min)./scaling_range);
         scaled_data2 = 100.0.*(1.0 - (fits(i,j+1)-scaling_min)./scaling_range);
         
         rgb1=colours(floor(scaled_data)+1,:);
         rgb2=colours(floor(scaled_data2)+1,:);
         fprintf(' & \\cellcolor[rgb]{%f,%f,%f} %5.4f',rgb1(1),rgb1(2),rgb1(3),fits(i,j))
         fprintf(' & \\cellcolor[rgb]{%f,%f,%f} %5.4f',rgb2(1),rgb2(2),rgb2(3),fits(i,j+1))
     end
    fprintf('\\\\\n')
end
fprintf('\\bottomrule\n')
fprintf('\\end{tabular}\n')
fprintf('\\label{tab:prediction_differences_raw_current}\n')
fprintf('\\end{footnotesize}\n')
fprintf('\\end{center}\n')
fprintf('\\end{table}\n')


