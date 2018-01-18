function [nI, snI] = getColorExact(scr_mask, ntscIm)

[n, m] = size(ntscIm);
lin_sz = n*m;

%>Initializes output with input luminance
nI(:,:,1) = ntscIm(:,:,1);

%Create matrix with linear indexes
idxs_M = reshape((1:lin_sz), n, m);
mask_idxs = find(scr_mask);

wd=1; 
len=0;
consts_len=0;
col_idxs = zeros(lin_sz*(2*wd+1)^2,1);
row_idxs = zeros(lin_sz*(2*wd+1)^2,1);
vals=zeros(lin_sz*(2*wd+1)^2,1);
gvals=zeros(1,(2*wd+1)^2);


for j=1:m
   for i=1:n
      consts_len=consts_len+1;
      
      if (~scr_mask(i,j))   
        tlen=0;
        for ii=max(1,i-wd):min(i+wd,n)
           for jj=max(1,j-wd):min(j+wd,m)
            
              if (ii~=i)|(jj~=j)
                 len=len+1; tlen=tlen+1;
                 row_idxs(len)= consts_len;
                 col_idxs(len)=idxs_M(ii,jj);
                 gvals(tlen)=ntscIm(ii,jj,1);
              end
           end
        end
        t_val=ntscIm(i,j,1);
        gvals(tlen+1)=t_val;
        c_var=mean((gvals(1:tlen+1)-mean(gvals(1:tlen+1))).^2);
        csig=c_var*0.6;
        mgv=min((gvals(1:tlen)-t_val).^2);
        if (csig<(-mgv/log(0.01)))
	   csig=-mgv/log(0.01);
	end
	if (csig<0.000002)
	   csig=0.000002;
        end

        gvals(1:tlen)=exp(-(gvals(1:tlen)-t_val).^2/csig);
        gvals(1:tlen)=gvals(1:tlen)/sum(gvals(1:tlen));
        vals(len-tlen+1:len)=-gvals(1:tlen);
      end

        
      len=len+1;
      row_idxs(len)= consts_len;
      col_idxs(len)=idxs_M(i,j);
      vals(len)=1; 

   end
end

       
vals=vals(1:len);
col_idxs=col_idxs(1:len);
row_idxs=row_idxs(1:len);


A=sparse(row_idxs,col_idxs,vals,consts_len,lin_sz);
b=zeros(size(A,1),1); %SVD ?


for t=2:3
    curIm=ntscIm(:,:,t);
    b(mask_idxs)=curIm(mask_idxs);
    new_vals=A\b;   
    nI(:,:,t)=reshape(new_vals,n,m,1);    
end



snI=nI;
nI=ntsc2rgb(nI);

