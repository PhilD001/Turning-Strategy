% This script runs regression models for the turn style preference paper
%
% Last updated by Philippe C. Dixon May 5th, 2018
%
% Instructions: 
% - Run each cell in sequence by selecting the cell and clicking 'run section'
% - Inspect output from each cell

clear all
close all

%% Extract data from xls sheet
% - select the supplemental data spreadsheet called 'data.xls' 

[f,p] = uigetfile('*.xls');                                      % select xls file
cd(p)
[num,txt,raw] = xlsread([p,f],'styles');

subject   = raw(2:end,1);
trial     = raw(2:end,2);
trialType = raw(2:end,3);
isStep    = raw(2:end,4);
surface   = raw(2:end,5);
condition = raw(2:end,6);
age       = raw(2:end,7);
sex       = raw(2:end,8);
mass      = raw(2:end,9);
height    = raw(2:end,10);
BMI       = raw(2:end,11);
balance   = raw(2:end,12);        
reaction  = raw(2:end,13);        
strength  = raw(2:end,14);        
SRegRV	  = raw(2:end,15);
StrRegRV  = raw(2:end,16);
maxRV	  = raw(2:end,17);
SPARCRV	  = raw(2:end,18);


%% Create table of data
% - variable types are updated to correct format


varNames = {'subject','trial','trialType','age','sex','mass','height','BMI',...
            'balance','reaction','strength','surface','condition',...
            'SRegRV','StrRegRV','maxRV','SPARCRV','isStep'};
        
tbl = table(subject,trial,trialType,age,sex,mass,height,BMI,balance,reaction,...
            strength,surface,condition,SRegRV,StrRegRV,maxRV,...
            SPARCRV,isStep,'VariableNames',varNames);

tbl.trialType  = categorical(tbl.trialType,'Ordinal',false);      % convert to nominal
tbl.surface    = categorical(tbl.surface,'Ordinal',false);        % convert to nominal
tbl.condition  = categorical(tbl.condition,'Ordinal',false);      % convert to nominal
tbl.sex        = categorical(tbl.sex,'Ordinal',false);            % convert to nominal
tbl.age        = cell2mat(tbl.age);                               % convert to numeric
tbl.mass       = cell2mat(tbl.mass);                              % convert to numeric
tbl.height     = cell2mat(tbl.height);                            % convert to numeric
tbl.BMI        = cell2mat(tbl.BMI);                               % convert to numeric
tbl.balance    = cell2mat(tbl.balance);                           % convert to numeric
tbl.reaction   = cell2mat(tbl.reaction);                          % convert to numeric
tbl.strength   = cell2mat(tbl.strength);                          % convert to numeric
tbl.isStep     = cell2mat(tbl.isStep);                            % convert to numeric
tbl.subject    = categorical(tbl.subject);                        % conver to string  
tbl.SRegRV	   = cell2mat(tbl.SRegRV);                            % convert to numeric
tbl.StrRegRV   = cell2mat(tbl.StrRegRV);                          % convert to numeric
tbl.maxRV	   = cell2mat(tbl.maxRV);                             % convert to numeric
tbl.SPARCRV	   = cell2mat(tbl.SPARCRV);                           % convert to numeric

%% GLME 1: Surface and condition
%
mdl1 = 'isStep~ 1 + surface + condition + (1|subject)';
glme1 = fitglme(tbl,mdl1,'Distribution','binomial')

% Results
% surface   p = 0.073
% condition p < 0.001*


%% ODDS Ratio
%
spin_by_condition = grpstats(tbl,{'condition','trialType'},'mean','DataVar','isStep')
gcount = spin_by_condition.GroupCount;
x = table([gcount(1);gcount(2)],[gcount(3);gcount(4)],'VariableNames',{'Step','Spin'},'RowNames',{'pre-planned','late-cue'})
[~,~,stats] = fishertest(x)

% Results
%
%  OddsRatio: 1.9323
%  ConfidenceInterval: [1.3629 2.7395]

%% GLME 2: Physiological parameters 
%
mdl2 = 'isStep~ 1 + balance + strength + reaction  + (1|subject)';
glme2 = fitglme(tbl,mdl2,'Distribution','binomial')

% Results 
% balance   p = 0.136    
% reaction  p = 0.241      
% strength  p = 0.811      



%% GLME 3: Gait parameters
%  
mdl3 = 'isStep~ 1 + SRegRV + StrRegRV + maxRV + SPARCRV + (1|subject)';
glme3 = fitglme(tbl,mdl3,'Distribution','binomial')

% Resuls
% SRegRV'    p = 0.218     
% StrRegRV'  p = 0.010*     
% maxRV'     p = 0.039*     
% SPARCRV'   p = 0.105    

