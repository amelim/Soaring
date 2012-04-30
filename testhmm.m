vft = vf;
for x = 1:vf.detail:vf.size
	for y = 1:vf.detail:vf.size
		for z = 1:vf.detail:vf.size
			if vf.w(x,y,z) < -3
				vft.w(x,y,z) = 1;
            elseif vf.w(x,y,z) < 0
                vft.w(x,y,z) = 2;
            elseif vf.w(x,y,z) == 0
                vft.w(x,y,z) = 3;
            elseif vf.w(x,y,z) < 4 
                vft.w(x,y,z) = 4;
            else
            	vft.w(x,y,z) = 5;
            end
        end
    end
end
%One chimney found 30:90
%None in 60:90
LL1 = [];
LL2 = [];
LL3 = [];
count1 = 0;
count2 = 0;
count3 = 0;
%for z = 1:vf.detail:vf.size
for y = 1:vf.detail:vf.size
    data = vft.w([1:40],y,15);
    ll1 = dhmm_logprob(data, prior1, transmat1, obsmat1);
    if ll1 > -40
    	'Found Chimney'
    end
    ll2 = dhmm_logprob(data, prior2, transmat2, obsmat2);
    if ll2 > -40
    	'Found waves'
    end
    ll3 = dhmm_logprob(data, prior3, transmat3, obsmat3);
    if ll3 > -40
    	'Found bubble'
    end
    LL1 = [LL1 ll1];
    LL2 = [LL2 ll2];
    LL3 = [LL3 ll3];
%end
end
hold on
plot(LL1,'b', 'LineWidth',3);
plot(LL2,'r', 'LineWidth',3);
plot(LL3,'k', 'LineWidth',3);
