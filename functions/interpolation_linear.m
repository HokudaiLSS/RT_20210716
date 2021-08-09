function outputs = interpolation_linear(inputs)
%% Overview
% This function does a quick linear interpolation for a single parameter or
% double parameter lookup.

% Inputs:
%    value "value" [var] (e.g. CEA database for temperature_chamber)
%    abscissa "x" [var] (e.g. O/F in CEA databases)
%    abscissadomain "xdom" [var]
%    abscissainterval "dx" [var]
%    abscissaoffset "xoff" [var]
%    length_abscissadomain "Lx" [#]

% Conditional Inputs:
% *** 2D interpoloation case
%    length_ordinatedomain "Ly" [#]
%    ordinate "y" [var] (e.g. P_c in CEA databases)
%    ordinatedomain "ydom" [var]
%    ordinateinterval "dy" [var]
%    ordinateoffset "yoff" [var]

% Outputs:
%    interpolation_linear [var]

% Senior Functions:
%    calculation_pressure_chamber_PRTM
%    calculation_thrust_TRTEM

%% Test Data: a 2-dimensional CEA interpolation
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs = CEA.N2OHDPE.domain;
% inputs.abscissa = 6;
% inputs.ordinate = 3;
% inputs.value = CEA.N2OHDPE.temperature_chamber.value;

%% Test Data: a 1-dimensional CEA interpolation
% load(strcat(strrep(pwd,'functions','databases'),'\CEA'))
% inputs = CEA.N2OHDPE.domain;
% inputs.abscissa = 6;
% inputs.value = CEA.N2OHDPE.temperature_chamber.value(:,30);

%% Assign Inputs to Symbols
dx = inputs.abscissainterval;
Lx = inputs.length_abscissadomain;
value = inputs.value;
x = inputs.abscissa;
xdom = inputs.abscissadomain;
xoff = inputs.abscissaoffset;

if length(value(1,:)) > 2
    dy = inputs.ordinateinterval;
    Ly = inputs.length_ordinatedomain;
    y = inputs.ordinate;
    ydom = inputs.ordinatedomain;
    yoff = inputs.ordinateoffset;
end

%% The One-dimensional Linear Interpolation
% computation 1: round
% output: index_abscissa "Xi" [var]
Xi = round(1 + (x - xoff)/dx);

% Account for inputs that lay outside of the abscissa domain
if Xi < 2
    Xi = round(2);
end
if Xi > (Lx-1)
    Xi = Lx-1;
end
Xi2 = Xi-1;
X   = xdom(Xi2);

% computation 2: -
% output: run "dX" [var]
dX  = xdom(Xi) - xdom(Xi2);
a  = value(Xi);
b  = value(Xi2);

% computation 3: - / * +
% output: interpolation_linear "z" [var]
z = ((a - b)/(dX))*(x - X) + b;

%% The Two Dimensional Interpolation if Applicable
if length(value(1,:)) > 2
    % computation c1-1: round
    % output: index_ordinate "Yi" [var]
    Yi = round(1 + (y - yoff)/dy);
    if Yi < 2
        Yi = round(2);
    end
    if Yi > (Ly-1)
        Yi = Ly-1;
    end
    
    % computation c1-2: -
    % output: run "dY" [var]
    Yi2 = Yi-1;
    Y   = ydom(Yi2);
    dY  = ydom(Yi) - ydom(Yi2);
    a  = value(Xi,Yi2);
    b  = value(Xi2,Yi2);
    c  = value(Xi,Yi);
    d  = value(Xi2,Yi);

    % computation c1-3: - / * +
    % output: interpolation_linear abscissa 1 "z1" [var]
    z1 = ((a - b)/(dX))*(x - X) + b;
    
    % computation c1-4: - / * +
    % output: interpolation_linear abscissa 2 "z2" [var]
    z2 = ((c - d)/(dX))*(x - X) + d;
    
    % computation c1-5: - / * +
    % output: interpolation_linear "z" [var]
    z  = ((z2 - z1)/(dY))*(y - Y) + z1;
end

%% Assign Symbols to Outputs
outputs.interpolation_linear = z;
end