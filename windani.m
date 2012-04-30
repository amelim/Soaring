load wind
daspect([1 1 1]);
view(2)
[verts averts] = streamslice(x,y,z,u,v,w,[],[],[5]);
sl = streamline([verts averts]);
axis tight off;
set(sl,'Visible', 'off');
iverts = interpstreamspeed(x,y,z,u,v,w,verts,.05);
set(gca,'DrawMode', 'fast', 'Position', [0 0 1 1], 'ZLim', [4.9 5.1]);
set(gcf, 'Color', 'black');
streamparticles(iverts, 200, ...
        'Animate', 100, 'FrameRate', 40, ...
        'MarkerSize', 10, 'MarkerFaceColor', 'yellow');
