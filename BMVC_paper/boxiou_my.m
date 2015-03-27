function iou = boxiou(l1,t1,w1,h1,l2,t2,w2,h2) 
a = max([l1 t1; l2 t2]);
b = min([l1+w1,t1+h1;l2+w2, t2+h2]);
i = max(b(1)-a(1),0)*max(b(2)-a(2));
iou = i/(w1*h1+w2*h2-i);