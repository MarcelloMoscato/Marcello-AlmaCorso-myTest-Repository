--
-- PKG_RINF_SECUREFILE_V082  (Package) 
--
CREATE OR REPLACE PACKAGE APPL_RINF_EVO."PKG_RINF_SECUREFILE_V082" AS
/******************************************************************************
   NAME:       PKG_SECUREFILE
   PURPOSE:     Gestione documenti in campi BLOB (securefile)

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/24/2014  D.Campagiorni           1. Created this package.
******************************************************************************/
PROCEDURE PutLogOfAcquisition (
         id_acquisizione      IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_ACQUISIZIONE%TYPE,
         id_tipo_log     IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_LOG%TYPE,
        p_estensione    IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.ESTENSIONE_FILE%TYPE,
        docFileName    IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.FILE_NAME%TYPE
    );
PROCEDURE PutLogOfLoading (
         id_caricamento      IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_ACQUISIZIONE%TYPE,
        p_estensione    IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.ESTENSIONE_FILE%TYPE,
        docFileName    IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.FILE_NAME%TYPE
    );
PROCEDURE calc_space_securefiles (
         ownname          IN  VARCHAR2
        ,tabname          IN  VARCHAR2
        ,colname          IN  VARCHAR2
        ,partname         IN  VARCHAR2
    );
    PROCEDURE WriteBadAcquisitionLog (
         id_caricamento      IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_ACQUISIZIONE%TYPE,
        p_file IN RAW
    );
PROCEDURE PutFileRI (
         id_versione      IN DOCS_RINF_EVO.VERSIONE_RINF_SF.CODICE_VERSIONE%TYPE,
         estensione_file VARCHAR2,
        p_file IN BLOB,
        p_error OUT NUMBER
    );
PROCEDURE PutFtpCertification (
         p_utente      IN DOCS_RINF_EVO.FTP_ADDRESS.USERNAME%TYPE,
         p_password      IN DOCS_RINF_EVO.FTP_ADDRESS.PASSWORD%TYPE,
         p_indirizzo      IN DOCS_RINF_EVO.FTP_ADDRESS.INDIRIZZO%TYPE,
         p_nome_file IN VARCHAR2,
         p_estensione_file IN VARCHAR2,
        p_file IN BLOB,
        p_errorcode OUT NUMBER
    );
PROCEDURE LoadBFILEIntoLOB (
     src_dir    IN      VARCHAR2
    ,src_file   IN      VARCHAR2
    ,target_lob IN OUT  BLOB
    );

END PKG_RINF_SECUREFILE_V082;
/


--
-- PKG_RINF_SECUREFILE_V082  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY APPL_RINF_EVO."PKG_RINF_SECUREFILE_V082" 

AS
id_file   UTL_FILE.FILE_TYPE;
PROCEDURE LoadBFILEIntoLOB (
     src_dir    IN      VARCHAR2
    ,src_file   IN      VARCHAR2
    ,target_lob IN OUT  BLOB
    )
    /*
    || Procedure:   LoadBFILEIntoLOB
    || Purpose:     Loads an external LOB (BFILE) into an internal BasicFile
    ||              or SecureFile LOB
    || Scope:       Private
    || Author:      Jim Czuprynski (Fujitsu Consulting)
    ||
    */
    IS
        src_loc     BFILE   := BFILENAME(src_dir, src_file);
        load_amt    INTEGER := 4000;
    BEGIN
        -- Open the source document file in read-only mode
        DBMS_LOB.OPEN(
             file_loc => src_loc
            ,open_mode => DBMS_LOB.LOB_READONLY
        );

        -- Calculate the size of the external BFILE
        load_amt := DBMS_LOB.GETLENGTH(file_loc => src_loc);

        -- Load the LOB from the source file
        DBMS_LOB.LOADFROMFILE(target_lob, src_loc, load_amt);

        -- Close the opened BFILE external LOB
        DBMS_LOB.FILECLOSE(file_loc => src_loc);

    EXCEPTION
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('LoadLOBFromFILE Error: ' || SQLCODE || ' - ' || SQLERRM);

    END LoadBFILEIntoLob;

PROCEDURE PutLogOfAcquisition (
   id_acquisizione   IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_ACQUISIZIONE%TYPE,
   id_tipo_log       IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_LOG%TYPE,
   p_estensione      IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.ESTENSIONE_FILE%TYPE,
   docFileName       IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.FILE_NAME%TYPE)
IS
   docBlob   BLOB;
   imgBlob   BLOB;
BEGIN
   -- Add new row, returning references to the document and image BLOBs
   INSERT INTO DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF (CODICE_ACQUISIZIONE,
                                                   CODICE_LOG,
                                                   FILE_NAME,
                                                   SUBMIT_DTM,
                                                   STATUS,
                                                   ESTENSIONE_FILE,
                                                   DOCUMENT)
        VALUES (id_acquisizione,
                id_tipo_log,
                docFileName,
                SYSDATE,
                'NEW',
                p_estensione,
                EMPTY_BLOB ())
     RETURNING document
          INTO docBlob;

   -- Build the document LOB from the supplied file name
   LoadBFILEIntoLOB ('RINF_DIR', docFileName, docBlob);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE ('PutLogOfAcquisition Error' || SQLCODE);
--DBMS_OUTPUT.PUT_LINE('Severe error! ' || SQLCODE || ' - ' || SQLERRM);

END PutLogOfAcquisition;
PROCEDURE PutLogOfLoading (
         id_caricamento      IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_ACQUISIZIONE%TYPE,
        p_estensione    IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.ESTENSIONE_FILE%TYPE,
        docFileName    IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.FILE_NAME%TYPE
    ) IS
docBlob     BLOB;
imgBlob     BLOB;
    BEGIN

                -- Add new row, returning references to the document and image BLOBs
        INSERT INTO DOCS_RINF_EVO.ANAG_CARICAMENTI_SF
        (CODICE_CARICAMENTO, FILE_NAME, SUBMIT_DTM, STATUS, ESTENSIONE_FILE, DOCUMENT)
        VALUES (id_caricamento,  docFileName, SYSDATE, 'NEW', p_estensione, EMPTY_BLOB())
        RETURNING document INTO docBlob;

        -- Build the document LOB from the supplied file name
        LoadBFILEIntoLOB('RINF_DIR', docFileName, docBlob);


    EXCEPTION
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('PutLogOfLoading error! ' || SQLCODE || ' - ' || SQLERRM);

END PutLogOfLoading;
PROCEDURE WriteBadAcquisitionLog (
         id_caricamento      IN DOCS_RINF_EVO.ACQUISIZIONE_DATI_SF.CODICE_ACQUISIZIONE%TYPE,
        p_file IN RAW
    ) IS
docBlob     BLOB;
imgBlob     BLOB;
nome_file VARCHAR2(500);
    BEGIN
nome_file:='AcquisitionStep1_' || TO_CHAR (id_caricamento)||'_'|| TO_CHAR(sysdate,'DDMMYYYY') || '.log';

id_file := PKG_RINF_UTILITY.SETFILELOG (
            nome_file ,
            'RINF_DIR',
            SYSDATE);
            DBMS_OUTPUT.PUT_LINE(nome_file);
IF UTL_FILE.IS_OPEN (id_file) THEN

UTL_FILE.PUT_RAW(id_file, p_file,TRUE);
UTL_FILE.FCLOSE(id_file);
DBMS_OUTPUT.PUT_LINE ('file aperto');
    END IF;


PutLogOfLoading(id_caricamento,'log',nome_file);

UTL_FILE.FREMOVE('RINF_DIR',nome_file);
    EXCEPTION
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('WriteBadAcquisitionLog error! ' || SQLCODE || ' - ' || SQLERRM);

END WriteBadAcquisitionLog;
PROCEDURE ORI_PutFileRI (
            id_versione      IN DOCS_RINF_EVO.VERSIONE_RINF_SF.CODICE_VERSIONE%TYPE,
            estensione_file VARCHAR2,
            p_file IN RAW,
            p_error OUT NUMBER
        ) IS
docBlob     BLOB;
nome_file VARCHAR2(100);

    BEGIN
        p_error:=0;
        nome_file:=UPPER(estensione_file)||'RINF_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'.'||estensione_file;

        DBMS_OUTPUT.PUT_LINE(nome_file);


        IF UTL_FILE.IS_OPEN (id_file) THEN
            UTL_FILE.PUT_RAW(id_file, p_file,TRUE);
            UTL_FILE.FCLOSE(id_file);
            DBMS_OUTPUT.PUT_LINE ('file aperto');
        END IF;



        INSERT INTO DOCS_RINF_EVO.VERSIONE_RINF_SF
        (CODICE_VERSIONE, FILE_NAME, SUBMIT_DTM, STATUS, ESTENSIONE_FILE, DOCUMENT)
        VALUES (id_versione,  nome_file, SYSDATE, 'NEW', UPPER(estensione_file), EMPTY_BLOB())
        RETURNING document INTO docBlob;

        LoadBFILEIntoLOB('RINF_DIR', nome_file, docBlob);
        UTL_FILE.FREMOVE('RINF_DIR', nome_file);

    EXCEPTION
        WHEN OTHERS THEN
        p_error:=SQLCODE;
        DBMS_OUTPUT.PUT_LINE('ORI_PutFileRI error! ' || SQLCODE || ' - ' || SQLERRM);

END ORI_PutFileRI;

PROCEDURE PutFileRI (
            id_versione      IN DOCS_RINF_EVO.VERSIONE_RINF_SF.CODICE_VERSIONE%TYPE,
            estensione_file IN VARCHAR2,
            p_file IN BLOB,
            p_error OUT NUMBER
        ) IS
docBlob     BLOB;
nome_file VARCHAR2(100);
len number;
vstart NUMBER := 1;
bytelen NUMBER := 32000;
my_vr RAW(32000);
x NUMBER;
ls_ErrMsg varchar2(4000);
p_est VARCHAR2(100);


    BEGIN
        p_error:=0;
        p_est:= UPPER(estensione_file);  --11/01/2016 siamo stati costretti ad utilizzare una variabile di appoggio perchè la query successiva restituiva sempre 1

        select count(*) into x from  DOCS_RINF_EVO.VERSIONE_RINF_SF
        where
        CODICE_VERSIONE=id_versione
        AND  ESTENSIONE_FILE= p_est;

        IF x=0 THEN
                nome_file:=UPPER(estensione_file)||'RINF_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'.'||estensione_file;

        DBMS_OUTPUT.PUT_LINE(nome_file);

/* Vecchio codice, modificato il 22 ottobre 2014 da F. Cosmo */
/*
        IF UTL_FILE.IS_OPEN (id_file) THEN
            UTL_FILE.PUT_RAW(id_file, p_file,TRUE);
            UTL_FILE.FCLOSE(id_file);
            DBMS_OUTPUT.PUT_LINE ('file aperto');
        END IF;
*/

/* Codice modificato */
            --id_file := PKG_RINF_UTILITY.SETFILELOG (nome_file ,'RINF_DIR',SYSDATE);
            id_file := UTL_FILE.FOPEN ('RINF_DIR', nome_file,'WB',32767);
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('152, FILE APERTO');
            vstart := 1;
            bytelen := 32000;
            IF UTL_FILE.IS_OPEN (id_file) THEN
                len:=dbms_lob.getlength(p_file);
                x := len;
                --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('159, Lunghezza file '||to_char(len));

                IF len < 32760 THEN
                    utl_file.put_raw(id_file,p_file);
                    utl_file.fflush(id_file);
                    --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('164, Lunghezza file minore di 32k');
                ELSE -- write in pieces
                    vstart := 1;
                    WHILE vstart < len --and bytelen > 0
                    LOOP
                        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('170, vstart: '||to_char(vstart));
                        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('171, x: '||to_char(x));
                        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('172, bytelen:'||to_char(bytelen));
                        dbms_lob.read(p_file,bytelen,vstart,my_vr);
                        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('176, dbms_lob.read eseguito');
                        utl_file.put_raw(id_file,my_vr);
                        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('179, Putraw eseguito');
                        utl_file.fflush(id_file);
                        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('182, FFlush eseguito');

                        -- set the start position for the next cut
                        vstart := vstart + bytelen;

                        -- set the end position if less than 32000 bytes
                        x := x - bytelen;
                           IF x < 32000 THEN
                              bytelen := x;
                           END IF;

                    end loop;
                end if;
                --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('191, Prechiusura');
                UTL_FILE.FCLOSE(id_file);
                --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('194, PostChiusura');
            END IF;
/* Fine Codice modificato da Fabio Cosmo */





        INSERT INTO DOCS_RINF_EVO.VERSIONE_RINF_SF
        (CODICE_VERSIONE, FILE_NAME, SUBMIT_DTM, STATUS, ESTENSIONE_FILE, DOCUMENT)
        VALUES (id_versione,  nome_file, SYSDATE, 'NEW', UPPER(estensione_file), EMPTY_BLOB())
        RETURNING document INTO docBlob;

        -- Build the document LOB from the supplied file name
        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('206, LoadBFILEIntoLOB');

        LoadBFILEIntoLOB('RINF_DIR', nome_file, docBlob);

        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('209, FREMOVE');

        UTL_FILE.FREMOVE('RINF_DIR', nome_file);

        --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('212, OK');
        END IF;

    EXCEPTION
        WHEN UTL_FILE.INVALID_PATH THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := 'Invalid Path Specified';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN UTL_FILE.INVALID_MODE THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := 'Invalid Mode Specified';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN UTL_FILE.INVALID_FILEHANDLE THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg :=  'Invalid File Handle';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN UTL_FILE.INVALID_OPERATION THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := 'Invalid Operation Specified';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN UTL_FILE.READ_ERROR THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := 'Unable to Read Specified File';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN UTL_FILE.WRITE_ERROR THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := 'Unable to Write to Specified File';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN UTL_FILE.INTERNAL_ERROR THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := 'Unspecified Internal Error Encountered';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN VALUE_ERROR THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := 'Invalid Value Encountered. Perhaps ' ||
                         'an argument to a GET or PUT operation ' ||
                         'was > 32,767 Bytes';
            --INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

        WHEN OTHERS THEN
            p_error:=SQLCODE;
            IF UTL_FILE.is_open (id_file) THEN
              UTL_FILE.fclose (id_file);
            END IF;
            ls_ErrMsg := SQLERRM;
--            INSERT INTO LOG_DEBUG(RIGA_DEBUGGATA) VALUES ('Server error! ' || ls_ErrMsg);
--            RAISE_APPLICATION_ERROR( -20000, ls_ErrMsg  );

END PutFileRI;

PROCEDURE NewPutFileRI (
         id_versione      IN DOCS_RINF_EVO.VERSIONE_RINF_SF.CODICE_VERSIONE%TYPE,
         estensione_file VARCHAR2,
        p_file IN BFILE,
        p_error OUT NUMBER
    ) IS
docBlob     BLOB;
imgBlob     BLOB;
nome_file VARCHAR2(100);

vblob BLOB;
vstart NUMBER := 1;
bytelen NUMBER := 32000;
len NUMBER;
my_vr RAW(32000);
x NUMBER;
l_output utl_file.file_type;
src_loc     BFILE   :=p_file ;

    BEGIN
        vstart := 1;
        bytelen := 32000;
        --l_output := utl_file.fopen('DIR_TEMP', 'filename','wb', 32760);


        p_error:=0;

        nome_file:=UPPER(estensione_file)||'RINF_'||TO_CHAR(SYSDATE,'YYYYMMDD')||'.'||CASE WHEN UPPER(estensione_file)='RXML' THEN 'xml' ELSE estensione_file END;
        id_file := PKG_RINF_UTILITY.SETFILELOG (
            nome_file ,
            'RINF_DIR',
            SYSDATE);


            DBMS_OUTPUT.PUT_LINE(nome_file);

            IF UTL_FILE.IS_OPEN (id_file) THEN
                --UTL_FILE.PUT_RAW(id_file, p_file,TRUE);
                --UTL_FILE.FCLOSE(id_file);
                vstart := 1;
                DBMS_LOB.OPEN(
                     file_loc => src_loc
                    ,open_mode => DBMS_LOB.LOB_READONLY
                );

                -- Calculate the size of the external BFILE
                len := DBMS_LOB.GETLENGTH(file_loc => src_loc     );
                WHILE vstart < len and bytelen > 0
                LOOP
                   dbms_lob.read(src_loc     ,bytelen,vstart,my_vr);

                   utl_file.put_raw(id_file,my_vr);
                   utl_file.fflush(id_file);

                   -- set the start position for the next cut
                   vstart := vstart + bytelen;

                   -- set the end position if less than 32000 bytes
                   x := x - bytelen;
                   IF x < 32000 THEN
                      bytelen := x;
                   END IF;

                DBMS_OUTPUT.PUT_LINE ('file aperto');
                utl_file.fclose(id_file);
                end loop;
            END IF;


        INSERT INTO DOCS_RINF_EVO.VERSIONE_RINF_SF
        (CODICE_VERSIONE, FILE_NAME, SUBMIT_DTM, STATUS, ESTENSIONE_FILE, DOCUMENT)
        VALUES (id_versione,  nome_file, SYSDATE, 'NEW', UPPER(estensione_file), EMPTY_BLOB())
        RETURNING document INTO docBlob;

        -- Build the document LOB from the supplied file name
        LoadBFILEIntoLOB('RINF_DIR', nome_file, docBlob);
        UTL_FILE.FREMOVE('RINF_DIR',nome_file);

    EXCEPTION
        WHEN OTHERS THEN
        p_error:=SQLCODE;
             DBMS_OUTPUT.PUT_LINE('NewPutFileRI error! ' || SQLCODE || ' - ' || SQLERRM);

END NewPutFileRI;
PROCEDURE PutFtpCertification (
         p_utente      IN DOCS_RINF_EVO.FTP_ADDRESS.USERNAME%TYPE,
         p_password      IN DOCS_RINF_EVO.FTP_ADDRESS.PASSWORD%TYPE,
         p_indirizzo      IN DOCS_RINF_EVO.FTP_ADDRESS.INDIRIZZO%TYPE,
         p_nome_file IN VARCHAR2,
         p_estensione_file IN VARCHAR2,
        p_file IN BLOB,
        p_errorcode OUT NUMBER
    ) IS
docBlob     BLOB;
nome_file VARCHAR2(100);
len number;
vstart NUMBER := 1;
bytelen NUMBER := 32000;
my_vr RAW(32000);
x NUMBER;
ls_ErrMsg varchar2(4000);

    BEGIN
    DELETE FROM DOCS_RINF_EVO.FTP_ADDRESS;
        vstart := 1;
        bytelen := 32000;


        p_errorcode:=0;
IF  p_file IS NOT NULL  THEN   --01/12/2015 Controllo aggiunto per gestire l'inserimetno senza il file del certificato
        nome_file:=p_nome_file||p_estensione_file;
        id_file := PKG_RINF_UTILITY.SETFILELOG (
            nome_file ,
            'RINF_DIR',
            SYSDATE);


            DBMS_OUTPUT.PUT_LINE(nome_file);

            IF UTL_FILE.IS_OPEN (id_file) THEN
                len:=dbms_lob.getlength(p_file);
                x := len;

                IF len < 32760 THEN
                    utl_file.put_raw(id_file,p_file);
                    utl_file.fflush(id_file);
                ELSE -- write in pieces
                    vstart := 1;
                    WHILE vstart < len
                    LOOP
                        dbms_lob.read(p_file,bytelen,vstart,my_vr);

                        -- set the start position for the next cut
                        vstart := vstart + bytelen;

                        -- set the end position if less than 32000 bytes
                        x := x - bytelen;
                           IF x < 32000 THEN
                              bytelen := x;
                           END IF;

                    end loop;
                end if;
                UTL_FILE.FCLOSE(id_file);

            END IF;


        INSERT INTO DOCS_RINF_EVO.FTP_ADDRESS
        (USERNAME, PASSWORD, INDIRIZZO, CERTIFICATO)
        VALUES (p_utente,p_password,p_indirizzo, EMPTY_BLOB())
        RETURNING CERTIFICATO INTO docBlob;

        -- Build the document LOB from the supplied file name
        LoadBFILEIntoLOB('RINF_DIR', nome_file, docBlob);
        UTL_FILE.FREMOVE('RINF_DIR',nome_file);
ELSE
  INSERT INTO DOCS_RINF_EVO.FTP_ADDRESS
        (USERNAME, PASSWORD, INDIRIZZO)
        VALUES (p_utente,p_password,p_indirizzo);
END IF;

    EXCEPTION
        WHEN OTHERS THEN
        p_errorcode:=SQLCODE;
             DBMS_OUTPUT.PUT_LINE('PutFtpCertification error! ' || SQLCODE || ' - ' || SQLERRM);

END PutFtpCertification;
    PROCEDURE calc_space_securefiles (
         ownname          IN  VARCHAR2
        ,tabname          IN  VARCHAR2
        ,colname          IN  VARCHAR2
        ,partname         IN  VARCHAR2
    )
    /*
    || Procedure:   calc_space_securefiles
    || Purpose:     Displays space utilization for a SecureFile LOB.
    || Scope:       Public
    || Author:      Jim Czuprynski (Fujitsu Consulting)
    */
    IS
       lobname      VARCHAR2(30);
       lobpartname  VARCHAR2(30);
       sgmt_byts    NUMBER(15,2);
       sgmt_blks    NUMBER;
       used_byts    NUMBER(15,2);
       used_blks    NUMBER;
       expd_byts    NUMBER(15,2);
       expd_blks    NUMBER;
       unxp_byts    NUMBER(15,2);
       unxp_blks    NUMBER;
       KBC          NUMBER;

    BEGIN
        KBC := (1024);

        -- Gather all partition names for a partitioned LOB
        SELECT lob_name, lob_partition_name
          INTO lobname, lobpartname
          FROM all_lob_partitions
         WHERE table_owner = ownname
           AND table_name = tabname
           AND column_name = colname
           AND partition_name = partname
        ;

        DBMS_SPACE.SPACE_USAGE(
             segment_owner          => ownname
            ,segment_name           => lobname
            ,segment_type           => 'LOB PARTITION'
            ,segment_size_blocks    => sgmt_blks
            ,segment_size_bytes     => sgmt_byts
            ,used_blocks            => used_blks
            ,used_bytes             => used_byts
            ,expired_blocks         => expd_blks
            ,expired_bytes          => expd_byts
            ,unexpired_blocks       => unxp_blks
            ,unexpired_bytes        => unxp_byts
            ,partition_name         => lobpartname
       );
       DBMS_OUTPUT.ENABLE;
       DBMS_OUTPUT.PUT_LINE('============================================================');
       DBMS_OUTPUT.PUT_LINE('Space Usage for SecureFile LOB ' || UPPER(ownname) || '.' || UPPER(tabname) || '.' || UPPER(colname) );
       DBMS_OUTPUT.PUT_LINE('Partition Name: ' || UPPER(partname) );
       DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
       DBMS_OUTPUT.PUT_LINE('  Segment Blocks: ' || sgmt_blks || ' KB: ' || ROUND((sgmt_byts / KBC),2) );
       DBMS_OUTPUT.PUT_LINE('     Used Blocks: ' || used_blks || ' KB: ' || ROUND((used_byts / KBC),2) );
       DBMS_OUTPUT.PUT_LINE('  Expired Blocks: ' || expd_blks || ' KB: ' || ROUND((expd_byts / KBC),2) );
       DBMS_OUTPUT.PUT_LINE('Unexpired Blocks: ' || unxp_blks || ' KB: ' || ROUND((unxp_byts / KBC),2) );
       DBMS_OUTPUT.PUT_LINE(' ');
       DBMS_OUTPUT.PUT_LINE('============================================================');

    END calc_space_securefiles;

END PKG_RINF_SECUREFILE_V082;
/