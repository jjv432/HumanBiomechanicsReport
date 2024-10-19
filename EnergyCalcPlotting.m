clc
clear all
close all
format compact

%% Mechanical Energy Calculations

HSTO = readstruct("Adjusted_HSTO.json");
Data = readstruct("Interested_2.json");
Velocities = readstruct('ComVelo.json');

M = 161.5/2.205; %lbs to kg
g = 9.81;

TakeNames = ["Take1", "Take2", "Take3", "Take4"];
ImpairmentNames = ["Blindfold", "P6Goggles", "NoGlasses", "Regular", "P7Goggles"];


for z = 1:length(ImpairmentNames)

    for y = 1:length(TakeNames)
        
        Elevation = Data.(ImpairmentNames(z)).CoMPosZ.(TakeNames(y));
        Velo = Velocities.(ImpairmentNames(z)).CoMVelX.(TakeNames(y));
        
        Kinetic.(ImpairmentNames(z)).(TakeNames(y)) = .5*M*(Velo).^2;
        Potential.(ImpairmentNames(z)).(TakeNames(y)) = M*g*Elevation;
        Beg = HSTO.(ImpairmentNames(z)).(TakeNames(y)).Beg1;
        NormalizedPotential.(ImpairmentNames(z)).(TakeNames(y)) = M*g*(Elevation - Elevation(Beg));
        NormalizedKinetic.(ImpairmentNames(z)).(TakeNames(y)) = .5*M*(Velo - Velo(Beg)).^2;
        MechEnergy = M*g*Elevation + .5*M*(Velo).^2;
        
        Energy.(ImpairmentNames(z)).(TakeNames(y)) = MechEnergy;

    end


end

writestruct(Energy, 'Energy.json')
writestruct(NormalizedPotential, 'NormalizedPotential.json')
writestruct(NormalizedKinetic, 'NormalizedKinetic.json')

%% Plotting Energy
for a = 1:length(ImpairmentNames)
    figure(a)
    sgtitle(strcat("Mechanical Energy for ", ImpairmentNames(a)))
    
    for b = 1:length(TakeNames)
        if a == length(ImpairmentNames) && b ==4 % No data for P7Gogg T4
            break;
        end
        subplot(2,2,b) 
        plot(Energy.(ImpairmentNames(a)).(TakeNames(b)))
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
        ylabel('Energy (J)')
        
    end
    
    saveas(gcf,strcat("Energy For ", ImpairmentNames(a)),'pdf')

end


%% Picking out Specific Plots
close all

ExtraNames = ["Blindfold", "NoGlasses", "P6Goggles", "P7Goggles", "Regular"];
ExtraTakes = ["Take4", "Take1", "Take4", "Take3", "Take3"];
for d = 1:length(ExtraNames)
    
    figure(20+d)
        plot(Energy.(ExtraNames(d)).(ExtraTakes(d)));
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
        ylabel('Energy (J)')
        title(strcat("Mechanical Energy for ", ExtraNames(d)))
        saveas(gcf,strcat("Energy For ", ExtraNames(d), ExtraTakes(d)),'pdf')


end

for d = 1:length(ExtraNames)
    
    figure(30+d)
        Beg = HSTO.(ExtraNames(d)).(ExtraTakes(d)).Beg1;
        plot(NormalizedPotential.(ExtraNames(d)).(ExtraTakes(d)));
        hold on
        plot(NormalizedKinetic.(ExtraNames(d)).(ExtraTakes(d)));
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
        ylabel('\Delta Energy (J)')
        title(strcat("Potential and Kinetic Energy for ", ExtraNames(d)))
        legend("Potential", "Kinetic")
        saveas(gcf,strcat("Potential and Kinetic Energy For ", ExtraNames(d), ExtraTakes(d)),'png')
        


end

