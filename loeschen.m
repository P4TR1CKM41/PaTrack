 clc
 clear all
 close all

 load('C:\Users\adpatrick\Downloads\OneDrive_1_1-2-2024\Pivot_Turn_Topfolder\left\P_101OpenSim.mat')


names = fieldnames (MOMENT_TABLE)

for n = 1 : length (names)
    %ankle_angle_l_moment %knee_valgus_lat_l_moment
TEST(:,n) = normalize_vector(MOMENT_TABLE.(names{n, 1}).ankle_angle_l_moment(CONTACT_KINEMATIC.(names{n, 1}))', 1)
 
end

plot(TEST,'DisplayName','TEST')