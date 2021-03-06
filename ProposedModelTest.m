clear;
clc;

%%load network, There are two networks  available in this project twitter and facebook.
load('TwitterDataf.mat');
%load('TwitterData.mat');
%load('facebook.mat');

%Gerenrate Sythetic graph 
%Nodes=1000;
% ListGraph=random_graphList(Nodes);
% More details about Barabási–Albert model read : https://en.wikipedia.org/wiki/Barab%C3%A1si%E2%80%93Albert_model
%ListGraph=BAgraph_dir(Nodes,10,10);
% More details about this network read : https://en.wikipedia.org/wiki/Watts%E2%80%93Strogatz_model
%ListGraph=WattsStrogatz(Nodes,Nodes*10,0.3); 

% for i =1:Nodes
%   k=size(ListGraph{i,1});
%   Nodelist = ListGraph{i,1};
%   NodeDegree(i)=k(2);     
% end

%%random human factors (min ,max) values
% min=(1*pi())/24;
% max=(2*pi())/24;
% NodeFR= (min)+(max)-(min)*rand(Nodes,1);
% NodeHe= (min)+(max)*rand(Nodes,1);

%%Randome human factores
%NodeFR= (pi()/24)+((pi())-(pi()/24))*rand(Nodes,1); Omega
%NodeDes=(0.2)+(1)*rand(Nodes,1); Beta
%NodeHe= (pi()/24)+((pi()/2)-(pi()/24))*rand(Nodes,1); Delta

%IDSelectedNode= randperm(Nodes,5);

test=1;%number of test
step_time=0.125;

tic
St=cell(test,1);
Dt=cell(test,1);
Qt=cell(test,1);
Net=cell(test,1);
RumorPopularityt=cell(test,1);
NbrSpreaderst=cell(test,1);
NbrInfectedt=cell(test,1);



for i=1:test
    [S,D,Q,Ne,RumorPopularity,NbrInfected,NbrSpreader] = ModelPropagationlive(step_time,ListGraph,Nodes,NodeDegree,IDSelectedNode,NodeFR,NodeDes,NodeHe);

   
    St{i}=S;
    Dt{i}=D;
    Qt{i}=Q;
    Net{i}=Ne;
    RumorPopularityt{i}=RumorPopularity;
    NbrSpreaderst{i}=NbrSpreader;
    NbrInfectedt{i}=NbrInfected ;
   
end


[Sr,Dr,Qr,Ner,R,I,Sp] =DataCleaning(test,St,Dt,Qt,Net,RumorPopularityt,NbrInfectedt,NbrSpreaderst);

R=R/test;

% plot the resutls
B=(Sr+Qr+Ner)/test;
Be=(Sr+Qr+Ner+Dr)/test;

hold on
subplot(1,3,1)
l=size(R);
x=0:1:l(1)-1;
title('Rumor popularity')
hold on
plot(x, R,'DisplayName','Rumor popularity');



hold on
subplot(1,3,2)
l=size(Sr);
x=0:1:l(1)-1;
hold on
title('The impact of the rumor')
plot(x, I,'DisplayName','Infetcted individuals');
plot(x, Sp,'DisplayName','Spreders');

hold on
subplot(1,3,3)
hold on
title('The evolution of the rate of infected individuals according to their opinions')
plot(x, B,'DisplayName','I');
plot(x,Sr/test,'DisplayName','Supporting');
plot(x,Qr/test,'DisplayName','Qyring');
plot(x,Dr/test ,'DisplayName','Deniy');
plot(x,Ner/test ,'DisplayName','Neuteral');


toc
