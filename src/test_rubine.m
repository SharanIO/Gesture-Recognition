function gesture_class = test_rubine(gesture_filename)

    % Load the saved weights and bias
    w0 = load("w0.mat");
    w0 = w0.w0;
    weight = load("weights.mat");
    weight = weight.weight;

    % Load the gesture data from the 'data' folder
    data = load(fullfile('data', gesture_filename));
    gesture_data = data.points;

    % Extract features from the new gesture data
    x = gesture_data(:, 1);
    y = gesture_data(:, 2);
    time = gesture_data(:, 3);
    tfeatures = extract_features(x, y, time);

    % Perform classification
    wf = transpose(weight) * transpose(tfeatures);
    v = w0 + wf;

    % Determine which class the gesture belongs to
    gesture_class = find(v == max(v));  % Return the class with the highest score
end
