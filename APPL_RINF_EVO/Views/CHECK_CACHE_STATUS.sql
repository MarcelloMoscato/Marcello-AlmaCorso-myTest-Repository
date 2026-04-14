--
-- CHECK_CACHE_STATUS  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.CHECK_CACHE_STATUS
("Ambito", CACHED, UNCACHED, VER)
BEQUEATH DEFINER
AS 
Select Ambito, Cached, unCached, Ver from(
select 1 ord, 'SL Controllati' Ambito, count(CASE WHEN CACHE_FIELD is NOT NULL THEN 1 END) Cached, count(CASE WHEN CACHE_FIELD is NULL THEN 1 END) unCached, 0 Ver from RINF_CONTROLLATI_EVO.SEZIONI_LINEA
union all
select 1 ord, 'PO Controllati' Ambito, count(CASE WHEN CACHE_FIELD is NOT NULL THEN 1 END) Cached, count(CASE WHEN CACHE_FIELD is NULL THEN 1 END) unCached, 0 Ver from RINF_CONTROLLATI_EVO.PUNTI_OPERATIVI
union all
select 2 ord, 'SL Autorizzati' Ambito, count(CASE WHEN CACHE_FIELD is NOT NULL THEN 1 END) Cached, count(CASE WHEN CACHE_FIELD is NULL THEN 1 END) unCached, 0 Ver from RINF_AUTORIZZAZIONI_EVO.SEZIONI_LINEA
union all
select 2 ord, 'PO Autorizzati' Ambito, count(CASE WHEN CACHE_FIELD is NOT NULL THEN 1 END) Cached, count(CASE WHEN CACHE_FIELD is NULL THEN 1 END) unCached, 0 Ver from RINF_AUTORIZZAZIONI_EVO.PUNTI_OPERATIVI
union all
select 3 ord, 'SL Pubblicati' Ambito, count(CASE WHEN CACHE_FIELD is NOT NULL THEN 1 END) Cached, count(CASE WHEN CACHE_FIELD is NULL THEN 1 END) unCached, CODICE_VERSIONE Ver from RINF_PUBBLICATI_EVO.SEZIONI_LINEA  group by (CODICE_VERSIONE)
union all
select 3 ord, 'PO Pubblicati' Ambito, count(CASE WHEN CACHE_FIELD is NOT NULL THEN 1 END) Cached, count(CASE WHEN CACHE_FIELD is NULL THEN 1 END) unCached, CODICE_VERSIONE Ver from RINF_PUBBLICATI_EVO.PUNTI_OPERATIVI  group by (CODICE_VERSIONE)
) 
order by ord, ver desc;
