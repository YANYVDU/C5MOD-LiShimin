-- Insert SQL Rules Here 
INSERT INTO Audio_Sounds (SoundID, 								Filename, 			LoadType)
VALUES		('SND_LEADER_MUSIC_LISHIMIN_PEACE','LISHIMIN_PEACE', 	'DynamicResident'),
			('SND_LEADER_MUSIC_LISHIMIN_WAR',	'LISHIMIN_WAR', 		'DynamicResident');

INSERT INTO Audio_2DSounds (ScriptID, 								SoundID, 								SoundType, 		MinVolume, 	MaxVolume,	IsMusic,	Looping,Priority)
VALUES		('AS2D_LEADER_MUSIC_LISHIMIN_PEACE', 			'SND_LEADER_MUSIC_LISHIMIN_PEACE', 	'GAME_MUSIC', 	90, 		90, 		1, 		    1,0),
			('AS2D_LEADER_MUSIC_LISHIMIN_WAR', 			'SND_LEADER_MUSIC_LISHIMIN_WAR', 		'GAME_MUSIC',	90, 		90, 		1,		    1,0);
