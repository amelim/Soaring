%Andrew Melim
function vf = thermals()

%Size of the VectorField in all axis
vf.size = 100;
%Number of thermals to generate
vf.nt = 1;
%Number of waves
vf.nw = 0;
%Number of bubbles
vf.nb = 0;
vf.detail = 1;
[vf.x vf.y vf.z] = meshgrid(1:vf.size,1:vf.size,1:vf.size);

t_height = 30; 
%Random positions for 4 thermals
t_xy = [50;50];%randi([0 vf.size],2,vf.nt);
%Random raius for thermals
t_r = 10;%randi([-2 2],1,vf.nt) + 10;
t_speed = 3;
%%--WAVES--%%
%Width
w_w = 20;
%Height
w_h = 20;
%Depth
w_d = 5;
%Determine bottom left corner of vector
w_xy = randi([0 vf.size],2,vf.nw);


%%--BUBBLES--%%
b_xy = randi([0 vf.size],3,vf.nb);
b_r = 10;


%Initial Wind
for x = 1:vf.detail:vf.size
	for y = 1:vf.detail:vf.size
		for z = 1:vf.detail:vf.size
			%Initial Values
			if z==1
			    u = 100; %X Component
			    v = 0;%Y Component
			    w = .5;%randi([-10 10],1,1);%Z Component
            else
            	u = vf.u(x,y,z-1) + randi([-1 1],1,1);
            	v = vf.v(x,y,z-1) + randi([-10 10],1,1);
            	w = vf.w(x,y,z-1) + randi([-1 1],1,1);
            end
            vf.u(x,y,z)=u;
            vf.v(x,y,z)=v;
            vf.w(x,y,z)=0;


            %Thermal effects
            for t = 1:vf.nt
            	xy = t_xy(:,t);
            	d = sqrt((xy(1)-x).^2 + (xy(2)-y).^2);
            	if(d < t_r(t))
                    vf.w(x,y,z) = vf.w(x,y,z) + t_speed;
                elseif(d < t_r(t).*1.5)
                    vf.w(x,y,z) = vf.w(x,y,z) - t_speed;
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
            %%--BUBBLES--%%
            for t = 1:vf.nb
                xy = b_xy(:,t);
                dxy = sqrt((xy(1)-x).^2 + (xy(2)-y).^2 + (xy(3)-z).^2);
                if(dxy < b_r)
                    vf.w(x,y,z) = vf.w(x,y,z) + t_speed;
                end
            end
        end
    end
end

%hold on;
camproj perspective; camva(8)
[sx sy sz] = meshgrid(1,1:10:vf.size,1:10:vf.size);
verts = stream3(vf.x,vf.y,vf.z,vf.u,vf.v,vf.w,sx,sy,sz);
hlines = streamline(verts);
%iverts = interpstreamspeed(vf.x, vf.y, vf.z, vf.u, vf.v, vf.w, verts, .05);
%axis tight;
%view(30, 30)
%view(2)
%set(gca,'DrawMode', 'fast', 'Position', [0 0 1 1], 'ZLim', [4.9 5.1]);
daspect([1 1 1])
figure

end






%%%%%%%%%%%------OLD------%%%%%%%%%%%%




%box on
%streamparticles(iverts, 35, 'animate', 100, 'FrameRate', 40, 'ParticleAlignment', 'on')


%[verts averts] = streamslice(vf.x,vf.y,vf.z,vf.u,vf.v,vf.w,[],[],[5]);
%sl = streamline([verts averts]);
%iverts = interpstreamspeed(vf.x, vf.y, vf.z, vf.u, vf.v, vf.w, verts, .005);
%set(sl,'Visible', 'off');
%set(gcf, 'Color', 'black');
%streamparticles(iverts, 200, ...
%        'Animate', 100, 'FrameRate', 40, ...
%        'MarkerSize', 10, 'MarkerFaceColor', 'yellow');
%[verts averts] = streamslice(vf.u, vf.v, vf.w, [], [], [5]);

%!!Really slow and inefficient for viz!!
%quiver3(vf.x, vf.y, vf.z, vf.u, vf.v, vf.w, 1);
%wind_spd = sqrt(vf.u.^2 + vf.v.^2 + vf.w.^2);
%slice(wind_spd,[],[],[5]);
%colormap(jet);
%shading interp
%camlight;sqrt((xy(1)-x).^2 + (xy(2)-y).^2)
