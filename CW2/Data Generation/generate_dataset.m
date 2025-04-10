% generate_dataset.m
% Script to generate simulation data using FEA automation (with error logging and retries)

% Set number of samples
N = 100;  % Adjust as needed

% Latin Hypercube Sampling (normalized between 0 and 1)
X_norm = lhsdesign(N, 4);

% Rescale to actual parameter bounds
W1 = 0.4 + X_norm(:,1)*(0.6 - 0.4);
W2 = 0.1 + X_norm(:,2)*(0.2 - 0.1);
R  = 0.04 + X_norm(:,3)*(0.06 - 0.04);
t  = 0.01 + X_norm(:,4)*(0.02 - 0.01);

% Preallocate arrays
sigma_max = zeros(N,1);
mass = zeros(N,1);
runtime = zeros(N,1);

% Material density
rho = 2700;

% Error tracking
failed_inputs = [];
error_msgs = {};

% Open error log
logFile = fopen('error_log.txt', 'w');
fprintf(logFile, 'Simulation Error Log\n---------------------\n');

% Loop through all samples
for i = 1:N
    fprintf('Running simulation %d of %d...\n', i, N);

    success = false;
    attempts = 0;

    while ~success && attempts < 2
        attempts = attempts + 1;
        try
            [sigma_max(i), runtime(i)] = MaintenancePlate_StressExtract_Function(W1(i), W2(i), R(i), t(i));
            mass(i) = rho * t(i) * (4*W1(i)^2 - 4*W2(i)^2 + (4 - pi)*R(i)^2);
            success = true;
        catch ME
            fprintf('  Attempt %d failed: %s\n', attempts, ME.message);
            if attempts == 2
                % Log failure
                sigma_max(i) = NaN;
                mass(i) = NaN;
                runtime(i) = NaN;

                fprintf(logFile, '[%s] Simulation %d FAILED after 2 attempts\n', datestr(now), i);
                fprintf(logFile, '  Inputs: W1=%.4f, W2=%.4f, R=%.4f, t=%.4f\n', W1(i), W2(i), R(i), t(i));
                fprintf(logFile, '  Error: %s\n\n', ME.message);

                failed_inputs = [failed_inputs; W1(i), W2(i), R(i), t(i)];
                error_msgs{end+1} = ME.message;
            end
        end
    end
end

% Save successful results
T = table(W1, W2, R, t, sigma_max, mass, runtime);
writetable(T, 'simulation_results.csv');
fprintf('✅ Data saved to simulation_results.csv\n');

% Save failed cases if any
if ~isempty(failed_inputs)
    failed_tbl = array2table(failed_inputs, 'VariableNames', {'W1', 'W2', 'R', 't'});
    writetable(failed_tbl, 'failed_cases.csv');
    fprintf('⚠️ %d simulations failed. See failed_cases.csv and error_log.txt\n', size(failed_inputs,1));
else
    fprintf('✅ All simulations completed successfully.\n');
end

% Close the error log
fclose(logFile);
