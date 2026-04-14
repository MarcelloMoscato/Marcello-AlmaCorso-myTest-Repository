--
-- V_RAPPORTO_ACQUISIZIONE_V082  (View) 
--
CREATE OR REPLACE VIEW APPL_RINF_EVO.V_RAPPORTO_ACQUISIZIONE_V082
(CODICE_ACQUISIZIONE, CODICE_DTP, DTP, TIPO_OGGETTO, LETTI, 
 ACCETTATI, SCARTATI)
BEQUEATH DEFINER
AS 
SELECT --buoni.CODICE_ACQUISIZIONE,
          nvl(buoni.CODICE_ACQUISIZIONE,1 ) CODICE_ACQUISIZIONE,
          buoni.CODICE_DTP,
          d.DESCRIZIONE DTP,
          buoni.tipo_oggetto,
          NVL (buoni.accettati, 0) + NVL (scarti.scartati, 0) letti,
          NVL (buoni.accettati, 0) accettati,
          NVL (scarti.scartati, 0) scartati
     FROM (  SELECT CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')
                       tipo_oggetto,
                    COUNT (*) Accettati
               FROM RINF_LAVORAZIONE_EVO.OGGETTI_ACQUISITI
           GROUP BY CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')) buoni,
          (  SELECT CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')
                       tipo_oggetto,
                    COUNT (DISTINCT SEDE_TECNICA) Scartati
               FROM RINF_LAVORAZIONE_EVO.SCARTI_ACQUISIZIONE
           GROUP BY CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')) scarti,
          RINF_ANAGRAFICHE_EVO.ANAG_DTP d
    WHERE     buoni.CODICE_ACQUISIZIONE = scarti.CODICE_ACQUISIZIONE(+)
          AND buoni.CODICE_DTP = scarti.CODICE_DTP(+)
          AND buoni.tipo_oggetto = scarti.tipo_oggetto(+)
          AND d.codice_dtp = buoni.codice_dtp
   UNION  -- conteggio dalle tabella OGGETTI_ACQUISITI e SCARTI_ACQUISIZIONE quando è presente il codice DTP in outer join sugli acquisiti
   SELECT scarti.CODICE_ACQUISIZIONE,
          scarti.CODICE_DTP,
          d.DESCRIZIONE DTP,
          scarti.tipo_oggetto,
          NVL (buoni.accettati, 0) + NVL (scarti.scartati, 0) letti,
          NVL (buoni.accettati, 0) accettati,
          NVL (scarti.scartati, 0) scartati
     FROM (  SELECT CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')
                       tipo_oggetto,
                    COUNT (*) Accettati
               FROM RINF_LAVORAZIONE_EVO.OGGETTI_ACQUISITI
           GROUP BY CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')) buoni,
          (  SELECT CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')
                       tipo_oggetto,
                    COUNT (DISTINCT SEDE_TECNICA) Scartati
               FROM RINF_LAVORAZIONE_EVO.SCARTI_ACQUISIZIONE
           GROUP BY CODICE_ACQUISIZIONE,
                    CODICE_DTP,
                    DECODE (SUBSTR (CODICE_SOL_PO, 1, 2),
                            'TR', 'Sezione di Linea',
                            'LO', 'Punto Operativo')) scarti,
          RINF_ANAGRAFICHE_EVO.ANAG_DTP d
    WHERE     scarti.CODICE_ACQUISIZIONE = buoni.CODICE_ACQUISIZIONE(+)
          AND scarti.CODICE_DTP = buoni.CODICE_DTP(+)
          AND scarti.tipo_oggetto = buoni.tipo_oggetto(+)
          AND d.codice_dtp = scarti.codice_dtp
   UNION    -- conteggio dalla tabella scarti_acquisizione quando non è presente il codice DTP
   SELECT scarti.CODICE_ACQUISIZIONE,
          NULL CODICE_DTP,
          NULL DTP,
          scarti.tipo_oggetto,
          NVL (scarti.scartati, 0) letti,
          0 accettati,
          NVL (scarti.scartati, 0) scartati
     FROM (  SELECT CODICE_ACQUISIZIONE,
                    DECODE (CLASSE,
                            'CLASSE_R16000T', 'Binario di Corsa SOL',
                            'CLASSE_R16000L', 'Binario di Corsa OP',
                            'CLASSE_R16100', 'Binario di Raccordo',
                            'CLASSE_R24750', 'Marciapiede',
                            'CLASSE_R25350T', 'Galleria SOL',
                            'CLASSE_R25350L', 'Galleria OP') --ricordarsi di inserire le etichette nel caso si aggiungono voci
                       tipo_oggetto,
                    COUNT (DISTINCT SEDE_TECNICA) Scartati
               FROM RINF_LAVORAZIONE_EVO.SCARTI_ACQUISIZIONE
              WHERE CODICE_DTP IS NULL
           GROUP BY CODICE_ACQUISIZIONE,
                    DECODE (CLASSE,
                            'CLASSE_R16000T', 'Binario di Corsa SOL',
                            'CLASSE_R16000L', 'Binario di Corsa OP',
                            'CLASSE_R16100', 'Binario di Raccordo',
                            'CLASSE_R24750', 'Marciapiede',
                            'CLASSE_R25350T', 'Galleria SOL',
                            'CLASSE_R25350L', 'Galleria OP')) scarti;
