SELECT `200_050_MasterDetailedStatsAndAttrbs`.name
FROM 200_050_MasterDetailedStatsAndAttrbs
WHERE (((`200_050_MasterDetailedStatsAndAttrbs`.Age)>=  @bi_min_age) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.Age)<=  @bi_max_age) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.Height)>= @bi_min_height) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.Height)<= @bi_max_height) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.SprintSpeed)>= @fa19_min_spd) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.Strength)>= @fa19_min_str) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.Dribbling)>= @fa19_min_drb) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.Agility)>= @fa19_min_agl) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.Position) in @pos_cdn_str) 
AND ((`200_050_MasterDetailedStatsAndAttrbs`.league) in @leg_cdn_str))