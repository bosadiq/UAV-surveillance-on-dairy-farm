% Constants and Initialization
N_Cattles = 50; % Example number of Cattles
N_UAVs = 5; % Example number of UAVs
UAV_Range = 100; % UAV Range
IoT_Range = 50; % IoT Range
UAV_Energy_Value = 100; % UAV Energy Value
Health_Threshold = 0.5; % Health Threshold
UAV_Energy_Consumption = 1; % UAV Energy Consumption per unit distance

% Initialize UAV and cattle positions, health, and energy levels
cattleHealth = rand(N_Cattles, 1); % Random health for demonstration
UAV_Energy = ones(N_UAVs, 1) * UAV_Energy_Value; % Energy level of each UAV
cattlePosition = rand(N_Cattles, 2) * 100; % Random positions for demonstration
UAV_Position = rand(N_UAVs, 2) * 100; % Random positions for demonstration
UAV_Path = cell(N_UAVs, 1); % Paths taken by UAVs

% Calculate and Display Distance of Each Cattle to Nearest UAV
nearestUAVDistance = inf(N_Cattles, 1);
cattleAssignedUAV = zeros(N_Cattles, 1); % Store which UAV is closest to each cattle
for i = 1:N_Cattles
    for j = 1:N_UAVs
        distance = sqrt(sum((cattlePosition(i,:) - UAV_Position(j,:)).^2));
        if distance < nearestUAVDistance(i) && distance <= UAV_Range
            nearestUAVDistance(i) = distance;
            cattleAssignedUAV(i) = j; % Assign this cattle to UAV j
        end
    end
    if cattleAssignedUAV(i) > 0 % If the cattle is assigned to a UAV
        UAV_Path{cattleAssignedUAV(i)} = [UAV_Path{cattleAssignedUAV(i)}; cattlePosition(i,:)]; % Add cattle position to UAV's path
    end
end

% Scatter Plot for UAV Monitoring Paths
figure;
hold on;
title('UAV Monitoring Paths');
xlabel('X Coordinate');
ylabel('Y Coordinate');

% Plot cattle positions
scatter(cattlePosition(:,1), cattlePosition(:,2), 'o', 'filled', 'DisplayName', 'Cattles');

% Plot UAV positions
scatter(UAV_Position(:,1), UAV_Position(:,2), 's', 'filled', 'DisplayName', 'UAVs');

% Plot the paths
for j = 1:N_UAVs
    if ~isempty(UAV_Path{j})
        % Plot the path for each UAV as a line from UAV to each assigned cattle
        UAV_Path_X = [UAV_Position(j,1) UAV_Path{j}(:,1)'];
        UAV_Path_Y = [UAV_Position(j,2) UAV_Path{j}(:,2)'];
        plot(UAV_Path_X, UAV_Path_Y, '-o', 'DisplayName', sprintf('Path UAV %d', j));
    end
end

% Add legend
legend;
hold off;

% Bar Plot for Health Status of Each Cattle
figure;
bar(cattleHealth);
title('Health Status of Each Cattle');
xlabel('Cattle ID');
ylabel('Health Status');
ylim([0 1]);

% Bar Plot for UAV Energy Levels
figure;
bar(UAV_Energy);
title('UAV Energy Levels');
xlabel('UAV ID');
ylabel('Energy Level');

% Bar Plot for Distance of Each Cattle to Nearest UAV
figure;
bar(nearestUAVDistance);
title('Distance of Each Cattle to Nearest UAV');
xlabel('Cattle ID');
ylabel('Distance to Nearest UAV')
