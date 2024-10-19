clc
clearvars -except HSTO Data
close all
format compact

%% Plotting CoM with Xlines

%*****Make sure HSTO is up to date/ correct
HSTO = readstruct("Adjusted_HSTO.json");
Data = readstruct("Interested_2.json");

TakeNames = ["Take1", "Take2", "Take3", "Take4"];
ImpairmentNames = ["Blindfold", "P6Goggles", "NoGlasses", "Regular", "P7Goggles"];

for a = 1:length(ImpairmentNames)
    figure(a)
    sgtitle(strcat("CoM Vertical Position for ", ImpairmentNames(a)))
    
    for b = 1:length(TakeNames)
        if a == length(ImpairmentNames) && b ==4 % No data for P7Gogg T4
            break;
        end
        subplot(2,2,b) 
        Beg = HSTO.(ImpairmentNames(a)).(TakeNames(b)).Beg1;
        plot(Data.(ImpairmentNames(a)).CoMPosZ.(TakeNames(b)) - Data.(ImpairmentNames(a)).CoMPosZ.(TakeNames(b))(Beg))
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
        ylabel('Elevation (m)')
        xlabel('Frame')
        
    end
    
    saveas(gcf,strcat("Adjusted CoM Position For ", ImpairmentNames(a)),'png')

end



ComVelo = readstruct('ComVelo.json');
for c = 1:length(ImpairmentNames)
    figure(c + length(ImpairmentNames))
    sgtitle(strcat("CoM Forward Velocity for ", ImpairmentNames(c)))
    
    for b = 1:length(TakeNames)
        if c == length(ImpairmentNames) && b ==4 % No data for P7Gogg T4
            break;
        end
        subplot(2,2,b) 
        plot(ComVelo.(ImpairmentNames(c)).CoMVelX.(TakeNames(b)))
        hold on
        xline(HSTO.(ImpairmentNames(c)).(TakeNames(b)).TO1, '--r')
        hold on
        xline(HSTO.(ImpairmentNames(c)).(TakeNames(b)).HS1, '--b')
        hold on
        xline(HSTO.(ImpairmentNames(c)).(TakeNames(b)).TO2, '--r')
        hold on
        xline(HSTO.(ImpairmentNames(c)).(TakeNames(b)).HS2, '--b')
        hold on
        %rectangle('Position', [HSTO.(ImpairmentNames(a)).(TakeNames(b)).TO1, -5, HSTO.(ImpairmentNames(a)).(TakeNames(b)).HS2 - HSTO.(ImpairmentNames(a)).(TakeNames(b)).TO1, 10])
        xlim([HSTO.(ImpairmentNames(c)).(TakeNames(b)).Beg1, HSTO.(ImpairmentNames(c)).(TakeNames(b)).End2])
        ylabel('Velocity (m/s)')
        xlabel('Frame')
    end
    
    saveas(gcf,strcat("Adjusted CoM Velocity For ", ImpairmentNames(c)),'png')

end

%% Picking out Specific Plots
close all

ExtraNames = ["Blindfold", "NoGlasses", "P6Goggles", "P7Goggles", "Regular"];
ExtraTakes = ["Take4", "Take1", "Take4", "Take3", "Take3"];
for d = 1:length(ExtraNames)
    
    figure(20+d)
        Beg = HSTO.(ExtraNames(d)).(ExtraTakes(d)).Beg1;
        plot(Data.(ExtraNames(d)).CoMPosZ.(ExtraTakes(d)) - Data.(ExtraNames(d)).CoMPosZ.(ExtraTakes(d))(Beg));
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
        ylabel('Elevation (m)')
        title(strcat("CoM Vertical Position for ", ExtraNames(d)))
        saveas(gcf,strcat("CoM Vertical Position for ", ExtraNames(d), ExtraTakes(d)),'png')


end

for d = 1:length(ExtraNames)
    
    figure(30+d)
        plot(ComVelo.(ExtraNames(d)).CoMVelX.(ExtraTakes(d)));
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
        ylabel('Velocity (m/s)')
        title(strcat("CoM Forward Velocity for ", ExtraNames(d)))
        saveas(gcf,strcat("CoM Forward Velocity for ", ExtraNames(d), ExtraTakes(d)),'png')


end

%% Plotting CoM height for every take
close all
figure(40)
for d = 1:length(ExtraNames)
    
        Beg = HSTO.(ExtraNames(d)).(ExtraTakes(d)).Beg1;
        TO1 = HSTO.(ExtraNames(d)).(ExtraTakes(d)).TO1;
        HS2 = HSTO.(ExtraNames(d)).(ExtraTakes(d)).HS2;
        
        plot(Data.(ExtraNames(d)).CoMPosZ.(ExtraTakes(d))(Beg:end) - Data.(ExtraNames(d)).CoMPosZ.(ExtraTakes(d))(Beg));
        xlim([0 600])
        hold on
       
end
legend(ExtraNames)
title('Normalized CoM Vertical Position')
ylabel('Elevation (m)')
xlabel('Frame')
saveas(gcf,"Combinded CoM",'png')
