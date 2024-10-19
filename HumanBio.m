clc
clearvars -except Raw
close all
format compact

NewData = 0; %DO NOT SET TO 1 (Unless reading new data; i.e. drunk_goggles_1
%% Data Import/ Sorting: Setup

%Import; getting excel sheet into a struct by page then information

%Name of each sheet in the Excel workbook
sheetNames = ["GeneralInformation", "TimeCode", "SegmentOrientationEuler", "SegmentPosition", "SegmentVelocity", "SegmentAcceleration", "SegmentAngularVelocity", "SegmentAngularAcceleration", "JointAnglesZXY", "JointAnglesXZY", "ErgonomicJointAnglesZXY", "ErgonomicJointAnglesXZY", "CenterOfMass"];

%Each combination of column name; names change as columns progress
columnNames1 = ["Frame", "Time"];
columnNames2 = ["Pelvis", "L5", "L3", "T12", "T8", "Neck", "Head", "RightShoulder", "RightUpperArm", "RightForearm", "RightHand", "LeftShoulder", "LeftUpperArm", "LeftForearm", "LeftHand", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToe", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToe"];
columnNames3 = ["L5S1", "L4L3", "L1T12", "T9T8", "T1C7", "C1", "RightT4Shoulder", "RightShoulder", "RightElbow", "RightWrist", "LefttT4Shoulder", "LeftShoulder", "LeftElbow", "LeftWrist", "RightHip", "RightKnee", "RightAnkle", "RightBallFoot", "LeftHip", "LeftKnee", "LeftAnkle", "LeftBallFoot"];
columnNames4 = ["T8Head", "T8LeftUpperArm", "T8RightUpperArm", "PelvisT8", "VerticalPelvis", "VerticalT8"];
columnNames5 = ["CoMPos", "CoMVel", "CoMAcc"];

%Modifiers: these are what's repeatdly added to the 'coulumnNames' above
XYZ = ["X", "Y", "Z"];
NameMods1 = ["LateralBending", "AxialBending", "FlexionExtension"];
NameMods2 = ["AbductionAdduction", "InternalExternal", "FlexionExtension"];
NameMods3 = ["UlnarDeviation", "PronationSupination", "FlexionExtension"];
NameMods4 = ["AbductionAdduction", "InternalExternal", "DorsiflextionPlantarflextion"];


%% Data Import/ Sorting: Struct creation/ organization


if NewData

    Names = [""];

    %Relic
    PossibleNames = ["", ""];

    %The for loop below is just for the time code sheet
    currentRaw = readmatrix('drunk_goggles_2.xlsx', "Sheet", 2, 'Range', 'A2');
    for z = 1:2
        Raw.(sheetNames(2)).(columnNames1(z)) = currentRaw(:, z);
    end

    %Now, doing the rest of the sheets. The purpose of this loop is to go
    %though each sheet, determine the appropriate naming schemes, then save
    %the data from the excel sheet to a struct field that has the same name
    %as the column in the Excel workbook
    for i = 3: length(sheetNames)

        ten = 0; %Useful b/c sequencing changes on the tenth sheet

        sheetName = sheetNames(i);

        currentRaw = readmatrix('drunk_goggles_2.xlsx', "Sheet", i, 'Range', 'B2');

        %These if statements tell you what sheet you're on.  This is important
        %because the order of the column names and their modifiers is dependent
        %on which sheet you're on.
        if (i<=8)
            Names = columnNames2;
            Modifier = XYZ;

        elseif(i<=9) %figure out modifier
            Names = columnNames3;
            ten = 1;

        elseif (i==11)
            Names = columnNames4;
            Modifier = NameMods1;

        elseif(i<13) %figure out modifier
            Names = columnNames4;
            Modifier = NameMods1;


        else
            Names = columnNames5;
            Modifier = XYZ;

        end

        %Total number of columns for the sheet (Excluding the 'Frame' column)
        columnCount = 3*length(Names); %xyz, etc.

        for a = 1:length(Names) %Each name
            baseName = Names(a);
            for b = 1:3 %Each modifier

                currColumn = b + 3*(a-1);

                if ten
                    %Some special conditions where the modifiers mix and match
                    if ((currColumn >= 62) && (currColumn <= 64)) || ((currColumn >= 50) && (currColumn <= 52))
                        Modifier = NameMods4;
                    elseif ((currColumn >= 38) && (currColumn <= 43)) || ((currColumn >= 26) && (currColumn <= 31))
                        Modifier = NameMods3;
                    elseif currColumn <= 19
                    else
                        Modifier = NameMods2;
                    end
                end

                modName = Modifier(b);
                currName = strcat(baseName, modName);

                %Adding the columns from the excel sheet to the struct 'Raw'
                Raw.(sheetName).(currName) = currentRaw(:, currColumn);

                %Relic
                PossibleNames = [PossibleNames ; [baseName modName]];

            end


        end


    end
    
    %Writing this data to a .json file so that this very lengthy process
    %doesn't need to be repeated
    writestruct(Raw, 'raw_data.json') 
end

%% Frames to Events

%{
    Each of the matrices below are the start and end frames for each visual
    condition.  Each row corresponds to a Take.  The first and second
    columns are the beginning and end of each take, respectively. Each
    frame was picked out visually from the video.
%}

P6Goggles = [

3900    5250
7200    9200
11200   12800
14400   16200
];

NoGlasses = [

19200   20900
22800   24500
26600   28200
30400   32000

];

Regular = [

35600   37000
39200   40800
43200   44500
46500   48200
];

Blindfold = [

58000   59600
61600   63600
66400   68000
70800   72300
];

P7Goggles = [

80000   81600
83800   85200
87600   89200
1       2
];


%% Saving Take Data Only

%{
    The purpose of this section is to select only the data that we're
    interested, and save it to a new struct called 'Interested.'
%}

%Useful for naming stuct fields
TakeNames = ["Take1", "Take2", "Take3", "Take4"];
ImpairmentNames = ["P6Goggles", "NoGlasses", "Regular", "Blindfold", "P7Goggles"];

%Useful for organizing the frame data above
Combined = [P6Goggles, NoGlasses, Regular, Blindfold, P7Goggles];

% Add more to these to get all of the parameters. Will need
% InterestedParameters to be the same length as BaseIP. BaseIP is the stuct
% field you click on to get to the InterestedParameters
InterestedParameters = ["CoMPosZ", "RightLowerLegY", "RightLowerLegX", "RightAnkleDorsiflextionPlantarflextion", "RightLowerLegZ", "CoMVelX"]; %Flexion mis-spelled on purpose, oops
BaseIP = ["CenterOfMass", "SegmentVelocity", "SegmentVelocity", "JointAnglesZXY", "SegmentAngularVelocity", "CenterOfMass"];

Raw = readstruct("raw_data.json");

%Now, actually sorting the data

for k = 1:length(InterestedParameters) %Each parameter
    for j = 1:length(ImpairmentNames) %Each impairment

        for i = 1:size(Regular, 1) %Each take

            x = 2*(j-1) + 1; %Keeping track of the column in 'Combined'
            Beginning = Combined(i, x);
            End = Combined(i,x+1);
            dX = End - Beginning; %Relic

            %Saving the take data to the struct 'Interested' by
            %auto-assigning names.
            if k == 5 %bc struct members had same name
                Shank.(ImpairmentNames(j)).(InterestedParameters(k)).(TakeNames(i))(:,1) = Raw.(BaseIP(k)).(InterestedParameters(k))(1, Beginning:End); %.json flipped 1 and Beginning:End!
            elseif k==6
                ComVelo.(ImpairmentNames(j)).(InterestedParameters(k)).(TakeNames(i))(:,1) = Raw.(BaseIP(k)).(InterestedParameters(k))(1, Beginning:End); %.json flipped 1 and Beginning:End!
            else
                Interested.(ImpairmentNames(j)).(InterestedParameters(k)).(TakeNames(i))(:,1) = Raw.(BaseIP(k)).(InterestedParameters(k))(1, Beginning:End); %.json flipped 1 and Beginning:End!
            end
        end

    end

end


%% Old stuff
% %% Sanity check
% %
% % Doing the same parameter all at once
% %
% % for j = 1:length(ImpairmentNames)
% %
% %     for i = 1:size(Regular, 1)
% %
% %         if (j == 5) && (i == 4) %Have to do this bc no values for last take of P7Goggles
% %             return;
% %         end
% %
% %         x = 2*(j-1) + 1;
% %         Beginning = Combined(i, x);
% %         End = Combined(i,x+1);
% %         dX = End - Beginning;
% %         Interested.(ImpairmentNames(j)).CoMPosZ.(TakeNames(i))(:,1) = Raw.CenterOfMass.CoMPosZ(Beginning:End, 1);
% %
% %     end
% %
% %
% % end


%% Actual Plotting
%
% {
%     Want CoM posn (X,Y,Z), shank velo, shank accel, foot velocity vs time,
%     foot angle vs foot velocity, foot angle vs time.  Going to do only the
%     right side (where applicable)
% }
%
%
%
% Just doing CoM here
% PVA = ["CoMPos", "CoMVel", "CoMAcc"];
% XYZ = ["X", "Y", "Z"];
%
% PlotTitles = ["CoMPos", "CoMVel", "CoMAcc"];
% FigCount = 1;
%
%
%
% CurrIndexes = Regular;
%
%
% This gives every plot for CoM with x,y,z together but takes are separate
% so far.
%
% for i = 1:size(CurrIndexes,1) %For each take
%     Beginning = Regular(i, 1);
%     End = Regular(i, 2);
%     Pos = zeros([1+End-Beginning, 3]);
%
% for j = 1:3 %For each characteristic (Pos, Vel, Acc)
%
% for k = 1:3 %For each dimension (X, Y, Z)
%
%     word = strcat(PVA(j), XYZ(k));
%     Pos(:,k) = Raw.CenterOfMass.(word)(Beginning:End);
%
% end
%
% xFrame = 1:size(Pos,1);
%
% Titles = strcat(PlotTitles(j), TakeNames(i));
%
% figure(FigCount)
%     subplot(3, 1, 1)
%     plot(xFrame, Pos(:,1))
%     legend("x")
%     title(Titles)
%     subplot(3, 1, 2)
%     plot(xFrame, Pos(:,2))
%     legend("y")
%     subplot(3, 1, 3)
%     plot(xFrame, Pos(:,3))
%     legend("z")
%     saveas(gcf, Titles, 'png')
%
%  FigCount = FigCount + 1;
%
% end
% end
