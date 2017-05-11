function[el,az,roll] = trans2euler(trans)

el = 0;
az = 0;
roll = 0;

el = asin(-trans(1,3));
az = atan2(trans(1,2), trans(1,1));
roll = atan2(