% This example shows how to compute IRFs, HDs, and FEVDs of in a VAR with 
% data for unemployment and GDP growth using the VAR Toolbox.  
% Identification is achieved by imposing long-run restrictions à la 
% Blanchard and Quah.  

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
clear all; clear session; %close all; 
clc 
warning off all

folder = fileparts(which(mfilename));
pp     = genpath(pwd);
addpath(pp);

% Load
[xlsdata, xlstext] = xlsread('CombinedData.xlsx', 'Feuil1');
% Define data
X = xlsdata;
% Define label for plots
dates = xlstext(2:end,1);
vnames = xlstext(1,2:end);
% Define number of variables and of observations
[nobs, nvar] = size(X);


%% VAR ESTIMATION
% =======================================================================
% Set the case for the VARout (0, 1, or 2)
det = 2;
% Set number of nlags
nlags = 4;
% Estimate 
[VAR, VARopt] = VARmodel(X,nlags,det);
% Print at screen and create table
VARopt.vnames = vnames;
[beta, tstat, TABLE] = VARprint(VAR,VARopt);

pause

%% IMPULSE RESPONSE
% =======================================================================
% Set options some options for IRF calculation
VARopt.nsteps = 60;
VARopt.ident = 'bq';
VARopt.quality = 0;
% Compute IRF
[IRF, VAR] = VARir(VAR,VARopt);
% Compute error bands
[IRFINF,IRFSUP,IRFMED] = VARirband(VAR,VARopt);
% Plot
VARirplot(IRFMED,VARopt,IRFINF,IRFSUP);

pause
