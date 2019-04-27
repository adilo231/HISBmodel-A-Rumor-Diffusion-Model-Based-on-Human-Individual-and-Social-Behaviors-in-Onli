function [S,D,Q,Ne,RumorPopularity,NbrInfected,NbrSpreader] = ModelPropagationlive(step_time,ListGraph,Nodes,NodeDegree,IDSelectedNode,NodeFR,NodeDes,NodeHe) 


S=zeros(100,1);
Q=zeros(100,1);
NN=zeros(100,1);
D =zeros(100,1);
Ne=zeros(100,1);
RumorPopularity=zeros(100,1);
NbrSpreaders=zeros(100,1);
NbrInfected= zeros(100,1);
NbrSpreader(1)=0
ListInNodes(1)=0;
s=size(IDSelectedNode);

count = 1;
Time = 0.125;
NbrOFBN=0;
NodeNumAcc = zeros(Nodes,1);
NodeAccBelief = zeros(Nodes,1);
NodeAccAtt = zeros(Nodes,1);
NbrOfAcc=zeros(Nodes,1);
BbrOfNSedn= zeros(Nodes,1);
NodesSendR= zeros(Nodes,1);

Lspreaders =0;
pro=6/10;
for kk=1:floor(s(2)*pro)
    NodeAccBelief(IDSelectedNode(kk))= 20;
    NodeAccAtt(IDSelectedNode(kk))= 1;
    NodeNumAcc(IDSelectedNode(kk)) = 0.125;
    NbrOfAcc(IDSelectedNode(kk))=1;
    BbrOfNSedn(IDSelectedNode(kk))=4;
    ListInNodes(end+1)= IDSelectedNode(kk);
end
for kk=floor(s(2)*pro)+1:s(2)
    NodeAccBelief(IDSelectedNode(kk))= -20;
    NodeAccAtt(IDSelectedNode(kk))= 1;
    NodeNumAcc(IDSelectedNode(kk)) = 0.125;
    NbrOfAcc(IDSelectedNode(kk))=1;
    BbrOfNSedn(IDSelectedNode(kk))=4;
    ListInNodes(end+1)= IDSelectedNode(kk);
end

ListInNodes(1)= [];
S(1)=1/Nodes;
Q(1)=0;
D(1)=1/Nodes;
Ne(1)=0;
NN(1)=Nodes-2/Nodes;


NbrInfected(1)=1;

RumorPopularity(1)=pro*10*20;
while  length(ListInNodes)  > 0
    
    
    for ll =length(ListInNodes):-1:1
        i=ListInNodes(ll);
        if(NodeNumAcc(i)> 0)
            Nodelist = ListGraph{i,1};
            SizeL = size(Nodelist);
            a=abs( exp(-(Time-NodeNumAcc(i))*NodeDes(i))*sin((NodeFR(i)*(Time-NodeNumAcc(i)))-(NodeHe(i))));
            send =0 ;
            if exp(-(Time-NodeNumAcc(i))*NodeDes(i)) < 0.01
                ListInNodes(ll)=[];
                NodeAccAtt(i)=0;
            else
                % sending the rumor to the I th nighbords
                NodeAccAtt(i)=((a)*NodeDegree(i)*NodeAccBelief(i));
            end
            
            
            if(BbrOfNSedn(i) > 0)
                l=randi(100);
                y=(a)*50;
                
                if( l <= y  )
                    send = 1;
                end
                
                if send == 1 && NodeDegree(i) > 0
                    BbrOfNSedn(i)= BbrOfNSedn(i)-1;
                    send2=0;
                    IDSelectedNod=randperm(SizeL(2),floor(NodeDegree(i)*0.2));
                    s=size(IDSelectedNod);
                    for NO=1:  s(2)
                        l=randi(100);
                        p= (NodeDegree(i)/(NodeDegree(Nodelist( IDSelectedNod(NO)))+NodeDegree(i)))*50*(1/(1+NbrOfAcc(Nodelist( IDSelectedNod(NO)))));
                        if(l <= p )
                            NbrSpreader(count)=NbrSpreader(count)+1;
                            BbrOfNSedn(Nodelist( IDSelectedNod(NO)))=BbrOfNSedn(Nodelist( IDSelectedNod(NO)))+1;
                            NbrOfAcc(Nodelist( IDSelectedNod(NO)))=NbrOfAcc(Nodelist( IDSelectedNod(NO)))+1;
                            NodesSendR(i)=NodesSendR(i)+1;
                            if(length(find(ListInNodes== Nodelist( IDSelectedNod(NO))))==0)
                                ListInNodes(end+1)=Nodelist( IDSelectedNod(NO));
                            end
                            
                            if NodeNumAcc(Nodelist( IDSelectedNod(NO)))== 0
                                
                                NodeNumAcc(Nodelist( IDSelectedNod(NO)))= Time;
                                if NodeAccBelief(i) < 0
                                    NodeAccBelief(Nodelist( IDSelectedNod(NO)))= -10;
                                else
                                    NodeAccBelief(Nodelist( IDSelectedNod(NO)))= 20;
                                end
                                NodeAccAtt(Nodelist( IDSelectedNod(NO)))= 1;
                                
                            elseif NodeNumAcc(Nodelist( IDSelectedNod(NO))) > 0
                                
                                % NodeAccBelief(Nodelist( IDSelectedNode))=NodeAccBelief(Nodelist( IDSelectedNode))+(NodeAccBelief(i)/exp(NbrOfAcc(Nodelist( IDSelectedNode))));
                                if NodeAccBelief(i) < 0
                                    NodeAccBelief(Nodelist( IDSelectedNod(NO)))= NodeAccBelief(Nodelist( IDSelectedNod(NO)))+(-10/(1+NbrOfAcc(Nodelist( IDSelectedNod(NO)))));
                                else
                                    NodeAccBelief(Nodelist( IDSelectedNod(NO)))= NodeAccBelief(Nodelist( IDSelectedNod(NO)))+(20/(1+NbrOfAcc(Nodelist( IDSelectedNod(NO)))));
                                    
                                end
                                
                                
                            end
                            send2=1;
                        end
                    end
                    
                end
            end
        end
    end
    
    count=count+1;
    NbrSpreader(count)=0;
    S(count)=sum(NodeAccBelief(:)>20)/Nodes;
    Q(count)=((sum(NodeAccBelief(:)>10)/Nodes)-S(count));
    NN(count)=sum(NodeNumAcc(:)==0)/Nodes;
    D(count)= (sum(NodeAccBelief(:)<0))/Nodes;
    Ne(count)= ((sum(NodeAccBelief(:)>=0)/Nodes)-S(count)-Q(count)-NN(count));
    
    
    
    RumorPopularity(count)=sum((NodeAccAtt(:)>0));
    NbrInfected(count)=length(ListInNodes);
      
    Time=Time+step_time;
        
end
end
