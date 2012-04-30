%Here we wish to train our HMMs on non-noisy datasets for each type of thermal
%Andrew Melim
addpath([pwd, '/HMMall/HMM']);
addpath([pwd, '/HMMall/KPMstats']);
addpath([pwd, '/HMMall/KPMtools']);
addpath([pwd, '/HMMall/netlab3.3']);


%Size of the VectorField in all axis
vf.size = 40;
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
t_xy = randi([0 vf.size],2,vf.nt);
%Training location
%t_xy = [10;10]
%Random raius for thermals
%t_r = randi([-2 2],1,vf.nt) + 10;
t_r = 8; 
t_speed = 5;
%%--WAVES--%%
%Width
w_w = 20;
%Height
w_h = 20;
%Depth
w_d = 5;
%Determine bottom left corner of vector
w_xy = randi([0 vf.size],2,vf.nw);
%w_xy = [0;0];


%%--BUBBLES--%%
b_xy = randi([0 vf.size],3,vf.nb);
%b_xy = [10;10;5];
b_r = 5;


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
                    vf.w(x,y,z) = vf.w(x,y,z) + t_speed;
                elseif(d < t_r(t).*1.5)
                    vf.w(x,y,z) = vf.w(x,y,z) - t_speed - 2;
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

camproj perspective; camva(8)
[sx sy sz] = meshgrid(1,1:2:vf.size,1:2:vf.size);
verts = stream3(vf.x,vf.y,vf.z,vf.u,vf.v,vf.w,sx,sy,sz);
hlines = streamline(verts);
%[verts averts] = streamslice(vf.x,vf.y,vf.z,vf.u,vf.v,vf.w,[],[],[5]);


%Discretization
% < - 3 is strong decline = 1 
% < 0 is decline = 2 
% 0 = flat = 3
% > 0 is climb = 4
% > 4 is strong climb = 5
vfd = vf;
for x = 1:vf.detail:vf.size
	for y = 1:vf.detail:vf.size
		for z = 1:vf.detail:vf.size
			if vf.w(x,y,z) < -3
				vfd.w(x,y,z) = 1;
            elseif vf.w(x,y,z) < 0
                vfd.w(x,y,z) = 2;
            elseif vf.w(x,y,z) == 0
                vfd.w(x,y,z) = 3;
            elseif vf.w(x,y,z) < 4 
                vfd.w(x,y,z) = 4;
            else
            	vfd.w(x,y,z) = 5;
            end
        end
    end
end



%Number of states for a behavior
%Three for chimney (DOWN - STRONG UP - DOWN)
O = 5;
Qs = [5,6,3];

%Four for wave (UP - FLAT - DOWN - FLAT)
%There are 3 behaviors
%    data = [];
%    Q = 3;
	%We want 20 training sequences
	%nex = 20
    %for i = 1:nex
        %data = [data vfd.w(:,i,10)];
    %end
    %prior0 = normalise(rand(Q,1));
    %transmat0 = mk_stochastic(rand(Q,Q));
    %obsmat0 = mk_stochastic(rand(Q,O));
    %[LL, prior3, transmat3, obsmat3] = dhmm_em(data, prior0, transmat0, obsmat0, 'max_iter', 10)

