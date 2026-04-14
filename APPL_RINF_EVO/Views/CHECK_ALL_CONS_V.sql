--
-- CHECK_ALL_CONS_V  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_ALL_CONS_V
("SCHEMA", TABLE_NAME, C_TYP, CONSTRAINT_NAME, POSITION, 
 COLUMN_NAME, STATUS, OWNER)
BEQUEATH DEFINER
AS 
SELECT 
        CONS.OWNER SCHEMA, cols.table_name, 
        cons.constraint_type c_typ, 
        cons.constraint_name, cols.position, cols.column_name, cons.status, cons.owner
    FROM all_constraints cons 
    JOIN all_cons_columns cols ON (cons.constraint_name = cols.constraint_name AND cons.owner = cols.owner AND CONS.OWNER LIKE '%RINF%')
    ORDER BY 1, 2, 3, 4, 5;
