function [weight, w0] = train_rubine()
    addpath('utils');
    features = [];

    % Load all gesture data files
    data_path = fullfile(pwd, '..', 'data');  % Get the absolute path to 'data' folder

    % Load all gesture data files from the 'data' folder
    mat = dir(fullfile(data_path, 'rubine_data/*.mat'));
    if isempty(mat)
        error('No data files found in the data directory.');
    end
    for i = 1:length(mat)
        data = load(fullfile(mat(i).folder, mat(i).name));
        gesture_points = data.points;
        x = gesture_points(:, 1);
        y = gesture_points(:, 2);
        time = gesture_points(:, 3);

        % Extract features for this gesture
        features(i,:) = extract_features(x, y, time);
    end

    % Class means and covariance
    c1 = features(1:15,:);
    c2 = features(16:30,:);
    c3 = features(31:45,:);
    c4 = features(46:60,:);
    c5 = features(61:75,:);
    c6 = features(76:90,:);
    c7 = features(91:105,:);

    % Compute mean feature vectors for each class
    class_means = cellfun(@(c) mean(c, 1), {c1, c2, c3, c4, c5, c6, c7}, 'UniformOutput', false);
    
    % Compute covariances and inverse covariance matrix
    cov_matrices = cell(7,1);
    for i = 1:7
        cov_matrices{i} = cov(features((i-1)*15+1:i*15, :));
    end
    avg_cov = mean(cat(3, cov_matrices{:}), 3);
    inv_avg_cov = inv(avg_cov);
    
    % Compute weights for each class
    weight = cell2mat(cellfun(@(mean_vec) inv_avg_cov * mean_vec', class_means, 'UniformOutput', false));

    % Bias term calculation
    w0 = 0;  % Initialize bias term
    for i = 1:7
        mean_vec = class_means{i};
        w0 = w0 + weight' * mean_vec';
    end
    w0 = -(1/2) * w0;

    % Save the weights and bias in the 'data' folder
    save(fullfile(data_path, 'weights.mat'), 'weight');
    save(fullfile(data_path, 'w0.mat'), 'w0');
end