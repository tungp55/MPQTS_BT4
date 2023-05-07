%Calculate Horizontal Angle
    function Alpha_Horizontal = CalculationHorizontalAngle(Leader)
        v_leader = Leader(4:6);
        Alpha_Horizontal = atan(abs(v_leader(2)/v_leader(1)));
        if (v_leader(1) > 0)
            if (v_leader(2) < 0)                
                Alpha_Horizontal = 2*pi - Alpha_Horizontal ;
            end
        else
            if (v_leader(2) > 0)
                Alpha_Horizontal = pi - Alpha_Horizontal;
            else
                Alpha_Horizontal = Alpha_Horizontal + pi;
            end
        end
    end