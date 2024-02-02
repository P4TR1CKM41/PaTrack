close all
trilanme = 'T_Cutting10';

td_an = CONTACT.(trilanme)(1)+10
td_kin = fix(td_an/OPTIONS.ftkratio)  ; 

MARKERS.(trilanme).Opti.forfoot_lat_right.data(:, td_kin)


scatter3(MARKERS.(trilanme).Opti.forfoot_lat_right.data(1, td_kin), MARKERS.(trilanme).Opti.forfoot_lat_right.data(2, td_kin), MARKERS.(trilanme).Opti.forfoot_lat_right.data(3, td_kin))
hold on
scatter3(MARKERS.(trilanme).Opti.forfoot_med_right.data(1, td_kin), MARKERS.(trilanme).Opti.forfoot_med_right.data(2, td_kin), MARKERS.(trilanme).Opti.forfoot_med_right.data(3, td_kin))
scatter3(MARKERS.(trilanme).Opti.toe_right.data(1, td_kin), MARKERS.(trilanme).Opti.toe_right.data(2, td_kin), MARKERS.(trilanme).Opti.toe_right.data(3, td_kin))

scatter3(MARKERS.(trilanme).Opti.calc_med_right.data(1, td_kin), MARKERS.(trilanme).Opti.calc_med_right.data(2, td_kin), MARKERS.(trilanme).Opti.calc_med_right.data(3, td_kin))
scatter3(MARKERS.(trilanme).Opti.calc_lat_right.data(1, td_kin), MARKERS.(trilanme).Opti.calc_lat_right.data(2, td_kin), MARKERS.(trilanme).Opti.calc_lat_right.data(3, td_kin))
scatter3(MARKERS.(trilanme).Opti.calc_back_right.data(1, td_kin), MARKERS.(trilanme).Opti.calc_back_right.data(2, td_kin), MARKERS.(trilanme).Opti.calc_back_right.data(3, td_kin))

FP.(trilanme).COP.Right  
scatter3(FP.(trilanme).COP.Right(1, td_an), FP.(trilanme).COP.Right(2, td_an), FP.(trilanme).COP.Right(3, td_an), 'filled')
quiver3(FP.(trilanme).COP.Right(1, td_an), FP.(trilanme).COP.Right(2, td_an), FP.(trilanme).COP.Right(3, td_an),FP.(trilanme).GRFfilt.Right(1, td_an), FP.(trilanme).GRFfilt.Right(2, td_an), FP.(trilanme).GRFfilt.Right(3, td_an))

axis equal