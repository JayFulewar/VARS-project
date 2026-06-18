% VARS Optimization and Plotting Script
% Based on the E-Waste Incinerator VARS Project Methodology

clear; clc; close all;

% 1. DEFINE TEMPERATURE RANGES (Converted from Celsius to Kelvin)
% The Carnot COP formula requires absolute temperatures (Kelvin).
Tg_range = (87:1:107) + 273.15;  % Generator Temp: 87°C to 107°C
Te_range = (3:1:20)  + 273.15;   % Evaporator Temp: 3°C to 20°C
To_range = (30:1:50) + 273.15;   % Condenser/Absorber Temp: 30°C to 50°C

% 2. INITIALIZE VARIABLES FOR OPTIMIZATION
max_COP = 0;
opt_Tg = 0;
opt_Te = 0;
opt_To = 0;

% Target realistically feasible max COP based on literature review
target_COP_limit = 1.20; 

% 3. RUN ITERATIVE LOOPS TO FIND MAX COP
for Tg = Tg_range
    for Te = Te_range
        for To = To_range

            % Ensure physical validity (To must be strictly between Te and Tg)
            if To > Te && Tg > To

                % Maximum Theoretical COP Formula (Carnot)
                COP = (Te * (Tg - To)) / (Tg * (To - Te));

                % Check for optimal values under the realistic limit
                if COP > max_COP && COP <= target_COP_limit
                    max_COP = COP;
                    opt_Tg = Tg;
                    opt_Te = Te;
                    opt_To = To;
                end
            end
        end
    end
end

% 4. DISPLAY THE OPTIMIZED RESULTS
fprintf('--- Optimization Results ---\n');
fprintf('Optimal Generator Temp (Tg): %.0f °C\n', opt_Tg - 273.15);
fprintf('Optimal Evaporator Temp (Te): %.0f °C\n', opt_Te - 273.15);
fprintf('Optimal Condenser Temp (To): %.0f °C\n', opt_To - 273.15);
fprintf('Maximum Feasible COP: %.4f\n\n', max_COP);


% 5. PLOT THE PERFORMANCE GRAPHS
% Fixing two optimal temperatures to plot the variation of the third
Tg_fixed = 105 + 273.15; 
Te_fixed = 5   + 273.15;   
To_fixed = 43  + 273.15; 

% Figure 3.1.a: COP vs To (Condenser/Absorber Temp)
COP_vs_To = (Te_fixed .* (Tg_fixed - To_range)) ./ (Tg_fixed .* (To_range - Te_fixed));
figure(1);
plot(To_range, COP_vs_To, 'LineWidth', 1.5);
title('COP vs to');
xlabel('to (Kelvin)');
ylabel('COP');
grid on;

% Figure 3.1.b: COP vs Tg (Generator Temp)
COP_vs_Tg = (Te_fixed .* (Tg_range - To_fixed)) ./ (Tg_range .* (To_fixed - Te_fixed));
figure(2);
plot(Tg_range, COP_vs_Tg, 'LineWidth', 1.5);
title('COP vs tg');
xlabel('tg (Kelvin)');
ylabel('COP');
grid on;

% Figure 3.1.c: COP vs Te (Evaporator Temp)
COP_vs_Te = (Te_range .* (Tg_fixed - To_fixed)) ./ (Tg_fixed .* (To_fixed - Te_range));
figure(3);
plot(Te_range, COP_vs_Te, 'LineWidth', 1.5);
title('COP vs te');
xlabel('te (Kelvin)');
ylabel('COP');
grid on;