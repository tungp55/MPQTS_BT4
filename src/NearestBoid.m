% Find nearest boid of the Leader, MinIndex is index of Boid in the flock
% BoidsFlag is a array to mark any boid is arranged to come to the desired point and do not need to be arrange
function [Nearest, BoidsFlag, MinIndex] = NearestBoid(Leader, BoidsFlag, Boids, BoidsNum)
%global BoidsNum;
%global Boids;
i = 1;
if (any(BoidsFlag))
    while (i < BoidsNum && BoidsFlag(i) ~= 0)
        i = i + 1;
    end
end
d_min = dist(Leader(1:3), Boids(i,1:3));
while (d_min == 0 && i < BoidsNum )
    i = i + 1;
    d_min = dist(Leader(1:3), Boids(i,1:3));
end

MinIndex = i;
for Index = 1:BoidsNum
    if ((BoidsFlag(Index) == 0) && Index ~= MinIndex)
        vhl_o_pos = Boids(Index,1:3);
        d = dist(Leader(1:3), vhl_o_pos);
        if (d > 0) && (d < d_min)
            d_min = d;
            MinIndex = Index;
        end
    end
end
Nearest = Boids(MinIndex, :);
BoidsFlag(MinIndex) = 1;
end