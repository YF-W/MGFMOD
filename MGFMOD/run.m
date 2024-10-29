clear all;
clc;

load('Yale_5_258_3view');

num=length(X);
G = [0.3, 0.5, 0.7];
for i =1:num   
    XS=X{i};  
    numview=length(XS); 
     label=out_label{i};
     [outlier_score] = MGFMOD(XS,G);
     [~, ~, ~, AUC(1,i)] = perfcurve(label, outlier_score,1);
     
end


