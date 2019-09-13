SELECT DISTINCT `100_070_PlayerSelect`.name
FROM 100_070_PlayerSelect
WHERE (((`100_070_PlayerSelect`.Age)>=  @bi_min_age) 
AND ((`100_070_PlayerSelect`.Age)<=  @bi_max_age) 
AND ((`100_070_PlayerSelect`.Height)>= @bi_min_height) 
AND ((`100_070_PlayerSelect`.Height)<= @bi_max_height) 
AND ((`100_070_PlayerSelect`.SprintSpeed)>= @fa19_min_spd) 
AND ((`100_070_PlayerSelect`.Strength)>= @fa19_min_str) 
AND ((`100_070_PlayerSelect`.Dribbling)>= @fa19_min_drb) 
AND ((`100_070_PlayerSelect`.Agility)>= @fa19_min_agl) 
AND ((`100_070_PlayerSelect`.Position) in @pos_cdn_str))
LIMIT 0, @lmt