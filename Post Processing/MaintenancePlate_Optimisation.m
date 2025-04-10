% Multi-objective optimization of a stiffened plate using NSGA-II in MATLAB
% Objectives: Minimize mass and von Mises stress

clc; clear; close all;

% Constants
rho = 2700; % Density of aluminum alloy (kg/m^3)

% Variable bounds
lb = [0.4, 0.1, 0.04, 0.01]; % Lower bounds
ub = [0.6, 0.2, 0.06, 0.02]; % Upper bounds

% Number of design variables
nVar = length(lb);

% Optimization using NSGA-II
gen = 100; % Number of generations
popSize = 100; % Population size

% Run NSGA-II
initPop = lb + (ub - lb) .* lhsdesign(popSize, nVar); % LHS sampling
options = optimoptions('gamultiobj', ...
    'PopulationSize', popSize, ...
    'MaxGenerations', gen, ...
    'InitialPopulationMatrix', initPop, ...
    'CrossoverFraction', 0.9, ...
    'MutationFcn', {@mutationadaptfeasible, 0.2}, ...
    'Display', 'iter', ...
    'PlotFcn', @gaplotpareto);

% Objective function
objFcn = @(X) plateObjectives(X, rho);

% Run the optimization
[X_pareto, F_pareto, exitFlag, output, population, scores] = gamultiobj(objFcn, nVar, [], [], [], [], lb, ub, options);

% Extract mass and stress values
mass_pareto = F_pareto(:, 1);
stress_pareto = F_pareto(:, 2);

% Extract all sub-optimal solutions
mass_all = scores(:, 1);
stress_all = scores(:, 2);

% Plot Pareto Front and Sub-Optimal Solutions
figure('color','white')
scatter(mass_all, stress_all, 'ko', 'MarkerEdgeAlpha', 0.25,'MarkerFaceColor','k','MarkerFaceAlpha', 0.25); % Sub-optimal solutions
hold on;
scatter(mass_pareto, stress_pareto, 'bo', 'filled'); % Pareto front solutions
xlabel('Mass (kg)');
ylabel('Maximum von Mises Stress (MPa)');
grid on;
legend('Sub-Optimal Solutions', 'Pareto Front (Optimal Solutions)');
exportgraphics(gcf, 'Fig_CW2_ParetoFront.png', 'Resolution',500)

%% Objective function definition
function F = plateObjectives(X, rho)
    % Extract design variables
    W1 = X(:, 1);
    W2 = X(:, 2);
    R = X(:, 3);
    t = X(:, 4);
    
    % Compute mass of the plate
    mass_values = rho .* t .* (4 .* W1.^2 - 4 .* W2.^2 + (4 - pi) .* R.^2);
    
    % Compute von Mises stress using a dummy equation (to be replaced with your surrogate models)
    a = 1e3; b = 1e3; c = 1e3; d = 1e3; % Coefficients
    stress_values = a .* W1 + b .* W2 - c .* R - d .* t;
    
    % Return objectives
    F = [mass_values, stress_values];
end
