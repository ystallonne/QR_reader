function [ new_coordinates ] = transformPerspective( u , v , img )
%transformPerspective Performs the perspective transformation
%   input arguments: vector with x-coordinates, vector with y-coordinates
%   and the image
%
%   output: the transformed coordinates

image_gray = img;
figure

imshow(image_gray);
title('IM trans');

size_image = size(image_gray);

u0 = u(1);  
v0 = v(1);

u1 = u(2);
v1 = v(2);

u2 = u(3);
v2 = v(3);

u3 = u(4);
v3 = v(4);

x0 = 1;
y0 = 1;

x1 = 501;
y1 = 1;

x2 = 1;
y2 = 501;

x3 = 501;
y3 = 501;

u = [u0 u1 u2 u3].';
v = [v0 v1 v2 v3].';
x = [x0 x1 x2 x3].';
y = [y0 y1 y2 y3].';
a = zeros(8,1);

u_x = [u(1)*x(1) u(2)*x(2) u(3)*x(3) u(4)*x(4)].';
v_x = [v(1)*x(1) v(2)*x(2) v(3)*x(3) v(4)*x(4)].';
u_y = [u(1)*y(1) u(2)*y(2) u(3)*y(3) u(4)*y(4)].';
v_y = [v(1)*y(1) v(2)*y(2) v(3)*y(3) v(4)*y(4)].';

correspondance_matrix = [u v ones(4,1) zeros(4,3) -u_x -v_x; zeros(4,3) u v ones(4,1) -u_y -v_y];

a = inv(correspondance_matrix)*[x;y];

transformation_matrix = [a(1) a(4) a(7); a(2) a(5) a(8); a(3) a(6) 1];

new_coordinates = ones(size_image(1),size_image(2)); %ones to get white missing pixels

primes = zeros(1,3);

for i = 1:size_image(1)
    for j = 1:size_image(2)
        primes = [i j 1]*transformation_matrix;
        x_new = primes(1)./primes(3);
        y_new = primes(2)./primes(3);
        
        x_new = round(x_new);
        y_new = round(y_new);

        if (x_new > 0) & (y_new > 0)      
            new_coordinates(x_new,y_new) = image_gray(i,j);             
        end
    end
end
      
figure('name','transformed perspective')
imshow(new_coordinates);

end

