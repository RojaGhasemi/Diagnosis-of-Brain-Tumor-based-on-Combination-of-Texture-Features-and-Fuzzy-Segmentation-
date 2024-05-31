function Out=Calfitness_f1(p)

len=length(p);
for i=1:len
    Out(i)=sum(p(i).xpoints.^2);
end

