%jumpTEST

%construct figure window
screensize = get(0,'ScreenSize');
outsize = [((screensize(3)*1.1)-screensize(3))/2 ((screensize(4)*1.1)-screensize(4))/2 screensize(3)*0.9 screensize(4)*0.9];
insize = [0 0 screensize(3) screensize(4)];
figure('Name','Game_Name', ...
       'NumberTitle','off', ...
       'MenuBar','none', ...
       'Position',insize, ...
       'OuterPosition',outsize);

    
%square = [0 0 100 100 0; 0 100 100 0 0];
coolsquare(200,25,100,20);

axis([0,2160,0,1080])
axis off
hold off

%call jump
% jump(square,100,3,9.81);

[X,Y,BUTTON] = ginput(1);
%facilitiate continuous jump input
while BUTTON ~= 3
if BUTTON == 32 | BUTTON == 1
    jumppre(100,10,9.81);
end
[X,Y,BUTTON] = ginput(1);
end