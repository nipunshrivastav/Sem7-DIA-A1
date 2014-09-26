% Nipun Shrivastava 2011cs50288
% CSL783 Assignment 1
% Corner Detection in Images
% Declaration - This assignment has been done by me.

function C = hrs(I, sigma1, sigma2, w, k)


if(size(I,3)==1)
    I1 = double((I))/255;
else
    I1 = double(rgb2gray(I))/255;
end

[row, col] = size(I1);
% extracting size of image


fltrdImg = bfilter2(I1,w,[sigma1 sigma2]);
% filtering image

xDerMask = [-1 0 1;-1 0 1;-1 0 1];
yDerMask = [-1 -1 -1;0 0 0;1 1 1];
% define masks to calc x and y gradients

Ix = conv2(fltrdImg,xDerMask,'same');
Iy = conv2(fltrdImg,yDerMask,'same');
% calculating gradients along x and y

Ix2 = Ix.*Ix;
Iy2 = Iy.*Iy;
Ixy = Ix.*Iy;
% Products of gradient

sumMask =  fspecial('gaussian', [9 9], 3);
% Gaussian Mask

Sx2 = conv2(Ix2,sumMask,'same');
Sy2 = conv2(Iy2,sumMask,'same');
Sxy = conv2(Ixy,sumMask,'same');
% Sum of products

for i = drange(1:row)
    for j = drange(1:col)
        R(i,j) =  Sx2(i,j)*Sy2(i,j) - Sxy(i,j)*Sxy(i,j) - k*((Sx2(i,j)+Sy2(i,j)^2));
    end
end
% Loop to find response at each pixel


Rmaxima = zeros(row,col);
% only keeps the local maxima

for i = drange(2:row-1)
    for j = drange(2:col-1)
        if ((R(i,j)>R(i-1,j-1)) && (R(i,j)>R(i-1,j)) && (R(i,j)>R(i-1,j+1)) && (R(i,j)>R(i,j-1)) && (R(i,j)>R(i,j+1)) && (R(i,j)>R(i+1,j-1)) && (R(i,j)>R(i+1,j)) && (R(i,j)>R(i+1,j+1)))
            Rmaxima(i,j) = R(i,j);
        end
    end
end

for i = 1
    for j = drange(3:col-2)
        if ((R(i,j)>R(i,j-1)) && (R(i,j)>R(i,j+1)) && (R(i,j)>R(i+1,j-1)) && (R(i,j)>R(i+1,j)) && (R(i,j)>R(i+1,j+1)))
            Rmaxima(i,j) = R(i,j);
        end
    end
end

for i = row
    for j = drange(3:col-2)
        if ((R(i,j)>R(i-1,j-1)) && (R(i,j)>R(i-1,j)) && (R(i,j)>R(i-1,j+1)) && (R(i,j)>R(i,j-1)) && (R(i,j)>R(i,j+1)))
            Rmaxima(i,j) = R(i,j);
        end
    end
end

for j = 1
    for i = drange(3:row-2)
        if ((R(i,j)>R(i-1,j)) && (R(i,j)>R(i-1,j+1)) && (R(i,j)>R(i,j+1)) && (R(i,j)>R(i+1,j)) && (R(i,j)>R(i+1,j+1)))
            Rmaxima(i,j) = R(i,j);
        end
    end
end

for j = col
    for i = drange(3:row-2)
        if ((R(i,j)>R(i-1,j-1)) && (R(i,j)>R(i-1,j)) && (R(i,j)>R(i,j-1)) && (R(i,j)>R(i+1,j-1)) && (R(i,j)>R(i+1,j)))
            Rmaxima(i,j) = R(i,j);
        end
    end
end

for i = drange(1:5)
    for j = drange(1:5)
        Rmaxima(i,j) = -10;
    end
end

for i = drange(1:5)
    for j = drange(col:-1:col-4)
        Rmaxima(i,j) = -10;
    end
end

for i = drange(row:-1:row-4)
    for j = drange(col:-1:col-4)
        Rmaxima(i,j) = -10;
    end
end


for i = drange(row:-1:row-4)
    for j = drange(1:5)
        Rmaxima(i,j) = -10;
    end
end

m = 1;
% index for corners

for i = drange(1:row)
    for j = drange(1:col)
        if (Rmaxima(i,j)>0)
            C(m,1) = j;
            C(m,2) = i;
            m = m+1;
        end
    end
end
% Detecting corners

m-1
% Printing number of corners

figure, imshow(I);
hold on
plot(C(:,1), C(:,2), 'r*'); % Detected corners are plotted on the image