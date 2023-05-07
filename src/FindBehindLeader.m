% Find the position behind the Leader a distance D_Behind
    function BehindLeader = FindBehindLeader(Leader, D_Behind)
        p_leader = Leader(1:3);
        v_leader = Leader(4:6);
        tv_behind = -v_leader;
        tv_behind = setMag(tv_behind, D_Behind);
        p_behind = p_leader + tv_behind;
        BehindLeader(1) = p_behind(1) ;
        BehindLeader(2) = p_behind(2) ;
        BehindLeader(3) = 0;
        BehindLeader(4:6) = Leader(4:6);
    end