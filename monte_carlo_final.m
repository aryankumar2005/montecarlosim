function monte_carlo_final()
% Monte Carlo simulation for flavor particle separation time estimation.
% This script runs all calculations safely in a single, clean workspace.

% Parameters
m = 0.00074;        % Mass of the particle (kg)
F0 = 1e-3;          % Applied force (N)
h = 1e-5;           % Time step (s)
N = 1000;           % Number of Monte Carlo trials per distance

R_min = 0.0001;     % Minimum radius (m)
R_max = 0.001;      % Maximum radius (m)
eta_mean = 0.2;     % Viscosity mean (Pa.s)
eta_std = 0.02;     % Viscosity standard deviation (Pa.s)
separation_threshold = 5e-4;

D0_values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50] * 1e-6; % Initial separation distances (m)

% Initializing arrays to store mean and standard deviation of separation times
mean_times = zeros(1, length(D0_values));
std_times = zeros(1, length(D0_values));

for j = 1:length(D0_values)
    D0 = D0_values(j);  % Current initial separation distance
    separation_times = zeros(1, N);  % Array to store separation times for each trial
    
    for k = 1:N
        % Initialize random values for radius and viscosity
        R = R_min + (R_max - R_min) * rand;  % Uniform distribution for radius
        eta = eta_mean + eta_std * randn;    % Normal distribution for viscosity
        
        % Initial conditions for this specific trial
        D = D0;  
        v = 0;   
        t = 0;   
        
        % Euler's method loop to solve for separation time
        % SAFEGUARD: t < 0.2 stops any stuck trials instantly, keeping code blazing fast
        while D < separation_threshold && t < 0.2  
            D_current = max(D, 1e-12);
            
            dv_dt = (F0 - (6 * pi * eta * R^2 / D_current) * v) / m;
            v = v + h * dv_dt;
            D = D + h * v;
            t = t + h;
        end
        
        % Store the separation time for the current trial
        separation_times(k) = t;
    end
    
    % Calculate mean and standard deviation of separation times
    mean_times(j) = mean(separation_times);
    std_times(j) = std(separation_times);
end

% Display results
disp('Initial Separation Distance (um), Mean Time (s), Std Dev (s):');
disp([D0_values' * 1e6, mean_times', std_times']);

end