--
-- V_TRATTE_PIC_FL  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.V_TRATTE_PIC_FL
(PIC_DISPARI, PIC_PARI, CODICE_LOCALITA_INIZIO_PIC, LO_INIZIO, CODICE_LOCALITA_FINE_PIC, 
 LO_FINE, FASCICOLO_LINEA, CODICE_LINEA_FCL, DEFINIZIONE, PROGR_KM_FROM_SX, 
 PROGR_KM_TO_SX, PROGR_KM_FROM_DX, PROGR_KM_TO_DX)
BEQUEATH DEFINER
AS 
SELECT pic_dispari,
            pic_pari,
            CODICE_LOCALITA_INIZIO_PIC,
            LO_INIZIO,
            CODICE_LOCALITA_FINE_PIC,
            LO_FINE,
            'FL ' || TO_CHAR (f.FASCICOLO_LINEA) fascicolo_linea,
            L.CODICE_LINEA_FCL,
            T.DEFINIZIONE,
            PROGR_KM_FROM_SX,
            PROGR_KM_TO_SX,
            PROGR_KM_FROM_DX,
            PROGR_KM_TO_DX
       FROM RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL fl,
            RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE f,
            RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL t,
            RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN l,
            RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN r,
            (SELECT pic_dispari.CODICE_TRATTA_PIC pic_dispari,
                    pic_pari.CODICE_TRATTA_PIC pic_pari,
                    pic_dispari.CODICE_LOCALITA_INIZIO_PIC,
                    LO_INIZIO.NOME_LOCALITA30 LO_INIZIO,
                    pic_dispari.CODICE_LOCALITA_FINE_PIC,
                    LO_FINE.NOME_LOCALITA30 LO_FINE
               FROM RINF_ANAGRAFICHE_EVO.tratte_pic pic_dispari,
                    RINF_ANAGRAFICHE_EVO.tratte_pic pic_pari,
                    RINF_ANAGRAFICHE_EVO.localita_pic lo_inizio,
                    RINF_ANAGRAFICHE_EVO.localita_pic lo_fine
              WHERE     pic_dispari.FLAG_DISPARI = 1
                    AND pic_pari.FLAG_DISPARI = 0
                    AND NVL (pic_dispari.DATA_FINE_VALIDITA,
                             TO_DATE ('31/12/2999', 'dd/mm/yyyy')) > SYSDATE
                    AND NVL (pic_dispari.DATA_INIZIO_VALIDITA,
                             TO_DATE ('31/12/1999', 'dd/mm/yyyy')) <= SYSDATE
                    AND NVL (pic_pari.DATA_FINE_VALIDITA,
                             TO_DATE ('31/12/2999', 'dd/mm/yyyy')) > SYSDATE
                    AND NVL (pic_pari.DATA_INIZIO_VALIDITA,
                             TO_DATE ('31/12/1999', 'dd/mm/yyyy')) <= SYSDATE
                    AND pic_dispari.SEDE_TECNICA = pic_pari.SEDE_TECNICA
                    AND pic_dispari.CODICE_LOCALITA_INIZIO_PIC =
                           pic_pari.CODICE_LOCALITA_FINE_PIC
                    AND pic_dispari.CODICE_LOCALITA_FINE_PIC =
                           pic_pari.CODICE_LOCALITA_INIZIO_PIC
                    AND pic_dispari.CODICE_LOCALITA_INIZIO_PIC =
                           LO_INIZIO.CODICE_LOCALITA_PIC
                    AND pic_dispari.CODICE_LOCALITA_FINE_PIC =
                           LO_FINE.CODICE_LOCALITA_PIC
                    AND pic_dispari.DATA_SCADENZA IS NULL
                    AND pic_pari.DATA_SCADENZA IS NULL
                    AND lo_inizio.DATA_SCADENZA IS NULL
                    AND lo_fine.DATA_SCADENZA IS NULL) tratte_pic
      WHERE     tratte_pic.pic_dispari = R.CODICE_TRATTA_PIC
            AND R.CODICE_TRATTA_ROMAN = L.CODICE_TRATTA_ROMAN
            AND L.CODICE_LINEA_FCL = T.CODICE_LINEA_FCL
            AND T.CODICE_LINEA_FCL = FL.CODICE_LINEA_FCL(+)
            AND FL.CODICE_FASCICOLO = F.CODICE_FASCICOLO(+)
            AND NVL (t.DATA_INIZIO_VALIDITA,
                     TO_DATE ('31/12/1999', 'dd/mm/yyyy')) <= SYSDATE
            AND NVL (t.DAT_FINE_VAL, TO_DATE ('31/12/2999', 'dd/mm/yyyy')) >
                   SYSDATE
            AND fl.DATA_SCADENZA IS NULL
            AND f.DATA_SCADENZA IS NULL
            AND t.DATA_SCADENZA IS NULL
            AND l.DATA_SCADENZA IS NULL
            AND r.DATA_SCADENZA IS NULL
   ORDER BY 1;
