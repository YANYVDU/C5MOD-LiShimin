CREATE TABLE IF NOT EXISTS DYY_MOD_LINKAGE (
    `MOD` TEXT DEFAULT '',
    `VALUE` INTEGER DEFAULT 0 NOT NULL);

INSERT OR REPLACE INTO DYY_MOD_LINKAGE
            (MOD,                VALUE)
VALUES      ('S_TANG',1);


--银装陌刀debuff
insert into PromotionCollections(Type) values ('PROMOTION_COLLECTION_S_TANG');
insert into PromotionCollections_Entries(CollectionType, PromotionIndex, PromotionType,  TriggerRangedDefense,TriggerMeleeDefense, TriggerHPPercent,TriggerLuaHook) values
('PROMOTION_COLLECTION_S_TANG', 1, 'PROMOTION_S_TANG_LONGSWORDSMAN', 1, 1,100,1);
insert into PromotionCollections(Type) values ('PROMOTION_COLLECTION_S_TANG_DEBUFF');
insert into PromotionCollections_Entries(CollectionType, PromotionIndex, PromotionType) values
('PROMOTION_COLLECTION_S_TANG_DEBUFF', 1, 'PROMOTION_S_TANG_DEBUFF_1'),
('PROMOTION_COLLECTION_S_TANG_DEBUFF', 2, 'PROMOTION_S_TANG_DEBUFF_2'),
('PROMOTION_COLLECTION_S_TANG_DEBUFF', 3, 'PROMOTION_S_TANG_DEBUFF_3');

insert into PromotionCollections_AddEnemyPromotions(CollectionType, OtherCollectionType) values
('PROMOTION_COLLECTION_S_TANG', 'PROMOTION_COLLECTION_S_TANG_DEBUFF');


--大将军/大文晋升赋予
INSERT OR IGNORE INTO UnitPromotions_UnitCombats(PromotionType, UnitCombatType) 
SELECT 'PROMOTION_LINYAN_WRITER', Type  FROM UnitCombatInfos UNION
SELECT 'PROMOTION_S_TANG_DAYI', Type  FROM UnitCombatInfos UNION
SELECT 'PROMOTION_LINYAN_GENERAL', Type  FROM UnitCombatInfos;

--百川归海
INSERT  INTO UnitPromotions_PromotionModifiers (PromotionType,OtherPromotionType ,Modifier)
SELECT  'PROMOTION_S_TANG_ELITE_RIDER_3',Type,5 FROM    UnitPromotions;

--探矿生成资源列表
INSERT INTO Improvements_Create_Collection(ImprovementType,TerrainType,TerrainOnly,FeatureType,FeatureOnly,ResourceType)
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_AMBER' UNION ALL
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_JADE' UNION ALL
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_LAPIS' UNION ALL
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_GEMS' UNION ALL
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_GOLD' UNION ALL
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_SILVER' UNION ALL
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_COPPER' UNION ALL
SELECT 'IMPROVEMENT_S_TANG_TANKUANG',NULL,0,NULL,0,'RESOURCE_SALT';


--打油诗
INSERT INTO GreatWorks (Type, GreatWorkClassType, Description, Quote, Audio, Image)
SELECT 'GREAT_WORK_POETRY_S_TANG_' || ID, 'GREAT_WORK_LITERATURE', 'TXT_KEY_POETRY_S_TANG', 'TXT_KEY_POETRY_QUOTE_S_TANG', 'AS2D_GREAT_ARTIST_ARTWORK', 'GreatWriter_Background.dds'
FROM Buildings WHERE ID < 300;
INSERT INTO Unit_UniqueNames (UnitType, UniqueName, GreatWorkType)
SELECT 'UNIT_S_TANG_SHIREN', 'TXT_KEY_WRITER_S_TANG_'|| ID, 'GREAT_WORK_POETRY_S_TANG_' || ID
FROM Buildings WHERE ID < 300;

INSERT INTO Language_en_US (Tag, Text)
SELECT 'TXT_KEY_WRITER_S_TANG_'|| ID, '打油诗人' || ID
FROM Buildings WHERE ID < 300;

--荣誉对入驻城市加成
INSERT INTO Policy_BuildingClassYieldModifiers (PolicyType, BuildingClassType,YieldType,YieldMod)
SELECT  Type , 'BUILDINGCLASS_LINYAN_GENERAL','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_SCIENTIST','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_ENGINEER','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_ARTIST','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_WRITER','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_PROPHET','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_MERCHANT','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_MUSICIAN','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_ADMIRAL','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  UNION
SELECT  Type , 'BUILDINGCLASS_LINYAN_DOCTOR','YIELD_PRODUCTION',3  FROM    Policies    WHERE PolicyBranchType  ='POLICY_BRANCH_HONOR'  ;



INSERT INTO UnitPromotions_CivilianUnitType (PromotionType,UnitType)
SELECT PromotionType,'UNIT_S_TANG_FANGSHI'  FROM    UnitPromotions_CivilianUnitType    WHERE   UnitType='UNIT_WORKER';

INSERT INTO UnitPromotions_CivilianUnitType (PromotionType,UnitType)
VALUES  ('PROMOTION_QINWANG','UNIT_S_TANG_LONGSWORDSMAN');



INSERT INTO ArtDefine_UnitInfos 
		(Type, 										DamageStates,	Formation)
SELECT	'ART_DEF_UNIT_SP_S_TANG_MODAOBING',			DamageStates, 	'DefaultMelee'
FROM ArtDefine_UnitInfos WHERE Type = 'ART_DEF_UNIT_NATIONAL_GUARD';

INSERT INTO ArtDefine_UnitInfoMemberInfos 	
		(UnitInfoType,								UnitMemberInfoType,								 NumMembers)
VALUES	('ART_DEF_UNIT_SP_S_TANG_MODAOBING', 			'ART_DEF_UNIT_MEMBER_SP_S_TANG_ZHONGBUBING',		1),
		('ART_DEF_UNIT_SP_S_TANG_MODAOBING', 			'ART_DEF_UNIT_MEMBER_SP_S_TANG_MGJ',				2),
		('ART_DEF_UNIT_SP_S_TANG_MODAOBING', 			'ART_DEF_UNIT_MEMBER_SP_S_TANG_ZHONGBUBING',		3),
		('ART_DEF_UNIT_SP_S_TANG_MODAOBING', 			'ART_DEF_UNIT_MEMBER_SP_S_TANG_MGJ',				3),
		('ART_DEF_UNIT_SP_S_TANG_MODAOBING', 			'ART_DEF_UNIT_MEMBER_SP_S_TANG_ZHONGBUBING',		2),
		('ART_DEF_UNIT_SP_S_TANG_MODAOBING', 			'ART_DEF_UNIT_MEMBER_SP_S_TANG_MGJ',				1);


INSERT INTO ArtDefine_UnitMemberCombats 
		(UnitMemberType,									EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT	'ART_DEF_UNIT_MEMBER_SP_S_TANG_ZHONGBUBING',			EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
FROM ArtDefine_UnitMemberCombats WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_NATIONAL_GUARD';

INSERT INTO ArtDefine_UnitMemberCombatWeapons	
		(UnitMemberType,									"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_SP_S_TANG_ZHONGBUBING',			"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
FROM ArtDefine_UnitMemberCombatWeapons WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_NATIONAL_GUARD';

INSERT INTO ArtDefine_UnitMemberInfos 	
		(Type, 											Scale,	ZOffset, Domain, Model, 							MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_SP_S_TANG_ZHONGBUBING',		Scale,	ZOffset, Domain, 'tang_bubinjia.fxsxml',			MaterialTypeTag, MaterialTypeSoundOverrideTag
FROM ArtDefine_UnitMemberInfos WHERE Type = 'ART_DEF_UNIT_MEMBER_NATIONAL_GUARD';

INSERT INTO ArtDefine_UnitMemberCombats 
		(UnitMemberType,									EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation)
SELECT	'ART_DEF_UNIT_MEMBER_SP_S_TANG_MGJ',					EnableActions, DisableActions, MoveRadius, ShortMoveRadius, ChargeRadius, AttackRadius, RangedAttackRadius, MoveRate, ShortMoveRate, TurnRateMin, TurnRateMax, TurnFacingRateMin, TurnFacingRateMax, RollRateMin, RollRateMax, PitchRateMin, PitchRateMax, LOSRadiusScale, TargetRadius, TargetHeight, HasShortRangedAttack, HasLongRangedAttack, HasLeftRightAttack, HasStationaryMelee, HasStationaryRangedAttack, HasRefaceAfterCombat, ReformBeforeCombat, HasIndependentWeaponFacing, HasOpponentTracking, HasCollisionAttack, AttackAltitude, AltitudeDecelerationDistance, OnlyTurnInMovementActions, RushAttackFormation
FROM ArtDefine_UnitMemberCombats WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_NATIONAL_GUARD';

INSERT INTO ArtDefine_UnitMemberCombatWeapons	
		(UnitMemberType,									"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_SP_S_TANG_MGJ',					"Index", SubIndex, ID, VisKillStrengthMin, VisKillStrengthMax, ProjectileSpeed, ProjectileTurnRateMin, ProjectileTurnRateMax, HitEffect, HitEffectScale, HitRadius, ProjectileChildEffectScale, AreaDamageDelay, ContinuousFire, WaitForEffectCompletion, TargetGround, IsDropped, WeaponTypeTag, WeaponTypeSoundOverrideTag
FROM ArtDefine_UnitMemberCombatWeapons WHERE UnitMemberType = 'ART_DEF_UNIT_MEMBER_NATIONAL_GUARD';

INSERT INTO ArtDefine_UnitMemberInfos 	
		(Type, 											Scale,	ZOffset, Domain, Model, 							MaterialTypeTag, MaterialTypeSoundOverrideTag)
SELECT	'ART_DEF_UNIT_MEMBER_SP_S_TANG_MGJ',				Scale,	ZOffset, Domain, 'tang_mgj.fxsxml',					MaterialTypeTag, MaterialTypeSoundOverrideTag
FROM ArtDefine_UnitMemberInfos WHERE Type = 'ART_DEF_UNIT_MEMBER_NATIONAL_GUARD';

INSERT INTO ArtDefine_StrategicView 
		(StrategicViewType, 						TileType,	Asset)
SELECT	'ART_DEF_UNIT_SP_S_TANG_MODAOBING',			'Unit', 	Asset
FROM ArtDefine_StrategicView WHERE StrategicViewType = 'ART_DEF_UNIT_NATIONAL_GUARD';








CREATE TABLE IF NOT EXISTS 
ROG_GlobalUserSettings (
	Type 				text 			default null,
	Value 				integer 		default 0);

INSERT INTO Building_ResourceQuantity (BuildingType, ResourceType,Quantity)
VALUES  ('BUILDING_LINYAN_GENERAL_2','RESOURCE_MANPOWER',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_CONSUMER',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_HORSE',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_IRON',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_COAL',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_OIL',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_ALUMINUM',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_URANIUM',10),
        ('BUILDING_LINYAN_GENERAL_2','RESOURCE_ELECTRICITY',10);
INSERT  INTO Building_ResourceQuantity(BuildingType,ResourceType,Quantity)
SELECT  'BUILDING_LINYAN_GENERAL_2','RESOURCE_TITANIUM',10
WHERE EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Policy_SpecialistYieldChanges(PolicyType,SpecialistType ,YieldType ,Yield)
SELECT  'POLICY_LINYAN_DOCTOR',Type,'YIELD_SCIENCE' ,5  FROM Specialists    WHERE
NOT EXISTS (
    SELECT 1
    FROM Policy_SpecialistYieldChanges
    WHERE Policy_SpecialistYieldChanges.PolicyType = 'POLICY_LINYAN_DOCTOR'
    AND Policy_SpecialistYieldChanges.SpecialistType = Type
    AND Policy_SpecialistYieldChanges.YieldType = 'YIELD_SCIENCE');

INSERT OR IGNORE INTO Policy_SpecialistYieldChanges(PolicyType, SpecialistType, YieldType, Yield)  
SELECT 'POLICY_LINYAN_DOCTOR', Type, 'YIELD_HEALTH', 5  
FROM Specialists  
WHERE EXISTS (  
    SELECT 1  
    FROM ROG_GlobalUserSettings  
    WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1  )  
AND NOT EXISTS (  
    SELECT 1  
    FROM Policy_SpecialistYieldChanges  
    WHERE Policy_SpecialistYieldChanges.PolicyType = 'POLICY_LINYAN_DOCTOR'  
    AND Policy_SpecialistYieldChanges.SpecialistType = Type  
    AND Policy_SpecialistYieldChanges.YieldType = 'YIELD_HEALTH'  );

INSERT  or  IGNORE  INTO Building_SpecialistYieldChangesLocal(BuildingType,SpecialistType ,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','SPECIALIST_MUSICIAN','YIELD_HEALTH' ,2  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_SpecialistYieldChangesLocal(BuildingType,SpecialistType ,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','SPECIALIST_ARTIST','YIELD_HEALTH' ,2  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_SpecialistYieldChangesLocal(BuildingType,SpecialistType ,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','SPECIALIST_WRITER','YIELD_HEALTH' ,2  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_SpecialistYieldChangesLocal(BuildingType,SpecialistType ,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','SPECIALIST_SCIENTIST','YIELD_HEALTH' ,2  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_SpecialistYieldChangesLocal(BuildingType,SpecialistType ,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','SPECIALIST_MERCHANT','YIELD_HEALTH' ,2  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_SpecialistYieldChangesLocal(BuildingType,SpecialistType ,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','SPECIALIST_ENGINEER','YIELD_HEALTH' ,2  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_SpecialistYieldChangesLocal(BuildingType,SpecialistType ,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','SPECIALIST_DOCTOR','YIELD_HEALTH' ,2  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_GlobalYieldModifiers(BuildingType,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','YIELD_HEALTH' ,5  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Building_GlobalYieldModifiers(BuildingType,YieldType ,Yield)
SELECT  'BUILDING_LINYAN_DOCTOR','YIELD_DISEASE' ,-5  WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT  or  IGNORE  INTO Policy_GoldenAgeGreatPersonRateModifier(PolicyType,GreatPersonType ,Modifier)
SELECT  'POLICY_LINYAN_ARTIST','GREATPERSON_GREAT_DOCTOR' ,100 WHERE   EXISTS (SELECT * FROM ROG_GlobalUserSettings WHERE Type = 'WORLD_POWER_PATCH' AND Value = 1);
INSERT INTO Language_zh_CN (Tag, Text)
SELECT Tag, Text
FROM Language_en_US
WHERE NOT EXISTS (
    SELECT 1
    FROM Language_zh_CN
    WHERE Language_zh_CN.Tag = Language_en_US.Tag
);
INSERT INTO Language_ZH_HANT_HK (Tag, Text)
SELECT Tag, Text
FROM Language_en_US
WHERE NOT EXISTS (
    SELECT 1
    FROM Language_ZH_HANT_HK
    WHERE Language_ZH_HANT_HK.Tag = Language_en_US.Tag
);







