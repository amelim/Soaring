%Andrew Melim



%Size of the VectorField in all axis
vf.size = 50;
%Number of thermals to generate
vf.nt = 0;
vf.nw = 1;
vf.detail = 1;
[vf.x vf.y vf.z] = meshgrid(1:vf.size,1:vf.size,1:vf.size);

t_height = 30; 
%Random positions for 4 thermals
t_xy = randi([0 40],2,vf.nt);
%Random raius for thermals
t_r = randi([-2 2],1,4) + 10;

%%--WAVES--%%
%Width
w_w = 20;
%Height
w_h = 20;
%Depth
w_d = 5;
%Determine bottom left corner of vector
w_xy = randi([20 40],2,vf.nw)


%Initial Wind
for x = 1:vf.detail:vf.size
	for y = 1:vf.detail:vf.size
		for z = 1:vf.detail:vf.size
			%Initial Values
			if z==1
			    u = 100; %X Component
			    v = 0;%Y Component
			    w = 0;%randi([-10 10],1,1);%Z Component
            else
            	u = vf.u(x,y,z-1);% + randi([-1 1],1,1);
            	v = vf.v(x,y,z-1);% + randi([-10 10],1,1);
            	w = vf.w(x,y,z-1);% + randi([-1 1],1,1);
            end
            vf.u(x,y,z)=u;
            vf.v(x,y,z)=v;
            vf.w(x,y,z)=w;


            %Thermal effects
            for t = 1:vf.nt
            	xy = t_xy(:,t);
            	d = sqrt((xy(1)-x).^2 + (xy(2)-y).^2);
            	if(d < t_r(t))
                    vf.w(x,y,z) = vf.w(x,y,z) + 10;
                elseif(d < t_r(t).*1.5)
                    vf.w(x,y,z) = vf.w(x,y,z) - 4;
                end
            end

            %%--WAVES--%%
            for t = 1:vf.nw
	            %Positive top left origin
                xy = w_xy(:,t);
                if(x >= xy(1) & x < xy(1)+w_w)
                    if(y >= xy(2) & x < xy(2)+w_h)
    		            for d = 1:w_d
    			            theta = (1/4)*pi*(y);
    			            theta = mod(theta,2*pi);
    			            vf.w(x,y,z) = vf.w(x,y,z)+sin(theta)*5;
                        end
                    end
                end
            end
        end
    end
end






hold on;

[sx sy sz] = meshgrid(1,1:5:50,1:5:50);
hlines = streamline(stream3(vf.x,vf.y,vf.z,vf.u,vf.v,vf.w,sx,sy,sz));
%[verts averts] = streamslice(vf.u, vf.v, vf.w, [], [], [5]);

%!!Really slow and inefficient for viz!!
%quiver3(vf.x, vf.y, vf.z, vf.u, vf.v, vf.w, 1);
wind_spd = sqrt(vf.u.^2 + vf.v.^2 + vf.w.^2);
%slice(wind_spd,[],[],[5]);
%colormap(jet);
%shading interp
view(3)
%camlight;sqrt((xy(1)-x).^2 + (xy(2)-y).^2)
