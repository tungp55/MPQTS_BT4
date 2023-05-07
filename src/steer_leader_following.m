function steer = steer_leader_following(CurrentBoid, Leader, FleeDistance, D_BehindLeader)
global SaveBehindLeader;
v_pos = CurrentBoid(1:3);
v_vel = CurrentBoid(4:6);
v_maxspeed = CurrentBoid(10);
v_maxforce = CurrentBoid(11);
v_max_see_ahead = CurrentBoid(13);

 p_leader = Leader(1:3);
 v_leader = Leader(4:6);
% LeaderSeeAhead = Leader(13);
% 
% tv_head = v_leader;
% tv_head = setMag(tv_head, LeaderSeeAhead);
% LeaderAhead = p_leader + tv_head;

tv_behind = -v_leader;
tv_behind = setMag(tv_behind, D_BehindLeader);
p_following = p_leader + tv_behind;

delete(SaveBehindLeader);
SaveBehindLeader = plot(p_following(1), p_following(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');

% If the character is on the leader's sight, add a force
% to evade the route immediately.
if (isOnLeaderSight(CurrentBoid, Leader))
    evade_force = steer_evade(CurrentBoid, p_leader, v_leader, FleeDistance);
else
    evade_force = [0,0,0];
end

% Creates a force to arrive at the behind point
arrival_force = steer_arrival(CurrentBoid, p_following);

% Separation force
separation_force = steer_separation(CurrentBoid);

force = evade_force + 0.5*arrival_force + separation_force;
steer = setLimit(force, v_maxforce); % set limit steer force

end