clc
%clear all %commented so the struct doesn't get recreated every run
close all
format compact

%% Plotting example 

%{
    This is an example of plotting from the struct 'Interested.'  The
    struct is organized into Visual Impairment > Parameter > Take Number >
    Take Data.  
    
    *** Even though 'P7Goggles' has a 'Take4' field, there is no data for
    Take4.  It only has one to make the code a bit simpler.

    All of the data is from the second take (the one on the grass)
%}

Data = readstruct("Interested.json");



figure(1)
    subplot(2,2,1)
    sgtitle("CoM Pos Z for Blindfold")
    plot(Data.Blindfold.CoMPosZ.Take1)
    title("Take1")
    subplot(2,2,2)
    plot(Data.Blindfold.CoMPosZ.Take2)
    title("Take2")
    subplot(2,2,3)
    plot(Data.Blindfold.CoMPosZ.Take3)
    title("Take3")
    subplot(2,2,4)
    plot(Data.Blindfold.CoMPosZ.Take4)
    title("Take4")

    saveas(gcf, 'ExPlot1', 'jpg')

figure(2)
    subplot(3,2,1)
    sgtitle("CoM Pos Z for all impairements' Take 1")
    plot(Data.P6Goggles.CoMPosZ.Take1)
    title("P6Goggles")
    subplot(3,2,2)
    plot(Data.NoGlasses.CoMPosZ.Take1)
    title("No Glasses")
    subplot(3,2,3)
    plot(Data.Regular.CoMPosZ.Take1)
    title("Regular")
    subplot(3,2,4)
    plot(Data.Blindfold.CoMPosZ.Take1)
    title("Blindfold")
    subplot(3,2,5)
    plot(Data.P7Goggles.CoMPosZ.Take1)
    title("P7Goggles")

    saveas(gcf, 'ExPlot2', 'jpg')


