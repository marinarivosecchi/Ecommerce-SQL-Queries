-- This query shows Sales per site, month, year and domain_id from sustainable Items

-- Table to collect Item IDs with sustainability requirements 

BEGIN
CREATE TEMP TABLE Items AS (
    Select  i.sit_site_id as sit_site_id, i.ite_item_id as ite_item_id
      FROM meli-bi-data.WHOWNER.LK_ITE_ITEMS i , unnest(ITE_ITEM_ATTRIBUTES) ITE_ITEM_ATTRIBUTES
      inner join `meli-bi-data.WHOWNER.AG_LK_CAT_CATEGORIES`as C ON C.CAT_CATEG_ID_L7 = I.CAT_CATEG_ID and i.SIT_SITE_ID = C.SIT_SITE_ID 

      where
        array_length(split(ITE_ITEM_DOM_DOMAIN_ID,"-"))>=1 

      and i.sit_site_id in ('MLA','MLB','MLM','MLC','MCO','MLU')

      

       and (
         
         
         i.sit_site_id = ('MLA') and  (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('AIR_CONDITIONERS') and upper(ITE_ITEM_ATTRIBUTES.ID)='ENERGY_EFFICIENCY' and upper(ITE_ITEM_ATTRIBUTES.VALUE_NAME) in ('A+','A++','A+++') )
       
       or (i.sit_site_id in ('MLB','MLM','MLC','MCO','MLU') and  (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('AIR_CONDITIONERS') and upper(ITE_ITEM_ATTRIBUTES.ID)='ENERGY_EFFICIENCY' and upper(ITE_ITEM_ATTRIBUTES.VALUE_NAME) in ('A','A+','A++','A+++') ))

       or (i.sit_site_id = ('MLM') and (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)])= ('REFRIGERATORS') and upper(ITE_ITEM_ATTRIBUTES.ID)='WITH_INVERTER_TECHNOLOGY' and upper(ITE_ITEM_ATTRIBUTES.VALUE_NAME) in ('SI','SÍ','YES','SIM') ))
              or (i.sit_site_id in ('MLB','MLA','MLC','MCO','MLU') and  (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('REFRIGERATORS') and upper(ITE_ITEM_ATTRIBUTES.ID)='ENERGY_EFFICIENCY' and upper(ITE_ITEM_ATTRIBUTES.VALUE_NAME) in ('A','A+','A++','A+++') ))



      or
       (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) IN ('BATH_SPONGES', 'CLEANING_SPONGES') and upper(ITE_ITEM_ATTRIBUTES.ID)='MATERIAL' and upper(ITE_ITEM_ATTRIBUTES.VALUE_NAME) in ('VEGETAL','LUFA','LUFFA','NATURAL','BUCHA_NATURAL','LUFFA_VEGETAL','LUFFA_VEGETAL_NATURAL','LOOFA') )

      
    or
    
(upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) IN ('SOLAR_PANELS', 
                                'SOLAR_KITS',
                                'MANUAL_MENSTRUAL_CUP_STERILIZERS',
                                'REUSABLE_PADS',
                                'MENSTRUAL_CUPS',
                                'VOLTAGE_REGULATORS',
                                'SOLAR_BATTERIES',
                                'BICYCLES',
                                'WIND_TURBINE_GENERATORS',
                                'COMPOSTERS',
                                'REVERSE_OSMOSIS_FILTERS',
                                'WATER_PURIFIER_FILTERS_REFILLS',
                                'ELECTRIC_BICYCLES',
                                'BABY_ECOLOGICAL_DIAPERS',
                                'STORAGE_SOLAR_HEATER_KITS',
                                'HYDROPONIC_POTS',
                                'HYDROPONIC_GROWING_SYSTEMS',
                                'WATER_PURIFIERS_AND_FILTERS',
                                'REUSABLE_MAKEUP_REMOVER_PADS'
))

or (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('ELECTRICAL_CABLES') AND CAT_CATEG_ID_L3 IN (439041, 436889))
or (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('POWER_INVERTERS')AND CAT_CATEG_ID_L3 IN (439041, 436889))
or (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('SPORT_AND_BAZAAR_BOTTLES')AND CAT_CATEG_ID_L3 IN(189026,123032,393762,180608,206537,179932,206537))
or (upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('ELECTRICAL_SUPPLIES') AND CAT_CATEG_ID_L3 IN (439041, 436889) )
)
      
   );
END;

-- Sales per site, month, year and domain_id from those items 

Select 
  sit_site_id as Site,
  EXTRACT (MONTH FROM ORD_CLOSED_DT )as Mes,
  EXTRACT (YEAR FROM ORD_CLOSED_DT )as Ano,
  DOM_DOMAIN_ID AS DOM_ID,

      SUM(ORD_ITEM.QTY) as SI,
      CAST (SUM(ORD_ITEM.QTY * ORD_ITEM.UNIT_PRICE * CC_USD_RATIO )AS FLOAT64) as GMV_USD, 

FROM meli-bi-data.WHOWNER.BT_ORD_ORDERS
where 1=1
and ORD_CLOSED_DT between '2023-03-01' and '2023-03-31'
--and sit_site_id='MLA'
and sit_site_id in ('MLA','MLB','MLM','MLC','MCO','MLU')
and (ORD_TGMV_FLG=TRUE )
AND ORD_CATEGORY.MARKETPLACE_ID='TM'
and concat(sit_site_id,ord_item.id) in (select concat(sit_site_id,ite_item_id) from Items)
group by 1,2,3,4
order by 3,2,1 asc
