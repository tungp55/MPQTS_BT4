% Check whether any Boid is on leader sight
function isOnLeaderSight = isOnLeaderSight(CurrentBoid, Leader)
global FleeDistance;
v_pos = CurrentBoid(1:3);
p_leader = Leader(1:3);
v_leader = Leader(4:6);
LeaderSeeAhead = Leader(13);

tv_head = v_leader;
tv_head = setMag(tv_head, LeaderSeeAhead);
LeaderAhead = p_leader + tv_head;
if (dist(LeaderAhead, v_pos) <= FleeDistance)
    isOnLeaderSight = 1;
else
    isOnLeaderSight = 0;
end
end