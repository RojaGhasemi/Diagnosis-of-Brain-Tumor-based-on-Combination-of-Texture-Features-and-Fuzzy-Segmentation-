function Perf=Call_Performanc(a,DataSet,DataSet_Y)
 % classification rate   
[row col] = size(DataSet);
correct = 0;false=0;
for i=1:size(DataSet_Y,2)
    [I] = round(a(i));
    Class(i)=I;
    [II] =DataSet_Y (i);
    if I == II
        correct = correct + 1
    else
        false = false + 1; 
    end
end   
Perf = correct / col*100;
save 'Class';
end