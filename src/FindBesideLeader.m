% Find the left beside and right beside positons of the Leader a distance D_Beside
    function [RightBesideLeader, LeftBesideLeader] = FindBesideLeader(Leader, Alpha_Horizontal, D_Behind, D_Beside)
        BehindLeader = FindBehindLeader(Leader, D_Behind);
        LeftBesideLeader(3) = 0;
        RightBesideLeader(3) = 0;
        RightBesideLeader(4:6) = Leader(4:6);
        LeftBesideLeader(4:6) = Leader(4:6);
        
        if (Alpha_Horizontal > 0 && Alpha_Horizontal < pi/2)
            LeftBesideLeader(1) = BehindLeader(1) - abs(sin(Alpha_Horizontal)*D_Beside);
            LeftBesideLeader(2) = BehindLeader(2) + abs(cos(Alpha_Horizontal)*D_Beside);
            
            RightBesideLeader(1) = BehindLeader(1) + abs(sin(Alpha_Horizontal)*D_Beside);
            RightBesideLeader(2) = BehindLeader(2) - abs(cos(Alpha_Horizontal)*D_Beside);
        else
            %2
            if (Alpha_Horizontal > pi/2 && Alpha_Horizontal < pi)
                LeftBesideLeader(1) = BehindLeader(1) - abs(sin(Alpha_Horizontal)*D_Beside);
                LeftBesideLeader(2) = BehindLeader(2) - abs(cos(Alpha_Horizontal)*D_Beside);
                
                RightBesideLeader(1) = BehindLeader(1) + abs(sin(Alpha_Horizontal)*D_Beside);
                RightBesideLeader(2) = BehindLeader(2) + abs(cos(Alpha_Horizontal)*D_Beside);
                
            else
                %3
                if (Alpha_Horizontal > pi && Alpha_Horizontal < 3*pi/2)
                    LeftBesideLeader(1) = BehindLeader(1) + abs(sin(Alpha_Horizontal)*D_Beside);
                    LeftBesideLeader(2) = BehindLeader(2) - abs(cos(Alpha_Horizontal)*D_Beside);
                    
                    RightBesideLeader(1) = BehindLeader(1) - abs(sin(Alpha_Horizontal)*D_Beside);
                    RightBesideLeader(2) = BehindLeader(2) + abs(cos(Alpha_Horizontal)*D_Beside);
                else
                    %4
                    if (Alpha_Horizontal > 3*pi/2 && Alpha_Horizontal < 2*pi)
                        LeftBesideLeader(1) = BehindLeader(1) + abs(sin(Alpha_Horizontal)*D_Beside);
                        LeftBesideLeader(2) = BehindLeader(2) + abs(cos(Alpha_Horizontal)*D_Beside);
                        
                        RightBesideLeader(1) = BehindLeader(1) - abs(sin(Alpha_Horizontal)*D_Beside);
                        RightBesideLeader(2) = BehindLeader(2) - abs(cos(Alpha_Horizontal)*D_Beside);
                    else
                        if (Alpha_Horizontal == 0)
                            LeftBesideLeader(2) = BehindLeader(2) + D_Beside;
                            RightBesideLeader(2) = BehindLeader(2) - D_Beside;
                        else
                            if (Alpha_Horizontal == pi)
                                LeftBesideLeader(2) = BehindLeader(2) - D_Beside;
                                RightBesideLeader(2) = BehindLeader(2) + D_Beside;
                            else
                                if (Alpha_Horizontal == pi/2)
                                    LeftBesideLeader(1) = BehindLeader(1) - D_Beside;
                                    RightBesideLeader(1) = BehindLeader(1) + D_Beside;
                                else
                                    if (Alpha_Horizontal == 3*pi/2)
                                        LeftBesideLeader(1) = BehindLeader(1) + D_Beside;
                                        RightBesideLeader(1) = BehindLeader(1) - D_Beside;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
