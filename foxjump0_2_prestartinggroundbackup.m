%fox jump game

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
global ispara;
ispara = true;

score = 0;
g = 9.81;
neverpara = false;
onlyticonce = false;

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
y = jump1(80,jumpsmooth,g);


%-------------------------------Assets------------------------------------%
mainbg = imread('.\Assets\art\bin\skyspan1.png');
auximg = mainbg;
bg = imagesc(-257,0,flip(auximg,1));

frame = 1; frametic = 1;
ticrate = 3; %periods per sprite animation frame

spritedata = [];
alphadata = [];
spritedatadie = [];
alphadatadie = [];
paradata = [];
alphaparadata = [];
para = [];

%main sprite
[spritedata, alphadata] = spriteload('.\Assets\art\bin\foxidle', 'x2', '.png', 9);
for n = 1:1:9
    auxsprite(:,:,:,n) = spritedata(:,:,:,n);
    auxalphachannel(:,:,:,n) = alphadata(:,:,:,n);
end
[spritey, spritex, channels, frames] = size(spritedata);
sprite = imagesc('XData',[(aspect(1)/2) - spritex/2, (aspect(1)/2) + spritex/2], ...
                 'YData',[(aspect(2)/2) - spritey/2, (aspect(2)/2) + spritey/2], ...
                 'CData',flip(spritedata(:,:,:,1),1), ...
                 'AlphaData',flip(alphadata(:,:,:,1),1));

%defeat sprite
[spritedatadie, alphadatadie] = spriteload('.\Assets\art\bin\foxdie', 'x2', '.png', 1);
auxspritedie = spritedatadie;
auxalphachanneldie = alphadatadie;
[spriteydie, spritexdie, channels] = size(spritedatadie); 

%parachute sprite
[paradata, alphaparadata] = spriteload('.\Assets\art\bin\parachute', 'x2', '.png', 1);
auxpara = paradata;
auxalphapara = alphaparadata;
[paray, parax, channels] = size(paradata);

hold on


%------------------------------Game Loop----------------------------------%

%Generate platform field
xpf = [];
ypf = [];
platformrecord = [];
pfwidth = 48;
pfheight = 16;
npf = 50;               %no. of platforms
pfd = 60;               %mean distance between platforms

for n = 1:1:npf
    hold on
    xpf = [xpf randi(floor(aspect(1)*1.1))];
    ypf = [ypf randi(30)];
    platformcentre = [xpf(n), (aspect(2)/2 + ypf(n)+pfd*(n-1))];
    pf(n) = pfgen(pfwidth,pfheight);
    drawnow
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
    
    spriteposxc = (aspect(1)/2)+camera(1);
    spriteposyc = (aspect(2)/2)+camera(2)+y(yveln);
    spriteposx = [spriteposxc - spritex/2, spriteposxc + spritex/2];
    spriteposy = [spriteposyc - spritey/2, spriteposyc + spritey/2];
    paraposxc = (aspect(1)/2)+camera(1);
    paraposyc = (aspect(2)/2)+camera(2)+y(yveln)+20;
    paraposx = [paraposxc - parax/2, paraposxc + parax/2];
    paraposy = [paraposyc - paray/2, paraposyc + paray/2];
    
    %check nearest platform
    [d, pfindex] = min(abs(spriteposy(1) - platformrecord(:,2)));
    %score counter
    if pfindex - 1 > score
        score = pfindex - 1;
    end
    %platform noclip conditions
    if d <= 25 && abs(spriteposxc - platformrecord(pfindex,1)) <= 34 && yveln > jumpsmooth
        camera(2) = y(yveln) + camera(2);
        spriteposy = platformrecord(pfindex,2)+spritey/4;
        yveln = 2*jumpsmooth;
        ispara = false;
        delete(para)
        
    %defeat condition
    %pop parachute when too low
    elseif axes(3) + aspect(2) < abs(platformrecord(pfindex,2))
        ispara = false;
        neverpara = true;
        delete(para)
        
        if onlyticonce == false
            tpop = tic;
            onlyticonce = true;
        end
        tocpop = toc(tpop);
        asplat = g;
        vsplat = asplat*tocpop/(9*period);
        camera(2) = camera(2)-vsplat*tocpop/(9*period)-10;
        
        if camera(2)+aspect(2) < 0 
            text((aspect(1)/2)-120+camera(1),(aspect(2)/2)+(2*pfd)+camera(2),"Game over...", ...
                 'Color','white','FontSize',30,'FontName','Chihaya Jyun','FontWeight','bold')
            text((aspect(1)/2)-60+camera(1),(aspect(2)/2)+pfd+camera(2),strcat("Score: ", num2str(score)), ...
                 'Color','white','FontSize',20,'FontName','Chihaya Jyun','FontWeight','bold')

            %replace with dead sprite
            delete(sprite)
            delete(para)
            if face == "right"
                alphachanneldie = auxalphachanneldie;
                spritedie = imagesc('XData',spriteposx, ...
                                    'YData',spriteposy, ...
                                    'CData',flip(spritedatadie,1), ...
                                    'AlphaData',flip(alphadatadie,1));
            elseif face == "left"
                spritedie = flip(auxspritedie,2);
                alphachanneldie = flip(auxalphachanneldie,2);
                spritedie = imagesc('XData',spriteposx, ...
                                    'YData',spriteposy, ...
                                    'CData',flip(flip(spritedatadie,1),2), ...
                                    'AlphaData',flip(flip(alphadatadie,1),2));
            end
            break;
        end
    
    %freefall
    elseif neverpara == true 
        tocpop = toc(tpop);
        asplat = g;
        vsplat = asplat*tocpop/(9*period);
        camera(2) = camera(2)-vsplat*tocpop/(9*period)-10;
    else
        delete(para)
        camera(2) = camera(2)-10;
        alphapara = auxalphapara;
        if ispara == true
            para = imagesc('XData',paraposx, ...
                           'YData',paraposy, ...
                           'CData',flip(paradata,1), ...
                           'AlphaData',flip(alphaparadata,1));
        end
    end
    if y(yveln) == 0 && neverpara == false
        ispara = true;
    end
    axes = [0+camera(1), aspect(1)+camera(1), 0+camera(2) + y(yveln), aspect(2)+camera(2) + y(yveln)];
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
           platformrecord(n,:) = [0 -500];
        end
    end
    
    %victory/loss conditions
    if camera(2) > pfd*(npf-1)-3
        text((aspect(1)/2)-80+camera(1),(aspect(2)/2)+pfd*(npf+2),"You win!", ...
             'Color','white','FontSize',30,'FontName','Chihaya Jyun','FontWeight','bold')
        text((aspect(1)/2)-60+camera(1),(aspect(2)/2)+pfd*(npf+1),strcat("Score: ", num2str(npf)), ...
             'Color','white','FontSize',20,'FontName','Chihaya Jyun','FontWeight','bold') 
        break
    end
end
