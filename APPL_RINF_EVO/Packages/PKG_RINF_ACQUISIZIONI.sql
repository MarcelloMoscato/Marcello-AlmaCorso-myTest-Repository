--
-- PKG_RINF_ACQUISIZIONI  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_ACQUISIZIONI" AS
/******************************************************************************
   NAME:       PKG_RINF_ACQUISIZIONI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/20/2014      d.campagiorni       1. Created this package.
******************************************************************************/

--> Modifica per testare l'utilizo di git

TYPE empcur IS REF CURSOR;
  PROCEDURE SetRomanAcquisition (data_riferimento DATE, p_error OUT NUMBER);
  PROCEDURE SetPICAcquisition (data_riferimento DATE, p_error OUT NUMBER);
  PROCEDURE SetINEAnagrafiche (data_riferimento DATE, p_error OUT NUMBER);
  PROCEDURE SetGISAcquisition (p_error OUT NUMBER);
  PROCEDURE SetPulisciSOL_TK_PROFILE (n_caricamento          NUMBER,
                                     n_acquisizione          NUMBER,
                                    data_caricamento       DATE,
                                    data_scarico           DATE,
                                    p_error            OUT NUMBER);
PROCEDURE SetPulisciOP_TRACK_PLATF(n_caricamento          NUMBER,
                                    n_acquisizione          NUMBER,
                                    data_caricamento       DATE,
                                    data_scarico           DATE,
                                    p_error            OUT NUMBER);
PROCEDURE SetBinariFermateLog (n_caricamento          NUMBER,
                               n_acquisizione         NUMBER,
                               data_caricamento       DATE,
                               data_scarico           DATE,
                               p_error            OUT NUMBER);
PROCEDURE SetGallerieLog (n_caricamento          NUMBER,
                          n_acquisizione         NUMBER,
                          data_caricamento       DATE,
                          data_scarico           DATE,
                          p_error            OUT NUMBER);

--PROCEDURE GetLogOfAcquisition (p_codice_acquisizione   IN     NUMBER,
--                               p_codice_log            IN     NUMBER,
--                               p_cursor                   OUT empcur);

END PKG_RINF_ACQUISIZIONI;
/


--
-- PKG_RINF_ACQUISIZIONI  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_ACQUISIZIONI" IS
/******************************************************************************
   NAME:       PKG_RINF_ACQUISIZIONI
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/20/2014      d.campagiorni       1. Created this package.
******************************************************************************/
   id_file     UTL_FILE.FILE_TYPE;
   nome_file   VARCHAR2 (500);

   --14/12/2016 sostituita la data di riferimento della validit� degli oggetti da SYSDATE con il giorno della fotografia del DWH
  PROCEDURE SetPICAcquisition (data_riferimento DATE, p_error OUT NUMBER)    IS

   BEGIN
      p_error := 0;


--ANAG_TIPO_ESERCIZIO 1
--Aggiorno i codici esistenti

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPOESERCIZIO n
            WHERE     n.CODICE_TIPOESERCIZIO = O.CODICE_TIPO
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento)
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPOESERCIZIO
             FROM RINF_STAGING_EVO.PIC_TIPOESERCIZIO
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);


--Inserisco i nuovi codici

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO (CODICE_TIPO,
                                                       DESCRIZIONE)
   SELECT CODICE_TIPOESERCIZIO, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPOESERCIZIO
    WHERE     NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND CODICE_TIPOESERCIZIO IN
                 (SELECT CODICE_TIPOESERCIZIO
                    FROM RINF_STAGING_EVO.PIC_TIPOESERCIZIO
                   WHERE     NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                         AND NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                  MINUS
                  SELECT CODICE_TIPO
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO);

--Inserico la data scadenza per i codici non pi� validi

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPO FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_ESERCIZIO
           MINUS
           SELECT CODICE_TIPOESERCIZIO
             FROM RINF_STAGING_EVO.PIC_TIPOESERCIZIO
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);

-----------------------
--ANAG_TIPO_BLOCCO 2
-----------------------

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPOBLOCCO n
            WHERE     N.CODICE_TIPOBLOCCO = O.CODICE_TIPO
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento)
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPOBLOCCO
             FROM RINF_STAGING_EVO.PIC_TIPOBLOCCO
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);



INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO (CODICE_TIPO, DESCRIZIONE)
   SELECT CODICE_TIPOBLOCCO, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPOBLOCCO
    WHERE     NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND CODICE_TIPOBLOCCO IN
                 (SELECT CODICE_TIPOBLOCCO
                    FROM RINF_STAGING_EVO.PIC_TIPOBLOCCO
                   WHERE     NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                         AND NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                  MINUS
                  SELECT CODICE_TIPO
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPO FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_BLOCCO
           MINUS
           SELECT CODICE_TIPOBLOCCO
             FROM RINF_STAGING_EVO.PIC_TIPOBLOCCO
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);

-----------------------
--ANAG_TIPO_CAT_LIN_MASS_ASS 3
-----------------------

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPOCATLINEAMASASS n
            WHERE     N.CODICE_PIC_TIPOCATLINEAMASASS = O.CODICE_TIPO
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento)
 WHERE CODICE_TIPO IN
          (SELECT CODICE_PIC_TIPOCATLINEAMASASS
             FROM RINF_STAGING_EVO.PIC_TIPOCATLINEAMASASS
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);



INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS (CODICE_TIPO,
                                                              DESCRIZIONE)
   SELECT CODICE_PIC_TIPOCATLINEAMASASS, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPOCATLINEAMASASS
    WHERE     NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND CODICE_PIC_TIPOCATLINEAMASASS IN
                 (SELECT CODICE_PIC_TIPOCATLINEAMASASS
                    FROM RINF_STAGING_EVO.PIC_TIPOCATLINEAMASASS
                   WHERE     NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                         AND NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                  MINUS
                  SELECT CODICE_TIPO
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPO
             FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_CAT_LIN_MASS_ASS
           MINUS
           SELECT CODICE_PIC_TIPOCATLINEAMASASS
             FROM RINF_STAGING_EVO.PIC_TIPOCATLINEAMASASS
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);

-----------------------
--ANAG_TIPO_LOCALITA 4
-----------------------

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPOLOCALITA n
            WHERE     N.CODICE_TIPOLOCALITA = O.CODICE_TIPO
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento)
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPOLOCALITA
             FROM RINF_STAGING_EVO.PIC_TIPOLOCALITA
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA (CODICE_TIPO,
                                                      DESCRIZIONE)
   SELECT CODICE_TIPOLOCALITA, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPOLOCALITA
    WHERE     NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND CODICE_TIPOLOCALITA IN
                 (SELECT CODICE_TIPOLOCALITA
                    FROM RINF_STAGING_EVO.PIC_TIPOLOCALITA
                   WHERE     NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                         AND NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                  MINUS
                  SELECT CODICE_TIPO
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPO FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOCALITA
           MINUS
           SELECT CODICE_TIPOLOCALITA
             FROM RINF_STAGING_EVO.PIC_TIPOLOCALITA
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);

-----------------------
--ANAG_TIPO_TRAFFICO 5
-----------------------

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAFFICO o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPOTRAFFICO n
            WHERE N.CODICE_TIPOTRAFFICO = O.CODICE_TIPO)
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPOTRAFFICO FROM RINF_STAGING_EVO.PIC_TIPOTRAFFICO);

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAFFICO (CODICE_TIPO,
                                                      DESCRIZIONE)
   SELECT CODICE_TIPOTRAFFICO, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPOTRAFFICO
    WHERE CODICE_TIPOTRAFFICO IN
             (SELECT CODICE_TIPOTRAFFICO FROM RINF_STAGING_EVO.PIC_TIPOTRAFFICO
              MINUS
              SELECT CODICE_TIPO
                FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAFFICO);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAFFICO
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPO FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAFFICO
           MINUS
           SELECT CODICE_TIPOTRAFFICO FROM RINF_STAGING_EVO.PIC_TIPOTRAFFICO);

--ANAG_TRASPORTO_COMBINATO 6

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPOTRASPCOMBINATO n
            WHERE     O.CODICE_TRASPORTO = N.CODICE_TIPOTRASPCOMBINATO
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento)
 WHERE CODICE_TRASPORTO IN
          (SELECT CODICE_TIPOTRASPCOMBINATO
             FROM RINF_STAGING_EVO.PIC_TIPOTRASPCOMBINATO n
            WHERE     O.CODICE_TRASPORTO = N.CODICE_TIPOTRASPCOMBINATO
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO (CODICE_TRASPORTO,
                                                            DESCRIZIONE)
   SELECT CODICE_TIPOTRASPCOMBINATO, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPOTRASPCOMBINATO
    WHERE     NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND CODICE_TIPOTRASPCOMBINATO IN
                 (SELECT CODICE_TIPOTRASPCOMBINATO
                    FROM RINF_STAGING_EVO.PIC_TIPOTRASPCOMBINATO n
                   WHERE     NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                         AND NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                  MINUS
                  SELECT CODICE_TRASPORTO
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TRASPORTO IN
          (SELECT CODICE_TRASPORTO
             FROM RINF_ANAGRAFICHE_EVO.ANAG_TRASPORTO_COMBINATO
           MINUS
           SELECT CODICE_TIPOTRASPCOMBINATO
             FROM RINF_STAGING_EVO.PIC_TIPOTRASPCOMBINATO n
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);

--ANAG_TIPO_TRAZIONE 7

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPOTRAZIONE n
            WHERE     O.CODICE_TIPO = N.CODICE_TIPOTRAZIONE
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento)
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPOTRAZIONE
             FROM RINF_STAGING_EVO.PIC_TIPOTRAZIONE
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE (CODICE_TIPO,
                                                      DESCRIZIONE)
   SELECT CODICE_TIPOTRAZIONE, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPOTRAZIONE
    WHERE     NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND CODICE_TIPOTRAZIONE IN
                 (SELECT CODICE_TIPOTRAZIONE
                    FROM RINF_STAGING_EVO.PIC_TIPOTRAZIONE
                   WHERE     NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                         AND NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                  MINUS
                  SELECT CODICE_TIPO
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPO FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_TRAZIONE
           MINUS
           SELECT CODICE_TIPOTRAZIONE
             FROM RINF_STAGING_EVO.PIC_TIPOTRAZIONE
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);


--ANAG_TIPO_PUNTOORARIO 8

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PUNTOORARIO o
   SET (DESCRIZIONE, DATA_SCADENZA) =
          (SELECT DESCRIZIONE, NULL
             FROM RINF_STAGING_EVO.PIC_TIPIPUNTOORARIO n
            WHERE O.CODICE_TIPO = N.CODICETIPOPUNTOORARIO)
 WHERE CODICE_TIPO IN
          (SELECT CODICETIPOPUNTOORARIO FROM RINF_STAGING_EVO.PIC_TIPIPUNTOORARIO);

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PUNTOORARIO (CODICE_TIPO,
                                                         DESCRIZIONE)
   SELECT CODICETIPOPUNTOORARIO, DESCRIZIONE
     FROM RINF_STAGING_EVO.PIC_TIPIPUNTOORARIO
    WHERE CODICETIPOPUNTOORARIO IN
             (SELECT CODICETIPOPUNTOORARIO
                FROM RINF_STAGING_EVO.PIC_TIPIPUNTOORARIO
              MINUS
              SELECT CODICE_TIPO
                FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PUNTOORARIO);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PUNTOORARIO
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TIPO IN
          (SELECT CODICE_TIPO
             FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_PUNTOORARIO
           MINUS
           SELECT CODICETIPOPUNTOORARIO FROM RINF_STAGING_EVO.PIC_TIPIPUNTOORARIO);

--LOCALITA_PIC 9

UPDATE RINF_ANAGRAFICHE_EVO.LOCALITA_PIC o
   SET (CODICE_LOCALITA_MIR,
        COD_LOCALITA_IN_RETE,
        DATA_INIZIO_VALIDITA,
        DATA_FINE_VALIDITA,
        RETE_PROPRIETARIA,
        SIGLA_LOCALITA,
        NOME_LOCALITA8,
        NOME_LOCALITA12,
        NOME_LOCALITA16,
        NOME_LOCALITA30,
        NOME_LOCALITA40,
        FLAG_LOCALITA_CONFINE,
        DATA_INIZIO_VALIDITA_FCL,
        DATA_FINE_VALIDITA_FCL,
        COORDINATA_X,
        COORDINATA_Y,
        COORDINATA_Z,
        FLAG_INCROCI_PRECEDENZE,
        FLAG_SERVIZIO_VIAGGIATORI,
        FLAG_SERVIZIO_MERCI,
        FLAG_INTERVIENE_DISTANZIAMENTO,
        FLAG_SOTTOPASSAGGI,
        TIPO_APPARATO,
        TIPO_LOCALITASBF,
        TIPO_STAZIONE,
        TIPO_LOCALITA,
        TIPO_PUNTOORARIO,
        CASSIFICAZIONE_IAP,
        COD_ISTAT_COMUNE,
        DESCRIZIONE_COMUNE,
        COD_ISTAT_PROVINCIA,
        SIGLA_PROVINCIA,
        DESCRIZIONE_PROVINCIA,
        DATA_SCADENZA) =
          (SELECT CODICELOCALITAMIR,
                  CODICELOCALITAIR2K,
                  l.DATAINIZIOVALIDITA,
                  l.DATAFINEVALIDITA,
                  RETEPROPRIETARIA,
                  SIGLALOCALITA,
                  DESCRLOCALITA8,
                  DESCRLOCALITA12,
                  DESCRLOCALITA16,
                  DESCRLOCALITA30,
                  DESCRLOCALITA40,
                  FLAGCONFINE,
                  DATAINIZIOVALIDITAFCL,
                  DATAFINEVALIDITAFCL,
                  COORDINATAX,
                  COORDINATAY,
                  COORDINATAZ,
                  FLAGAMMETTEINCROCIPRECEDENZE,
                  FLAGSERVIZIOVIAGGIATORI,
                  FLAGSERVIZIOMERCI,
                  FLAGINTERVIENEDISTANZIAMENTO,
                  FLAGSOTTOPASSAGGI,
                  TIPOAPPARATO,
                  TIPOLOCALITASBF,
                  TIPOSTAZIONE,
                  TIPOLOCALITA,
                  TIPOPUNTOORARIO,
                  CASSIFICAZIONEIAP,
                  DSCCODISTATCOMUNE,
                  DESCRIZIONECOMUNE,
                  DSCCODISTATPROVINCIA,
                  SIGLAPROVINCIA,
                  DESCRIZIONEPROVINCIA,
                  NULL
             FROM RINF_STAGING_EVO.PIC_LOCALITA l,
                  (SELECT DISTINCT CODICELOCALITAPIC, CODICELOCALITAIR2K
                     FROM RINF_STAGING_EVO.PIC_LOCALITACIRCINFR
                    WHERE     NVL (DATAINIZIOVALIDITA,
                                   TO_DATE ('01011999', 'DDMMYYYY')) <=
                                 data_riferimento
                          AND NVL (DATAFINEVALIDITA,
                                   TO_DATE ('01012999', 'DDMMYYYY')) >=
                                 data_riferimento) c
            WHERE     l.CODICELOCALITAPIC = O.CODICE_LOCALITA_PIC
                  AND L.CODICELOCALITAPIC = C.CODICELOCALITAPIC(+)
                  AND NVL (l.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (l.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento)
 WHERE CODICE_LOCALITA_PIC IN
          (SELECT l.CODICELOCALITAPIC
             FROM RINF_STAGING_EVO.PIC_LOCALITA l
            WHERE     NVL (l.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (l.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);



INSERT INTO RINF_ANAGRAFICHE_EVO.LOCALITA_PIC (
               CODICE_LOCALITA_PIC,
               CODICE_LOCALITA_MIR,
               COD_LOCALITA_IN_RETE,
               DATA_INIZIO_VALIDITA,
               DATA_FINE_VALIDITA,
               RETE_PROPRIETARIA,
               SIGLA_LOCALITA,
               NOME_LOCALITA8,
               NOME_LOCALITA12,
               NOME_LOCALITA16,
               NOME_LOCALITA30,
               NOME_LOCALITA40,
               FLAG_LOCALITA_CONFINE,
               DATA_INIZIO_VALIDITA_FCL,
               DATA_FINE_VALIDITA_FCL,
               COORDINATA_X,
               COORDINATA_Y,
               COORDINATA_Z,
               FLAG_INCROCI_PRECEDENZE,
               FLAG_SERVIZIO_VIAGGIATORI,
               FLAG_SERVIZIO_MERCI,
               FLAG_INTERVIENE_DISTANZIAMENTO,
               FLAG_SOTTOPASSAGGI,
               TIPO_APPARATO,
               TIPO_LOCALITASBF,
               TIPO_STAZIONE,
               TIPO_LOCALITA,
               TIPO_PUNTOORARIO,
               CASSIFICAZIONE_IAP,
               COD_ISTAT_COMUNE,
               DESCRIZIONE_COMUNE,
               COD_ISTAT_PROVINCIA,
               SIGLA_PROVINCIA,
               DESCRIZIONE_PROVINCIA)
   SELECT l.CODICELOCALITAPIC,
          CODICELOCALITAMIR,
          CODICELOCALITAIR2K,
          l.DATAINIZIOVALIDITA,
          l.DATAFINEVALIDITA,
          RETEPROPRIETARIA,
          SIGLALOCALITA,
          DESCRLOCALITA8,
          DESCRLOCALITA12,
          DESCRLOCALITA16,
          DESCRLOCALITA30,
          DESCRLOCALITA40,
          FLAGCONFINE,
          DATAINIZIOVALIDITAFCL,
          DATAFINEVALIDITAFCL,
          COORDINATAX,
          COORDINATAY,
          COORDINATAZ,
          FLAGAMMETTEINCROCIPRECEDENZE,
          FLAGSERVIZIOVIAGGIATORI,
          FLAGSERVIZIOMERCI,
          FLAGINTERVIENEDISTANZIAMENTO,
          FLAGSOTTOPASSAGGI,
          TIPOAPPARATO,
          TIPOLOCALITASBF,
          TIPOSTAZIONE,
          TIPOLOCALITA,
          TIPOPUNTOORARIO,
          CASSIFICAZIONEIAP,
          DSCCODISTATCOMUNE,
          DESCRIZIONECOMUNE,
          DSCCODISTATPROVINCIA,
          SIGLAPROVINCIA,
          DESCRIZIONEPROVINCIA
     FROM RINF_STAGING_EVO.PIC_LOCALITA l,
          (SELECT DISTINCT CODICELOCALITAPIC, CODICELOCALITAIR2K
             FROM RINF_STAGING_EVO.PIC_LOCALITACIRCINFR
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento) c
    WHERE     L.CODICELOCALITAPIC = C.CODICELOCALITAPIC(+)
          AND NVL (l.DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND NVL (l.DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND l.CODICELOCALITAPIC IN
                 (SELECT l.CODICELOCALITAPIC
                    FROM RINF_STAGING_EVO.PIC_LOCALITA l
                   WHERE     NVL (l.DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                         AND NVL (l.DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                  MINUS
                  SELECT CODICE_LOCALITA_PIC
                    FROM RINF_ANAGRAFICHE_EVO.LOCALITA_PIC);

UPDATE RINF_ANAGRAFICHE_EVO.LOCALITA_PIC
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_LOCALITA_PIC IN
          (SELECT CODICE_LOCALITA_PIC FROM RINF_ANAGRAFICHE_EVO.LOCALITA_PIC
           MINUS
           SELECT CODICELOCALITAPIC
             FROM RINF_STAGING_EVO.PIC_LOCALITA l
            WHERE     NVL (l.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (l.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);

--29/02/2016 aggiornamento della data di fine validit� per gli oggetti scaduti
UPDATE RINF_ANAGRAFICHE_EVO.LOCALITA_PIC p
   SET DATA_FINE_VALIDITA =
          (SELECT MAX (DATAFINEVALIDITA)
             FROM RINF_STAGING_EVO.PIC_LOCALITA h
            WHERE     DATAFINEVALIDITA IS NOT NULL
                  AND h.CODICELOCALITAPIC = p.CODICE_LOCALITA_PIC)
WHERE CODICE_LOCALITA_PIC IN
          (SELECT CODICE_LOCALITA_PIC FROM RINF_ANAGRAFICHE_EVO.LOCALITA_PIC
           MINUS
           SELECT CODICELOCALITAPIC
             FROM RINF_STAGING_EVO.PIC_LOCALITA l
            WHERE     NVL (l.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (l.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);

 --TRATTE_PIC 10

UPDATE RINF_ANAGRAFICHE_EVO.TRATTE_PIC o
   SET (CODICE_LOCALITA_INIZIO_PIC,
        CODICE_LOCALITA_FINE_PIC,
        CODICE_VIA,
        COD_PERCORSO_PIC,
        SEDE_TECNICA,
        DATA_INIZIO_VALIDITA,
        DATA_FINE_VALIDITA,
        RETE_PROPRIETARIA,
        LUNGHEZZA,
        FLAG_MARCIA_PARALLELA,
        FLAG_DISPARI,
        CODICE_TRATTA_MIR,
        CODICE_TIPO_TRASP_COMBINATO1,
        CODICE_TIPO_TRASP_COMBINATO2,
        CODICE_CAT_LINEA_MAS_ASS,
        CODICE_TIPOTRAZIONE,
        TIPO_TRATTA,
        CODICE_TIPO_ESERCIZIO,
        DATA_ATTIVAZIONE_FCL,
        DATA_CESSAZIONE_FCL,
        CODICE_TIPO_TRAFFICO,
        CODICE_CATEGORIA_LINEA,
        CODICE_TIPO_BLOCCO,
        DATA_SCADENZA) =
          (SELECT CODICELOCALITAINIZIO,
                  CODICELOCALITAFINE,
                  CODICEVIA,
                  c.IDPERCORSO,
                  c.CODICETRATTAIR2K,
                  t.DATAINIZIOVALIDITA,
                  t.DATAFINEVALIDITA,
                  RETEPROPRIETARIA,
                  LUNGHEZZA,
                  FLAGAMMESSAMARCIAPARALLELA,
                  FLAGORIENTAMENTODISPARI,
                  CODTRATTAMIR,
                  CODICE_TIPOTRASPCOMBINATO1,
                  CODICE_TIPOTRASPCOMBINATO2,
                  CODICE_CATLINEAMASASS,
                  CODICE_TIPOTRAZIONE,
                  TIPOTRATTA,
                  CODICE_TIPOESERCIZIO,
                  DATAATTIVAZIONEFCL,
                  DATACESSAZIONEFCL,
                  CODICE_TIPOTRAFFICO,
                  CODICE_CATEGORIALINEA,
                  CODICE_TIPOBLOCCO,
                  NULL
             FROM RINF_STAGING_EVO.PIC_TRATTECIRC t,
                  (SELECT DISTINCT CODICETRATTA, CODICETRATTAIR2K, IDPERCORSO
                     FROM RINF_STAGING_EVO.PIC_PERCORSIINFR
                    WHERE
                    CODICETRATTAIR2K like 'TR%' AND
                    NVL (DATAINIZIOVALIDITA,
                                   TO_DATE ('01011999', 'DDMMYYYY')) <=
                                 data_riferimento
                          AND NVL (DATAFINEVALIDITA,
                                   TO_DATE ('01012999', 'DDMMYYYY')) >=
                                 data_riferimento) c
            WHERE     O.CODICE_TRATTA_PIC = t.CODICETRATTA
                  AND t.CODICETRATTA = c.CODICETRATTA(+)
                  AND NVL (t.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (t.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento)
 WHERE CODICE_TRATTA_PIC IN
          (SELECT CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_TRATTECIRC t
            WHERE     NVL (t.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (t.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.TRATTE_PIC (CODICE_TRATTA_PIC,
                                              CODICE_LOCALITA_INIZIO_PIC,
                                              CODICE_LOCALITA_FINE_PIC,
                                              CODICE_VIA,
                                              COD_PERCORSO_PIC,
                                              SEDE_TECNICA,
                                              DATA_INIZIO_VALIDITA,
                                              DATA_FINE_VALIDITA,
                                              RETE_PROPRIETARIA,
                                              LUNGHEZZA,
                                              FLAG_MARCIA_PARALLELA,
                                              FLAG_DISPARI,
                                              CODICE_TRATTA_MIR,
                                              CODICE_TIPO_TRASP_COMBINATO1,
                                              CODICE_TIPO_TRASP_COMBINATO2,
                                              CODICE_CAT_LINEA_MAS_ASS,
                                              CODICE_TIPOTRAZIONE,
                                              TIPO_TRATTA,
                                              CODICE_TIPO_ESERCIZIO,
                                              DATA_ATTIVAZIONE_FCL,
                                              DATA_CESSAZIONE_FCL,
                                              CODICE_TIPO_TRAFFICO,
                                              CODICE_CATEGORIA_LINEA,
                                              CODICE_TIPO_BLOCCO)
   SELECT t.CODICETRATTA,
          CODICELOCALITAINIZIO,
          CODICELOCALITAFINE,
          CODICEVIA,
          c.IDPERCORSO,
          c.CODICETRATTAIR2K,
          t.DATAINIZIOVALIDITA,
          t.DATAFINEVALIDITA,
          RETEPROPRIETARIA,
          LUNGHEZZA,
          FLAGAMMESSAMARCIAPARALLELA,
          FLAGORIENTAMENTODISPARI,
          CODTRATTAMIR,
          CODICE_TIPOTRASPCOMBINATO1,
          CODICE_TIPOTRASPCOMBINATO2,
          CODICE_CATLINEAMASASS,
          CODICE_TIPOTRAZIONE,
          TIPOTRATTA,
          CODICE_TIPOESERCIZIO,
          DATAATTIVAZIONEFCL,
          DATACESSAZIONEFCL,
          CODICE_TIPOTRAFFICO,
          CODICE_CATEGORIALINEA,
          CODICE_TIPOBLOCCO
     FROM RINF_STAGING_EVO.PIC_TRATTECIRC t,
          (SELECT DISTINCT CODICETRATTA, CODICETRATTAIR2K, IDPERCORSO
             FROM RINF_STAGING_EVO.PIC_PERCORSIINFR
            WHERE
            CODICETRATTAIR2K like 'TR%' AND
            NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento) c
    WHERE     t.CODICETRATTA = c.CODICETRATTA(+)
          AND NVL (t.DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND NVL (t.DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND t.CODICETRATTA IN
                 (SELECT CODICETRATTA
                    FROM RINF_STAGING_EVO.PIC_TRATTECIRC t
                   WHERE     NVL (t.DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                         AND NVL (t.DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                  MINUS
                  SELECT CODICE_TRATTA_PIC
                    FROM RINF_ANAGRAFICHE_EVO.TRATTE_PIC);

UPDATE RINF_ANAGRAFICHE_EVO.TRATTE_PIC
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TRATTA_PIC IN
          (SELECT CODICE_TRATTA_PIC FROM RINF_ANAGRAFICHE_EVO.TRATTE_PIC
           MINUS
           SELECT CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_TRATTECIRC t
            WHERE     NVL (t.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (t.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);

--29/02/2016 aggiornamento della data di fine validit� per gli oggetti scaduti

UPDATE RINF_ANAGRAFICHE_EVO.TRATTE_PIC p
   SET DATA_FINE_VALIDITA =
          (SELECT MAX (DATAFINEVALIDITA)
             FROM RINF_STAGING_EVO.PIC_TRATTECIRC h
            WHERE     DATAFINEVALIDITA IS NOT NULL
                  AND h.CODICETRATTA = p.CODICE_TRATTA_PIC)
 WHERE CODICE_TRATTA_PIC IN
          (SELECT CODICE_TRATTA_PIC FROM RINF_ANAGRAFICHE_EVO.TRATTE_PIC
           MINUS
           SELECT CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_TRATTECIRC t
            WHERE     NVL (t.DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (t.DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);

--ANAG_CORRIDOI 11

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI o
   SET (CODICE_CORRIDOIO,
        SIGLA_CORRIDOIO,
        NOME_CORRIDOIO_MERCI,
        INIZIO_VALIDITA,
        FINE_VALIDITA,
        TIPO_CORRIDOIO,
        NOTE,
        DATA_SCADENZA,
        CODICE_CORRIDOIO_633) =
          (SELECT CODICECORRIDOIOMERCI,
                  NUMEROCORRIDOIOMERCI,
                  NOMECORRIDOIOMERCI,
                  DATAINIZIOVALIDITA,
                  DATAFINEVALIDITA,
                  CODICE_TIPOCORRIDOIOMERCI,
                  NOTECORRIDOIOMERCI,
                  NULL,
                  TO_NUMBER (
                     SUBSTR (NUMEROCORRIDOIOMERCI, INSTR ('RFC', 1) + 4, 1))
             FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI n
            WHERE     O.CODICE_GIURISDIZIONE = N.CODICEGIURISDIZIONE
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento)
 WHERE CODICE_GIURISDIZIONE IN
          (SELECT CODICEGIURISDIZIONE
             FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI
            WHERE     NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI (CODICE_GIURISDIZIONE,
                                                 CODICE_CORRIDOIO,
                                                 SIGLA_CORRIDOIO,
                                                 NOME_CORRIDOIO_MERCI,
                                                 INIZIO_VALIDITA,
                                                 FINE_VALIDITA,
                                                 TIPO_CORRIDOIO,
                                                 NOTE,
                                                 CODICE_CORRIDOIO_633)
   SELECT CODICEGIURISDIZIONE,
          CODICECORRIDOIOMERCI,
          NUMEROCORRIDOIOMERCI,
          NOMECORRIDOIOMERCI,
          DATAINIZIOVALIDITA,
          DATAFINEVALIDITA,
          CODICE_TIPOCORRIDOIOMERCI,
          NOTECORRIDOIOMERCI,
          TO_NUMBER (SUBSTR (NUMEROCORRIDOIOMERCI, INSTR ('RFC', 1) + 4, 1))
     FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI
    WHERE     NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND CODICEGIURISDIZIONE IN
                 (SELECT CODICEGIURISDIZIONE
                    FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI
                   WHERE     NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                         AND NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                  MINUS
                  SELECT CODICE_GIURISDIZIONE
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_GIURISDIZIONE IN
          (SELECT CODICE_GIURISDIZIONE
             FROM RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI
           MINUS
           SELECT CODICEGIURISDIZIONE
             FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI
            WHERE     NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);

--CORRIDOIO_TRATTE   12

UPDATE RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE o
   SET (INIZIO_VALIDITA, FLAG_TITOLARE, DATA_SCADENZA) =
          (  SELECT MAX (DATAINIZIOVALIDITA), FLAGTITOLARE, NULL
               FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_TRATTA n
              WHERE     O.CODICE_GIURISDIZIONE = N.CODICEGIURISDIZIONE
                    AND O.CODICE_TRATTA_PIC = N.CODICETRATTA
                    AND NVL (DATAINIZIOVALIDITA,
                             TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
           GROUP BY CODICEGIURISDIZIONE, CODICETRATTA, FLAGTITOLARE)
 WHERE (CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC) IN
          (SELECT CODICEGIURISDIZIONE, CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_TRATTA
            WHERE NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                     data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE (CODICE_GIURISDIZIONE,
                                                    INIZIO_VALIDITA,
                                                    CODICE_TRATTA_PIC,
                                                    FLAG_TITOLARE)
     SELECT CODICEGIURISDIZIONE,
            MAX (DATAINIZIOVALIDITA),
            CODICETRATTA,
            FLAGTITOLARE
       FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_TRATTA t,
            RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI c,
            RINF_ANAGRAFICHE_EVO.TRATTE_PIC p --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
      WHERE     C.CODICE_GIURISDIZIONE = t.CODICEGIURISDIZIONE
            AND t.CODICETRATTA = p.CODICE_TRATTA_PIC
            AND NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                   data_riferimento
            AND (CODICEGIURISDIZIONE, CODICETRATTA) IN
                   (SELECT CODICEGIURISDIZIONE, CODICETRATTA
                      FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_TRATTA
                     WHERE NVL (DATAINIZIOVALIDITA,
                                TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                    MINUS
                    SELECT CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC
                      FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE)
   GROUP BY CODICEGIURISDIZIONE, CODICETRATTA, FLAGTITOLARE;

UPDATE RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC) IN
          (SELECT CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC
             FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_TRATTE
           MINUS
           SELECT CODICEGIURISDIZIONE, CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_TRATTA
            WHERE NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                     data_riferimento);

 --CORRIDOIO_LOCALITA 13

UPDATE RINF_ANAGRAFICHE_EVO.CORRIDOIO_LOCALITA o
   SET (INIZIO_VALIDITA, FLAG_TITOLARE, DATA_SCADENZA) =
          (  SELECT MAX (DATAINIZIOVALIDITA), FLAGTITOLARE, NULL
               FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_LOCALITA n
              WHERE     O.CODICE_GIURISDIZIONE = N.CODICEGIURISDIZIONE
                    AND O.CODICE_LOCALITA_PIC = N.CODICELOCALITA
                    AND NVL (DATAINIZIOVALIDITA,
                             TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
           GROUP BY CODICEGIURISDIZIONE, CODICELOCALITA, FLAGTITOLARE)
 WHERE (CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC) IN
          (SELECT CODICEGIURISDIZIONE, CODICELOCALITA
             FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_LOCALITA
            WHERE NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                     data_riferimento);

INSERT INTO RINF_ANAGRAFICHE_EVO.CORRIDOIO_LOCALITA (CODICE_GIURISDIZIONE,
                                                      INIZIO_VALIDITA,
                                                      CODICE_LOCALITA_PIC,
                                                      FLAG_TITOLARE)
     SELECT CODICEGIURISDIZIONE,
            MAX (DATAINIZIOVALIDITA),
            CODICELOCALITA,
            FLAGTITOLARE
       FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_LOCALITA l,
            RINF_ANAGRAFICHE_EVO.ANAG_CORRIDOI c,
            RINF_ANAGRAFICHE_EVO.LOCALITA_PIC p --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
      WHERE     l.CODICEGIURISDIZIONE = c.CODICE_GIURISDIZIONE
            AND l.CODICELOCALITA = P.CODICE_LOCALITA_PIC
            AND NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                   data_riferimento
            AND (CODICEGIURISDIZIONE, CODICELOCALITA) IN
                   (SELECT CODICEGIURISDIZIONE, CODICELOCALITA
                      FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_LOCALITA
                     WHERE NVL (DATAINIZIOVALIDITA,
                                TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                    MINUS
                    SELECT CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC
                      FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_LOCALITA)
   GROUP BY CODICEGIURISDIZIONE, CODICELOCALITA, FLAGTITOLARE;

UPDATE RINF_ANAGRAFICHE_EVO.CORRIDOIO_LOCALITA
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC) IN
          (SELECT CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC
             FROM RINF_ANAGRAFICHE_EVO.CORRIDOIO_LOCALITA
           MINUS
           SELECT CODICEGIURISDIZIONE, CODICELOCALITA
             FROM RINF_STAGING_EVO.PIC_CORRIDOIOMERCI_LOCALITA
            WHERE NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                     data_riferimento);


-- ANAG_LINEE_TENT 14

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT o
   SET (CODICE_LINEA_TENT,
        NUMERO_LINEA_TENT,
        NOME_LINEA_TENT,
        INIZIO_VALIDITA,
        FINE_VALIDITA,
        TIPO_STATO_INFR,
        FLAG_AV,
        FLAG_CORE,
        DATA_COMPLETAMENTO,
        NOTE,
        DATA_SCADENZA) =
          (SELECT CODICELINEATEN,
                  NUMEROLINEATEN,
                  NOMELINEATEN,
                  DATAINIZIOVALIDITA,
                  DATAFINEVALIDITA,
                  TIPOSTATOINFRASTRUTTURA,
                  FLAGAV,
                  FLAGCORE,
                  DATACOMPLETAMENTO,
                  NOTELINEATEN,
                  NULL
             FROM RINF_STAGING_EVO.PIC_LINEATEN n
            WHERE     O.CODICE_GIURISDIZIONE = N.CODICEGIURISDIZIONE
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento)
 WHERE CODICE_GIURISDIZIONE IN
          (SELECT CODICEGIURISDIZIONE
             FROM RINF_STAGING_EVO.PIC_LINEATEN n
            WHERE     NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT (CODICE_GIURISDIZIONE,
                                                   CODICE_LINEA_TENT,
                                                   NUMERO_LINEA_TENT,
                                                   NOME_LINEA_TENT,
                                                   INIZIO_VALIDITA,
                                                   FINE_VALIDITA,
                                                   TIPO_STATO_INFR,
                                                   FLAG_AV,
                                                   FLAG_CORE,
                                                   DATA_COMPLETAMENTO,
                                                   NOTE)
   SELECT CODICEGIURISDIZIONE,
          CODICELINEATEN,
          NUMEROLINEATEN,
          NOMELINEATEN,
          DATAINIZIOVALIDITA,
          DATAFINEVALIDITA,
          TIPOSTATOINFRASTRUTTURA,
          FLAGAV,
          FLAGCORE,
          DATACOMPLETAMENTO,
          NOTELINEATEN
     FROM RINF_STAGING_EVO.PIC_LINEATEN
    WHERE     NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND CODICEGIURISDIZIONE IN
                 (SELECT CODICEGIURISDIZIONE
                    FROM RINF_STAGING_EVO.PIC_LINEATEN
                   WHERE     NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                         AND NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                  MINUS
                  SELECT CODICE_GIURISDIZIONE
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_GIURISDIZIONE IN
          (SELECT CODICE_GIURISDIZIONE
             FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT
           MINUS
           SELECT CODICEGIURISDIZIONE
             FROM RINF_STAGING_EVO.PIC_LINEATEN
            WHERE     NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);

--LINEA_TENT_TRATTE   15

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_TENT_TRATTE o
   SET (INIZIO_VALIDITA,
        CODICE_TRATTA_PIC,
        FLAG_TITOLARE,
        DATA_SCADENZA) =
          (  SELECT MAX (DATAINIZIOVALIDITA),
                    CODICETRATTA,
                    FLAGTITOLARE,
                    NULL
               FROM RINF_STAGING_EVO.PIC_LINEATEN_TRATTA n
              WHERE     o.CODICE_GIURISDIZIONE = N.CODICEGIURISDIZIONE
                    AND o.CODICE_TRATTA_PIC = N.CODICETRATTA
                    AND DATAINIZIOVALIDITA <= data_riferimento
           GROUP BY CODICEGIURISDIZIONE, CODICETRATTA, FLAGTITOLARE)
 WHERE (CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC) IN
          (SELECT CODICEGIURISDIZIONE, CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_LINEATEN_TRATTA
            WHERE DATAINIZIOVALIDITA <= data_riferimento);



INSERT INTO RINF_ANAGRAFICHE_EVO.LINEA_TENT_TRATTE (CODICE_GIURISDIZIONE,
                                                     INIZIO_VALIDITA,
                                                     CODICE_TRATTA_PIC,
                                                     FLAG_TITOLARE)
     SELECT CODICEGIURISDIZIONE,
            MAX (DATAINIZIOVALIDITA),
            CODICETRATTA,
            FLAGTITOLARE
       FROM RINF_STAGING_EVO.PIC_LINEATEN_TRATTA t,
            RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT l,
            RINF_ANAGRAFICHE_EVO.TRATTE_PIC p --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
      WHERE     t.CODICEGIURISDIZIONE = l.CODICE_GIURISDIZIONE
            AND t.CODICETRATTA = p.CODICE_TRATTA_PIC
            AND DATAINIZIOVALIDITA <= data_riferimento
            AND (CODICEGIURISDIZIONE, CODICETRATTA) IN
                   (SELECT CODICEGIURISDIZIONE, CODICETRATTA
                      FROM RINF_STAGING_EVO.PIC_LINEATEN_TRATTA
                     WHERE DATAINIZIOVALIDITA <= data_riferimento
                    MINUS
                    SELECT CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC
                      FROM RINF_ANAGRAFICHE_EVO.LINEA_TENT_TRATTE)
   GROUP BY CODICEGIURISDIZIONE, CODICETRATTA, FLAGTITOLARE;

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_TENT_TRATTE
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC) IN
          (SELECT CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC
             FROM RINF_ANAGRAFICHE_EVO.LINEA_TENT_TRATTE
           MINUS
           SELECT CODICEGIURISDIZIONE, CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_LINEATEN_TRATTA
            WHERE DATAINIZIOVALIDITA <= data_riferimento);

--LINEA_TENT_LOCALITA   16

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_TENT_LOCALITA o
   SET (INIZIO_VALIDITA, FLAG_TITOLARE, DATA_SCADENZA) =
          (  SELECT MAX (DATAINIZIOVALIDITA), FLAGTITOLARE, NULL
               FROM RINF_STAGING_EVO.PIC_LINEATEN_LOCALITA n
              WHERE     O.CODICE_GIURISDIZIONE = N.CODICEGIURISDIZIONE
                    AND O.CODICE_LOCALITA_PIC = N.CODICELOCALITA
                    AND DATAINIZIOVALIDITA <= data_riferimento
           GROUP BY CODICEGIURISDIZIONE, CODICELOCALITA, FLAGTITOLARE)
 WHERE (CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC) IN
          (SELECT CODICEGIURISDIZIONE, CODICELOCALITA
             FROM RINF_STAGING_EVO.PIC_LINEATEN_LOCALITA
            WHERE DATAINIZIOVALIDITA <= data_riferimento);



INSERT INTO RINF_ANAGRAFICHE_EVO.LINEA_TENT_LOCALITA (CODICE_GIURISDIZIONE,
                                                       INIZIO_VALIDITA,
                                                       CODICE_LOCALITA_PIC,
                                                       FLAG_TITOLARE)
     SELECT CODICEGIURISDIZIONE,
            MAX (DATAINIZIOVALIDITA),
            CODICELOCALITA,
            FLAGTITOLARE
       FROM RINF_STAGING_EVO.PIC_LINEATEN_LOCALITA t,
            RINF_ANAGRAFICHE_EVO.ANAG_LINEE_TENT l,
            RINF_ANAGRAFICHE_EVO.LOCALITA_PIC p --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
      WHERE     t.CODICEGIURISDIZIONE = l.CODICE_GIURISDIZIONE
            AND t.CODICELOCALITA = p.CODICE_LOCALITA_PIC
            AND DATAINIZIOVALIDITA <= data_riferimento
            AND (CODICEGIURISDIZIONE, CODICELOCALITA) IN
                   (SELECT CODICEGIURISDIZIONE, CODICELOCALITA
                      FROM RINF_STAGING_EVO.PIC_LINEATEN_LOCALITA
                     WHERE DATAINIZIOVALIDITA <= data_riferimento
                    MINUS
                    SELECT CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC
                      FROM RINF_ANAGRAFICHE_EVO.LINEA_TENT_LOCALITA)
   GROUP BY CODICEGIURISDIZIONE, CODICELOCALITA, FLAGTITOLARE;

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_TENT_LOCALITA
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC) IN
          (SELECT CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC
             FROM RINF_ANAGRAFICHE_EVO.LINEA_TENT_LOCALITA
           MINUS
           SELECT CODICEGIURISDIZIONE, CODICELOCALITA
             FROM RINF_STAGING_EVO.PIC_LINEATEN_LOCALITA
            WHERE DATAINIZIOVALIDITA <= data_riferimento);

--ANAG_LINEA_COMMERCIALE 17

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE o
   SET (CODICE_LINEA_COMMERCIALE,
        DATA_INIZIO_VAL,
        DATA_FINE_VAL,
        DEFINIZIONE,
        SIGLA_LINEA_COMMERCIALE,
        CODICE_TIPO_LINEA,
        NOTE,
        DATA_SCADENZA) =
          (SELECT CODICETRATTACOMMERCIALE,
                  DATAINIZIOVALIDITA,
                  DATAFINEVALIDITA,
                  NOMETRATTACOMMERCIALE,
                  SIGLATRATTACOMMERCIALE,
                  TIPOTRATTACOMMERCIALE,
                  NOTETRATTACOMMERCIALE,
                  NULL
             FROM RINF_STAGING_EVO.PIC_TRATTA_COMM n
            WHERE     O.CODICE_GIURISDIZIONE = N.CODICEGIURISDIZIONE
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento)
 WHERE CODICE_GIURISDIZIONE IN
          (SELECT CODICEGIURISDIZIONE
             FROM RINF_STAGING_EVO.PIC_TRATTA_COMM
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE (
               CODICE_LINEA_COMMERCIALE,
               DATA_INIZIO_VAL,
               DATA_FINE_VAL,
               DEFINIZIONE,
               SIGLA_LINEA_COMMERCIALE,
               CODICE_TIPO_LINEA,
               NOTE,
               CODICE_GIURISDIZIONE)
   SELECT CODICETRATTACOMMERCIALE,
          DATAINIZIOVALIDITA,
          DATAFINEVALIDITA,
          NOMETRATTACOMMERCIALE,
          SIGLATRATTACOMMERCIALE,
          TIPOTRATTACOMMERCIALE,
          NOTETRATTACOMMERCIALE,
          CODICEGIURISDIZIONE
     FROM RINF_STAGING_EVO.PIC_TRATTA_COMM
    WHERE     NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                 data_riferimento
          AND NVL (DATAFINEVALIDITA, TO_DATE ('01012999', 'DDMMYYYY')) >=
                 data_riferimento
          AND CODICEGIURISDIZIONE IN
                 (SELECT CODICEGIURISDIZIONE
                    FROM RINF_STAGING_EVO.PIC_TRATTA_COMM
                   WHERE     NVL (DATAINIZIOVALIDITA,
                                  TO_DATE ('01011999', 'DDMMYYYY')) <=
                                data_riferimento
                         AND NVL (DATAFINEVALIDITA,
                                  TO_DATE ('01012999', 'DDMMYYYY')) >=
                                data_riferimento
                  MINUS
                  SELECT CODICE_GIURISDIZIONE
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_GIURISDIZIONE IN
          (SELECT CODICE_GIURISDIZIONE
             FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE
            MINUS
             SELECT CODICEGIURISDIZIONE
             FROM RINF_STAGING_EVO.PIC_TRATTA_COMM
            WHERE     NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
                  AND NVL (DATAFINEVALIDITA,
                           TO_DATE ('01012999', 'DDMMYYYY')) >= data_riferimento);

--LINEA_COMM_TRATTE 18

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_COMM_TRATTE o
   SET (DATA_INIZIO_VAL, TITOLARE, DATA_SCADENZA) =
          (  SELECT MAX (DATAINIZIOVALIDITA), FLAGTITOLARE, NULL
               FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_TRATTA c,
                    RINF_ANAGRAFICHE_EVO.TRATTE_PIC t,
                    RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a
              WHERE     O.CODICE_GIURISDIZIONE = c.CODICEGIURISDIZIONE
                    AND o.CODICE_TRATTA_PIC = c.CODICETRATTA
                    AND T.CODICE_TRATTA_PIC = C.CODICETRATTA
                    AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                    AND NVL (DATAINIZIOVALIDITA,
                             TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
           GROUP BY FLAGTITOLARE)
 WHERE (CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC) IN
          (SELECT CODICEGIURISDIZIONE, CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_TRATTA c,
                  RINF_ANAGRAFICHE_EVO.TRATTE_PIC t,
                  RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a
            WHERE     T.CODICE_TRATTA_PIC = C.CODICETRATTA
                  AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);


INSERT INTO RINF_ANAGRAFICHE_EVO.LINEA_COMM_TRATTE (CODICE_GIURISDIZIONE,
                                                     DATA_INIZIO_VAL,
                                                     CODICE_TRATTA_PIC,
                                                     TITOLARE)
     SELECT CODICEGIURISDIZIONE,
            MAX (DATAINIZIOVALIDITA),
            CODICETRATTA,
            FLAGTITOLARE
       FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_TRATTA c,
            RINF_ANAGRAFICHE_EVO.TRATTE_PIC t,
            RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
      WHERE     T.CODICE_TRATTA_PIC = C.CODICETRATTA
            AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
            AND NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                   data_riferimento
            AND (CODICEGIURISDIZIONE, CODICETRATTA) IN
                   (SELECT CODICEGIURISDIZIONE, CODICETRATTA
                      FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_TRATTA c,
                           RINF_ANAGRAFICHE_EVO.TRATTE_PIC t,
                           RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a
                     WHERE     T.CODICE_TRATTA_PIC = C.CODICETRATTA
                           AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                           AND NVL (DATAINIZIOVALIDITA,
                                    TO_DATE ('01011999', 'DDMMYYYY')) <=
                                  data_riferimento
                    MINUS
                    SELECT CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC
                      FROM RINF_ANAGRAFICHE_EVO.LINEA_COMM_TRATTE)
   GROUP BY CODICEGIURISDIZIONE, CODICETRATTA, FLAGTITOLARE;

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_COMM_TRATTE
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC) IN
          (SELECT CODICE_GIURISDIZIONE, CODICE_TRATTA_PIC
             FROM RINF_ANAGRAFICHE_EVO.LINEA_COMM_TRATTE
           MINUS
           SELECT CODICEGIURISDIZIONE, CODICETRATTA
             FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_TRATTA c,
                  RINF_ANAGRAFICHE_EVO.TRATTE_PIC t,
                  RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a
            WHERE     T.CODICE_TRATTA_PIC = C.CODICETRATTA
                  AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);

--LINEA_COMM_LOCALITA 19

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_COMM_LOCALITA o
   SET (DATA_INIZIO_VAL, TITOLARE, DATA_SCADENZA) =
          (  SELECT MAX (DATAINIZIOVALIDITA), FLAGTITOLARE, NULL
               FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_LOCALITA c,
                    RINF_ANAGRAFICHE_EVO.LOCALITA_PIC l,
                    RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a
              WHERE     O.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                    AND O.CODICE_LOCALITA_PIC = C.CODICELOCALITA
                    AND C.CODICELOCALITA = L.CODICE_LOCALITA_PIC
                    AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                    AND NVL (DATAINIZIOVALIDITA,
                             TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento
           GROUP BY FLAGTITOLARE);


INSERT INTO RINF_ANAGRAFICHE_EVO.LINEA_COMM_LOCALITA (CODICE_GIURISDIZIONE,
                                                       DATA_INIZIO_VAL,
                                                       CODICE_LOCALITA_PIC,
                                                       TITOLARE)
     SELECT CODICEGIURISDIZIONE,
            MAX (DATAINIZIOVALIDITA),
            CODICELOCALITA,
            FLAGTITOLARE
       FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_LOCALITA c,
            RINF_ANAGRAFICHE_EVO.LOCALITA_PIC l,
            RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
      WHERE     C.CODICELOCALITA = L.CODICE_LOCALITA_PIC
            AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
            AND NVL (DATAINIZIOVALIDITA, TO_DATE ('01011999', 'DDMMYYYY')) <=
                   data_riferimento
            AND (CODICEGIURISDIZIONE, CODICELOCALITA) IN
                   (SELECT CODICEGIURISDIZIONE, CODICELOCALITA
                      FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_LOCALITA c,
                           RINF_ANAGRAFICHE_EVO.LOCALITA_PIC l,
                           RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a
                     WHERE     C.CODICELOCALITA = L.CODICE_LOCALITA_PIC
                           AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                           AND NVL (DATAINIZIOVALIDITA,
                                    TO_DATE ('01011999', 'DDMMYYYY')) <=
                                  data_riferimento
                    MINUS
                    SELECT CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC
                      FROM RINF_ANAGRAFICHE_EVO.LINEA_COMM_LOCALITA)
   GROUP BY CODICEGIURISDIZIONE, CODICELOCALITA, FLAGTITOLARE;

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_COMM_LOCALITA
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC) IN
          (SELECT CODICE_GIURISDIZIONE, CODICE_LOCALITA_PIC
             FROM RINF_ANAGRAFICHE_EVO.LINEA_COMM_LOCALITA
           MINUS
           SELECT CODICEGIURISDIZIONE, CODICELOCALITA
             FROM RINF_STAGING_EVO.PIC_TRATTA_COMM_LOCALITA c,
                  RINF_ANAGRAFICHE_EVO.LOCALITA_PIC l,
                  RINF_ANAGRAFICHE_EVO.ANAG_LINEA_COMMERCIALE a
            WHERE     C.CODICELOCALITA = L.CODICE_LOCALITA_PIC
                  AND A.CODICE_GIURISDIZIONE = C.CODICEGIURISDIZIONE
                  AND NVL (DATAINIZIOVALIDITA,
                           TO_DATE ('01011999', 'DDMMYYYY')) <= data_riferimento);
EXCEPTION
WHEN OTHERS THEN
p_error:=SQLCODE;
DBMS_OUTPUT.PUT_LINE ('Errore SetPICAcquisition' || SUBSTR (SQLERRM, 1, 300));
END SetPICAcquisition;
PROCEDURE SetRomanAcquisition (data_riferimento DATE, p_error OUT NUMBER)    IS

   BEGIN
      p_error := 0;


--ANAG_LINEA_FCL 1

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL o
   SET (DATA_INIZIO_VALIDITA,
        CODICE_DTP,
        CODICE_LINEA_INVERSA,
        DEFINIZIONE,
        KM_INIZIO_ANTINF,
        KM_FINE_ANTINF,
        VEL_MAX_ANTINF,
        FLAG_DISPARI,
        DATA_ULTIMA_MODIFICA,
        DATA_INIZIO_VAL_R,
        DAT_FINE_VAL,
        CODICE_LINEA_PRECEDENTE,
        DATA_SCADENZA) =
          (SELECT FCL_INIVAL_PREV,
                  FCL_DIST_ID,
                  FCL_INV_FCL_ID,
                  FCL_SNAME,
                  FCL_ANTINF_DA,
                  FCL_ANTINF_A,
                  FCL_ANTINF_VMAX,
                  FCL_DISPARI,
                  FCL_TIMESTAMP,
                  FCL_INIVAL_REALE,
                  FCL_FINVAL,
                  FCL_LINOR_FCL_ID,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL n
            WHERE O.CODICE_LINEA_FCL = N.FCL_ID)
 WHERE CODICE_LINEA_FCL IN
          (SELECT FCL_ID FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL--WHERE NVL(FCL_FINVAL,TO_DATE('01011999','DDMMYYYY'))<=SYSDATE
       );

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL (CODICE_LINEA_FCL,
                                                  DATA_INIZIO_VALIDITA,
                                                  CODICE_DTP,
                                                  CODICE_LINEA_INVERSA,
                                                  DEFINIZIONE,
                                                  KM_INIZIO_ANTINF,
                                                  KM_FINE_ANTINF,
                                                  VEL_MAX_ANTINF,
                                                  FLAG_DISPARI,
                                                  DATA_ULTIMA_MODIFICA,
                                                  DATA_INIZIO_VAL_R,
                                                  DAT_FINE_VAL,
                                                  CODICE_LINEA_PRECEDENTE)
   SELECT FCL_ID,
          FCL_INIVAL_PREV,
          FCL_DIST_ID,
          FCL_INV_FCL_ID,
          FCL_SNAME,
          FCL_ANTINF_DA,
          FCL_ANTINF_A,
          FCL_ANTINF_VMAX,
          FCL_DISPARI,
          FCL_TIMESTAMP,
          FCL_INIVAL_REALE,
          FCL_FINVAL,
          FCL_LINOR_FCL_ID
     FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL
    WHERE     NVL (FCL_FINVAL, TO_DATE ('01019999', 'DDMMYYYY')) >= data_riferimento
          AND FCL_ID IN
                 (SELECT FCL_ID
                    FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL
                   WHERE NVL (FCL_FINVAL,
                              TO_DATE ('01019999', 'DDMMYYYY')) >= data_riferimento
                  MINUS
                  SELECT CODICE_LINEA_FCL
                    FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_LINEA_FCL IN
          (SELECT CODICE_LINEA_FCL FROM RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL
           MINUS
           SELECT FCL_ID
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL
            WHERE NVL (FCL_FINVAL, TO_DATE ('01019999', 'DDMMYYYY')) >=
                     data_riferimento);

--ANAG_TIPO_LOC_ROMAN

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN o
   SET (SIGLA_TIPO, DESCRIZIONE, DATA_SCADENZA) =
          (SELECT LOCL_NAME, LOCL_LNAME, NULL
             FROM RINF_STAGING_EVO.ROMAN_SYS_LOCATION_CLASS n
            WHERE o.TIPO_LOCALITA = n.LOCL_ID)
 WHERE TIPO_LOCALITA IN
          (SELECT LOCL_ID FROM RINF_STAGING_EVO.ROMAN_SYS_LOCATION_CLASS);

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN (TIPO_LOCALITA,
                                                       SIGLA_TIPO,
                                                       DESCRIZIONE)
   SELECT LOCL_ID, LOCL_NAME, LOCL_LNAME
     FROM RINF_STAGING_EVO.ROMAN_SYS_LOCATION_CLASS
    WHERE LOCL_ID IN
             (SELECT LOCL_ID FROM RINF_STAGING_EVO.ROMAN_SYS_LOCATION_CLASS
              MINUS
              SELECT TIPO_LOCALITA
                FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN
   SET DATA_SCADENZA = data_riferimento
 WHERE TIPO_LOCALITA IN
          (SELECT TIPO_LOCALITA
             FROM RINF_ANAGRAFICHE_EVO.ANAG_TIPO_LOC_ROMAN
           MINUS
           SELECT LOCL_ID FROM RINF_STAGING_EVO.ROMAN_SYS_LOCATION_CLASS);

--ANAG_REGIONE_ROMAN

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN o
   SET (SIGLA, DESCRIZIONE, DATA_SCADENZA) =
          (SELECT REG_NAME, REG_LNAME, NULL
             FROM RINF_STAGING_EVO.ROMAN_TOP_REGION n
            WHERE o.CODICE_REGIONE = n.REG_ID)
 WHERE CODICE_REGIONE IN (SELECT REG_ID FROM RINF_STAGING_EVO.ROMAN_TOP_REGION);

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN (CODICE_REGIONE,
                                                      SIGLA,
                                                      DESCRIZIONE)
   SELECT REG_ID, REG_NAME, REG_LNAME
     FROM RINF_STAGING_EVO.ROMAN_TOP_REGION
    WHERE REG_ID IN
             (SELECT REG_ID FROM RINF_STAGING_EVO.ROMAN_TOP_REGION
              MINUS
              SELECT CODICE_REGIONE
                FROM RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_REGIONE IN
          (SELECT CODICE_REGIONE
             FROM RINF_ANAGRAFICHE_EVO.ANAG_REGIONE_ROMAN
           MINUS
           SELECT REG_ID FROM RINF_STAGING_EVO.ROMAN_TOP_REGION);


--ANAG_COER_ROMAN
--UPDATE RINF_ANAGRAFICHE_EVO.ANAG_COER_ROMAN --implimentato ma in maniera errata perch� TOP_DISTRICT non sono i COER
--SET
--(SIGLA, DESCRIZIONE, DATA_SCADENZA)=
--(SELECT  DIST_NAME, DIST_LNAME, NULL
--FROM RINF_STAGING_EVO.ROMAN_TOP_DISTRICT n
--WHERE
--o.CODICE_COER=n.DIST_ID)
--WHERE
--CODICE_COER IN
--(SELECT DIST_ID FROM RINF_STAGING_EVO.ROMAN_TOP_DISTRICT);
--
--INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_COER_ROMAN
--(CODICE_COER, SIGLA, DESCRIZIONE)
--SELECT DIST_ID, DIST_NAME, DIST_LNAME
--FROM RINF_STAGING_EVO.ROMAN_TOP_DISTRICT
--WHERE
--DIST_ID IN
--(SELECT DIST_ID FROM RINF_STAGING_EVO.ROMAN_TOP_DISTRICT
--MINUS
--SELECT CODICE_COER FROM RINF_ANAGRAFICHE_EVO.ANAG_COER_ROMAN);
--
--UPDATE RINF_ANAGRAFICHE_EVO.ANAG_COER_ROMAN
--SET DATA_SCADENZA=SYSDATE
--WHERE
--CODICE_COER IN
--(SELECT CODICE_COER FROM RINF_ANAGRAFICHE_EVO.ANAG_COER_ROMAN
--MINUS
--SELECT DIST_ID FROM RINF_STAGING_EVO.ROMAN_TOP_DISTRICT);

--LOCALITA_ROMAN

UPDATE RINF_ANAGRAFICHE_EVO.LOCALITA_ROMAN o
   SET (CODICE_AMM,
        TIPO_LOCALITA,
        DEFINIZIONE_S,
        DEFINIZIONE_L,
        VERSIONE_PREC,
        DEFINIZIONE_12,
        DEFINIZIONE_16,
        CODICE_LOCALITA_PIC,
        CODICE_LOCALITA_MIR,
        FLAG_CONFINE,
        DATA_SCADENZA) =
          (SELECT LOC_RA_ID,
                  LOC_LOCL_ID,
                  LOC_SNAME,
                  LOC_LNAME,
                  LOC_PREV_LOC_ID,
                  LOC_NAME_12,
                  LOC_NAME_16,
                  LOC_CODE_SIRIO,
                  LOC_CODE_BDO,
                  LOC_BORDER,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_TOP_LOCATION n
            WHERE n.LOC_ID = o.CODICE_LOCALITA_ROMAN)
 WHERE CODICE_LOCALITA_ROMAN IN
          (SELECT LOC_ID FROM RINF_STAGING_EVO.ROMAN_TOP_LOCATION);

INSERT INTO RINF_ANAGRAFICHE_EVO.LOCALITA_ROMAN (CODICE_LOCALITA_ROMAN,
                                                  CODICE_AMM,
                                                  TIPO_LOCALITA,
                                                  DEFINIZIONE_S,
                                                  DEFINIZIONE_L,
                                                  VERSIONE_PREC,
                                                  DEFINIZIONE_12,
                                                  DEFINIZIONE_16,
                                                  CODICE_LOCALITA_PIC,
                                                  CODICE_LOCALITA_MIR,
                                                  FLAG_CONFINE)
   SELECT LOC_ID,
          LOC_RA_ID,
          LOC_LOCL_ID,
          LOC_SNAME,
          LOC_LNAME,
          LOC_PREV_LOC_ID,
          LOC_NAME_12,
          LOC_NAME_16,
          LOC_CODE_SIRIO,
          LOC_CODE_BDO,
          LOC_BORDER
     FROM RINF_STAGING_EVO.ROMAN_TOP_LOCATION
    WHERE LOC_ID IN
             (SELECT LOC_ID FROM RINF_STAGING_EVO.ROMAN_TOP_LOCATION
              MINUS
              SELECT CODICE_LOCALITA_ROMAN
                FROM RINF_ANAGRAFICHE_EVO.LOCALITA_ROMAN);

UPDATE RINF_ANAGRAFICHE_EVO.LOCALITA_ROMAN
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_LOCALITA_ROMAN IN
          (SELECT CODICE_LOCALITA_ROMAN
             FROM RINF_ANAGRAFICHE_EVO.LOCALITA_ROMAN
           MINUS
           SELECT LOC_ID FROM RINF_STAGING_EVO.ROMAN_TOP_LOCATION);

--TRATTE_ROMAN

UPDATE RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN o
   SET (CODICE_BRANCH,
        CODICE_REGIONE,
        CODICE_DTP,
        LUNGHEZZA,
        VIA,
        DIREZIONE,
        CODICE_TRATTA_PIC,
        DATA_SCADENZA) =
          (SELECT TRSC_BRA_ID,
                  TRSC_REG_ID,
                  TRSC_DIST_ID,
                  TRSC_LEN,
                  TRSC_RADIO_CH_A,
                  TRSC_DIRECTION,
                  TRSC_PIC_ID,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_TOP_TRACKSECTION n
            WHERE o.CODICE_TRATTA_ROMAN = n.TRSC_ID)
 WHERE CODICE_TRATTA_ROMAN IN
          (SELECT TRSC_ID FROM RINF_STAGING_EVO.ROMAN_TOP_TRACKSECTION);

INSERT INTO RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN (CODICE_TRATTA_ROMAN,
                                                CODICE_BRANCH,
                                                CODICE_REGIONE,
                                                CODICE_DTP,
                                                LUNGHEZZA,
                                                VIA,
                                                DIREZIONE,
                                                CODICE_TRATTA_PIC)
   SELECT TRSC_ID,
          TRSC_BRA_ID,
          TRSC_REG_ID,
          TRSC_DIST_ID,
          TRSC_LEN,
          TRSC_RADIO_CH_A,
          TRSC_DIRECTION,
          TRSC_PIC_ID
     FROM RINF_STAGING_EVO.ROMAN_TOP_TRACKSECTION
    WHERE TRSC_ID IN
    --13/02/2018 a parit� di codice PIC si considera la tratta con codice Roman pi� alto (mail E.Tisbi del 18/12/2017)
             (SELECT MAX(TRSC_ID) FROM RINF_STAGING_EVO.ROMAN_TOP_TRACKSECTION
             GROUP BY TRSC_PIC_ID
              MINUS
              SELECT CODICE_TRATTA_ROMAN
                FROM RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN);

UPDATE RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_TRATTA_ROMAN IN
          (SELECT CODICE_TRATTA_ROMAN FROM RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN
           MINUS
           SELECT TRSC_ID FROM RINF_STAGING_EVO.ROMAN_TOP_TRACKSECTION);

--LINEA_FCL_TRATTE_ROMAN

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN o
   SET (PROG_TRATTA,
        PROGR_KM_FROM_SX,
        PROGR_KM_TO_SX,
        PROGR_KM_FROM_DX,
        PROGR_KM_TO_DX,
        BANALIZZATO,
        DATA_MODIFICA,
        DATA_SCADENZA) =
          (SELECT FCLT_IX,
                  FCLT_PROGR_KM_FROM_SX,
                  FCLT_PROGR_KM_TO_SX,
                  FCLT_PROGR_KM_FROM_DX,
                  FCLT_PROGR_KM_TO_DX,
                  FCLT_BANALIZZATO,
                  FCLT_TIMESTAMP,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_TRATTE n
            WHERE     O.CODICE_LINEA_FCL = N.FCLT_FCL_ID
                  AND O.CODICE_TRATTA_ROMAN = N.FCLT_TRSC_ID)
 WHERE (CODICE_LINEA_FCL, CODICE_TRATTA_ROMAN) IN
          (SELECT FCLT_FCL_ID, FCLT_TRSC_ID
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_TRATTE);

INSERT INTO RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN (
               CODICE_LINEA_FCL,
               CODICE_TRATTA_ROMAN,
               PROG_TRATTA,
               PROGR_KM_FROM_SX,
               PROGR_KM_TO_SX,
               PROGR_KM_FROM_DX,
               PROGR_KM_TO_DX,
               BANALIZZATO,
               DATA_MODIFICA)
   SELECT FCLT_FCL_ID,
          FCLT_TRSC_ID,
          FCLT_IX,
          FCLT_PROGR_KM_FROM_SX,
          FCLT_PROGR_KM_TO_SX,
          FCLT_PROGR_KM_FROM_DX,
          FCLT_PROGR_KM_TO_DX,
          FCLT_BANALIZZATO,
          FCLT_TIMESTAMP
     FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_TRATTE t,
          RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL f,
          RINF_ANAGRAFICHE_EVO.TRATTE_ROMAN r --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
    WHERE     T.FCLT_FCL_ID = F.CODICE_LINEA_FCL
          AND T.FCLT_TRSC_ID = R.CODICE_TRATTA_ROMAN
          AND (FCLT_FCL_ID, FCLT_TRSC_ID) IN
                 (SELECT FCLT_FCL_ID, FCLT_TRSC_ID
                    FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_TRATTE
                  MINUS
                  SELECT CODICE_LINEA_FCL, CODICE_TRATTA_ROMAN
                    FROM RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN);

UPDATE RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_LINEA_FCL, CODICE_TRATTA_ROMAN) IN
          (SELECT CODICE_LINEA_FCL, CODICE_TRATTA_ROMAN
             FROM RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN
           MINUS
           SELECT FCLT_FCL_ID, FCLT_TRSC_ID
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_TRATTE);

--LINEE_FCL_DATI_ROMAN
--10/02/2016 questa anagrafica veniva valorizzata prima delle altre anagrafiche di roman e fallivano le FK

UPDATE RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN o
   SET (CODICE_LINEA_FCL,
        DIREZIONE,
        CODICE_TRATTA_ROMAN,
        FCLD_RS_ID,
        FCLD_CP_ID,
        PROGR_KM,
        TIPO_PUNTO,
        NOME_PUNTO,
        GRADO_PRESTAZIONE,
        GRADO_FRENATURA,
        GRADO_FRENATURA_SUB,
        RAGGIO_CURVATURA,
        PENDENZA,
        ISTRADAMENTO,
        CANDELIERE_1,
        CANDELIERE_2,
        RALLENTAMENTO,
        SPINTA,
        TUNNEL,
        VMAX_A,
        VMAX_B,
        VMAX_C,
        VMAX_P,
        RIDVEL_A,
        RIDVEL_B,
        RIDVEL_C,
        RIDVEL_P,
        NOTA,
        RICH_NORME,
        BANALIZZATO,
        DCM_DU_ID,
        DCM_TIMESTAMP,
        DCI_DU_ID,
        DCI_TIMESTAMP,
        RST_DU_ID,
        RST_TIMESTAMP,
        KM_FITTIZIA,
        SCMT,
        TB_ID,
        SSC,
        DATA_SCADENZA) =
          (SELECT FCLD_FCL_ID,
                  FCLD_TRCK_ID,
                  FCLD_TRSC_ID,
                  FCLD_RS_ID,
                  FCLD_CP_ID,
                  FCLD_PROGR_KM,
                  FCLD_TIPO_PUNTO,
                  FCLD_SNAME,
                  FCLD_GRADO_PRESTAZIONE,
                  FCLD_GRADO_FRENATURA,
                  FCLD_GRADO_FRENATURA_SUB,
                  FCLD_RAGGIO_CURVATURA,
                  FCLD_PENDENZA,
                  FCLD_ISTRADAMENTO,
                  FCLD_CANDELIERE_1,
                  FCLD_CANDELIERE_2,
                  FCLD_RALLENTAMENTO,
                  FCLD_SPINTA,
                  FCLD_TUNNEL,
                  FCLD_VMAX_A,
                  FCLD_VMAX_B,
                  FCLD_VMAX_C,
                  FCLD_VMAX_P,
                  FCLD_RIDVEL_A,
                  FCLD_RIDVEL_B,
                  FCLD_RIDVEL_C,
                  FCLD_RIDVEL_P,
                  FCLD_NOTA,
                  FCLD_RICH_NORME,
                  FCLD_BANALIZZATO,
                  FCLD_DCM_DU_ID,
                  FCLD_DCM_TIMESTAMP,
                  FCLD_DCI_DU_ID,
                  FCLD_DCI_TIMESTAMP,
                  FCLD_RST_DU_ID,
                  FCLD_RST_TIMESTAMP,
                  FCLD_KM_FITTIZIA,
                  FCLD_SCMT,
                  FCLD_TB_ID,
                  FCLD_SSC,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_DATI n
            WHERE o.FCLD_ID = n.FCLD_ID)
 WHERE FCLD_ID IN (SELECT FCLD_ID FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_DATI);

INSERT INTO RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN (FCLD_ID,
                                                        CODICE_LINEA_FCL,
                                                        DIREZIONE,
                                                        CODICE_TRATTA_ROMAN,
                                                        FCLD_RS_ID,
                                                        FCLD_CP_ID,
                                                        PROGR_KM,
                                                        TIPO_PUNTO,
                                                        NOME_PUNTO,
                                                        GRADO_PRESTAZIONE,
                                                        GRADO_FRENATURA,
                                                        GRADO_FRENATURA_SUB,
                                                        RAGGIO_CURVATURA,
                                                        PENDENZA,
                                                        ISTRADAMENTO,
                                                        CANDELIERE_1,
                                                        CANDELIERE_2,
                                                        RALLENTAMENTO,
                                                        SPINTA,
                                                        TUNNEL,
                                                        VMAX_A,
                                                        VMAX_B,
                                                        VMAX_C,
                                                        VMAX_P,
                                                        RIDVEL_A,
                                                        RIDVEL_B,
                                                        RIDVEL_C,
                                                        RIDVEL_P,
                                                        NOTA,
                                                        RICH_NORME,
                                                        BANALIZZATO,
                                                        DCM_DU_ID,
                                                        DCM_TIMESTAMP,
                                                        DCI_DU_ID,
                                                        DCI_TIMESTAMP,
                                                        RST_DU_ID,
                                                        RST_TIMESTAMP,
                                                        KM_FITTIZIA,
                                                        SCMT,
                                                        TB_ID,
                                                        SSC)
   SELECT FCLD_ID,
          FCLD_FCL_ID,
          FCLD_TRCK_ID,
          FCLD_TRSC_ID,
          FCLD_RS_ID,
          FCLD_CP_ID,
          FCLD_PROGR_KM,
          FCLD_TIPO_PUNTO,
          FCLD_SNAME,
          FCLD_GRADO_PRESTAZIONE,
          FCLD_GRADO_FRENATURA,
          FCLD_GRADO_FRENATURA_SUB,
          FCLD_RAGGIO_CURVATURA,
          FCLD_PENDENZA,
          FCLD_ISTRADAMENTO,
          FCLD_CANDELIERE_1,
          FCLD_CANDELIERE_2,
          FCLD_RALLENTAMENTO,
          FCLD_SPINTA,
          FCLD_TUNNEL,
          FCLD_VMAX_A,
          FCLD_VMAX_B,
          FCLD_VMAX_C,
          FCLD_VMAX_P,
          FCLD_RIDVEL_A,
          FCLD_RIDVEL_B,
          FCLD_RIDVEL_C,
          FCLD_RIDVEL_P,
          FCLD_NOTA,
          FCLD_RICH_NORME,
          FCLD_BANALIZZATO,
          FCLD_DCM_DU_ID,
          FCLD_DCM_TIMESTAMP,
          FCLD_DCI_DU_ID,
          FCLD_DCI_TIMESTAMP,
          FCLD_RST_DU_ID,
          FCLD_RST_TIMESTAMP,
          FCLD_KM_FITTIZIA,
          FCLD_SCMT,
          FCLD_TB_ID,
          FCLD_SSC
     FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_DATI d,
          RINF_ANAGRAFICHE_EVO.LINEA_FCL_TRATTE_ROMAN l --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
    WHERE     l.CODICE_LINEA_FCL = d.FCLD_FCL_ID
          AND l.CODICE_TRATTA_ROMAN = d.FCLD_TRSC_ID
          AND FCLD_ID IN
                 (SELECT FCLD_ID FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_DATI
                  MINUS
                  SELECT FCLD_ID
                    FROM RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN);


UPDATE RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN
   SET DATA_SCADENZA = data_riferimento
 WHERE FCLD_ID IN
          (SELECT FCLD_ID FROM RINF_ANAGRAFICHE_EVO.LINEE_FCL_DATI_ROMAN
           MINUS
           SELECT FCLD_ID FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_DATI);


--inserimento valori ANAG_FASCICOLO_LINEE

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE o
   SET (CODICE_FASCICOLO_INVERSO,
        DEFINIZIONE,
        CODICE_DTP,
        FLAG_DISPARI,
        FASCICOLO_LINEA,
        DATA_MODIFICA,
        DATA_SCADENZA) =
          (SELECT FCLAG_INV_FCLAG_ID,
                  FCLAG_SNAME,
                  FCLAG_DIST_ID,
                  FCLAG_DISPARI,
                  FCLAG_FL,
                  FCLAG_TIMESTAMP,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR n
            WHERE FCLAG_DISPARI = 1 AND n.FCLAG_ID = o.CODICE_FASCICOLO
           UNION
           SELECT p.FCLAG_INV_FCLAG_ID,
                  p.FCLAG_SNAME,
                  p.FCLAG_DIST_ID,
                  p.FCLAG_DISPARI,
                  d.FCLAG_FL,
                  p.FCLAG_TIMESTAMP,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR p,
                  RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR d
            WHERE     p.FCLAG_ID = o.CODICE_FASCICOLO
                  AND p.FCLAG_DISPARI = 0
                  AND d.FCLAG_DISPARI = 1
                  AND p.FCLAG_INV_FCLAG_ID = d.FCLAG_ID)
 WHERE CODICE_FASCICOLO IN
          (SELECT FCLAG_ID
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR n
            WHERE FCLAG_DISPARI = 1
           UNION
           SELECT p.FCLAG_ID
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR p,
                  RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR d
            WHERE     p.FCLAG_DISPARI = 0
                  AND d.FCLAG_DISPARI = 1
                  AND p.FCLAG_INV_FCLAG_ID = d.FCLAG_ID);

INSERT INTO RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE (
               CODICE_FASCICOLO,
               CODICE_FASCICOLO_INVERSO,
               DEFINIZIONE,
               CODICE_DTP,
               FLAG_DISPARI,
               FASCICOLO_LINEA,
               DATA_MODIFICA)
   SELECT FCLAG_ID,
          FCLAG_INV_FCLAG_ID,
          FCLAG_SNAME,
          FCLAG_DIST_ID,
          FCLAG_DISPARI,
          FCLAG_FL,
          FCLAG_TIMESTAMP
     FROM (SELECT FCLAG_ID,
                  FCLAG_INV_FCLAG_ID,
                  FCLAG_SNAME,
                  FCLAG_DIST_ID,
                  FCLAG_DISPARI,
                  FCLAG_FL,
                  FCLAG_TIMESTAMP
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR
            WHERE FCLAG_DISPARI = 1
           UNION
           SELECT p.FCLAG_ID,
                  p.FCLAG_INV_FCLAG_ID,
                  p.FCLAG_SNAME,
                  p.FCLAG_DIST_ID,
                  p.FCLAG_DISPARI,
                  d.FCLAG_FL,
                  p.FCLAG_TIMESTAMP
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR p,
                  RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR d
            WHERE     p.FCLAG_DISPARI = 0
                  AND d.FCLAG_DISPARI = 1
                  AND p.FCLAG_INV_FCLAG_ID = d.FCLAG_ID)
    WHERE FCLAG_ID IN
             (SELECT FCLAG_ID FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR
              MINUS
              SELECT CODICE_FASCICOLO
                FROM RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE);

UPDATE RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE
   SET DATA_SCADENZA = data_riferimento
 WHERE CODICE_FASCICOLO IN
          (SELECT CODICE_FASCICOLO
             FROM RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE
           MINUS
           SELECT FCLAG_ID FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR);

--FASCICOLO_LINEE_FCL

UPDATE RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL o
   SET (CODICE_LINEA_FCL_PADRE,
        DATA_MODIFICA,
        PROG_LINEA,
        DATA_SCADENZA) =
          (SELECT FCLAGD_PADRE_FCL_ID,
                  FCLAGD_TIMESTAMP,
                  FCLAGD_IX,
                  NULL
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR_DETT n
            WHERE     O.CODICE_FASCICOLO = N.FCLAGD_FCLAG_ID
                  AND o.CODICE_LINEA_FCL = n.FCLAGD_FCL_ID)
 WHERE (CODICE_FASCICOLO, CODICE_LINEA_FCL) IN
          (SELECT FCLAGD_FCLAG_ID, FCLAGD_FCL_ID
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR_DETT);

INSERT INTO RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL (
               CODICE_FASCICOLO,
               CODICE_LINEA_FCL,
               CODICE_LINEA_FCL_PADRE,
               DATA_MODIFICA,
               PROG_LINEA)
   SELECT FCLAGD_FCLAG_ID,
          FCLAGD_FCL_ID,
          FCLAGD_PADRE_FCL_ID,
          FCLAGD_TIMESTAMP,
          FCLAGD_IX
     FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR_DETT d,
          RINF_ANAGRAFICHE_EVO.ANAG_LINEA_FCL l,
          RINF_ANAGRAFICHE_EVO.ANAG_FASCICOLO_LINEE f --10/02/2016 Aggiunta join per rendere pi� robusto il codice, per garantire l'integrazione referenziale
    WHERE     d.FCLAGD_FCL_ID = l.CODICE_LINEA_FCL
          AND d.FCLAGD_FCLAG_ID = F.CODICE_FASCICOLO
          AND (FCLAGD_FCLAG_ID, FCLAGD_FCL_ID) IN
                 (SELECT FCLAGD_FCLAG_ID, FCLAGD_FCL_ID
                    FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR_DETT
                  MINUS
                  SELECT CODICE_FASCICOLO, CODICE_LINEA_FCL
                    FROM RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL);

UPDATE RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL
   SET DATA_SCADENZA = data_riferimento
 WHERE (CODICE_FASCICOLO, CODICE_LINEA_FCL) IN
          (SELECT CODICE_FASCICOLO, CODICE_LINEA_FCL
             FROM RINF_ANAGRAFICHE_EVO.FASCICOLO_LINEE_FCL
           MINUS
           SELECT FCLAGD_FCLAG_ID, FCLAGD_FCL_ID
             FROM RINF_STAGING_EVO.ROMAN_FS_LINEE_FCL_AGGR_DETT);
EXCEPTION
WHEN OTHERS THEN
p_error:=SQLCODE;
DBMS_OUTPUT.PUT_LINE ('Errore SetRomanAcquisition' || SUBSTR (SQLERRM, 1, 300));
END  SetRomanAcquisition;
PROCEDURE SetINEAnagrafiche (data_riferimento DATE, p_error OUT NUMBER) IS
BEGIN
p_error:=0;
--ANAG_DTP
Update RINF_ANAGRAFICHE_EVO.ANAG_DTP o
Set
(DESCRIZIONE, DATA_SCADENZA)=
(select DEFINIZIONE, null from RINF_STAGING_EVO.ANAG_DTP n
where
o.codice_dtp=TRIM(n.codice_dtp))
where
codice_dtp in (select TRIM(codice_dtp) from RINF_STAGING_EVO.ANAG_DTP);

Insert into RINF_ANAGRAFICHE_EVO.ANAG_DTP (CODICE_DTP, DESCRIZIONE)
select TRIM(codice_dtp), DEFINIZIONE from RINF_STAGING_EVO.ANAG_DTP
where
TRIM(codice_dtp) in
(select TRIM(codice_dtp) from RINF_STAGING_EVO.ANAG_DTP
minus
select codice_dtp from RINF_ANAGRAFICHE_EVO.ANAG_DTP) and
TRIM(codice_dtp)<>'DG00';

update RINF_ANAGRAFICHE_EVO.ANAG_DTP
set
DATA_SCADENZA=data_riferimento
where
CODICE_DTP<>'-1' and
CODICE_DTP IN
(select codice_dtp from RINF_ANAGRAFICHE_EVO.ANAG_DTP
MINUS
select TRIM(codice_dtp) from RINF_STAGING_EVO.ANAG_DTP);

--ANAG_UT
Update RINF_ANAGRAFICHE_EVO.ANAG_UT o
Set
(CODICE_DTP, DESCRIZIONE, DATA_SCADENZA)=
(select TRIM(CODICE_DTP),DEFINIZIONE, null from RINF_STAGING_EVO.ANAG_UT n
where
o.codice_ut=TRIM(n.codice_ut))
where
codice_ut in (select TRIM(codice_ut) from RINF_STAGING_EVO.ANAG_UT);

Insert into RINF_ANAGRAFICHE_EVO.ANAG_UT (CODICE_UT, CODICE_DTP, DESCRIZIONE)
select TRIM(codice_ut), TRIM(CODICE_DTP), DEFINIZIONE from RINF_STAGING_EVO.ANAG_UT
where
TRIM(codice_ut) in
(select TRIM(codice_ut) from RINF_STAGING_EVO.ANAG_UT
minus
select codice_ut from RINF_ANAGRAFICHE_EVO.ANAG_UT) and
TRIM(codice_dtp)<>'DG00';

update RINF_ANAGRAFICHE_EVO.ANAG_UT
set
DATA_SCADENZA=data_riferimento
where
CODICE_UT<>'-1' and
CODICE_UT IN
(select codice_ut from RINF_ANAGRAFICHE_EVO.ANAG_UT
MINUS
select TRIM(codice_ut) from RINF_STAGING_EVO.ANAG_UT);

--ANAG_LINEA_TECNICA
Update RINF_ANAGRAFICHE_EVO.ANAG_LINEA_TECNICA o
Set
(DESCRIZIONE, DATA_SCADENZA)=
(select DEFINIZIONE, null from RINF_STAGING_EVO.ANAG_LINEA_TECNICA n
where
o.LT_ID=TRIM(n.CODICE_LINEA))
where
LT_ID in (select TRIM(CODICE_LINEA) from RINF_STAGING_EVO.ANAG_LINEA_TECNICA);

Insert into RINF_ANAGRAFICHE_EVO.ANAG_LINEA_TECNICA (LT_ID, DESCRIZIONE)
select TRIM(CODICE_LINEA), DEFINIZIONE from RINF_STAGING_EVO.ANAG_LINEA_TECNICA
where
TRIM(CODICE_LINEA) in
(select TRIM(CODICE_LINEA) from RINF_STAGING_EVO.ANAG_LINEA_TECNICA
minus
select LT_ID from RINF_ANAGRAFICHE_EVO.ANAG_LINEA_TECNICA);

update RINF_ANAGRAFICHE_EVO.ANAG_LINEA_TECNICA
set
DATA_SCADENZA=data_riferimento
where
LT_ID IN
(select LT_ID from RINF_ANAGRAFICHE_EVO.ANAG_LINEA_TECNICA
MINUS
select TRIM(CODICE_LINEA) from RINF_STAGING_EVO.ANAG_LINEA_TECNICA);

--NETWORK_OGGETTI
DELETE FROM RINF_ANAGRAFICHE_EVO.NETWORK_OGGETTI;


INSERT INTO RINF_ANAGRAFICHE_EVO.NETWORK_OGGETTI (COLLEGAMENTO,
                                              ID_NETWORK,
                                              DESC_NETWORK,
                                              COLL_DA_SEDE_TECNICA,
                                              COLL_DA_DESC,
                                              COLL_VERSO_SEDE_TECNICA,
                                              COLL_VERSO_DESC,
                                              OGGETTO_COLLEGAMENTO,
                                              LUNGHEZZA_TRATTA,
                                              OGGETTO_COLLEGAMENTO_DESC,
                                              NUMERO,
                                              TIPO_COLLEGAMENTO,
                                              TIPO_RELAZIONE,
                                              INIZIO_VALIDITA,
                                              FINE_VALIDITA)
   SELECT COLLEGAMENTO,
          ID_NETWORK,
          DESC_NETWORK,
          COLL_DA_SEDE_TECNICA,
          COLL_DA_DESC,
          COLL_VERSO_SEDE_TECNICA,
          COLL_VERSO_DESC,
          OGGETTO_COLLEGAMENTO,
          LUNGHEZZA_TRATTA,
          OGGETTO_COLLEGAMENTO_DESC,
          NUMERO,
          TIPO_COLLEGAMENTO,
          TIPO_RELAZIONE,
          INIZIO_VALIDITA,
          FINE_VALIDITA
     FROM RINF_STAGING_EVO.NETWORK_OGGETTI;
     EXCEPTION
    WHEN OTHERS THEN
    p_error:=SQLCODE;
    DBMS_OUTPUT.PUT_LINE ('Errore SetINEAnagrafiche' || SUBSTR (SQLERRM, 1, 300));
END SetINEAnagrafiche;


PROCEDURE SetGISAcquisition (p_error OUT NUMBER)
IS
   conta   NUMBER;
BEGIN
   --30/08/2016 procedura aggiunta per automatizzare l'acquisizione dei dati GIS

   p_error := 0;

   -- 13/10/2016 Aggiunto controllo per evitare di svuotare le tabelle del MDR GIS nel caso non siano presenti
   -- dati nell'area di Staging

   SELECT COUNT (*) INTO conta FROM RINF_STAGING_EVO.GIS_TRAT_RETE;

   IF conta > 0
   THEN
   --09/11/2017 Procedura modificata per storicizzazione MDR GIS
   INSERT INTO RINF_GIS_EVO.ANAG_MDR
   select codice,data_mdr_gis
   FROM
   (select NVL(max(VERSIONE_MDR),0)+1 codice from RINF_GIS_EVO.ANAG_MDR),
   (SELECT MAX (LO_ALLINEAMENTO_INRETE) data_mdr_gis
        FROM RINF_STAGING_EVO.GIS_LOCA_RETE);


   select max(VERSIONE_MDR) into conta from RINF_GIS_EVO.ANAG_MDR;

-- 01/08/2018 Il modello va storicizzato, i dati vanno in accodamento

--      DELETE FROM RINF_GIS_EVO.TRAT_RETE;
--
--      DELETE FROM RINF_GIS_EVO.LOCA_RETE;

      --GIS_LOCA_RETE


      INSERT INTO RINF_GIS_EVO.LOCA_RETE (
                     OR_ID,
                     LO_INDEXFIELD,
                     LO_REGIONE,
                     LO_DESCRIZIONE,
                     LO_DISMESSA,
                     LO_DATADISMISS,
                     LO_NOTE,
                     GEOMETRY,
                     LO_DATACREAZIONE,
                     LO_DATAAGGIORNAMENTO,
                     LO_FONTE,
                     LO_AUTORE,
                     LO_STATO,
                     PROVINCID,
                     COMUNEID,
                     LO_STATOUTENTE,
                     LO_DATACREAZIONE_INRETE,
                     LO_DATAAGGIORNAMENTO_INRETE,
                     LO_ALLINEAMENTO_INRETE,
                     VERSIONE_MDR)
         SELECT OR_ID,
                LO_INDEXFIELD,
                LO_REGIONE,
                LO_DESCRIZIONE,
                LO_DISMESSA,
                LO_DATADISMISS,
                LO_NOTE,
                GEOMETRY,
                LO_DATACREAZIONE,
                LO_DATAAGGIORNAMENTO,
                LO_FONTE,
                LO_AUTORE,
                LO_STATO,
                PROVINCID,
                COMUNEID,
                LO_STATOUTENTE,
                LO_DATACREAZIONE_INRETE,
                LO_DATAAGGIORNAMENTO_INRETE,
                LO_ALLINEAMENTO_INRETE,
                conta
           FROM RINF_STAGING_EVO.GIS_LOCA_RETE;

      --GIS_TRAT_RETE



      INSERT INTO RINF_GIS_EVO.TRAT_RETE (
                     OR_ID,
                     LA_ID,
                     TR_INDEXFIELD,
                     LB_ID,
                     LT_ID,
                     TR_ORIG,
                     TR_DEST,
                     TR_DESCRIZIONE,
                     TR_SAPPROGIN,
                     TR_SAPPROGOUT,
                     TR_CONCORDE,
                     TR_LUNGHGEOM,
                     TR_BINARIOSEMPL,
                     TR_DISMESSA,
                     TR_DATADISMISS,
                     TR_NOTE,
                     GEOMETRY,
                     TR_DATACREAZIONE,
                     TR_DATAAGGIORNAMENTO,
                     TR_FONTE,
                     TR_AUTORE,
                     TR_STATO,
                     TR_STATOUTENTE,
                     TR_DATACREAZIONE_INRETE,
                     TR_DATAAGGIORNAMENTO_INRETE,
                     TR_TAU,
                     TR_PROG_IN,
                     TR_PROG_OUT,
                     PROG,
                     TR_NUMBIN,
                     TR_ALLINEAMENTO_INRETE,
                     VERSIONE_MDR)
         SELECT OR_ID,
                LA_ID,
                TR_INDEXFIELD,
                LB_ID,
                LT_ID,
                TR_ORIG,
                TR_DEST,
                TR_DESCRIZIONE,
                TR_SAPPROGIN,
                TR_SAPPROGOUT,
                TR_CONCORDE,
                TR_LUNGHGEOM,
                TR_BINARIOSEMPL,
                TR_DISMESSA,
                TR_DATADISMISS,
                TR_NOTE,
                GEOMETRY,
                TR_DATACREAZIONE,
                TR_DATAAGGIORNAMENTO,
                TR_FONTE,
                TR_AUTORE,
                TR_STATO,
                TR_STATOUTENTE,
                TR_DATACREAZIONE_INRETE,
                TR_DATAAGGIORNAMENTO_INRETE,
                TR_TAU,
                TR_PROG_IN,
                TR_PROG_OUT,
                PROG,
                TR_NUMBIN,
                TR_ALLINEAMENTO_INRETE,
                conta
           FROM RINF_STAGING_EVO.GIS_TRAT_RETE;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
      DBMS_OUTPUT.PUT_LINE (
         'Errore SetGISAcquisition' || SUBSTR (SQLERRM, 1, 300));
END SetGISAcquisition;

PROCEDURE SetPulisciSOL_TK_PROFILE (n_caricamento          NUMBER,
                                    n_acquisizione          NUMBER,
                                    data_caricamento       DATE,
                                    data_scarico           DATE,
                                    p_error            OUT NUMBER)
IS
   --Questa procedura elimina i record delle livellette con chiave duplicata
   --per evitare che si verificano errori con conseguente mancato caricamento delle SOL
   TYPE grad_ogg_rt IS RECORD
   (
      id_binario   RINF_STAGING_EVO.CLASSE_S23300.IDENTIFICATIVO_BINARIO%TYPE,
      km_inizio    RINF_STAGING_EVO.CLASSE_S23300.KM_INIZIO%TYPE,
      km_fine      RINF_STAGING_EVO.CLASSE_S23300.KM_FINE%TYPE,
      pendenza     RINF_STAGING_EVO.CLASSE_S23300.PENDENZA%TYPE
   );

   TYPE grad_ogg_t IS TABLE OF grad_ogg_rt;

   l_grad_ogg   grad_ogg_t;
   n_conta NUMBER;

BEGIN
    p_error:=0;
   nome_file :=
         'PulisciLivellette_'
      || TO_CHAR (n_caricamento)
      || '_'
      || TO_CHAR (data_caricamento, 'DDMMYYYY')
      || '.log';
   id_file :=
      PKG_RINF_UTILITY.SETFILELOG (nome_file, 'RINF_DIR', data_caricamento);

   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         'Acquisizione dati Profilo di Gradiente, relativi al caricamento numero '
      || TO_CHAR (n_caricamento)
      || ' del '
      || TO_CHAR (data_caricamento, 'DD/MM/YYYY')
      || ' scarico dati del '
      || TO_CHAR (data_scarico, 'DD/MM/YYYY'));
   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');


    SELECT COUNT(*) INTO n_conta
       FROM RINF_STAGING_EVO.CLASSE_S23300;

       PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Conteggio oggetti presenti nell''area di Staging: '||n_conta);

   DELETE FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA;

   INSERT INTO RINF_STAGING_EVO.CLASSE_S23300_PULITA
      SELECT * FROM RINF_STAGING_EVO.CLASSE_S23300;

     SELECT IDENTIFICATIVO_BINARIO,
            KM_INIZIO,
            KM_FINE,
            PENDENZA
       BULK COLLECT INTO l_grad_ogg
       FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA a
      WHERE ROWID >
               (SELECT MIN (ROWID)
                  FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA b
                 WHERE     b.IDENTIFICATIVO_BINARIO = a.IDENTIFICATIVO_BINARIO
                       AND b.KM_INIZIO = a.KM_INIZIO
                       AND b.KM_FINE = a.KM_FINE
                       AND b.PENDENZA = a.PENDENZA)
   ORDER BY 1, 2;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');
   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
      '--------------------------------> ' || 'Livellette duplicate');

   FOR i IN 1 .. l_grad_ogg.COUNT
   LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            'Binario: '
         || l_grad_ogg (i).id_binario
         || ' Km inizio: '
         || RPAD(l_grad_ogg (i).km_inizio,10,' ')
         || ' Km fine: '
         || RPAD(l_grad_ogg (i).km_fine,10,' ')
         || ' Pendenza: '
         || l_grad_ogg (i).pendenza);
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   DELETE FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA a
         WHERE ROWID >
                  (SELECT MIN (ROWID)
                     FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA b
                    WHERE     b.IDENTIFICATIVO_BINARIO =
                                 a.IDENTIFICATIVO_BINARIO
                          AND b.KM_INIZIO = a.KM_INIZIO
                          AND b.KM_FINE = a.KM_FINE
                          AND b.PENDENZA = a.PENDENZA);

     SELECT IDENTIFICATIVO_BINARIO,
            KM_INIZIO,
            KM_FINE,
            PENDENZA
       BULK COLLECT INTO l_grad_ogg
       FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA
      WHERE (IDENTIFICATIVO_BINARIO, KM_INIZIO) IN
               (  SELECT IDENTIFICATIVO_BINARIO, KM_INIZIO
                    FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA
                GROUP BY IDENTIFICATIVO_BINARIO, KM_INIZIO
                  HAVING COUNT (*) > 1)
   ORDER BY 1, 2;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');
   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Livellette con chilometrica iniziale duplicata');

   FOR i IN 1 .. l_grad_ogg.COUNT
   LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            'Binario: '
         || l_grad_ogg (i).id_binario
         || ' Km inizio: '
         || RPAD(l_grad_ogg (i).km_inizio,10,' ')
         || ' Km fine: '
         || RPAD(l_grad_ogg (i).km_fine,10,' ')
         || ' Pendenza: '
         || l_grad_ogg (i).pendenza);
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   DELETE FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA
         WHERE (IDENTIFICATIVO_BINARIO, KM_INIZIO) IN
                  (  SELECT IDENTIFICATIVO_BINARIO, KM_INIZIO
                       FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA
                   GROUP BY IDENTIFICATIVO_BINARIO, KM_INIZIO
                     HAVING COUNT (*) > 1);

     SELECT IDENTIFICATIVO_BINARIO,
            KM_INIZIO,
            KM_FINE,
            PENDENZA
       BULK COLLECT INTO l_grad_ogg
       FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA
      WHERE KM_INIZIO IS NULL OR KM_FINE IS  NULL
   ORDER BY 1, 2;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');
   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Livellette con chilometriche iniziale o finale mancante');

   FOR i IN 1 .. l_grad_ogg.COUNT
   LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            'Binario: '
         || l_grad_ogg (i).id_binario
         || ' Km inizio: '
         || RPAD(l_grad_ogg (i).km_inizio,10,' ')
         || ' Km fine: '
         || RPAD(l_grad_ogg (i).km_fine,10,' ')
         || ' Pendenza: '
         || l_grad_ogg (i).pendenza);
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   DELETE FROM RINF_STAGING_EVO.CLASSE_S23300_PULITA
         WHERE KM_INIZIO IS NULL OR KM_FINE IS  NULL; --02/12/2016 Bug segnalato mail Schillaci, eliminato NOT nella condizione del KM_FINE

         UTL_FILE.FCLOSE (id_file);
                  PKG_RINF_SECUREFILE_V082.PUTLOGOFACQUISITION (
                     n_acquisizione,
                     3,
                     'log',
                     nome_file);
                  UTL_FILE.FREMOVE ('RINF_DIR', nome_file);
EXCEPTION
         WHEN OTHERS
         THEN     p_error:=SQLCODE;
    DBMS_OUTPUT.PUT_LINE ('Errore SetPulisciSOL_TK_PROFILE' || SUBSTR (SQLERRM, 1, 300));
END SetPulisciSOL_TK_PROFILE;
PROCEDURE SetPulisciOP_TRACK_PLATF(n_caricamento          NUMBER,
                                    n_acquisizione          NUMBER,
                                    data_caricamento       DATE,
                                    data_scarico           DATE,
                                    p_error            OUT NUMBER)
IS

   -- Questa procedura elimina i dati dei binari non di corsa dei marciapiedi
   -- per evitare che si verificano errori di chiave esterna nel cariamento dei marciapiedi
   -- con conseguente mancato caricamento delle OP
    TYPE plat_ogg_rt IS RECORD
   (
      id_marciapiede   RINF_STAGING_EVO.CLASSE_R24700.PO_TR_PLATFORM_1_2_1_0_6_2%TYPE,
      des_marciapiede    RINF_STAGING_EVO.CLASSE_R24700.PO_TR_PLATFORM_1_2_1_0_6_2_D%TYPE,
      id_binario_1      VARCHAR2(30),
      id_binario_2      VARCHAR2(30),
      id_binario_3      VARCHAR2(30),
      id_binario_4      VARCHAR2(30)
   );

   TYPE plat_ogg_t IS TABLE OF plat_ogg_rt;

   l_plat_ogg   plat_ogg_t;
   n_conta NUMBER;

BEGIN
    p_error:=0;
   nome_file :=
         'PulisciMarciapiedi_'
      || TO_CHAR (n_caricamento)
      || '_'
      || TO_CHAR (data_caricamento, 'DDMMYYYY')
      || '.log';
   id_file :=
      PKG_RINF_UTILITY.SETFILELOG (nome_file, 'RINF_DIR', data_caricamento);

   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         'Acquisizione dati Marciapiedi, relativi al caricamento numero '
      || TO_CHAR (n_caricamento)
      || ' del '
      || TO_CHAR (data_caricamento, 'DD/MM/YYYY')
      || ' scarico dati del '
      || TO_CHAR (data_scarico, 'DD/MM/YYYY'));
   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');


    SELECT COUNT(*) INTO n_conta
       FROM RINF_STAGING_EVO.CLASSE_R24700;

       PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Conteggio oggetti presenti nell''area di Staging: '||n_conta);

    PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   DELETE FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA;
   INSERT INTO RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SELECT * FROM RINF_STAGING_EVO.CLASSE_R24700;


---Eliminzione binari non presenti nell'anagrafica dei binari di corsa PO


  SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
    BULK COLLECT INTO l_plat_ogg
    FROM (SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
                 PO_TR_PLATFORM_1_2_1_0_6_2_D,
                 ' * '||BINARIO_1 BINARIO_1,
                 BINARIO_2,
                 BINARIO_3,
                 BINARIO_4
            FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
           WHERE BINARIO_1 IN
                    (SELECT BINARIO_1
                       FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
                     MINUS
                     SELECT PO_TRACK_1_2_1_0_0_2
                       FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO)
          UNION
          SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
                 PO_TR_PLATFORM_1_2_1_0_6_2_D,
                 BINARIO_1,
                 ' * '||BINARIO_2 BINARIO_2,
                 BINARIO_3,
                 BINARIO_4
            FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
           WHERE BINARIO_2 IN
                    (SELECT BINARIO_2
                       FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
                     MINUS
                     SELECT PO_TRACK_1_2_1_0_0_2
                       FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO)
          UNION
          SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
                 PO_TR_PLATFORM_1_2_1_0_6_2_D,
                 BINARIO_1,
                 BINARIO_2,
                 ' * '||BINARIO_3 BINARIO_3,
                 BINARIO_4
            FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
           WHERE BINARIO_3 IN
                    (SELECT BINARIO_3
                       FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
                     MINUS
                     SELECT PO_TRACK_1_2_1_0_0_2
                       FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO)
          UNION
          SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
                 PO_TR_PLATFORM_1_2_1_0_6_2_D,
                 BINARIO_1,
                 BINARIO_2,
                 BINARIO_3,
                 ' * '||BINARIO_4 BINARIO_4
            FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
           WHERE BINARIO_4 IN
                    (SELECT BINARIO_4
                       FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
                     MINUS
                     SELECT PO_TRACK_1_2_1_0_0_2
                       FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO))
ORDER BY 1, 2;

PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Marciapiedi con binari non presenti nei binari di corsa PO (Con * il binario errato)');

FOR i IN 1 .. l_plat_ogg.COUNT
   LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            'Marciapiede: '
         || l_plat_ogg (i).id_marciapiede
         || ' Definizione: '
         || RPAD(l_plat_ogg (i).des_marciapiede,60,' ')
         || ' Binario 1: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_1,' '),20,' ')
         || ' Binario 2: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_2,' '),20,' ')
         || ' Binario 3: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_3,' '),20,' ')
         || ' Binario 4: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_4,' '),20,' '));
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_1=NULL
   WHERE
   BINARIO_1 IN
   (select BINARIO_1 FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
   MINUS
   select PO_TRACK_1_2_1_0_0_2 FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO);

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_2=NULL
   WHERE
   BINARIO_2 IN
   (select BINARIO_2 FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
   MINUS
   select PO_TRACK_1_2_1_0_0_2 FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO);

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_3=NULL
   WHERE
   BINARIO_3 IN
   (select BINARIO_3 FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
   MINUS
   select PO_TRACK_1_2_1_0_0_2 FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO);

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_4=NULL
   WHERE
   BINARIO_4 IN
   (select BINARIO_4 FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
   MINUS
   select PO_TRACK_1_2_1_0_0_2 FROM RINF_LAVORAZIONE_EVO.BINARI_CORSA_PO);

   ---Elimino l'attribuzione pi� volte allo stesso binario

   SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
    BULK COLLECT INTO l_plat_ogg
    FROM (SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
         FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
         WHERE
   BINARIO_1 =BINARIO_2
   UNION
   SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
         FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
         WHERE
   BINARIO_1 =BINARIO_3
   UNION
   SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
         FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
         WHERE
   BINARIO_2 =BINARIO_3
   UNION
   SELECT PO_TR_PLATFORM_1_2_1_0_6_2,
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
         FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
         WHERE
   BINARIO_3 =BINARIO_4
   UNION                                            --aggiunto Alessio: mancavano alcune associazioni per la pulizia dei binari ripetuti (mail di errori Autiero 27/10/2016)
    SELECT PO_TR_PLATFORM_1_2_1_0_6_2,  --mancava questa
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
         FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
         WHERE
   BINARIO_2 =BINARIO_4
   UNION
    SELECT PO_TR_PLATFORM_1_2_1_0_6_2,      --e mancava anche questa anche se non era mai capitato il caso
         PO_TR_PLATFORM_1_2_1_0_6_2_D,
         BINARIO_1,
         BINARIO_2,
         BINARIO_3,
         BINARIO_4
         FROM RINF_STAGING_EVO.CLASSE_R24700_PULITA
         WHERE
   BINARIO_1 =BINARIO_4)
ORDER BY 1, 2;

PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Marciapiedi con duplicazione del binario associato');

FOR i IN 1 .. l_plat_ogg.COUNT
   LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            'Marciapiede: '
         || l_plat_ogg (i).id_marciapiede
         || ' Definizione: '
         || RPAD(l_plat_ogg (i).des_marciapiede,60,' ')
         || ' Binario 1: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_1,' '),20,' ')
         || ' Binario 2: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_2,' '),20,' ')
         || ' Binario 3: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_3,' '),20,' ')
         || ' Binario 4: '
         || RPAD(NVL(l_plat_ogg (i).id_binario_4,' '),20,' '));
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_2=NULL
   WHERE
   BINARIO_1 =BINARIO_2;

    UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_3=NULL
   WHERE
   BINARIO_1 =BINARIO_3;

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_3=NULL
   WHERE
   BINARIO_2 =BINARIO_3;

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET BINARIO_4=NULL
   WHERE
   BINARIO_3 =BINARIO_4;



   ---Shifting dei codici dei binari

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET
   BINARIO_1=BINARIO_2,
   BINARIO_2=NULL
   WHERE
   BINARIO_1 IS NULL AND BINARIO_2 IS NOT NULL;

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET
   BINARIO_1=BINARIO_3,
   BINARIO_3=NULL
   WHERE
   BINARIO_1 IS NULL AND BINARIO_3 IS NOT NULL;

   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET
   BINARIO_2=BINARIO_3,
   BINARIO_3=NULL
   WHERE
   BINARIO_1 IS NOT NULL AND BINARIO_2 IS NULL AND BINARIO_3 IS NOT NULL;


   UPDATE RINF_STAGING_EVO.CLASSE_R24700_PULITA
   SET
   BINARIO_3=BINARIO_4,
   BINARIO_4=NULL
   WHERE
   BINARIO_1 IS NOT NULL AND BINARIO_2 IS NOT NULL AND BINARIO_3 IS  NULL AND BINARIO_4 IS  NOT NULL;

          UTL_FILE.FCLOSE (id_file);
                  PKG_RINF_SECUREFILE_V082.PUTLOGOFACQUISITION (
                     n_acquisizione,
                     4,
                     'log',
                     nome_file);
                  UTL_FILE.FREMOVE ('RINF_DIR', nome_file);
EXCEPTION
         WHEN OTHERS
         THEN     p_error:=SQLCODE;
    DBMS_OUTPUT.PUT_LINE ('Errore SetPulisciOP_TRACK_PLATF' || SUBSTR (SQLERRM, 1, 300));


   END SetPulisciOP_TRACK_PLATF;



PROCEDURE SetBinariFermateLog (n_caricamento          NUMBER,
                               n_acquisizione         NUMBER,
                               data_caricamento       DATE,
                               data_scarico           DATE,
                               p_error            OUT NUMBER)
IS
--Questa procedura elenca i binari di fermata
   TYPE binf_ogg_rt IS RECORD
   (
      id_dtp         RINF_STAGING_EVO.CLASSE_R03000.CODICE_DTP%TYPE,
      id_po          RINF_STAGING_EVO.CLASSE_R03000.SEDE_TECNICA%TYPE,
      des_po         RINF_STAGING_EVO.CLASSE_R03000.DEFINIZIONE%TYPE,
      id_binario_c   VARCHAR2 (20),
      id_binario_f   VARCHAR2 (20)
   );

   TYPE binf_ogg_t IS TABLE OF binf_ogg_rt;

   l_binf_ogg   binf_ogg_t;
   n_conta      NUMBER;
BEGIN
   p_error := 0;
   nome_file :=
         'BinariFermate_'
      || TO_CHAR (n_caricamento)
      || '_'
      || TO_CHAR (data_caricamento, 'DDMMYYYY')
      || '.log';
   id_file :=
      PKG_RINF_UTILITY.SETFILELOG (nome_file, 'RINF_DIR', data_caricamento);

   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         'Acquisizione dati Binari di Fermata, relativi al caricamento numero '
      || TO_CHAR (n_caricamento)
      || ' del '
      || TO_CHAR (data_caricamento, 'DD/MM/YYYY')
      || ' scarico dati del '
      || TO_CHAR (data_scarico, 'DD/MM/YYYY'));
   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');



     SELECT p.codice_dtp,
            p.sede_tecnica,
            p.definizione,
            bc.PO_TRACK_1_2_1_0_0_2,
            bf.PO_TRACK_1_2_1_0_0_2
       BULK COLLECT INTO l_binf_ogg
       FROM RINF_LAVORAZIONE_EVO.PUNTI_OPERATIVI p,
            (SELECT PO_TRACK_1_2_1_0_0_2, SEDE_TECNICA
               FROM RINF_LAVORAZIONE_EVO.REL_PO_BINARI_CORSA rp
              WHERE PO_TRACK_1_2_1_0_0_2 LIKE 'LO%') bc,
            (SELECT PO_TRACK_1_2_1_0_0_2, SEDE_TECNICA
               FROM RINF_LAVORAZIONE_EVO.REL_PO_BINARI_CORSA rp
              WHERE PO_TRACK_1_2_1_0_0_2 LIKE 'TR%') bf
      WHERE     p.sede_tecnica = bc.sede_tecnica
            AND p.sede_tecnica = bf.sede_tecnica
   ORDER BY 1,
            2,
            3,
            4;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');
   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Punti Operativi con binari di corsa e binari di fermata');

   FOR i IN 1 .. l_binf_ogg.COUNT
   LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            l_binf_ogg (i).id_dtp
         || '   '
         || l_binf_ogg (i).id_po
         || '   '
         || RPAD (l_binf_ogg (i).des_po, 40, ' ')
         || ' Binario di Corsa: '
         || RPAD (l_binf_ogg (i).id_binario_c, 20, ' ')
         || ' Binario di Fermata: '
         || RPAD (l_binf_ogg (i).id_binario_f, 20, ' '));
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');



   UTL_FILE.FCLOSE (id_file);
   PKG_RINF_SECUREFILE_V082.PUTLOGOFACQUISITION (n_acquisizione,
                                                 5,
                                                 'log',
                                                 nome_file);
   UTL_FILE.FREMOVE ('RINF_DIR', nome_file);
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
      DBMS_OUTPUT.PUT_LINE (
         'Errore SetBinariFermateLog' || SUBSTR (SQLERRM, 1, 300));
END SetBinariFermateLog;

PROCEDURE SetGallerieLog (n_caricamento          NUMBER,
                          n_acquisizione         NUMBER,
                          data_caricamento       DATE,
                          data_scarico           DATE,
                          p_error            OUT NUMBER)
IS
--Questa procedura elenca le gallerie nnon presenti nella fornitura GIS e quelle senza binari

   TYPE binf_ogg_rt IS RECORD
   (
      tipo                  VARCHAR2 (100),
      id_tunnel             RINF_STAGING_EVO.CLASSE_R25350_LO.PO_TR_TUNNEL_1_2_1_0_5_2%TYPE,
      definizione           RINF_STAGING_EVO.CLASSE_R25350_LO.PO_TR_TUNNEL_1_2_1_0_5_2_D%TYPE,
      classificazione       VARCHAR2 (50),
      galleria_principale   RINF_STAGING_EVO.CLASSE_R25350_LO.PO_TR_TUNNEL_1_2_1_0_5_2%TYPE
   );

   TYPE binf_ogg_t IS TABLE OF binf_ogg_rt;

   l_binf_ogg   binf_ogg_t;
   n_conta      NUMBER;
BEGIN
   p_error := 0;
   nome_file :=
         'Gallerie_'
      || TO_CHAR (n_caricamento)
      || '_'
      || TO_CHAR (data_caricamento, 'DDMMYYYY')
      || '.log';
   id_file :=
      PKG_RINF_UTILITY.SETFILELOG (nome_file, 'RINF_DIR', data_caricamento);

   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         'Acquisizione dati Gallerie, relativi al caricamento numero '
      || TO_CHAR (n_caricamento)
      || ' del '
      || TO_CHAR (data_caricamento, 'DD/MM/YYYY')
      || ' scarico dati del '
      || TO_CHAR (data_scarico, 'DD/MM/YYYY'));
   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

     --Gallerie senza coordinate

     SELECT tipo,
            id_tunnel,
            definizione,
            classificazione,
            galleria_principale
       BULK COLLECT INTO l_binf_ogg
       FROM (SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DEI PO' tipo,
                    PO_TR_TUNNEL_1_2_1_0_5_2 id_tunnel,
                    PO_TR_TUNNEL_1_2_1_0_5_2_D definizione,
                    'PRINCIPALE' classificazione,
                    NULL GALLERIA_PRINCIPALE,
                    CODICE_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO b,
                    (SELECT CODICE_GALLERIA
                       FROM RINF_ANAGRAFICHE_EVO.POSIZIONE_GALLERIE
                     UNION
                     SELECT SOL_TUNNEL_1_1_1_1_8_2
                       FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) g
              WHERE     PO_TR_TUNNEL_1_2_1_0_5_2 = CODICE_GALLERIA(+)
                    AND PO_TR_TUNNEL_1_2_1_0_5_2 IS NOT NULL
                    AND NVL (PO_TR_TUNNEL_1_2_1_0_5_5, 0) >= 100
                    AND (   GALLERIA_PRINCIPALE IS NULL
                         OR GALLERIA_PRINCIPALE = PO_TR_TUNNEL_1_2_1_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DEI PO' tipo,
                    PO_TR_TUNNEL_1_2_1_0_5_2 id_tunnel,
                    PO_TR_TUNNEL_1_2_1_0_5_2_D,
                    'SECONDARIA' classificazione,
                    GALLERIA_PRINCIPALE,
                    CODICE_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO b,
                    (SELECT CODICE_GALLERIA
                       FROM RINF_ANAGRAFICHE_EVO.POSIZIONE_GALLERIE
                     UNION
                     SELECT SOL_TUNNEL_1_1_1_1_8_2
                       FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) g
              WHERE     PO_TR_TUNNEL_1_2_1_0_5_2 = CODICE_GALLERIA(+)
                    AND PO_TR_TUNNEL_1_2_1_0_5_2 IS NOT NULL
                    AND (   GALLERIA_PRINCIPALE IS NOT NULL
                         OR GALLERIA_PRINCIPALE <> PO_TR_TUNNEL_1_2_1_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI SECONDARI DEI PO' tipo,
                    PO_SD_TUNNEL_1_2_2_0_5_2 id_tunnel,
                    PO_SD_TUNNEL_1_2_2_0_5_2_D,
                    'PRINCIPALE' classificazione,
                    NULL GALLERIA_PRINCIPALE,
                    CODICE_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO g,
                    (SELECT CODICE_GALLERIA
                       FROM RINF_ANAGRAFICHE_EVO.POSIZIONE_GALLERIE
                     UNION
                     SELECT SOL_TUNNEL_1_1_1_1_8_2
                       FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) g
              WHERE     PO_SD_TUNNEL_1_2_2_0_5_2 IS NOT NULL
                    AND PO_SD_TUNNEL_1_2_2_0_5_2 = CODICE_GALLERIA(+)
                    AND NVL (PO_SD_TUNNEL_1_2_2_0_5_5, 0) >= 100
                    AND (   GALLERIA_PRINCIPALE IS NULL
                         OR GALLERIA_PRINCIPALE = PO_SD_TUNNEL_1_2_2_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI SECONDARI DEI PO' tipo,
                    PO_SD_TUNNEL_1_2_2_0_5_2 id_tunnel,
                    PO_SD_TUNNEL_1_2_2_0_5_2_D,
                    'SECONDARIA' classificazione,
                    GALLERIA_PRINCIPALE,
                    CODICE_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO g,
                    (SELECT CODICE_GALLERIA
                       FROM RINF_ANAGRAFICHE_EVO.POSIZIONE_GALLERIE
                     UNION
                     SELECT SOL_TUNNEL_1_1_1_1_8_2
                       FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) g
              WHERE     PO_SD_TUNNEL_1_2_2_0_5_2 IS NOT NULL
                    AND PO_SD_TUNNEL_1_2_2_0_5_2 = CODICE_GALLERIA(+)
                    AND (   GALLERIA_PRINCIPALE IS NOT NULL
                         OR GALLERIA_PRINCIPALE <> PO_SD_TUNNEL_1_2_2_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DELLE SdL' tipo,
                    SOL_TUNNEL_1_1_1_1_8_2 id_tunnel,
                    SOL_TUNNEL_1_1_1_1_8_2_D,
                    'PRINCIPALE' classificazione,
                    NULL GALLERIA_PRINCIPALE,
                    CODICE_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_TR b,
                    (SELECT CODICE_GALLERIA
                       FROM RINF_ANAGRAFICHE_EVO.POSIZIONE_GALLERIE
                     UNION
                     SELECT SOL_TUNNEL_1_1_1_1_8_2
                       FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) g
              WHERE     SOL_TUNNEL_1_1_1_1_8_2 = CODICE_GALLERIA(+)
                    AND SOL_TUNNEL_1_1_1_1_8_2 IS NOT NULL
                    AND NVL (SOL_TUNNEL_1_1_1_1_8_7, 0) >= 100
                    AND (   GALLERIA_PRINCIPALE IS NULL
                         OR GALLERIA_PRINCIPALE = SOL_TUNNEL_1_1_1_1_8_2)
             UNION
             SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DELLE SdL' tipo,
                    SOL_TUNNEL_1_1_1_1_8_2 id_tunnel,
                    SOL_TUNNEL_1_1_1_1_8_2_D,
                    'SECONDARIA' classificazione,
                    GALLERIA_PRINCIPALE,
                    CODICE_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_TR b,
                    (SELECT CODICE_GALLERIA
                       FROM RINF_ANAGRAFICHE_EVO.POSIZIONE_GALLERIE
                     UNION
                     SELECT SOL_TUNNEL_1_1_1_1_8_2
                       FROM RINF_ANAGRAFICHE_EVO.GALLERIE_DIRAMATE) g
              WHERE     SOL_TUNNEL_1_1_1_1_8_2 = CODICE_GALLERIA(+)
                    AND SOL_TUNNEL_1_1_1_1_8_7 IS NOT NULL
                    AND (   GALLERIA_PRINCIPALE IS NOT NULL
                         OR GALLERIA_PRINCIPALE <> SOL_TUNNEL_1_1_1_1_8_2))
      WHERE CODICE_GALLERIA IS NULL
   ORDER BY tipo, classificazione, id_tunnel;



   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');
   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Elenco Gallerie prive di coordinate (non presenti nella fornitura GIS)');

      PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   FOR i IN 1 .. l_binf_ogg.COUNT
   LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            RPAD (l_binf_ogg (i).tipo, 50, ' ')
         || '   '
         || l_binf_ogg (i).id_tunnel
         || '   '
         || RPAD (l_binf_ogg (i).definizione, 35, ' ')
         || '  '
         || RPAD (l_binf_ogg (i).classificazione, 20, ' ')
         || ' Galleria Principale:  '
         || CASE
               WHEN l_binf_ogg (i).definizione = 'PRINCIPALE'
               THEN
                  ' - '
               ELSE
                  RPAD (l_binf_ogg (i).galleria_principale, 25, ' ')
            END);
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

     --Gallerie senza binari

     SELECT tipo,
            id_tunnel,
            definizione,
            classificazione,
            GALLERIA_PRINCIPALE
       BULK COLLECT INTO l_binf_ogg
       FROM (SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DEI PO' tipo,
                    PO_TR_TUNNEL_1_2_1_0_5_2 id_tunnel,
                    PO_TR_TUNNEL_1_2_1_0_5_2_D definizione,
                    'PRINCIPALE' classificazione,
                    NULL GALLERIA_PRINCIPALE,
                    IDENTIFICATIVO_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO b,
                    (SELECT DISTINCT IDENTIFICATIVO_GALLERIA
                       FROM RINF_STAGING_EVO.CLASSE_R25350_LO_MULTIPLA b
                      WHERE CODICE_CARATTERISTICA = 'R25350_LO_3010') g
              WHERE     PO_TR_TUNNEL_1_2_1_0_5_2 = IDENTIFICATIVO_GALLERIA(+)
                    AND PO_TR_TUNNEL_1_2_1_0_5_2 IS NOT NULL
                    AND NVL (PO_TR_TUNNEL_1_2_1_0_5_5, 0) >= 100
                    AND (   GALLERIA_PRINCIPALE IS NULL
                         OR GALLERIA_PRINCIPALE = PO_TR_TUNNEL_1_2_1_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DEI PO' tipo,
                    PO_TR_TUNNEL_1_2_1_0_5_2 id_tunnel,
                    PO_TR_TUNNEL_1_2_1_0_5_2_D,
                    'SECONDARIA' classificazione,
                    GALLERIA_PRINCIPALE,
                    IDENTIFICATIVO_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO b,
                    (SELECT DISTINCT IDENTIFICATIVO_GALLERIA
                       FROM RINF_STAGING_EVO.CLASSE_R25350_LO_MULTIPLA b
                      WHERE CODICE_CARATTERISTICA = 'R25350_LO_3010') g
              WHERE     PO_TR_TUNNEL_1_2_1_0_5_2 = IDENTIFICATIVO_GALLERIA(+)
                    AND PO_TR_TUNNEL_1_2_1_0_5_2 IS NOT NULL
                    AND (   GALLERIA_PRINCIPALE IS NOT NULL
                         OR GALLERIA_PRINCIPALE <> PO_TR_TUNNEL_1_2_1_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI SECONDARI DEI PO' tipo,
                    PO_SD_TUNNEL_1_2_2_0_5_2 id_tunnel,
                    PO_SD_TUNNEL_1_2_2_0_5_2_D,
                    'PRINCIPALE' classificazione,
                    NULL GALLERIA_PRINCIPALE,
                    IDENTIFICATIVO_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO g,
                    (SELECT DISTINCT IDENTIFICATIVO_GALLERIA
                       FROM RINF_STAGING_EVO.CLASSE_R25350_LO_MULTIPLA b
                      WHERE CODICE_CARATTERISTICA = 'R25350_LO_3010') g
              WHERE     PO_SD_TUNNEL_1_2_2_0_5_2 IS NOT NULL
                    AND PO_SD_TUNNEL_1_2_2_0_5_2 = IDENTIFICATIVO_GALLERIA(+)
                    AND NVL (PO_SD_TUNNEL_1_2_2_0_5_5, 0) >= 100
                    AND (   GALLERIA_PRINCIPALE IS NULL
                         OR GALLERIA_PRINCIPALE = PO_SD_TUNNEL_1_2_2_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI SECONDARI DEI PO' tipo,
                    PO_SD_TUNNEL_1_2_2_0_5_2 id_tunnel,
                    PO_SD_TUNNEL_1_2_2_0_5_2_D,
                    'SECONDARIA' classificazione,
                    GALLERIA_PRINCIPALE,
                    IDENTIFICATIVO_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_LO g,
                    (SELECT DISTINCT IDENTIFICATIVO_GALLERIA
                       FROM RINF_STAGING_EVO.CLASSE_R25350_LO_MULTIPLA b
                      WHERE CODICE_CARATTERISTICA = 'R25350_LO_3010') g
              WHERE     PO_SD_TUNNEL_1_2_2_0_5_2 IS NOT NULL
                    AND PO_SD_TUNNEL_1_2_2_0_5_2 = IDENTIFICATIVO_GALLERIA(+)
                    AND (   GALLERIA_PRINCIPALE IS NOT NULL
                         OR GALLERIA_PRINCIPALE <> PO_SD_TUNNEL_1_2_2_0_5_2)
             UNION
             SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DELLE SdL' tipo,
                    SOL_TUNNEL_1_1_1_1_8_2 id_tunnel,
                    SOL_TUNNEL_1_1_1_1_8_2_D,
                    'PRINCIPALE' classificazione,
                    NULL GALLERIA_PRINCIPALE,
                    IDENTIFICATIVO_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_TR b,
                    (SELECT DISTINCT IDENTIFICATIVO_GALLERIA
                       FROM RINF_STAGING_EVO.CLASSE_R25350_TR_MULTIPLA b
                      WHERE CODICE_CARATTERISTICA = 'R25350_TR_3010') g
              WHERE     SOL_TUNNEL_1_1_1_1_8_2 = IDENTIFICATIVO_GALLERIA(+)
                    AND SOL_TUNNEL_1_1_1_1_8_2 IS NOT NULL
                    AND NVL (SOL_TUNNEL_1_1_1_1_8_7, 0) >= 100
                    AND (   GALLERIA_PRINCIPALE IS NULL
                         OR GALLERIA_PRINCIPALE = SOL_TUNNEL_1_1_1_1_8_2)
             UNION
             SELECT 'GALLERIA BINARI DI CIRCOLAZIONE DELLE SdL' tipo,
                    SOL_TUNNEL_1_1_1_1_8_2 id_tunnel,
                    SOL_TUNNEL_1_1_1_1_8_2_D,
                    'SECONDARIA' classificazione,
                    GALLERIA_PRINCIPALE,
                    IDENTIFICATIVO_GALLERIA
               FROM RINF_STAGING_EVO.CLASSE_R25350_TR b,
                    (SELECT DISTINCT IDENTIFICATIVO_GALLERIA
                       FROM RINF_STAGING_EVO.CLASSE_R25350_TR_MULTIPLA b
                      WHERE CODICE_CARATTERISTICA = 'R25350_TR_3010') g
              WHERE     SOL_TUNNEL_1_1_1_1_8_2 = IDENTIFICATIVO_GALLERIA(+)
                    AND SOL_TUNNEL_1_1_1_1_8_7 IS NOT NULL
                    AND (   GALLERIA_PRINCIPALE IS NOT NULL
                         OR GALLERIA_PRINCIPALE <> SOL_TUNNEL_1_1_1_1_8_2))
      WHERE IDENTIFICATIVO_GALLERIA IS NULL
   ORDER BY tipo, classificazione, id_tunnel;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');
   PKG_RINF_UTILITY.SETLINEINTOFILE (
      id_file,
         '--------------------------------> '
      || 'Elenco Gallerie non associate ad un binario');

      PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   FOR i IN 1 .. l_binf_ogg.COUNT
      LOOP
      PKG_RINF_UTILITY.SETLINEINTOFILE (
         id_file,
            RPAD (l_binf_ogg (i).tipo, 50, ' ')
         || '   '
         || l_binf_ogg (i).id_tunnel
         || '   '
         || RPAD (l_binf_ogg (i).definizione, 35, ' ')
         || '  '
         || RPAD (l_binf_ogg (i).classificazione, 20, ' ')
         || ' Galleria Principale:  '
         || CASE
               WHEN l_binf_ogg (i).definizione = 'PRINCIPALE'
               THEN
                  ' - '
               ELSE
                  RPAD (l_binf_ogg (i).galleria_principale, 25, ' ')
            END);
   END LOOP;

   PKG_RINF_UTILITY.SETLINEINTOFILE (id_file, ' ');

   UTL_FILE.FCLOSE (id_file);
   PKG_RINF_SECUREFILE_V082.PUTLOGOFACQUISITION (n_acquisizione,
                                                 6,
                                                 'log',
                                                 nome_file);
   UTL_FILE.FREMOVE ('RINF_DIR', nome_file);
EXCEPTION
   WHEN OTHERS
   THEN
      p_error := SQLCODE;
      DBMS_OUTPUT.PUT_LINE (
         'Errore SetGallerieLog' || SUBSTR (SQLERRM, 1, 300));
END SetGallerieLog;

--PROCEDURE GetLogOfAcquisition (p_codice_acquisizione   IN     NUMBER,
--                               p_codice_log            IN     NUMBER,
--                               p_cursor                   OUT empcur)
--IS
--BEGIN
--   OPEN p_cursor FOR
--      SELECT CODICE_ACQUISIZIONE, DOCUMENT
--        FROM DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF
--       WHERE     CODICE_ACQUISIZIONE = p_codice_acquisizione
--             AND CODICE_LOG = p_codice_log;
--END GetLogOfAcquisition;
END PKG_RINF_ACQUISIZIONI;
/