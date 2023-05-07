function [index,tmpDist]=findTarget(Boid,OBJNum,OBJs)
tmpDist=100000;J=0;
for i=1:OBJNum
    if (dist(Boid,OBJs(i,:))<tmpDist ) && ( OBJs(i,15)>0)
        tmpDist=dist(Boid,OBJs(i,:));
        J=i;
    end
end
index=J;