function y = fix_data(sensor,mode)

% mode 1: eliminiere Nullen
% mode 2: eliminiere +unendlich und -unendlich

if mode == 1
    nans = find(sensor == 0);            % Finde unplausible Werte
elseif mode == 2
    nans = find(sensor > 1000 | sensor < -1000);
end
time = 1:length(sensor);                % Erstelle numerischen Zeitvektor
i = time;                               % Kopiere Zeitvektor
sens_fixed = sensor;                    % Kopiere Volumenstromvektor
i(nans) = [];                           % Lösche Zeitwerte für unpl. Werte
sens_fixed(nans) = [];                  % Lösche unplausible Werte
y = interp1(i,sens_fixed,time,'linear');    %lin. Interpolation

end