

% This example shows how to compute IRFs, HDs, and FEVDs in a VAR with 
% data for inflation, unemployment, and interest rates using the VAR 
% Toolbox.  Identification of a demand, a supply, and a monetary policy 
% shock is achieved with a sign restriction procedure.  

% The VAR Toolbox 2.0 is required to run this code. To get the 
% latest version of the toolboxes visit: 
% 
%       https://sites.google.com/site/ambropo/MatlabCodes
% 
% =======================================================================
% Ambrogio Cesa Bianchi, March 2015
% ambrogio.cesabianchi@gmail.com


%% 1. PRELIMINARIES
% =======================================================================
clear all; clear session; close all; clc
warning off all

folder = fileparts(which(mfilename));
pp     = genpath(pwd);
addpath(pp);

% Load
[xlsdata, xlstext] = xlsread('CombinedData.xlsx','Feuil1');
X = xlsdata;


% DATA TRANSFORMATION

%% Transform variables
% GDP: Log + HP Filter
X(:,1) = 100 * (log(X(:,1)) - one_sided_hp_filter_serial(log(X(:,1)), 1600));

% 2. Inflation Log Difference
X(2:end, 2) = 400 * diff(log(X(:,2)));

% 3. Unemployment: Log + HP Filter
X(:,3) = 100 * (log(X(:,3)) - one_sided_hp_filter_serial(log(X(:,3)), 1600));

% Interest Rate: No transformation

% --- CLEANUP ---
% we remove the first row of the entire dataset to keep everything aligned.
X = X(2:end, :);

% Fix the Time Vector so graphs don't crash
T = 1:size(X,1);

% Define labels for your plots to match your data
vnames = {'GDP', 'Inflation', 'Unemployment', 'Bank Rate'};




% Define label for plots
dates = xlstext(2:end,1);
vnames = xlstext(1,2:end);
% Define number of variables and of observations
[nobs, nvar] = size(X);

T = 1:size(xlsdata, 1);
plot(T,xlsdata,'LineWidth',2),legend(vnames,'Location','NorthEast')

% Question 1: Plot raw data
T = 1:size(xlsdata, 1);
plot(T,xlsdata,'LineWidth',2),legend(vnames,'Location','NorthEast')
pause;close

%% VAR ESTIMATION
% =======================================================================
% Question 2: Estimate reduced-form VAR. Inspect the output
% Set the case for the VARout (0, 1 - cst, or 2 - cst+trend)
det = 2;
% Set number of nlags
nlags = 4;
% Estimate 
[VAR, VARopt] = VARmodel(X,nlags,det);
% Print at screen and create table
VARopt.vnames = vnames;
[beta, tstat, TABLE] = VARprint(VAR,VARopt);

pause;

% Q3: Trace the effects of a restrictive MP shock. Plot the IRFs at 24
% quarters with 66% confidence bands. Comments.

%% IMPULSE RESPONSE WITH CHOLESKY
% =======================================================================
% Set options some options for IRF calculation
VARopt.nsteps  = 24;
VARopt.ident   = 'oir';
VARopt.impact  = 1;     % 0 = 1 std shock / 1 = unit shock
VARopt.pctg    = 66; % Lower bound = (100-pctg)/2 / Upper bound = 100 - (100-pctg)/2
% Compute IRF
[IRF, VAR] = VARir(VAR,VARopt);
% Compute error bands
[IRFINF,IRFSUP,IRFMED] = VARirband(VAR,VARopt);

% Plot
VARirplot(IRFMED,VARopt,IRFINF,IRFSUP);

% Put all IRFs on one graph.
lab = { ...
    'GDP shock to GDP',    'GDP shock to Inflation',    'GDP shock to Unemp.',    'GDP shock to Bank Rate', ...
    'Inflation shock to GDP',     'Inflation shock to Inflation',     'Inflation shock to Unemp.',     'Inflation shock to Bank Rate', ...
    'Unemp. shock to GDP',        'Unemp. shock to Inflation',        'Unemp. shock to Unemp.',        'Unemp. shock to Bank Rate', ...
    'Bank Rate shock to GDP',     'Bank Rate shock to Inflation',     'Bank Rate shock to Unemp.',     'Bank Rate shock to Bank Rate'};

figure;

% --- ROW 1: GDP SHOCKS ---
subplot(4,4,1); plot(IRFMED(:,1,1),'k','LineWidth',2); hold on; plot([IRFINF(:,1,1) IRFSUP(:,1,1)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{1},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,2); plot(IRFMED(:,2,1),'k','LineWidth',2); hold on; plot([IRFINF(:,2,1) IRFSUP(:,2,1)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{2},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,3); plot(IRFMED(:,3,1),'k','LineWidth',2); hold on; plot([IRFINF(:,3,1) IRFSUP(:,3,1)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{3},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,4); plot(IRFMED(:,4,1),'k','LineWidth',2); hold on; plot([IRFINF(:,4,1) IRFSUP(:,4,1)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{4},'FontName','Times New Roman','FontSize',8); box off

% --- ROW 2: INFLATION SHOCKS ---
subplot(4,4,5); plot(IRFMED(:,1,2),'k','LineWidth',2); hold on; plot([IRFINF(:,1,2) IRFSUP(:,1,2)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{5},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,6); plot(IRFMED(:,2,2),'k','LineWidth',2); hold on; plot([IRFINF(:,2,2) IRFSUP(:,2,2)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{6},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,7); plot(IRFMED(:,3,2),'k','LineWidth',2); hold on; plot([IRFINF(:,3,2) IRFSUP(:,3,2)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{7},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,8); plot(IRFMED(:,4,2),'k','LineWidth',2); hold on; plot([IRFINF(:,4,2) IRFSUP(:,4,2)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{8},'FontName','Times New Roman','FontSize',8); box off


% --- ROW 3: UNEMPLOYMENT SHOCKS ---
subplot(4,4,9); plot(IRFMED(:,1,3),'k','LineWidth',2); hold on; plot([IRFINF(:,1,3) IRFSUP(:,1,3)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{9},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,10); plot(IRFMED(:,2,3),'k','LineWidth',2); hold on; plot([IRFINF(:,2,3) IRFSUP(:,2,3)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{10},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,11); plot(IRFMED(:,3,3),'k','LineWidth',2); hold on; plot([IRFINF(:,3,3) IRFSUP(:,3,3)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{11},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,12); plot(IRFMED(:,4,3),'k','LineWidth',2); hold on; plot([IRFINF(:,4,3) IRFSUP(:,4,3)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{12},'FontName','Times New Roman','FontSize',8); box off

% --- ROW 4: BANK RATE SHOCKS (Formerly MP) ---
subplot(4,4,13); plot(IRFMED(:,1,4),'k','LineWidth',2); hold on; plot([IRFINF(:,1,4) IRFSUP(:,1,4)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{13},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,14); plot(IRFMED(:,2,4),'k','LineWidth',2); hold on; plot([IRFINF(:,2,4) IRFSUP(:,2,4)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{14},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,15); plot(IRFMED(:,3,4),'k','LineWidth',2); hold on; plot([IRFINF(:,3,4) IRFSUP(:,3,4)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{15},'FontName','Times New Roman','FontSize',8); box off

subplot(4,4,16); plot(IRFMED(:,4,4),'k','LineWidth',2); hold on; plot([IRFINF(:,4,4) IRFSUP(:,4,4)],':k'); hold on;
plot(zeros(length(IRFMED),1),':r'); title(lab{16},'FontName','Times New Roman','FontSize',8); box off