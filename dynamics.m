function xdot = dynamics(t,x, vf)

% inputs: pitch, roll, thrust and thermals
% currently not using thrust in any way
u_pitch = 0;
u_roll = 0.1;
u_thermal = 0;
u_thrust = 0;
bank_rate = 0;

% constants
g = 9.8; % gravity
c_l = 1.0; % lift coefficient, appropriate number for estimation
c_d = 0.01; % drag coefficient
d_a = 1.225; % air density, sea level
a_w = 1; % wing area seems like an easy number
a_c = 0.05; % cross sectional area
m = 1; % mass, another easy number

% extremum constants
k = .05; % end scaling factor
w = 1; % period of perturbation
w_l = .05; % low pass
w_h = 1; % high pass
a = .05; % amplitude of perturbation

% x forward, y left, z down
px = x(1);
py = x(2);
pz = x(3);
vx = x(4);
vy = x(5);
vz = x(6);
gp = x(7); % glidepath
hd = x(8); % heading
energy = x(9);
% extremum
xi = x(10);
eta = x(11);

%Vector field access requires integers, so we round
try
if pz <= 0
    u_thermal = vf.w(round(px),round(py),-round(pz));
else
	u_thermal = 0;
end
end

xi_dot = -w_l*xi + w_l*(energy - eta)*a*sin(w*t);
eta_dot = -w_h*eta + w_h*energy;
bank_rate = k*xi;

va = sqrt(vx^2 + vy^2); % airspeed

lift = 0.5*d_a*(va^2)*a_w*c_l;
drag_x = 0.5*d_a*(vx^2)*a_c*c_d;
drag_y = 0.5*d_a*(vy^2)*a_c*c_d;
drag_z = 0.5*d_a*(vz^2)*a_c*c_d;

px_dot = vx;
py_dot = vy;
pz_dot = vz;
vx_dot = g*cos(gp)*cos(hd) - sign(vx)*(drag_x/m) - bank_rate*vy;
vy_dot = g*cos(gp)*sin(hd) - sign(vy)*(drag_y/m) + bank_rate*vx;
vz_dot = g*sin(gp) - u_thermal/m - 0*sign(vz)*drag_z/m - lift/m;

% E = 0.5*m*(vx^2 + vy^2 + vz^2) - g*m*pz; % z is down!
Edot = m*(vx*vx_dot + vy*vy_dot + vz*vz_dot) - g*m*vz;


gp_dot = u_pitch;
hd_dot  = u_roll;%k*xi



xdot = zeros(11,1);

if pz <= 0
    xdot(1) = px_dot;
    xdot(2) = py_dot;
    xdot(3) = pz_dot;
    xdot(4) = vx_dot;
    xdot(5) = vy_dot;
    xdot(6) = vz_dot;
    xdot(7) = gp_dot;
    xdot(8) = hd_dot;
    xdot(9) = Edot;
    xdot(10) = xi_dot;
    xdot(11) = eta_dot;
else % crash!
    xdot(1) = 0;
    xdot(2) = 0;
    xdot(3) = 0;
    xdot(4) = -vx;
    xdot(5) = -vy;
    xdot(6) = -vz;
    xdot(7) = 0;
    xdot(8) = 0;
    xdot(9) = Edot;
    xdot(10) = 0;
    xdot(11) = 0;
end


end
