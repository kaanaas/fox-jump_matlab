function shapetlate = translate(shape,a,b)
%translates a given shape right by a and up by b.

shapetlate(1,:) = shape(1,:)+a;
shapetlate(2,:) = shape(2,:)+b;