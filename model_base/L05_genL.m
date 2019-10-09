%modelresolution=960
function L=L05_genL(modelresolution,Radius)
local=zeros(1,modelresolution);
%Radius=20;

for i=1:modelresolution
 local(i)=exp((-(i-modelresolution/2)^2)/(2*(Radius)^2));
end
 local(local<0.001)=0.;

L=repmat(local,modelresolution,1);

for i=1:modelresolution
 L(i,:)=circshift(L(i,:),[1 i-modelresolution/2]);
end

%save L96_Localization.mat L
