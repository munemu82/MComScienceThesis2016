%load images
img1 =imread('010001.jpg');
img2 =imread('010084.jpg');
img3 =imread('010005.jpg');
img4 =imread('010060.jpg');
 % create the subplots
 figure;
 h    = [];
 h(1) = subplot(2,2,1);
 h(2) = subplot(2,2,2);
 h(3) = subplot(2,2,3);
 h(4) = subplot(2,2,4);
 
 image(img1,'Parent',h(1));
 image(img2,'Parent',h(2));
 image(img3,'Parent',h(3));
 image(img4,'Parent',h(4));