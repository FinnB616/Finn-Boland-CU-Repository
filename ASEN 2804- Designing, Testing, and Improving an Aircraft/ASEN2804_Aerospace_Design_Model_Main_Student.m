%%Aerospace Vechicle Design Engineering Model Baseline Main Script
%%(Student Version)
% ASEN 2804
% Authors: John Mah / Preston Tee
% Current Version:  AY25.00
% Changes in Current Version:
    %Updated Design Input file with component material, weight, and
    %component layout info (Component_Data worksheet).
    %Updated Weight function to allow for measure or modeled weight, water
    %weight and cg variation during boost, and fudge factor to account for
    %glue and tape.
    %Updated Stability function to incorporate improved configuration
    %layout options.
    %Moved plots to associated functions and enabled trigger to turn a
    %given section's plots on or off.
    %Updated file folder structure to improve organization & added
    %file/subfolder path code to automatically add when run

% Date Last Change: 13 Dec 24

%% Clean Workspace and Housekeeping
clear
% clearvars
close all
clc

% removes warnings for table variable names for a cleaner output
warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')

%Add folder and subfolder path for standard Design Input Files, Model
%Functions, and Static Test Stand Data
addpath(genpath('Design Input Files'));
addpath(genpath('Trade Study Input Files'));
addpath(genpath('Model Functions'));
addpath(genpath('Static Test Stand Data'));

filename = "Design Input File_Evan_Karen_V25-00";

%% Import and Read Aircraft Design File
Design_Input = readtable(filename,'Sheet','Main_Input','ReadRowNames',true); %Read in Aircraft Geometry File
Count = height(Design_Input); %Number of different aircraft configurations in design input file
%Count = 1;
% Import Airfoil Data File
Airfoil = readtable(filename,'Sheet','Airfoil_Data'); %Read in Airfoil Data

% Import Component Weight and Location Data File
Component_Data = readtable(filename,'Sheet','Component_Data'); %Read in Component Data

% Import Benchmark Aircraft Truth Data
Benchmark = readtable(filename,'Sheet','Benchmark_Truth'); %Read in Benchmark "Truth" Data for model validation only

% Import Material Properties Data
Material_Data = readtable(filename,'Sheet','Materials'); %Read in prototyp material densities for weight model


set(0, 'DefaultLineLineWidth', 2);
%% Quick Explainer - Tables
% This code heavily utilizes tables for data organization. You should think
% of a table as a spreadsheet. Tables are also very similar to a 2D array
% of data exept that the columns can be named so that it is clear what data
% is in those columns. There are multiple ways to get the data out of
% columns, through standard indexing, and through dot indexing. 
%
% Standard indexing:
%
% Like when indexing into an array you can get data out of a table by using
% parenthasis, (), which will return another table, which is often a 
% problem for calulations and plotting
%   Example:
%       NewTable = OriginalTable(:,:)
%
% Alternativly, if you index in the same way but with curly braces, {}, a
% standard array will be returned
%   Example:
%       NewArray = OriginalTable{:,:}
%
% Finally, if you would like to access just one column, tables support dot
% indexing using the name of the column header. This takes the form of the 
% name of the variable, then a dot, then the name of the column, This will
% return a standard 1D array of data
%   Example: 
%       NewArray = OriginalTable.ColumnName_1
%
% The tables in this code have been purposly organized such that the rows
% will ALWAYS correspond to the different configuration inputs in the input
% file. In other words, the first input row of the input file (1st row not
% including the header row) will match up with row 1 of the tables in this
% code, the second input will be the 2nd row of tables here, etc. Columns
% will always be variables of interest and will be named appropriately.
%
% More MATLAB documentation on getting data out of tables:
% https://www.mathworks.com/help/matlab/matlab_prog/access-data-in-a-table.html
%
% We have provided the necessary code for packaging the data into tables to
% output from and input to functions in order to keep the size of the
% function headers reasonable. It will be your responsibility to unpack and
% use data passed into functions in tables correctly. Please ensure you
% are using the preallocated varaible names and do not modify the code that
% creates the tables. We want to help you with the math, not with general
% coding

%% Caluations - Conditions and Sizing
% US Standard Atmophere - uses provided MATLAB File Exchange function
    [rho,a,T,P,nu,z]= atmos(Design_Input.altitude_o(:,:)); 
    ATMOS = table(rho,a,T,P,nu,z); % Reorganize atmopheric conditions into a table for ease of passing into functions
    clearvars rho a T P nu z % Clear original variables now that they are in a table
    g = 9.81; %Sets constant acceleration of gravity [m/s]

% Call Wing Geometry Calcuation Function
    Plot_WingGeo_Data = 1; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 10 - 19)
    WingGeo_Data = WingGeo(Design_Input,Count,Plot_WingGeo_Data); %Calculate specific wing geometry from wing configuration parameters

%% Calculations - Lift and Drag
% Call Wing Lift & Drag Model Function
    Plot_Wing_Data = 0;
    %Set to 0 to suppress plots for this function or 1 to output plots (Fig 20 - 29)
    [WingLiftModel,AoA,AoA_Count,AirfoilLiftCurve,WingLiftCurve,WingDragCurve] =...
        WingLiftDrag(Design_Input,Airfoil,Count,Benchmark,Plot_Wing_Data); 

% Call Parasite Drag Buildup Model Function
    Plot_Parasite_Data = 0; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 30 - 39)
    [Parasite_Data,FF_Table,Q_Table] = ...
        ParasiteDrag(Design_Input,Airfoil,WingGeo_Data,ATMOS,Count,Plot_Parasite_Data);

% Call Induced Drag Model Function
    Plot_Induced_Data = 0; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 40 - 49)
    InducedDrag_Data = ...
        InducedDrag(Design_Input,WingLiftModel,WingLiftCurve,WingDragCurve,WingGeo_Data,Count,Benchmark,Plot_Induced_Data,Parasite_Data);

% Call Complete Drag Polar Function
Plot_DragPolar_Data = 0; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 50 - 59)
[DragPolar_mod1,DragPolar_mod2,DragPolar_mod3] = ...
    DragPolar(Parasite_Data,InducedDrag_Data,Design_Input,AoA_Count,WingLiftCurve,WingDragCurve,AirfoilLiftCurve,Airfoil,Benchmark,Count,Plot_DragPolar_Data);

% Call L/D Analysis Function
    Plot_LD_Data = 0; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 60 - 69)
    [LD_mod1,LD_mod2,LD_mod3,LD_benchmark] = ...
        LD(Benchmark,DragPolar_mod1,DragPolar_mod2,DragPolar_mod3,WingLiftCurve,WingDragCurve,AoA_Count,Count,Plot_LD_Data);

%Call Weight Model
    Plot_Weight_Data = 0; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 70 - 79)
    [Weight_Data,CG_Data] = ...
        Weight(Design_Input,Count,WingGeo_Data,Airfoil,Material_Data,Component_Data,g,Plot_Weight_Data);

%% Calculations - Thrust & Dynamic Models
% Call Thrust Model
    Plot_Thrust_Data = 0; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 80 - 89)
    [ThrustCurves, Time, ThrustStruct] = Thrust(Plot_Thrust_Data);

% Call Boost-Ascent Flight Dynamics Model
    Plot_Boost_Data = 1; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 90 - 99)
    [apogee, hApogee, StateStruct] = BoostAscent(Design_Input, ATMOS, Parasite_Data, Weight_Data, ThrustCurves, Time, Count, g,Plot_Boost_Data);

% Call Glide Flight Dynamics Model (must select one drag polar model L/D
% data for use in this model)
    Plot_Glide_Data = 1; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 100 - 109)
    [GlideData] = GlideDescent(LD_mod1, apogee, Design_Input, ATMOS, Weight_Data, WingLiftModel, WingLiftCurve,WingDragCurve,hApogee,Count,Plot_Glide_Data); %Must select LD of your best model

%% Calculations - Stability Model
% Call Static Stability Function
    Plot_Stability_Data = 1; %Set to 0 to suppress plots for this function or 1 to output plots (Fig 110 - 119)
    [Boost_Initial_Stab,Boost_75_Stab,Boost_50_Stab,Boost_25_Stab,Boost_Empty_Stab,Glide_Stab,STAB_SM_SUMMARY,STAB_Xcg_SUMMARY,STAB_Xnp_SUMMARY,STAB_Vh_SUMMARY,STAB_Vv_SUMMARY,STAB_GLIDE_h1_SUMMARY]...
        = Stability(Design_Input, Count, CG_Data, WingGeo_Data, GlideData, WingLiftModel, Component_Data,Plot_Stability_Data);


%% Integrated Design and Trade Study Plots (2000 series plots)
    % Merged Boost-Ascent+Glide Flight Profile
    % Some setup to make plots more readable in color, look up the
    % documentation for 'cmap' for other color map options
    cmap = colormap(lines(Count));
    set(0,'DefaultAxesColorOrder',cmap)
    set(gca(),'ColorOrder',cmap);
    figure(2000)
    fields = fieldnames(StateStruct);
    for n = 1:Count
        [~, iApogee] = max(abs(StateStruct.(fields{n}).data(:, 6))); % find location of max z
        distBoost = vecnorm([StateStruct.(fields{n}).data(1:iApogee, 4), StateStruct.(fields{n}).data(1:iApogee, 5)], 2, 2);
        plot(distBoost,...
                -StateStruct.(fields{n}).data(1:iApogee, 6), ...
                DisplayName=Design_Input.Properties.RowNames{n}, Color=cmap(n, :))
        if n == 1
            hold on
        end
        p = plot([0, GlideData.bestGlide(n)] + distBoost(end),...
                [apogee(n), 0], ...
                DisplayName='', color = cmap(n, :));
        set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
    end
    xlabel('Total Lateral Distance Traveled [m]');
    ylabel('Height Achieved [m]');
    title('Boost-Best Glide 2D Total Distance Traveled');
    legend();
    grid on
    
    if Count ~= 1
        set(gcf,'Position',[0 0 960 440])
        l = xline(120,'--','k',DisplayName='');
        set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
    end
    hold off
    print("Boost Glide Plot " + num2str(Count),'-dpng','-r300')

    %Reset default color order
    set(0,'DefaultAxesColorOrder','default')

    %% CM over angle of attack
    figure(2100)
    cmap = colormap(lines(Count));
    set(0,'DefaultAxesColorOrder',cmap)
    set(gca(),'ColorOrder',cmap);
    hold on
    for n = 1:Count
        plot(AoA,(Glide_Stab.Cm0(n) + (Glide_Stab.Cm_alpha(n)*AoA)),DisplayName=Design_Input.Properties.RowNames{n}, Color=cmap(n, :))
    end
    ylabel('Cm');
    xlabel('Angle of Attack [Degrees]');
    l = yline(0,'k',DisplayName='');
    set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    legend();
    ylim([-0.15,0.3])
    xlim([-5,12])
    title('Moment Coefficient vs Angle of Attack');
    grid on
    hold off

    %%Design Trade Studies Plots
    %Student Team Developed Plots for Trade Studies (figures 3000 - 3999)
    %figure(3000)
%% Reset default color order
set(0,'DefaultAxesColorOrder','default')
