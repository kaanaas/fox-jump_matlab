%jumppre causes predefined graphical element to jump up with initial
%velocity u, with smoothness n, and then accelerate back to starting point
%by gravity value g. Recommended smoothness is ~1 per 20 velocity at g =
%9.81.
function jumppre(u,n,g)

gn = g;

%suvat equations
h = u^2/(2*gn);
tau = 2*h/u;

%calculate y transform
t = linspace(0,2*tau,1.6*n);
if t <= tau
    y = u.*t - .5*gn.*(t.^2);
else
    y = h - .5*gn.*((t-tau).^2);
end

for q = 1:1.6*n
    coolsquare(200,25,100,20+y(q));
    axis([0,2160,0,1080])
    axis off
    hold off
    pause(tau/(500*(5*n)))
end

