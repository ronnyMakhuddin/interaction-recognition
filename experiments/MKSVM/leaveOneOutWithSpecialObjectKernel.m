function [ accuracy, predictedValues] = leaveOneOutWithSpecialObjectKernel( kernel,groundTruth,C,method)
%LEAVEONEOUT Perform leave-one-out cross validation
%   Detailed explanation goes here

%kernel=getKernel('gaussianAlignment',sigma);

n=length(groundTruth);
nClasses=6;
predictedValues=zeros(n,nClasses);

m=size(kernel,3);
% for i=1:n
%     for j=1:m
%         if (isa(kernel{j},'double'))
%             x=kernel{j}(i,:);
%             x(i)=[];
%             X{j,i}=x;
%
%         end
%     end
% end
display(method);

load KobjGroundTruth.mat;

for i=1:n
    predictors=cell(nClasses,1);
    
    
    smallKernel=kernel;
    %for j=1:m
    test=squeeze(smallKernel(i,:,:));
    test(i,:)=[];
    smallKernel(i,:,:)=[];
    smallKernel(:,i,:)=[];
    
    KobjSpecial=KobjGroundTruth;
    KobjSpecial(i,:)=[];
    KobjSpecial(:,i)=[];
    
    smallKernel(:,:,end)=KobjSpecial;
    clearvars KobjSpecial;
    
    %fprintf('Current iteration %i out of %i \n',i,n);
    for k=1:nClasses
        
        % set up ground truth
        
        y=-ones(1,n);
        y(groundTruth==k)=1;
        
        
        
        %end
        
        y(i)=[];
        
        [predictors{k,1}]=trainSVMonlyKernel( smallKernel,y',C,method);
        predictedValues(i,k)=predictors{k,1}(test);
        %fprintf('value for the %i classifier %g \n',k,predictedLabels(i,k));
        
    end
    
end
% find max labels
[~,b]=max(predictedValues,[],2);
% find accuracy
accuracy=length(find(b==groundTruth'))/n;

end
