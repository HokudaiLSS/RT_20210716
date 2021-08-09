function outputs = integration_trapezoidal(inputs)
%% Overview
% This function does a trapezoidal integration and provides the cumulative
% area curve of the integration.

% Inputs:
%    abscissa "x" [var]
%    ordinate "y" [var]

% Outputs:
%    integral_trapezoidal "S" [var]
%    area_total ***S(end) [var]

% Senior Functions:
% iteration_efficiency_combustion_PRTM
% iteration_efficiency_thrust_TRTEM

%% Test Data
% inputs.abscissa = 0:0.1:3;
% inputs.ordinate = inputs.abscissa;

%% Assign Inputs to Symbols
x = inputs.abscissa;
y = inputs.ordinate;

%% The Calculation
% allocate space for solution vectors in advance
Lx = length(x);
dx = zeros(Lx,1); 
dy = zeros(Lx,1);
S  = zeros(Lx,1);

for i = 2:Lx
    % computation 1: -
    % output 1: abscissa_differential
    dx(i) = x(i) - x(i-1);
    
    % computation 2: *
    % output 2: ordinate_differential
    dy(i) = (1/2) * (y(i)+y(i-1));
    
    % computation 3: +
    % output 3: integral
    S(i) = dy(i)*dx(i) + S(i-1);
end

%% Assign Symbols to Outputs
outputs.area_total = S(end);
outputs.integral_trapezoidal = S;
end