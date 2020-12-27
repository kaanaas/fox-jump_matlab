function image = bgmoveud(image,n)
%relocates n pixels of a given (seamless) image array up or down.

    tempslice = image(end-n:end,:,:);
    image = [tempslice
             image(1:end-n-1,:,:)];