function vf = thermal(vf)
t_height = 30; 
%Random positions for 4 thermals
t_xy = randi([-40 40],2,vf.nt);
%Random raius for thermals
t_r = randi([-2 2],1,4) + 10;

for x = 1:vf.detail:vf.size
	for y = 1:vf.detail:vf.size
		for z = 1:vf.detail:vf.size
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


end
