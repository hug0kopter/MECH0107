% --- Setup ---
N = 1100;  % Number of samples

% Latin Hypercube Sampling 
X_norm = lhsdesign(N, 4);

% Scale normalized variables to actual parameter bounds
W1 = 0.4 + X_norm(:,1)*(0.6 - 0.4);
W2 = 0.1 + X_norm(:,2)*(0.2 - 0.1);
R  = 0.04 + X_norm(:,3)*(0.06 - 0.04);
t  = 0.01 + X_norm(:,4)*(0.02 - 0.01);

% Material density
rho = 2700;

% Output file setup
header = {'W1', 'W2', 'R', 't', 'sigma_max', 'mass', 'runtime'};
resultsFile = 'simulation_results.csv';

fid_out = fopen(resultsFile, 'w');
fprintf(fid_out, '%s,%s,%s,%s,%s,%s,%s\n', header{:});
fclose(fid_out);

% --- Simulation Loop ---
for i = 1:N
    fprintf('Running simulation %d of %d...\n', i, N);

    % Run FEA simulation
    [sigma_i, runtime_i] = MaintenancePlate_StressExtract_Function(W1(i), W2(i), R(i), t(i));

    % Calculate mass
    mass_i = rho * t(i) * (4*W1(i)^2 - 4*W2(i)^2 + (4 - pi)*R(i)^2);

    % Append result to file
    fid_out = fopen(resultsFile, 'a');
    fprintf(fid_out, '%.10f,%.10f,%.10f,%.10f,%.6f,%.6f,%.8f\n', ...
        W1(i), W2(i), R(i), t(i), sigma_i, mass_i, runtime_i);
    fclose(fid_out);
end

fprintf('All simulations completed and saved to %s.\n', resultsFile);