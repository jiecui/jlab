function valid
counter=1
max=0;
index=1;
totdist=0;
load('D:\KelsR\Data\101_3.vr');
x=X101_3;
[a,b]=size(x)
while(counter<3)   
while(x(index,1)~= -1003)
   index=index+1;
end;
index=index+2;
fline=index-1;
while(x(index,1)== 1)
   dist=sqrt((x(index,3)-x((fline),3))^2+(x(index,4)-x((fline),4))^2+(x(index,5)-x((fline),5))^2);
   if(dist>max)
      max=dist
   end;
end;
index=index+1;
max
counter=counter+1
end;