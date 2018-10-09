function w=window2(N,M,w_func)

wc=window(w_func,N);
wr=window(w_func,M);
[maskr,maskc]=meshgrid(wr,wc);

%maskc=repmat(wc,1,M); Old version
%maskr=repmat(wr',N,1);

w=maskr.*maskc;

end
