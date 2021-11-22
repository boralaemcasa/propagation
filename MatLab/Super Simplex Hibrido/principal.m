% Lançador para o Algoritmo Simplex
% Disciplina Otimização em Engenharia
% Prof. Rodney Rezende Saldanha
% =============================================================
% Deleta todas as variáveis.
  clear;
  close all;
  format long;
% -------------------------------------------
% Turn off warning : 'Matrix is close to singular or badly scaled.
% Results may be inaccurate.'
  warning('off','all') 
% -------------------------------------------

% RUNSIMPLEX(2);
% RUNSIMPLEX(4);
% RUNSIMPLEX(6);
% RUNSIMPLEX(10);
% RUNSIMPLEX(14);
% RUNSIMPLEX(18);
% RUNSIMPLEX(20);
% RUNSIMPLEX(22);
% RUNSIMPLEX(24);
% RUNSIMPLEX(26);

gap = 1.0e-02; % Gap de Dualidade
passo = 0.5;

% gap = 1.0e-06;
% passo = [0.01, 0.05, 0.1, 0.3, 0.5, 0.7, 0.8, 0.9, 0.95, 0.99]';

% gap = [1.0e-01, 1.0e-02, 1.0e-04, 1.0e-06, 1.0e-08, 1.0e-10]';
% passo = 0.95;

% RUNPI(2,gap,passo);
% RUNPI(4,gap,passo);
% RUNPI(6,gap,passo);
% RUNPI(10,gap,passo);
% RUNPI(14,gap,passo);
% RUNPI(18,gap,passo);
% RUNPI(20,gap,passo);
% RUNPI(22,gap,passo);
% RUNPI(24,gap,passo);
% RUNPI(26,gap,passo);

RUNHIBRID(2,gap,passo);
RUNHIBRID(4,gap,passo);
RUNHIBRID(6,gap,passo);
RUNHIBRID(10,gap,passo);
RUNHIBRID(14,gap,passo);
RUNHIBRID(18,gap,passo);
RUNHIBRID(20,gap,passo);
RUNHIBRID(22,gap,passo);
RUNHIBRID(24,gap,passo);
RUNHIBRID(26,gap,passo);
