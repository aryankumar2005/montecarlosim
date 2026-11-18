function separation_time()
% separation_time - Time for one flavour particle to be removed from a thin
% film of oil
%
% Solves the equation of motion with Euler's method for a single particle
% with a fixed radius and viscosity, then plots the separation distance
% against time.
%
% Inputs: none (all the parameters are set below)
% Outputs: prints the separation time and plots D(t)
%
% Example: separation_time

% Parameters
m = 0.00074;      % Mass of the particle (kg)
F0 = 1e-3;        % Applied force (N)
R = 0.0005;       % Radius of the particle (m)
eta = 0.2;        % Viscosity of the oil (Pa.s)
D0 = 1e-6;        % Initial separation distance (m)
film = 1e-4;      % Thickness of the oil film (m)
h = 1e-5;         % Time step (s)

% Initial conditions
D = D0;           % Separation distance (m)
v = 0;            % Velocity (m/s)
t = 0;            % Time (s)

% Arrays to store the results so they can be plotted
t_values = t;
D_values = D;

% Euler's method, keep going until the particle is out of the film
while D < film
    % Rate of change of velocity from the equation of motion
    dv_dt = (F0 - (6 * pi * eta * R^2 / D) * v) / m;
    % Rate of change of separation distance is just the velocity
    dD_dt = v;

    % Update velocity and separation distance using the old values
    v = v + h * dv_dt;
    D = D + h * dD_dt;
    % Update time
    t = t + h;

    % Store the new values
    t_values(end+1) = t;
    D_values(end+1) = D;
end

% Display the separation time
fprintf('Particle separated from the film at t = %.4f seconds\n', t);

% Plot separation distance against time
figure;
plot(t_values, D_values, 'b-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Separation distance D(t) (m)');
title('Separation distance against time for one particle');
grid on;

end
