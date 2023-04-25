-- Amount of Items that are sustainable hair shampoos and conditioners that are good and bad classified:
-- Good: When the item has "solid", "sólid" or "barra" in the title
-- Bad: Every other item.


SELECT 
      sit_site_id,

      case 
      when 
          ((upper(ITE_ITEM_TITLE) LIKE '%SOLID%') OR (upper(ITE_ITEM_TITLE) LIKE '%SÓLID%')  OR (upper(ITE_ITEM_TITLE) LIKE '%BARRA%' )) 
          THEN 'Bien atributado' 
      ELSE 'Mal atributado' END AS Atributado,

      count(distinct ITE_ITEM_ID)

FROM meli-bi-data.WHOWNER.LK_ITE_ITEMS i , unnest(ITE_ITEM_ATTRIBUTES) ITE_ITEM_ATTRIBUTES

WHERE 
        array_length(split(ITE_ITEM_DOM_DOMAIN_ID,"-"))>=1 
and
(upper(split(ITE_ITEM_DOM_DOMAIN_ID,"-")[OFFSET(1)]) = ('HAIR_SHAMPOOS_AND_CONDITIONERS') and upper(ITE_ITEM_ATTRIBUTES.ID) ='IS_SOLID' and upper(ITE_ITEM_ATTRIBUTES.VALUE_NAME) in ('SI','SÍ','YES','SIM'))
and
sit_site_id IN ('MLA','MLB','MLM','MLC','MCO','MLU')
AND upper(ITE_ITEM_STATUS) = 'ACTIVE'
GROUP BY 1,2

