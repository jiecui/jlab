function nd=reshape_dat(save_data)
nd = zeros(1999,8,417);
for i=1:97
    nd(:,:,i)=save_data((i-1)*1999+1:i*1999,:);
end