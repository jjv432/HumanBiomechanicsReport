clc
clearvars -except Data
close all
format compact

Data = readstruct('right_shank_data_z.json'); %If workspace empty

%% Finding TO and HS events

%{
    https://www.mdpi.com/2673-1592/4/2/22
    Source that states where to find HS and TO events (good figure
    depicting where to look in the shank angular velocity plots)
%}



%% Finding Guesses for beginning and end of max peak
Peak1 = [
    
    %Blindfold
    750 850
    1200 1350
    900 1000
    700 800

    %P6Goggles
    750     800
    1040    1120
    700     800
    1100    1140

    %NoGlasses
    1080    1140
    1000    1040
    860     900
    760     800

    %Regular
    700 750
    860 920
    570 610
    900 980

    %P7Goggles
    780 820
    800 850
    860 930
    1 2 
];

Peak2 = [
    
    %Blindfold
    1000 1100
    1500 1600    
    1150 1300
    950 1050

    %P6Goggles
    980     1060
    1300    1400
    960     1020
    1320    1360

    %NoGlasses
    1320    1360
    1240    1300
    1100    1140
    1000    1040
    
    %Regular
    940 1000
    1120 1160
    800 860
    1140 1220

    %P7Goggles
    1020 1070
    1040 1100
    1120 1180
    1 2 
    
];

TakeNames = ["Take1", "Take2", "Take3", "Take4"];
ImpairmentNames = ["Blindfold", "P6Goggles", "NoGlasses", "Regular", "P7Goggles"];

%% Finding Max, TO, and HS Indices

for i = 1:length(ImpairmentNames) %Each Impairment
    
    for j = 1:length(TakeNames) %Each Take
            
            %Just for PEAK 1***********************************

            %Finding Max Index
            Beginning = Peak1(j + 4*(i-1),1);
            End = Peak1(j + 4*(i-1),2);
            [MaxValue, MaxIndex] = max(Data.(ImpairmentNames(i)).RightLowerLegZ.(TakeNames(j))(Beginning:End));
            RealMax = MaxIndex + Beginning;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).Beg1 = Beginning;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).End1 = End;

            %Finding TO
            TF = islocalmin(Data.(ImpairmentNames(i)).RightLowerLegZ.(TakeNames(j))(RealMax:End));
            TOIndex = find(TF, 1, 'first');
            RealTOIndex = TOIndex + MaxIndex + Beginning -1;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).TO1 = RealTOIndex;

            %Finding HS
            TF = islocalmin(Data.(ImpairmentNames(i)).RightLowerLegZ.(TakeNames(j))(Beginning:RealMax));
            TOIndex = find(TF, 1, 'last');
            RealTOIndex = TOIndex + Beginning -1;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).HS1 = RealTOIndex;

            %Just for PEAK 2***********************************

            %Finding Max Index
            Beginning = Peak2(j + 4*(i-1),1);
            End = Peak2(j + 4*(i-1),2);
            [MaxValue, MaxIndex] = max(Data.(ImpairmentNames(i)).RightLowerLegZ.(TakeNames(j))(Beginning:End));
            RealMax = MaxIndex + Beginning;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).Beg2 = Beginning;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).End2 = End;

            %Finding TO
            TF = islocalmin(Data.(ImpairmentNames(i)).RightLowerLegZ.(TakeNames(j))(RealMax:End));
            TOIndex = find(TF, 1, 'first');
            RealTOIndex = TOIndex + MaxIndex + Beginning -1;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).TO2 = RealTOIndex;

            %Finding HS
            TF = islocalmin(Data.(ImpairmentNames(i)).RightLowerLegZ.(TakeNames(j))(Beginning:RealMax));
            TOIndex = find(TF, 1, 'last');
            RealTOIndex = TOIndex + Beginning -1;
            HSTO.(ImpairmentNames(i)).(TakeNames(j)).HS2 = RealTOIndex;
    end



end


%% Adjusting the indices of HS and TO based on previous plots

%Blindfold
HSTO.Blindfold.Take1.HS1 = 789;
HSTO.Blindfold.Take1.TO1 = 814;
HSTO.Blindfold.Take1.HS2 = 1008; %Noisy!
HSTO.Blindfold.Take1.TO2 = 1076; %Noisy!

HSTO.Blindfold.Take2.TO1 = 1294;
HSTO.Blindfold.Take2.TO2 = 1586; %Noisy!

HSTO.Blindfold.Take3.HS1 = 920; %Noisy!
HSTO.Blindfold.Take3.TO1 = 993; %Noisy!

HSTO.Blindfold.Take4.TO2 = 1026; %Noisy!

%P7Goggles
HSTO.P7Goggles.Take2.HS2 = 1057;

HSTO.P7Goggles.Take3.TO1 = 914;
HSTO.P7Goggles.Take3.TO2 = 1152;

%Regular
HSTO.Regular.Take1.HS2 = 962;
HSTO.Regular.Take2.HS2 = 1129;

%No Glasses
HSTO.NoGlasses.Take1.TO2 = 1358;

HSTO.NoGlasses.Take3.HS1 = 870;
HSTO.NoGlasses.Take3.TO1 = 894;

HSTO.NoGlasses.Take4.TO1 = 793;
HSTO.NoGlasses.Take4.TO2 = 1034;

%P6
HSTO.P6Goggles.Take1.TO1 = 793; %Noisy!
HSTO.P6Goggles.Take1.TO2 = 1038; %Noisy!

HSTO.P6Goggles.Take3.HS2 = 983;

HSTO.P6Goggles.Take4.HS2 = 1329;
HSTO.P6Goggles.Take4.TO2 = 1354;





%% Plotting These Results

for a = 1:length(ImpairmentNames)
    figure(a)
    sgtitle(strcat("Right Shank Angular Velocity for ", ImpairmentNames(a)))
    
    for b = 1:length(TakeNames)
        if a == length(ImpairmentNames) && b ==4 % No data for P7Gogg T4
            break;
        end
        subplot(2,2,b) 
        plot(Data.(ImpairmentNames(a)).RightLowerLegZ.(TakeNames(b)))
        hold on
        xline(HSTO.(ImpairmentNames(a)).(TakeNames(b)).TO1, '--r')
        hold on
        xline(HSTO.(ImpairmentNames(a)).(TakeNames(b)).HS1, '--b')
        hold on
        xline(HSTO.(ImpairmentNames(a)).(TakeNames(b)).TO2, '--r')
        hold on
        xline(HSTO.(ImpairmentNames(a)).(TakeNames(b)).HS2, '--b')
        hold on
        %rectangle('Position', [HSTO.(ImpairmentNames(a)).(TakeNames(b)).TO1, -5, HSTO.(ImpairmentNames(a)).(TakeNames(b)).HS2 - HSTO.(ImpairmentNames(a)).(TakeNames(b)).TO1, 10])
        xlim([HSTO.(ImpairmentNames(a)).(TakeNames(b)).Beg1, HSTO.(ImpairmentNames(a)).(TakeNames(b)).End2])
        xlabel('Frame')
        ylabel('Angular Velocity')
        
    end
    
    saveas(gcf,strcat("Adjusted Shank Angular Velocity for ", ImpairmentNames(a)),'png')

end

writestruct(HSTO, 'Adjusted_HSTO.json')



%% Picking out Specific Plots
close all

ExtraNames = ["Blindfold", "NoGlasses", "P6Goggles", "P7Goggles", "Regular"];
ExtraTakes = ["Take4", "Take1", "Take4", "Take3", "Take3"];
for d = 1:length(ExtraNames)
    
    figure(20+d)
        plot(Data.(ExtraNames(d)).RightLowerLegZ.(ExtraTakes(d)));
        hold on
        xline(HSTO.(ExtraNames(d)).(ExtraTakes(d)).TO1, '--r')
        hold on
        xline(HSTO.(ExtraNames(d)).(ExtraTakes(d)).HS1, '--b')
        hold on
        xline(HSTO.(ExtraNames(d)).(ExtraTakes(d)).TO2, '--r')
        hold on
        xline(HSTO.(ExtraNames(d)).(ExtraTakes(d)).HS2, '--b')
        hold off
        xlim([HSTO.(ExtraNames(d)).(ExtraTakes(d)).Beg1, HSTO.(ExtraNames(d)).(ExtraTakes(d)).End2])
        xlabel('Frame')
        ylabel('Angular Velocity')
        title(strcat("Right Shank Angular Velocity for ", ExtraNames(d)))
        saveas(gcf,strcat("Right Shank Angular Velocity for ", ExtraNames(d), ExtraTakes(d)),'png')


end


%% Old Stuff

% figure(1)
%     plot(Data.Blindfold.RightLowerLegZ.Take1)
%     hold on
%     xline(HSTO.Blindfold.Take1.TO1, '--r')
%     hold on
%     xline(HSTO.Blindfold.Take1.HS1, '--b')
%     hold on
%     xline(HSTO.Blindfold.Take1.TO2, '--r')
%     hold on
%     xline(HSTO.Blindfold.Take1.HS2, '--b')
% 
% figure(2)
%     plot(Data.P6Goggles.RightLowerLegZ.Take4)
%     hold on
%     xline(HSTO.P6Goggles.Take4.TO1, '--r')
%     hold on
%     xline(HSTO.P6Goggles.Take4.HS1, '--b')
%     hold on
%     xline(HSTO.P6Goggles.Take4.TO2, '--r')
%     hold on
%     xline(HSTO.P6Goggles.Take4.HS2, '--b')


% figure(1)
%     subplot(2,2,1)
%     sgtitle("Shank Angular Velocity for Blindfold")
%     plot(Data.Blindfold.RightLowerLegZ.Take1)
%     hold on
%     plot(149, -1.3250, 'x')
%     title("Take1")
%     subplot(2,2,2)
%     plot(Data.Blindfold.RightLowerLegZ.Take2)
%     title("Take2")
%     subplot(2,2,3)
%     plot(Data.Blindfold.RightLowerLegZ.Take3)
%     title("Take3")
%     subplot(2,2,4)
%     plot(Data.Blindfold.RightLowerLegZ.Take4)
%     title("Take4")
%     saveas(gcf, 'HO_TS_EX', 'jpg')

% [temp, index] = min(Data.Blindfold.RightLowerLegZ.Take1(1:151))

% figure(2)
%     plot(Data.Blindfold.RightLowerLegZ.Take4)