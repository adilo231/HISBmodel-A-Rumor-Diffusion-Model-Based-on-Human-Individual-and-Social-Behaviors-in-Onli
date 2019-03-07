% Random graph construction routine with various models
% INPUTS:  N - number of nodes
%          p - probability, 0<=p<=1, for all other inputs, p is not considered
%          E - fixed number of edges
%          distribution - probability distribution: use the "connecting-stubs model" generation model
%          degrees - particular degree sequence, used only if distribution = 'sequence'
% OUTPUTS: adj - adjacency matrix of generated graph (symmetric)
% Note 1: Default is Erdos-Renyi graph G(n,0.5)
% Note 2: Generates undirected, simple graphs only
% Note 3: In the worst-case scenario for a given degree distribution, the algorithm is very slow, and it works by restarting itself.
% Source: Various random graph models from the literature
% Other routines: numedges.m, isgraphic.m
% GB, October 31, 2005

function L = random_graphList(n)

L=cell(n,1); % initialize adjacency matrix
P=0.8;
 p=0.8; 
        for i=1:n
            for j=i+1:n
                if rand<=p;
                     s=size(L{i});
                     L{i}(s(2)+1)=j;
                       
                     s=size(L{j});
                     L{j}(s(2)+1)=i;
                end
            end
            p=p-(P/n);
        end
  
  
    
   
        
end  % end nargin options