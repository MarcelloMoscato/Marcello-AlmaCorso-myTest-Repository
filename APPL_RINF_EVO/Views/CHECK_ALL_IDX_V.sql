--
-- CHECK_ALL_IDX_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_ALL_IDX_V
(OWNER, T_NAME, IDX_NAME, COL_NUM, COL_NAME, 
 UNIQUENESS)
BEQUEATH DEFINER
AS 
select distinct
i.OWNER , i.table_name t_name, i.index_name idx_name, 
c.column_position col_num, c.column_name col_name, i.uniqueness --, i.INDEX_TYPE, i.status
from ALL_INDEXES i, ALL_IND_COLUMNS c
where 
      i.TABLE_NAME = c.TABLE_NAME
  and i.INDEX_NAME = c.INDEX_NAME
  and i.owner like '%RINF%'
order by i.OWNER, i.table_name, i.index_name, c.column_position;
