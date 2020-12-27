function jump(img,h,n,g)
%jump causes element to jump up by h, with smoothness n, and then
%accelerate back to starting point by gravity value g.

%suvat equations
u = sqrt(2*g*h);
tau = u/g;

%calculate y transform
t = linspace(0,2*tau,10*n);
if t <= tau
    y = u.*t - .5*g.*(t.^2);
else
    y = h - .5*g.*((t-tau).^2);
end

for q = 1:10*n
    %img = image('XData',0,'YData',y,'CData',img);
    img2 = translate(img,0,y(q));
    drawshape(img2,'b')
    axis([0,2160,0,1080])
    axis off
    pause(0.05/n)
end

