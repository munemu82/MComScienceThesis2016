%The Histogram Equalization algorithm enhances the contrast of images by
%transforming the values in an intensity image so that the histogram of 
%the output image is approximately flat.
I = imread('010001.jpg');
J = histeq(I,hgram);
subplot(2,2,1);
imshow( I );
subplot(2,2,2);
imhist(I)
subplot(2,2,3);
imshow( J );
subplot(2,2,4);
imhist(J)