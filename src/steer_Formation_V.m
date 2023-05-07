function Boids  = steer_Formation_V(Boids, Leader, D_Behind, D_Beside, Alpha_Horizontal)
global FleeDistance;
global BoidsNum;

p_leader = Leader(1:3);
v_leader = Leader(4:6);
LeaderSeeAhead = Leader(13);
tv_head = v_leader;
tv_head = setMag(tv_head, LeaderSeeAhead);

% Array of flags for boids to mark what boid is arranged to the left or the right
% BoidsFlag(i) = 1 means the Boid i-th was arranged to the left or the right
BoidsFlag = zeros(1, BoidsNum);

% Find nearest boid
    function [NearestBoid, BoidsFlag, MinIndex] = Nearest(Leader, BoidsFlag)
        i = 1;
        if (any(BoidsFlag))
            while (i < BoidsNum & BoidsFlag(i) ~= 0)
                i = i + 1;
            end
        end
        d_min = dist(Leader(1:3), Boids(i,1:3));
        MinIndex = i;
        for BoidIndex = 1:BoidsNum
            if ((BoidsFlag(BoidIndex) == 0) & BoidIndex ~= MinIndex)
                vhl_o_pos = Boids(BoidIndex,1:3);
                d = dist(Leader(1:3), vhl_o_pos);
                if (d < d_min)
                    d_min = d;
                    MinIndex = BoidIndex;
                end
            end
        end
        NearestBoid = Boids(MinIndex, :);
        BoidsFlag(MinIndex) = 1;
    end

% Merge boid to the left or right branch
    function CurrentBoid = MergeToLeader(CurrentBoid, Leader, isRight, BoidIndex)
        if (~isRight)
            p_following = LeftBesideLeader;
        else
            p_following = RightBesideLeader;
        end
        % If the character is on the leader's sight, add a force
        % to evade the route immediately.
        if (isOnLeaderSight(CurrentBoid, Leader))
            evade_force = steer_evade(CurrentBoid, p_leader, v_leader, FleeDistance);
        else
            evade_force = [0,0,0];
        end        
        arrival_force = steer_pursue_arrival(CurrentBoid, p_following);
        %arrival_force = steer_pursue(CurrentBoid, p_following);
        % Separation force to collide avoidance
        separation_force = steer_separation(CurrentBoid);
        force = evade_force + 0.5*arrival_force + 0.5* separation_force ;
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
        Boids = updateAtBoundary(Boids,BoidIndex);
    end

[RightBesideLeader, LeftBesideLeader] = FindBesideLeader(Leader, Alpha_Horizontal, D_Behind, D_Beside);
[LeaderRight,BoidsFlag,MinRightIndex] = Nearest(RightBesideLeader, BoidsFlag);
LeaderRight = MergeToLeader(LeaderRight,Leader,1, MinRightIndex);

[LeaderLeft,BoidsFlag,MinLeftIndex] = Nearest(LeftBesideLeader, BoidsFlag);
LeaderLeft = MergeToLeader(LeaderLeft,Leader,0, MinLeftIndex);

while (sum(BoidsFlag) < BoidsNum)
    [RightBesideLeader, ~] = FindBesideLeader(LeaderRight, Alpha_Horizontal, D_Behind, D_Beside);
    [NearestRight,BoidsFlag,MinRightIndex] = Nearest(RightBesideLeader, BoidsFlag);
    NearestRight = MergeToLeader(NearestRight,LeaderRight,1, MinRightIndex);
    LeaderRight = NearestRight;
    
    [~, LeftBesideLeader] = FindBesideLeader(LeaderLeft, Alpha_Horizontal, D_Behind, D_Beside);
    [NearestLeft,BoidsFlag,MinLeftIndex] = Nearest(LeftBesideLeader, BoidsFlag);
    NearestLeft = MergeToLeader(NearestLeft,LeaderLeft,0, MinLeftIndex);
    LeaderLeft = NearestLeft;
end
end