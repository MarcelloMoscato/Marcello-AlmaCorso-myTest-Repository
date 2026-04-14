--
-- CHECK_ALL_FK_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_ALL_FK_V
("SCHEMA", TABLE_NAME, C_TYPE, CONSTRAINT_NAME, POSITION, 
 COLUMN_NAME, R_OWNER, R_TABLE_NAME, R_PK)
BEQUEATH DEFINER
AS 
SELECT 
        c.owner SCHEMA, a.table_name, c.constraint_type c_type, a.constraint_name, 
        a.position, a.column_name,
        c.r_owner, 
        c_pk.table_name r_table_name, c_pk.constraint_name r_pk
    FROM all_cons_columns a
        JOIN all_constraints c ON a.owner = c.owner AND a.constraint_name = c.constraint_name
        JOIN all_constraints c_pk ON c.r_owner = c_pk.owner AND c.r_constraint_name = c_pk.constraint_name
    WHERE 
        c.constraint_type = 'R' 
      AND c.owner LIKE '%RINF%'
    ORDER BY 1, 2, 3, 4, 5;
