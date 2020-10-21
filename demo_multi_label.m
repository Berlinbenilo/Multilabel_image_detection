global I
load carlbl.mat
load stoplbl.mat
load zeebralbl.mat
[bboxes1,score1]=detect(acfDetector,I,'SelectStrongest',false);
[bboxes2,score2]=detect(acfDetector1,I,'SelectStrongest',false);
[bboxes3,score3]=detect(acfDetector2,I,'SelectStrongest',false);
labels1 = repelem("stop",numel(score1),1);
labels1 = categorical(labels1,{'stop','car','zeebra'});
labels2 = repelem("car",numel(score2),1);
labels2 = categorical(labels2,{'stop','car','zeebra'});
labels3 = repelem("zeebra",numel(score3),1);
labels3 = categorical(labels3,{'stop','car','zeebra'});
allBBoxes = [bboxes1;bboxes2;bboxes3];
allScores = [score1;score2;score3];
allLabels = [labels1;labels2;labels3];
[bboxes,scores,labels] = selectStrongestBboxMulticlass(allBBoxes,allScores,allLabels,...
    'RatioType','Min','OverlapThreshold',0.65);
annotations = string(labels) + ": " + string(scores);
l = insertObjectAnnotation(I,'rectangle',bboxes,'');
imshow(l)
title('Detected People, Scores, and Labels')
[m,n]=size(scores);
for i=1:m
    if labels(i,1)=='stop'
        s(i,1)=scores(i,1);
        bb(i,:)=bboxes(i,:);
        lbstop(i,1)=labels(i,1);
    elseif labels(i,1)=='car'
        car(i,1)=scores(i,1);
        bbcar(i,:)=bboxes(i,:);
        lbcar(i,1)=labels(i,1);
    elseif labels(i,1)=='zeebra'
        zeebra(i,1)=scores(i,1);
        bbzeebra(i,:)=bboxes(i,:);
        lbzeebra(i,1)=labels(i,1);
    end
end
[p,q]=size(s);
[p1,q1]=size(car)
[p2,q2]=size(zeebra);
[sc1,idx]=max(s);
[sc2,idx1]=max(car);
[sc3,idx3]=max(zeebra);

for i=1:p
    if s(i,1)>80
        bounding(i,1:4)=bb(i,:);
        lab(i,1)=lbstop(i,1);
    else
        bounding(i,1:4)=0;
        lab(i,1)=0;
    end
end
for i=1:p1
    if car(i,1)>40
        bounding1(i,1:4)=bbcar(i,:);
        lab1(i,1)=lbcar(i,1);
    else
        bounding1(i,1:4)=0;
        lab1(i,1)=0;
    end
end
for i=1:p2
    if zeebra(i,1)>30
        bounding2(i,1:4)=bbzeebra(i,:);
        lab2(i,1)=lbzeebra(i,1);
    else
        bounding2(i,1:4)=0;
        lab2(i,1)=0;
    end
end
b1=bb(idx,:);
b2=bbcar(idx1,:);
b3=bbzeebra(idx3,:);
b=[b1;b2;b3];
bound=[bounding;bounding1;bounding2];
labe=[lab;lab1;lab2];
 annotations = string(labe);
% annotation = sprintf('%s: (Confidence = %f)', label(idx), score);
% 
 outputImage = insertObjectAnnotation(I, 'rectangle', bound,'');
figure;
imshow(outputImage)