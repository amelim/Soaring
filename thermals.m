%Andrew Melim



%Size of the VectorField in all axis
vf.size = 50;
%Number of thermals to generate
vf.nt = 4;
vf.detail = 1;
[vf.x vf.y vf.z] = meshgrid(1:vf.size,1:vf.size,1:vf.size);

t_height = 30; 
%Random positions for 4 thermals
t_xy = randi([-40 40],2,vf.nt);
%Random raius for thermals
t_r = randi([-2 2],1,4) + 10;

%Initial Wind
for x = 1:vf.detail:vf.size
	for y = 1:vf.detail:vf.size
		for z = 1:vf.detail:vf.size
			if z==1
			    u = 100; %X Component
			    v = 0;%Y Component
			    w = randi([-10 10],1,1);%Z Component
            else
            	u = vf.u(x,y,z-1) + randi([-1 1],1,1);
            	v = vf.v(x,y,z-1) + randi([-10 10],1,1);
            	w = vf.w(x,y,z-1) + randi([-1 1],1,1);
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
