clear all; clc; close all; % Keep super clean.
interval = 8; % How long it is between two detections, in seconds.
decetion_times = 8; % How many times do you want to detect.
trainedClassifier = load('trainedModelBagTree'); % Load .mat file from MATLAB Deive.
for external_loop = 1:1:decetion_times+1
    if external_loop ~= 1 % Skip the first loop for initialisation.
        [a,t] = magfieldlog(m); % a is the input matrix for the model.
        % The size of a should be equal to interval * frequenc,
        % however due to the limited performance on mobile devices,
        % it is apt to be marginally less than the estimation value.
        clear m; % Empty the log variable in every loop for saving memory.
        scattered_coe = abs((max(a)-min(a))/mean(a))
        disp(datestr(now))
        a = array2table(a);
        featlabels_test = {'x', 'y', 'z'};
        a.Properties.VariableNames = featlabels_test;
        pred = trainedClassifier.trainedModelBagTree.predictFcn(a);
        pred = pred';
        pred = pred(:)';
        tab_pred = tabulate(pred);
        if scattered_coe >= exp(-1)
            disp(tab_pred)
        else
            disp('User lost himself.');
        end
    end
    m = mobiledev; % Turn on and initialise the receiver.
    m.MagneticSensorEnabled = 1; % Ensure the magnetic sensor is on.
    m.Logging = 1; % Start logging.
    tnit_time=clock; % Start timing.
    % Timer.
    for inner_loop = 1:1:1073741824 % Very bad design.
        if etime(clock,tnit_time)>interval
            break
        end
    end
    fprintf('\n')
end
