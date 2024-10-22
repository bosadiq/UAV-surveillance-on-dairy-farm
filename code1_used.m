% Parameters
numCattles = 50; % Number of cattle
numUAVs = 5; % Number of UAVs
UAVRange = 100; % Range of UAVs
UAVEnergyValues = ones(numUAVs, 1) * 100; % Initial energy of UAVs for each UAV
HealthThreshold = 0.5; % Threshold for cattle health
UAVEnergyConsumption = 1; % Energy consumed per unit distance

% Initialize positions
cattlePositions = rand(numCattles, 2) * 100; % Random positions in a 100x100 area
UAVPositions = rand(numUAVs, 2) * 100;

% Health status simulation
cattleHealth = rand(numCattles, 1);

% Initialize UAV paths
UAVPaths = cell(numUAVs, 1);

for i = 1:numCattles
    if cattleHealth(i) < HealthThreshold
        % Find the nearest UAV
        distances = vecnorm(UAVPositions - cattlePositions(i,:), 2, 2);
        [minDistance, nearestUAV] = min(distances);
        
        % Check if the UAV can reach the cattle
        if minDistance <= UAVRange && UAVEnergyValues(nearestUAV) - (minDistance * UAVEnergyConsumption) > 0
            % Update UAV position
            UAVPositions(nearestUAV, :) = cattlePositions(i, :);
            % Update UAV energy
            UAVEnergyValues(nearestUAV) = UAVEnergyValues(nearestUAV) - (minDistance * UAVEnergyConsumption);
            % Save path
            UAVPaths{nearestUAV} = [UAVPaths{nearestUAV}; cattlePositions(i, :)];
        end
    end
end

% Plot UAV Monitoring Paths
figure;
hold on;
plot(cattlePositions(:,1), cattlePositions(:,2), 'bo');
plot(UAVPositions(:,1), UAVPositions(:,2), 'rs');
for k = 1:numUAVs
    if ~isempty(UAVPaths{k})
        plot(UAVPaths{k}(:,1), UAVPaths{k}(:,2), 'k--');
    end
end
xlabel('X Coordinate');
ylabel('Y Coordinate');
title('UAV Monitoring Paths');
legend('Cattles', 'UAVs', 'Paths');
hold off;

% Plot Cattle Health Status
figure;
bar(cattleHealth);
xlabel('Cattle ID');
ylabel('Health Status');
title('Health Status of Each Cattle');
ylim([0, 1]);

% Plot UAV Energy Levels
figure;
bar(UAVEnergyValues);
xlabel('UAV ID');
ylabel('Remaining Energy');
title('Remaining Energy of UAVs');
ylim([0, 100]);

% Plot Distances to Nearest UAV
distancesToNearestUAV = zeros(numCattles, 1);
for i = 1:numCattles
    distances = vecnorm(UAVPositions - cattlePositions(i,:), 2, 2);
    distancesToNearestUAV(i) = min(distances);
end
figure;
bar(distancesToNearestUAV);
xlabel('Cattle ID');
ylabel('Distance to Nearest UAV');
title('Distance of Each Cattle to the Nearest UAV');
