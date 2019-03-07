function [Sr,Dr,Qr,Ner,R,I,Sp] =DataCleaning2(test,St,Dt,Qt,Net,RumorPopularityt,NbrInfectedt,NbrSpreaderst)
min=size(St{1});
min=min(1);
for i=1:test
    l=size(St{i});
    if l(1) < min 
        min=l(1);
    end
end
Sr=zeros(min,1);
Qr=zeros(min,1);
Dr=zeros(min,1);
Ner=zeros(min,1);
R= zeros(min,1);
I= zeros(min,1);
Sp= zeros(min,1);
for i=1:test
       for j=1:min
       
          Sr(j)=Sr(j)+ St{i}(j);
          Qr(j)=Qr(j)+ Qt{i}(j);
          Dr(j)=Dr(j)+ Dt{i}(j);
          Ner(j)=Ner(j)+ Net{i}(j);
          R(j)=R(j)+RumorPopularityt{i}(j);
          I(j)=I(j)+NbrInfectedt{i}(j);
          Sp(j)=Sp(j)+NbrSpreaderst{i}(j);
         
        
         
     end
    
end
end