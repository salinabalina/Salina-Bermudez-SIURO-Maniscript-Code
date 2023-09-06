function maketable(A,filename,caption,label,formatstr)
% February 29, 2004, Rosemary Renaut
% This small function can be used to create a file for input to a tex doc
% The file created has name "filename" and is a table of all entries
% in matrix A. It could be necesary to taylor the format of the print out
% Use for example %4.4f for each number in the matrix
% or %d
% This is also modified to pass the caption for the table and the label for
% the table
[trows,tcols]=size(A);
fid1=fopen(filename,'a');
fprintf(fid1,'%s','\begin{table}[!htb]\begin{center}\begin{tabular}{|c*{');
fprintf(fid1,'%d',tcols+1);
fprintf(fid1,'%s\n','}{|c}|}\hline');
fprintf(fid1,'%s\n','Noise type&$\snr$& $K_1^1$&$K_2^1$& $\tau_1$& $\tau_2$& $\rho_1$& $\rho_2$\\');
%% Need to format all the groups
for i=1:3
    if i==1 fprintf(fid1,'%s', '\hline\multirow{3}{*}{Gaussian}'); end
    fprintf(fid1,'%s','&$');
    for j=1:3 %the integers
         fprintf(fid1,'%0.4g',A(i,j));
         fprintf(fid1,'%s','$&$');
    end
    for j=4:tcols-1
                 fprintf(fid1,formatstr,A(i,j));
         fprintf(fid1,'%s','$&$');
    end
    fprintf(fid1,formatstr,A(i,tcols));
    fprintf(fid1,'%s\n','$\\');
end
fprintf(fid1,'%s','\hline'); 
for i=4:6
     if i==4, fprintf(fid1,'%s', '\multirow{3}{*}{Poisson} ');     end
    fprintf(fid1,'%s','&$');
    for j=1:3 %the integers
         fprintf(fid1,'%0.4g',A(i,j));
         fprintf(fid1,'%s','$&$');
    end
    for j=4:tcols-1
                 fprintf(fid1,formatstr,A(i,j));
         fprintf(fid1,'%s','$&$');
    end
    fprintf(fid1,formatstr,A(i,tcols));
    fprintf(fid1,'%s\n','$\\');
end
fprintf(fid1,'%s','\hline'); 
for i=7:trows
    if  i==7  
        fprintf(fid1,'%s', '\multirow{3}{*}{S \& P} ');
    end
    fprintf(fid1,'%s','&$');
    for j=1:3 %the integers
         fprintf(fid1,'%0.4g',A(i,j));
         fprintf(fid1,'%s','$&$');
    end
    for j=4:tcols-1
                 fprintf(fid1,formatstr,A(i,j));
         fprintf(fid1,'%s','$&$');
    end
    fprintf(fid1,formatstr,A(i,tcols));
    fprintf(fid1,'%s\n','$\\');
end
fprintf(fid1,'%s\n','\hline'); 
fprintf(fid1,'%s','\end{tabular}\caption{');
fprintf(fid1,'%s',caption);
fprintf(fid1,'%s\n','}\end{center}\end{table}'); 
