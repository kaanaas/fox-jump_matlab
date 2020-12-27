function image = bgmovelr(image,n)
%translates n pixels of a given (seamless) image array left by a.

tempslice = image(:,1:n,:);
image = [image(:,n+1:end,:), tempslice];