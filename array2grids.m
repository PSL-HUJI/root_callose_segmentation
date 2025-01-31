function outCell=array2grids(inArray,varargin)

gridSizes=[varargin{:}];

N=length(gridSizes);

Nmax=ndims(inArray);

if N<Nmax
   
    gridSizes=[gridSizes,inf(1,Nmax-N)];
    
    
elseif N>Nmax    
    
    gridSizes=gridSizes(1:Nmax);
    
end
N=Nmax;

C=cell(1,N);

for ii=1:N %loop over the dimensions
    
 dim=size(inArray,ii);
 T=min(dim, gridSizes(ii));
 
 if T~=floor(T) || T<=0
     error 'Grid dimension must be a strictly positive integer or Inf'
 end
 
 nn=( dim / T );
   nnf=floor(nn);
 
 resid=[];
 if nnf~=nn 
    nn=nnf;
    resid=dim-T*nn;
 end
 
 C{ii}=[ones(1,nn)*T,resid];    
    
    
end

outCell=mat2cell(inArray,C{:});