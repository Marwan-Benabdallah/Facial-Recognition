load fisheriris
MdlLinear = fitcdiscr(meas,species);
meanmeas = mean(meas);
meanclass = predict(MdlLinear,meanmeas)
MdlQuadratic = fitcdiscr(meas,species,'DiscrimType','quadratic');
meanclass2 = predict(MdlQuadratic,meanmeas)

accuracy = sum((predictedLabels == testLabels))/length(testLabels)*100;