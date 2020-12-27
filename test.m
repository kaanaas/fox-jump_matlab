%doodle game

%--------------------------------Credits----------------------------------%
% WRITTEN by    - daniel
% ASSETS/ART by - backgrounds: vnitti
%               - character sprite: hdst
%               - platforms: RottingPixels & daniel
%


%---------------------------------Setup-----------------------------------%
clear; clc; close all;

%globals
global platformcentre;
platformcentre = [];
global camera;
camera = [0 0];
global period;
period = 0.05;
global jumpsmooth;
jumpsmooth = 15;
global yveln;
yveln = 2*jumpsmooth;
global face;
face = "right";

%construct figure window
aspect = [512 768];
screensize = get(0,'ScreenSize');
outsize = [(screensize(3)/2 - aspect(1)/2), (screensize(4)/2 - aspect(2)/2), aspect(1), aspect(2)];
insize = [0 0 aspect(1) aspect(2)];
gameFigure = figure('Color',[.416 .69 .855], ...
                    'Name','Doodle Test', ...
                    'NumberTitle','off', ...
                    'MenuBar','none', ...
                    'Position',insize, ...
                    'OuterPosition',outsize, ...
                    'KeyPressFcn',@controls);

%define axes to game container size
haxis = axes('units','normalized', ...
             'position',[0 0 1 1]);
uistack(haxis,'bottom');
axes = [0+camera(1), aspect(1)+camera(1), 0+camera(2), aspect(2)+camera(2)];
axis(axes)
axis off
hold on

%Jump calculation
y = jump1(80,jumpsmooth,9.81);


%-------------------------------Assets------------------------------------%
mainbg = imread('.\Assets\art\bin\skyspan1.png');
auximg = mainbg;
bg = imagesc(-257,0,flip(auximg,1));

frame = 1; frametic = 1;
ticrate = 3; %periods per sprite animation frame

spritedata = [];
alphadata = [];
[spritedata, alphadata] = spriteload('.\Assets\art\bin\foxidle', 'x2', '.png');
for n = 1:1:9
    auxsprite(:,:,:,n) = spritedata(:,:,:,n);
    auxalphachannel(:,:,:,n) = alphadata(:,:,:,n);
end
[spritey, spritex, channels, frames] = size(spritedata);
sprite = imagesc('XData',[(aspect(1)/2) - spritex/2, (aspect(1)/2) + spritex/2], ...
                 'YData',[(aspect(2)/2) - spritey/2, (aspect(2)/2) + spritey/2], ...
                 'CData',flip(spritedata(:,:,:,1),1), ...
                 'AlphaData',flip(alphadata(:,:,:,1),1));
                 

hold on


%------------------------------Game Loop----------------------------------%

%Generate platform field
xpf = [];
ypf = [];
platformrecord = [];
pfwidth = 48;
pfheight = 16;
npf = 5;

for n = 1:1:npf
    hold on
    xpf = [xpf randi(floor(aspect(1)*1.1))];
    ypf = [ypf randi(30)];
    platformcentre = [xpf(n) ypf(n)+70*(n-1)];
    pf(n) = pfgen(pfwidth,pfheight);
    platformrecord = [platformrecord; platformcentre];
end

%Animation
k = 1;
while k == 1
%     auximg = bgmoveud(auximg,scrollspeed);    %was bg scroll animator
%     imagesc(flip(auximg,1));
    pause(period)
    
    if yveln < 2*jumpsmooth
        yveln = yveln+1;
    end
    
    spriteposxc = (aspect(1)/2)+camera(1)
    spriteposyc = (aspect(2)/2)+camera(2)+y(yveln)
    spriteposx = [spriteposxc - spritex/2, spriteposxc + spritex/2];
    spriteposy = [spriteposyc - spritey/2, spriteposyc + spritey/2];
    posy_ = floor(spriteposy)
    
    
    %check platform noclip conditions
    [d, pfindex] = min(abs(spriteposy(1) - platformrecord(:,2)));
    if d <= 25 && abs(spriteposxc - platformrecord(pfindex,1)) <= 34 && yveln > jumpsmooth
        axes = [0+camera(1), aspect(1)+camera(1), 0+camera(2) + y(yveln), aspect(2)+camera(2) + y(yveln)];
        camera(2) = y(yveln) + camera(2);
        spriteposy = platformrecord(pfindex,2);
        yveln = 2*jumpsmooth; 
    elseif camera(2)+aspect(2)/2 < 0
        axes = [0+camera(1), aspect(1)+camera(1), 0+camera(2)+y(yveln), aspect(2)+camera(2)+y(yveln)];
    else
        axes = [0+camera(1), aspect(1)+camera(1), 0+camera(2)+y(yveln), aspect(2)+camera(2)+y(yveln)];
        camera(2) = camera(2)-10
        collogy = 0;
    end
    
    axis(axes);

    
    %sprite animation
    if frametic < ticrate
        frametic = frametic + 1;
    else
        frametic = 1;
    end
    
    if frametic == ticrate && frame < 9
        frame = frame + 1;
    elseif frametic == ticrate && frame == 9
        frame = 1;
    end
    
    delete(sprite)
    if face == "right"
        alphachannel(:,:,:,frame) = auxalphachannel(:,:,:,frame);
        sprite = imagesc('XData',spriteposx, ...
                         'YData',spriteposy, ...
                         'CData',flip(spritedata(:,:,:,frame),1), ...
                         'AlphaData',flip(alphadata(:,:,:,frame),1));
    elseif face == "left"
        sprite = flip(auxsprite(:,:,:,frame),2);
        alphachannel(:,:,:,frame) = flip(auxalphachannel(:,:,:,frame),2);
        sprite = imagesc('XData',spriteposx, ...
                         'YData',spriteposy, ...
                         'CData',flip(flip(spritedata(:,:,:,frame),1),2), ...
                         'AlphaData',flip(flip(alphadata(:,:,:,frame),1),2));
    end
    
    %despawn below platforms when too high
    for n = 1:1:npf
        if platformrecord(n,2) < camera(2)-pfheight
           delete(pf(n));
        end
    end
    
    if camera(2) > 70*(npf-5)
        text((aspect(1)/2)-60,(aspect(2)/2)+70*(npf-4),"You won!", ...
             'Color','white','FontSize',20,'FontName','Chihaya Jyun','FontWeight','bold')
        break
    end
end


%------------------------------Functions----------------------------------%
