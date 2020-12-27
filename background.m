%background

%construct figure window
screensize = get(0,'ScreenSize');
outsize = [((screensize(3)*1.1)-screensize(3))/2 ((screensize(4)*1.1)-screensize(4))/2 screensize(3)*0.9 screensize(4)*0.9];
insize = [0 0 screensize(3) screensize(4)];
figure('Name','Game_Name', ...
       'NumberTitle','off', ...
       'MenuBar','none', ...
       'Position',insize, ...
       'OuterPosition',outsize);

%define axes to game container size
axis ij;
axis([0,2160,0,1080])
axis off
   
%background scroll speed settings
%make scrollspeed and p smaller for smoother animation
%product should be ~0.2
scrollspeed = 8;
p = 0.025;

%load image assets
main = imread('./Assets/art/cartoon-country-landscape-animation-loop-footage.jpeg');
auximg = main;

%estop button to kill process
estop = uicontrol('Style', 'PushButton', ...
                  'String', 'Kill program', ...
                  'Callback', 'delete(gcbf)');
              
%scroll animation
for k = 1:inf
    auximg = bgmove(auximg,scrollspeed);
    image('XData',0,'YData',0,'CData',auximg);
    
    if ~ishandle(estop)
        error('Force stopped by user');
    end
    pause(p)
    
end
