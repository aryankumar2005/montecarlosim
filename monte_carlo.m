function monte_carlo()
% monte_carlo - Monte Carlo simulation of the time for a flavour particle
% to be removed from a thin film of oil
%
% For each initial separation distance, runs N trials. Each trial uses a
% random particle radius (uniform distribution) and a random viscosity
% (normal distribution), and solves the equation of motion with Euler's
% method to find the separation time.
%
% Inputs: none (all the parameters are set below)
% Outputs: prints the mean and standard deviation of the separation time
% for each initial separation distance, and plots them
%
% Example: monte_carlo

% Parameters
m = 0.00074;          % Mass of the particle (kg)
F0 = 1e-3;            % Applied force (N)
h = 1e-5;             % Time step (s)
N = 1000;             % Number of trials for each initial distance
film = 1e-4;          % Thickness of the oil film (m)
t_max = 0.2;          % Stop a trial if it takes longer than this (s)

R_min = 0.0001;       % Smallest particle radius (m)
R_max = 0.001;        % Largest particle radius (m)
eta_mean = 0.2;       % Mean viscosity of the oil (Pa.s)
eta_sd = 0.02;        % Standard deviation of the viscosity (Pa.s)

% Initial separation distances (m)
D0_values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50] * 1e-6;

% Arrays to store the mean and standard deviation of the separation time
mean_times = zeros(1, length(D0_values));
sd_times = zeros(1, length(D0_values));

% Loop over each initial separation distance
for j = 1:length(D0_values)

    % Current initial separation distance
    D0 = D0_values(j);

    % Array to store the separation time of each trial
    separation_times = zeros(1, N);

    % Run N trials
    for k = 1:N

        % Random radius from a uniform distribution between R_min and R_max
        R = R_min + (R_max - R_min) * rand;
        % Random viscosity from a normal distribution
        eta = eta_mean + eta_sd * randn;

        % Initial conditions
        D = D0;     % Separation distance (m)
        v = 0;      % Velocity (m/s)
        t = 0;      % Time (s)

        % Euler's method, keep going until the particle is out of the film
        % (t_max is just there so the loop can't run forever)
        while D < film && t < t_max
            % Rate of change of velocity from the equation of motion
            dv_dt = (F0 - (6 * pi * eta * R^2 / D) * v) / m;
            % Rate of change of separation distance is just the velocity
            dD_dt = v;

            % Update velocity and separation distance using the old values
            v = v + h * dv_dt;
            D = D + h * dD_dt;
            % Update time
            t = t + h;
        end

        % Store the separation time for this trial
        separation_times(k) = t;
    end

    % Mean and standard deviation of the separation times for this distance
    mean_times(j) = mean(separation_times);
    sd_times(j) = std(separation_times);
end

% Display the results
disp('Initial separation distance (um), Mean time (s), Standard deviation (s):');
disp([D0_values' * 1e6, mean_times', sd_times']);

% Plot the mean separation time against initial separation distance,
% with error bars of one standard deviation
figure;
errorbar(D0_values * 1e6, mean_times, sd_times, 'o-');
xlabel('Initial separation distance (micrometres)');
ylabel('Mean separation time (s)');
title('Monte Carlo results');
grid on;

end
