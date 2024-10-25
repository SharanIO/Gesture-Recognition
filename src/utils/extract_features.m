function tfeatures = extract_features(tx, ty, ttime)
    % Helper function to extract the 13 features from gesture data
    
    txmin = min(tx);
    tymin = min(ty);
    txmax = max(tx);
    tymax = max(ty);

    %feature1
    tf1 = (tx(3) - tx(1)) / sqrt(((tx(3) - tx(1))^2) + ((ty(3) - ty(1))^2));

    %feature2
    tf2 = (ty(3) - ty(1)) / sqrt(((tx(3) - tx(1))^2) + ((ty(3) - ty(1))^2));

    %feature3
    tf3 = sqrt(((txmax - txmin)^2) + ((tymax - tymin)^2));

    %feature4
    tf4 = atan((tymax - tymin) / (txmax - txmin));

    %feature5
    tf5 = sqrt(((tx(end) - tx(1))^2) + ((ty(end) - ty(1))^2));

    %feature6
    tf6 = (tx(end) - tx(1)) / tf5;

    %feature7
    tf7 = (ty(end) - tx(1)) / tf5;

    %feature8
    tcal8 = arrayfun(@(i) sqrt(((tx(i+1) - tx(i))^2) + ((ty(i+1) - ty(i))^2)), 1:length(tx)-1);
    tf8 = sum(tcal8);

    %feature9
    tcaltemp = arrayfun(@(i) (ty(i+1) - ty(i)) / (tx(i+1) - tx(i)), 2:length(tx)-1);
    tcal9 = arrayfun(@(i) atan(tcaltemp(i+1) - tcaltemp(i)) / (1 + tcaltemp(i+1) * tcaltemp(i)), 1:length(tcaltemp)-1);
    tcal9(isnan(tcal9)) = 0;
    tf9 = sum(tcal9);

    %feature10
    tf10 = sum(abs(tcal9));

    %feature11
    tf11 = sum(tcal9 .^ 2);

    %feature12
    tcal12 = arrayfun(@(i) (((tx(i+1) - tx(i))^2) + ((ty(i+1) - ty(i))^2)) / ((ttime(i+1) - ttime(i))^2), 1:length(tx)-1);
    tf12 = max(tcal12);

    %feature13
    tf13 = ttime(end) - ttime(1);

    % Return feature vector
    tfeatures = [tf1, tf2, tf3, tf4, tf5, tf6, tf7, tf8, tf9, tf10, tf11, tf12, tf13];
end
