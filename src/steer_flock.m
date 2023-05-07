function [force]=steer_flock(Current,OBJs,OBJNum)
    align_force=steer_alignment(Current,OBJs,OBJNum);
    coh_force=steer_cohesion(Current,OBJs,OBJNum);
    sepr_force=steer_separation1(Current,OBJs,OBJNum);  
    force=align_force*0.5+coh_force*0.01+sepr_force*1;