%% Refine 1
% พารามิเตอร์
theta  = [0 : pi/50 : 8*pi]';     % มุมเกลียว
t_vec2 = [0 : length(theta)-1]' * 0.1; 
lambda = 0.03;                    % ลดรัศมีลงช้า ๆ

% รัศมีเกลียวหลัก
R = exp(-lambda * t_vec2);

% รัศมีหน้าตัด (ความหนาของก้อน)
tube_radius = 0.35;               

% สร้างหน้าตัดวงกลมรอบเกลียว
n = 30;                           
phi = linspace(0, 2*pi, n);       
[theta_grid, phi_grid] = meshgrid(theta, phi);

% คำนวณตำแหน่งเกลียวหลัก (pitch เล็กมากให้ขดติดกัน)
pitch = 0.06;  % ค่านี้ยิ่งเล็ก ยิ่งขดถี่
x_center = R .* cos(theta);
y_center = R .* sin(theta);
z_center = pitch * theta;

% ทำให้เป็น 2D grid
x_center_grid = repmat(x_center', n, 1);
y_center_grid = repmat(y_center', n, 1);
z_center_grid = repmat(z_center', n, 1);

% คำนวณ offset ของวงกลมรอบแกน
x = x_center_grid + tube_radius * cos(phi_grid) .* cos(theta_grid);
y = y_center_grid + tube_radius * cos(phi_grid) .* sin(theta_grid);
z = z_center_grid + tube_radius * sin(phi_grid);

% วาดผิว
figure;
set(gcf, 'Position', [0 0 1280 720]);
surf(x, y, z, ...
    'FaceColor', [0.55 0.27 0.07], ... % น้ำตาล
    'EdgeColor', 'none');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;
camlight; lighting gouraud; 
title('💩 ก้อนอึ');

%{
ปรับ pitch เหลือ 0.05 เพื่อให้ขดถี่จนแทบติดกัน

ลด lambda ให้รัศมีเล็กลงช้าหน่อย เพื่อให้ดูเป็นกอง ๆ ไม่หดเร็วเกิน

เพิ่ม tube_radius ให้ก้อนอึดูเต็ม ๆ 
%}

%% Refine 2
% พารามิเตอร์
theta  = [0 : pi/50 : 8*pi]';     % มุมเกลียว
t_vec2 = [0 : length(theta)-1]' * 0.1; 
lambda = 0.02;                    % ลดรัศมีหลักลงช้า ๆ

% รัศมีเกลียวหลัก
R = exp(-lambda * t_vec2);

% รัศมีหน้าตัดเริ่มต้น
tube_radius_start = 0.35;         
tube_radius_end   = 0.05;         % ปลายยอดเล็ก

% คำนวณการลดลงของ tube radius ตาม theta (เชิงเส้น)
tube_radius_vec = linspace(tube_radius_start, tube_radius_end, length(theta));

% สร้างหน้าตัดวงกลมรอบเกลียว
n = 30;                           
phi = linspace(0, 2*pi, n);       
[theta_grid, phi_grid] = meshgrid(theta, phi);

% คำนวณตำแหน่งเกลียวหลัก (pitch เล็กมากให้ขดติดกัน)
pitch = 0.05;  % ยิ่งเล็ก ยิ่งขดถี่
x_center = R .* cos(theta);
y_center = R .* sin(theta);
z_center = pitch * theta;

% ทำให้เป็น 2D grid
x_center_grid = repmat(x_center', n, 1);
y_center_grid = repmat(y_center', n, 1);
z_center_grid = repmat(z_center', n, 1);

% รัศมีท่อในรูป grid (ให้แต่ละหน้าตัดมีขนาดไม่เท่ากัน)
tube_radius_grid = repmat(tube_radius_vec', 1, n)';

% คำนวณ offset ของวงกลมรอบแกน
x = x_center_grid + tube_radius_grid .* cos(phi_grid) .* cos(theta_grid);
y = y_center_grid + tube_radius_grid .* cos(phi_grid) .* sin(theta_grid);
z = z_center_grid + tube_radius_grid .* sin(phi_grid);

% วาดผิว
figure;
set(gcf, 'Position', [0 0 1280 720]);
surf(x, y, z, ...
    'FaceColor', [0.55 0.27 0.07], ... % น้ำตาล
    'EdgeColor', 'none');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;
camlight; lighting gouraud; 
title('💩 ก้อนอึ ปลายแหลม');

%% Refine 3
% พารามิเตอร์
theta  = [0 : pi/50 : 8*pi]';
t_vec2 = [0 : length(theta)-1]' * 0.1; 

% รัศมีเกลียวหลัก (ให้หดเร็วขึ้นนิดหน่อยช่วงท้าย)
lambda_base = 0.02;  
lambda_vec = lambda_base + 0.05 * (theta / max(theta)).^2;
R = exp(-lambda_vec .* t_vec2);

% รัศมีหน้าตัดเริ่มต้น → ค่อย ๆ ลดลง
tube_radius_start = 0.35;
tube_radius_end   = 0.05;
tube_radius_vec = linspace(tube_radius_start, tube_radius_end, length(theta));

% pitch ค่อย ๆ ลดลงช่วงท้าย
pitch_start = 0.05;
pitch_end   = 0.01;
pitch_vec = linspace(pitch_start, pitch_end, length(theta));

% meshgrid สำหรับวงกลมรอบแกน
n = 30;
phi = linspace(0, 2*pi, n);
[theta_grid, phi_grid] = meshgrid(theta, phi);

% คำนวณตำแหน่งเกลียวหลัก
x_center = R .* cos(theta);
y_center = R .* sin(theta);
z_center = cumsum(pitch_vec);

% ทำเป็น grid
x_center_grid = repmat(x_center', n, 1);
y_center_grid = repmat(y_center', n, 1);
z_center_grid = repmat(z_center', n, 1);
tube_radius_grid = repmat(tube_radius_vec', n, 1); % ✅ ขนาดตรงกัน

% คำนวณจุดบนผิวท่อ
x = x_center_grid + tube_radius_grid .* cos(phi_grid) .* cos(theta_grid);
y = y_center_grid + tube_radius_grid .* cos(phi_grid) .* sin(theta_grid);
z = z_center_grid + tube_radius_grid .* sin(phi_grid);

% วาดผิว
figure;
set(gcf, 'Position', [0 0 1280 720]);
surf(x, y, z, ...
    'FaceColor', [0.55 0.27 0.07], ...
    'EdgeColor', 'none');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;
camlight; lighting gouraud;
title('💩 ก้อนอึ ปลายติดกัน');

%% Refine 4
% พารามิเตอร์
theta  = [0 : pi/50 : 8*pi]';
t_vec2 = [0 : length(theta)-1]' * 0.1; 

lambda_base = 0.02;  
lambda_vec = lambda_base + 0.05 * (theta / max(theta)).^2;
R = exp(-lambda_vec .* t_vec2);

tube_radius_start = 0.35;
tube_radius_end   = 0.05;
tube_radius_vec = linspace(tube_radius_start, tube_radius_end, length(theta));

pitch_start = 0.05;
pitch_end   = 0.01;
pitch_vec = linspace(pitch_start, pitch_end, length(theta));

% จำนวนจุดรอบวง
n = 30;
phi = linspace(0, 2*pi, n);

% meshgrid: note ลำดับต้องเป็น (theta, phi) เพื่อให้ขนาดตรงกันง่าย
[theta_grid, phi_grid] = meshgrid(theta, phi); % ขนาด n × m

x_center = R .* cos(theta);
y_center = R .* sin(theta);
z_center = cumsum(pitch_vec);

% ขยายเป็น grid ให้ขนาดตรงกัน (n × m)
x_center_grid    = repmat(x_center', n, 1);
y_center_grid    = repmat(y_center', n, 1);
z_center_grid    = repmat(z_center', n, 1);
tube_radius_grid = repmat(tube_radius_vec', n, 1); % ✅ ขนาด n × m

% คำนวณจุดบนผิวท่อ
x = x_center_grid + tube_radius_grid .* cos(phi_grid) .* cos(theta_grid);
y = y_center_grid + tube_radius_grid .* cos(phi_grid) .* sin(theta_grid);
z = z_center_grid + tube_radius_grid .* sin(phi_grid);

% วาด
figure;
set(gcf, 'Position', [0 0 1280 720]);
surf(x, y, z, ...
    'FaceColor', [0.55 0.27 0.07], ...
    'EdgeColor', 'none');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;
camlight; lighting gouraud;
title('💩 ก้อนอึ ปลายติดกัน');

%% Refine 5
% พารามิเตอร์
theta  = [0 : pi/50 : 8*pi]';
t_vec2 = [0 : length(theta)-1]' * 0.1; 

% รัศมีเกลียวหลัก
lambda_base = 0.02;  
lambda_vec = lambda_base + 0.05 * (theta / max(theta)).^2; % หดเร็วขึ้นเล็กน้อยช่วงท้าย
R = exp(-lambda_vec .* t_vec2);

% รัศมีท่อ ค่อย ๆ ลดลง
tube_radius_start = 0.35;
tube_radius_end   = 0.05;
tube_radius_vec = linspace(tube_radius_start, tube_radius_end, length(theta));

% pitch ค่อย ๆ ลดลง เพื่อให้ปลายแน่นขึ้น
pitch_start = 0.05;
pitch_end   = 0.005;  % ถี่มากช่วงท้าย
pitch_vec = linspace(pitch_start, pitch_end, length(theta));
z_center = cumsum(pitch_vec); % ใช้สะสมแทนคูณตรง ๆ

% meshgrid
n = 30;
phi = linspace(0, 2*pi, n);
[theta_grid, phi_grid] = meshgrid(theta, phi);

% centerline
x_center = R .* cos(theta);
y_center = R .* sin(theta);

% ทำเป็น grid
x_center_grid    = repmat(x_center', n, 1);
y_center_grid    = repmat(y_center', n, 1);
z_center_grid    = repmat(z_center', n, 1);
tube_radius_grid = repmat(tube_radius_vec', n, 1);

% ผิวท่อ
x = x_center_grid + tube_radius_grid .* cos(phi_grid) .* cos(theta_grid);
y = y_center_grid + tube_radius_grid .* cos(phi_grid) .* sin(theta_grid);
z = z_center_grid + tube_radius_grid .* sin(phi_grid);

% วาด
figure;
set(gcf, 'Position', [0 0 1280 720]);
surf(x, y, z, ...
    'FaceColor', [0.55 0.27 0.07], ...
    'EdgeColor', 'none');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
grid on;
camlight; lighting gouraud;
title('💩 ก้อนอึ ปลายไม่ลอย');
