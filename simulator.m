x_init = [0,0,-100,10,0,0,pi/2,0];

[T,Y] = ode45(@dynamics, [0,1000], x_init);

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
plot(T,Y(:,7),T,Y(:,8));
title('Heading and Glidepath of Glider');
legend('Glidepath', 'Heading');