-- Item_ids from specific deals (these are special groups of items that are made for a specific commercial campaign)

SELECT
dealid.DEAL_ID,
ORD.SIT_SITE_ID as Sitio,
ord.ITE_ITEM_ID
       
FROM  meli-bi-data.WHOWNER.BT_ORD_ORDERS as ORD
 
RIGHT JOIN  EXPLOTACION.LK_ITE_ITEMS_DEALS  AS  dealid
        ON  ORD.ite_item_id = dealid.ite_item_id AND ORD.sit_site_id = dealid.sit_site_id
       AND  ((dealid.sit_site_id = 'MLA' AND  dealid.DEAL_ID = 'MLA11589')
       OR  (dealid.sit_site_id = 'MLB' AND  dealid.DEAL_ID = 'MLB11342')
       OR  (dealid.sit_site_id = 'MLM' AND  dealid.DEAL_ID = 'MLM22484')
       OR  (dealid.sit_site_id = 'MLC' AND  dealid.DEAL_ID = 'MLC8783')      
       OR  (dealid.sit_site_id = 'MLU' AND  dealid.DEAL_ID = 'MLU890')      
       OR  (dealid.sit_site_id = 'MCO' AND  dealid.DEAL_ID = 'MCO8248')
       )
 
WHERE 
  ORD.SIT_SITE_ID IN ('MLA','MLB','MLM','MLC','MCO','MLU')
  and ORD.ORD_CLOSED_DT BETWEEN DATE '2022-12-01' and DATE '2022-12-18'
  AND ORD_CATEGORY.MARKETPLACE_ID='TM'
  and (ORD_TGMV_FLG=TRUE)

GROUP BY 1,2,3
