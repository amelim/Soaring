init_vx = 4;
init_height = 60;
mass = 1.0;
vf = thermals;

%Vector field structure requires inital condition x/y to be non-zero
x_init = [1,50,-init_height,init_vx,0,0,pi/2,0, 9.8*mass*init_height];

[T,Y] = ode45(@dynamics, [0,100], x_init, [], vf);


subplot(2,2,1);
plot3(Y(:,1),Y(:,2),-Y(:,3));
title('(x,y,z) Motion of Glider');

subplot(2,2,2);
plot(T, -Y(:,3));
title('z Motion of Glider');

subplot(2,2,3);
plot(T,Y(:,4),T,Y(:,5),T,-Y(:,6));
title('Velocity of Glider');
legend('V_x','V_y','V_z');

subplot(2,2,4);
plot(T,Y(:,9));
title('Total Energy of Glider');
