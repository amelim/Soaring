init_vx = 4;
init_height = 100;
mass = 1.0;


x_init = [0,0,-init_height,init_vx,0,0,pi/2,0, 9.8*mass*init_height];

[T,Y] = ode45(@dynamics, [0,100], x_init);


subplot(2,2,1);
plot(Y(:,1),Y(:,2));
title('(x,y) Motion of Glider');

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