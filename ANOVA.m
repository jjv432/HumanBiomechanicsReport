clc
clearvars -except Potential Kinetic HSTO Data
close all
format compact 

%% ANOVA

Potential = readstruct('NormalizedPotential.json');
Kinetic = readstruct('NormalizedKinetic.json');
Energy = readstruct('Energy.json');
HSTO = readstruct('HSTO.json');
Data = readstruct("Interested_2.json");

% Example data variables from the provided struct Kinetic
K1 = Kinetic.Blindfold.Take1;
K2 = Kinetic.Blindfold.Take2;
K3 = Kinetic.Blindfold.Take3;
K4 = Kinetic.Blindfold.Take4;

K5 = Kinetic.P6Goggles.Take1;
K6 = Kinetic.P6Goggles.Take2;
K7 = Kinetic.P6Goggles.Take3;
K8 = Kinetic.P6Goggles.Take4;

K9 = Kinetic.NoGlasses.Take1;
K10 = Kinetic.NoGlasses.Take2;
K11 = Kinetic.NoGlasses.Take3;
K12 = Kinetic.NoGlasses.Take4;

K13 = Kinetic.Regular.Take1;
K14 = Kinetic.Regular.Take2;
K15 = Kinetic.Regular.Take3;
K16 = Kinetic.Regular.Take4;

K17 = Kinetic.P7Goggles.Take1;
K18 = Kinetic.P7Goggles.Take2;
K19 = Kinetic.P7Goggles.Take3;
K20 = Kinetic.P7Goggles.Take4;

% Example data variables from the provided struct Energy
E1 = Energy.Blindfold.Take1;
E2 = Energy.Blindfold.Take2;
E3 = Energy.Blindfold.Take3;
E4 = Energy.Blindfold.Take4;

E5 = Energy.P6Goggles.Take1;
E6 = Energy.P6Goggles.Take2;
E7 = Energy.P6Goggles.Take3;
E8 = Energy.P6Goggles.Take4;

E9 = Energy.NoGlasses.Take1;
E10 = Energy.NoGlasses.Take2;
E11 = Energy.NoGlasses.Take3;
E12 = Energy.NoGlasses.Take4;

E13 = Energy.Regular.Take1;
E14 = Energy.Regular.Take2;
E15 = Energy.Regular.Take3;
E16 = Energy.Regular.Take4;

E17 = Energy.P7Goggles.Take1;
E18 = Energy.P7Goggles.Take2;
E19 = Energy.P7Goggles.Take3;
E20 = Energy.P7Goggles.Take4;

P1 = Potential.Blindfold.Take1;
P2 = Potential.Blindfold.Take2;
P3 = Potential.Blindfold.Take3;
P4 = Potential.Blindfold.Take4;

P5 = Potential.P6Goggles.Take1;
P6 = Potential.P6Goggles.Take2;
P7 = Potential.P6Goggles.Take3;
P8 = Potential.P6Goggles.Take4;

P9 = Potential.NoGlasses.Take1;
P10 = Potential.NoGlasses.Take2;
P11 = Potential.NoGlasses.Take3;
P12 = Potential.NoGlasses.Take4;

P13 = Potential.Regular.Take1;
P14 = Potential.Regular.Take2;
P15 = Potential.Regular.Take3;
P16 = Potential.Regular.Take4;

P17 = Potential.P7Goggles.Take1;
P18 = Potential.P7Goggles.Take2;
P19 = Potential.P7Goggles.Take3;
P20 = Potential.P7Goggles.Take4;

% Calculate the maximum length among all data vectors for each parameter
max_length_kinetic = max([length(K1), length(K2), length(K3), length(K4), length(K5), length(K6), length(K7), length(K8), length(K9), length(K10), length(K11), length(K12), length(K13), length(K14), length(K15), length(K16), length(K17), length(K18), length(K19), length(K20)]);
max_length_energy = max([length(E1), length(E2), length(E3), length(E4), length(E5), length(E6), length(E7), length(E8), length(E9), length(E10), length(E11), length(E12), length(E13), length(E14), length(E15), length(E16), length(E17), length(E18), length(E19), length(E20)]);

% Pad the remaining data vectors with NaN to match the maximum length
K1 = [K1, NaN(1, max_length_kinetic - length(K1))];
K2 = [K2, NaN(1, max_length_kinetic - length(K2))];
K3 = [K3, NaN(1, max_length_kinetic - length(K3))];
K4 = [K4, NaN(1, max_length_kinetic - length(K4))];
K5 = [K5, NaN(1, max_length_kinetic - length(K5))];
K6 = [K6, NaN(1, max_length_kinetic - length(K6))];
K7 = [K7, NaN(1, max_length_kinetic - length(K7))];
K8 = [K8, NaN(1, max_length_kinetic - length(K8))];
K9 = [K9, NaN(1, max_length_kinetic - length(K9))];
K10 = [K10, NaN(1, max_length_kinetic - length(K10))];
K11 = [K11, NaN(1, max_length_kinetic - length(K11))];
K12 = [K12, NaN(1, max_length_kinetic - length(K12))];
K13 = [K13, NaN(1, max_length_kinetic - length(K13))];
K14 = [K14, NaN(1, max_length_kinetic - length(K14))];
K15 = [K15, NaN(1, max_length_kinetic - length(K15))];
K16 = [K16, NaN(1, max_length_kinetic - length(K16))];
K17 = [K17, NaN(1, max_length_kinetic - length(K17))];
K18 = [K18, NaN(1, max_length_kinetic - length(K18))];
K19 = [K19, NaN(1, max_length_kinetic - length(K19))];
K20 = [K20, NaN(1, max_length_kinetic - length(K20))];

E1 = [E1, NaN(1, max_length_energy - length(E1))];
E2 = [E2, NaN(1, max_length_energy - length(E2))];
E3 = [E3, NaN(1, max_length_energy - length(E3))];
E4 = [E4, NaN(1, max_length_energy - length(E4))];
E5 = [E5, NaN(1, max_length_energy - length(E5))];
E6 = [E6, NaN(1, max_length_energy - length(E6))];
E7 = [E7, NaN(1, max_length_energy - length(E7))];
E8 = [E8, NaN(1, max_length_energy - length(E8))];
E9 = [E9, NaN(1, max_length_energy - length(E9))];
E10 = [E10, NaN(1, max_length_energy - length(E10))];
E11 = [E11, NaN(1, max_length_energy - length(E11))];
E12 = [E12, NaN(1, max_length_energy - length(E12))];
E13 = [E13, NaN(1, max_length_energy - length(E13))];
E14 = [E14, NaN(1, max_length_energy - length(E14))];
E15 = [E15, NaN(1, max_length_energy - length(E15))];
E16 = [E16, NaN(1, max_length_energy - length(E16))];
E17 = [E17, NaN(1, max_length_energy - length(E17))];
E18 = [E18, NaN(1, max_length_energy - length(E18))];
E19 = [E19, NaN(1, max_length_energy - length(E19))];
E20 = [E20, NaN(1, max_length_energy - length(E20))];

P1 = [P1, NaN(1, max_length_energy - length(P1))];
P2 = [P2, NaN(1, max_length_energy - length(P2))];
P3 = [P3, NaN(1, max_length_energy - length(P3))];
P4 = [P4, NaN(1, max_length_energy - length(P4))];
P5 = [P5, NaN(1, max_length_energy - length(P5))];
P6 = [P6, NaN(1, max_length_energy - length(P6))];
P7 = [P7, NaN(1, max_length_energy - length(P7))];
P8 = [P8, NaN(1, max_length_energy - length(P8))];
P9 = [P9, NaN(1, max_length_energy - length(P9))];
P10 = [P10, NaN(1, max_length_energy - length(P10))];
P11 = [P11, NaN(1, max_length_energy - length(P11))];
P12 = [P12, NaN(1, max_length_energy - length(P12))];
P13 = [P13, NaN(1, max_length_energy - length(P13))];
P14 = [P14, NaN(1, max_length_energy - length(P14))];
P15 = [P15, NaN(1, max_length_energy - length(P15))];
P16 = [P16, NaN(1, max_length_energy - length(P16))];
P17 = [P17, NaN(1, max_length_energy - length(P17))];
P18 = [P18, NaN(1, max_length_energy - length(P18))];
P19 = [P19, NaN(1, max_length_energy - length(P19))];
P20 = [P20, NaN(1, max_length_energy - length(P20))];

% Concatenate the data ranges for each parameter and condition
kinetic = [K1; K2; K3; K4; K5; K6; K7; K8; K9; K10; K11; K12; K13; K14; K15; K16; K17; K18; K19; K20];
energy = [E1; E2; E3; E4; E5; E6; E7; E8; E9; E10; E11; E12; E13; E14; E15; E16; E17; E18; E19; E20];
potential = [P1; P2; P3; P4; P5; P6; P7; P8; P9; P10; P11; P12; P13; P14; P15; P16; P17; P18; P19; P20];

% Reshape the padded data for repeated measures ANOVA
num_conditions = 5;
reshaped_kinetic = reshape(kinetic, [], num_conditions);
reshaped_energy = reshape(energy, [], num_conditions);
reshaped_potential = reshape(potential, [], num_conditions);

% Perform repeated measures ANOVA using anova1 for each parameter
[p_kinetic, tbl_kinetic, stats_kinetic] = anova1(reshaped_kinetic);
[p_energy, tbl_energy, stats_energy] = anova1(reshaped_energy);
[p_potential, tbl_potential, stats_potential] = anova1(reshaped_potential);

% Display the ANOVA results for each parameter
disp('ANOVA Table - Kinetic:');
disp(tbl_kinetic);
disp('P-value - Kinetic:');
disp(p_kinetic);
disp('ANOVA Stats - Kinetic:');
disp(stats_kinetic);

disp('ANOVA Table - Energy:');
disp(tbl_energy);
disp('P-value - Energy:');
disp(p_energy);
disp('ANOVA Stats - Energy:');
disp(stats_energy);

disp('ANOVA Table - Potential:');
disp(tbl_potential);
disp('P-value - Potential:');
disp(p_potential);
disp('ANOVA Stats - Potential:');
disp(stats_potential);

% Create separate box plots for Kinetic, Energy, and Potential
figure;
subplot(3, 1, 1);
boxplot(reshaped_kinetic, 'Labels', {'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4', 'Condition 5'});
ylabel('Kinetic Value');
title('Box Plot of Kinetic Parameter');
grid on;

subplot(3, 1, 2);
boxplot(reshaped_energy, 'Labels', {'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4', 'Condition 5'});
ylabel('Energy Value');
title('Box Plot of Energy Parameter');
grid on;

subplot(3, 1, 3);
boxplot(reshaped_potential, 'Labels', {'Condition 1', 'Condition 2', 'Condition 3', 'Condition 4', 'Condition 5'});
ylabel('Potential Value');
title('Box Plot of Potential Parameter');

% Adjust plot appearance if needed
grid on;

%%
% K1 = Kinetic.Blindfold.Take1;
% K2 = Kinetic.Blindfold.Take2;
% K3 = Kinetic.Blindfold.Take3;
% K4 = Kinetic.Blindfold.Take4;
% 
% K5 = Kinetic.P6Goggles.Take1;
% K6 = Kinetic.P6Goggles.Take2;
% K7 = Kinetic.P6Goggles.Take3;
% K8 = Kinetic.P6Goggles.Take4;
% 
% K9 = Kinetic.NoGlasses.Take1;
% K10 = Kinetic.NoGlasses.Take2;
% K11 = Kinetic.NoGlasses.Take3;
% K12 = Kinetic.NoGlasses.Take4;
% 
% K13 = Kinetic.Regular.Take1;
% K14 = Kinetic.Regular.Take2;
% K15 = Kinetic.Regular.Take3;
% K16 = Kinetic.Regular.Take4;
% 
% K17 = Kinetic.P7Goggles.Take1;
% K18 = Kinetic.P7Goggles.Take2;
% K19 = Kinetic.P7Goggles.Take3;
% K20 = Kinetic.P7Goggles.Take4;
% 
% % Calculate the maximum length among all data vectors
% max_length = max([length(K1), length(K2), length(K3), length(K4), length(K5), length(K6), length(K7), length(K8), length(K9), length(K10), length(K11), length(K12), length(K13), length(K14), length(K15), length(K16), length(K17), length(K18), length(K19), length(K20)]);
% 
% % Pad the shorter data vectors with NaN to match the maximum length
% K1 = [K1, NaN(1, max_length - length(K1))];
% K2 = [K2, NaN(1, max_length - length(K2))];
% K3 = [K3, NaN(1, max_length - length(K3))];
% K4 = [K4, NaN(1, max_length - length(K4))];
% 
% K5 = [K5, NaN(1, max_length - length(K5))];
% K6 = [K6, NaN(1, max_length - length(K6))];
% K7 = [K7, NaN(1, max_length - length(K7))];
% K8 = [K8, NaN(1, max_length - length(K8))];
% 
% K9 = [K9, NaN(1, max_length - length(K9))];
% K10 = [K10, NaN(1, max_length - length(K10))];
% K11 = [K11, NaN(1, max_length - length(K11))];
% K12 = [K12, NaN(1, max_length - length(K12))];
% 
% K13 = [K13, NaN(1, max_length - length(K13))];
% K14 = [K14, NaN(1, max_length - length(K14))];
% K15 = [K15, NaN(1, max_length - length(K15))];
% K16 = [K16, NaN(1, max_length - length(K16))];
% 
% K17 = [K17, NaN(1, max_length - length(K17))];
% K18 = [K18, NaN(1, max_length - length(K18))];
% K19 = [K19, NaN(1, max_length - length(K19))];
% K20 = [K20, NaN(1, max_length - length(K20))];
% 
% % Concatenate the data ranges for each parameter and condition
% kinetic = [K1; K2; K3; K4; K5; K6; K7; K8; K9; K10; K11; K12; K13; K14; K15; K16; K17; K18; K19; K20];
% 
% % Reshape the padded data for repeated measures ANOVA
% num_trials = 4;              % Assuming each condition has 4 trials except one with 3 trials
% num_conditions = 5;
% reshaped_kinetic = reshape(kinetic, [], num_conditions);
% 
% % Perform repeated measures ANOVA using anova1 for each parameter
% [p_kinetic, tbl_kinetic, stats_kinetic] = anova1(reshaped_kinetic);
% 
% % Display the ANOVA results for Kinetic measure
% disp('ANOVA Table - Kinetic:');
% disp(tbl_kinetic);
% disp('P-value - Kinetic:');
% disp(p_kinetic);
% disp('ANOVA Stats - Kinetic:');
% disp(stats_kinetic);
