function [spritedata, alphadata] = spriteload(path,scale,filetype,m)
%spriteload(path\name (folder), scale (eg x2), filetype (eg .png), number of frames)

spritedata = [];
alphadata = [];

for n = 1:1:m
    [charsprite, map, alphachannel] = imread(strcat(path,num2str(n),scale,filetype));
    spritedata = cat(4,spritedata,charsprite);
    alphadata = cat(4,alphadata,alphachannel);
end