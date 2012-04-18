%Glider function to be used with ODE45
%Andrew Melim
function xdot = glider(t, x)

    % va airspeed
    % wx, wy, wz wind airspeed components
    % gamma: glidepath
    
    xdot = [va*cos(gamma)*cos(phi)+wx;
            va*cos(gamma)*sin(phi)+wy;
            va*sin(gamma)+wz];


end
