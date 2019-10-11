SET SERVEROUTPUT ON;
CLEAR SCREEN;
DROP TABLE A2ERROREVENT CASCADE CONSTRAINTS;
/
CREATE TABLE A2ERROREVENT (
    ERRORID INTEGER,
    SOURCE_ROWID ROWID,
    SOURCE_TABLE VARCHAR2(30),
    ERRORCODE INTEGER,
    FILTERID INTEGER,
    DATETIME DATE,
    ACTION VARCHAR2(6),
    CONSTRAINT ERROREVENTACTION 
    CHECK (ACTION IN ('SKIP','MODIFY'))
    );
/
DROP SEQUENCE A2ERROREVENT_SEQ;
CREATE SEQUENCE A2ERROREVENT_SEQ;
/
DROP TABLE DWPROD CASCADE CONSTRAINTS;
DROP TABLE DWCUST CASCADE CONSTRAINTS;
DROP TABLE DWSALE CASCADE CONSTRAINTS;
/
CREATE TABLE DWPROD (
    DWPRODID INTEGER,
    DWSOURCETABLE VARCHAR2(30),
    DWSOURCEID INTEGER,
    PRODNAME VARCHAR2(100),
    PRODCATNAME VARCHAR2(100),
    PRODMANUNAME VARCHAR2(100),
    PRODSHIPNAME VARCHAR2(100),
    PRIMARY KEY (DWPRODID)
);
/
CREATE TABLE DWCUST (
    DWCUSTID INTEGER,
    DWSOURCEIDBRIS INTEGER,
    DWSOURCEIDMELB INTEGER,
    FIRSTNAME VARCHAR2(100),
    SURNAME VARCHAR2(100),
    GENDER VARCHAR2(1),
    PHONE INTEGER,
    POSTCODE INTEGER,
    CITY VARCHAR2(30),
    STATE VARCHAR2(10),
    CUSTCATNAME VARCHAR2(100),
    PRIMARY KEY (DWCUSTID)
);
/
CREATE TABLE DWSALE (
    DWSALEID INTEGER,
    DWCUSTID INTEGER,
    DWPRODID INTEGER,
    DWSOURCEIDBRIS INTEGER,
    DWSOURCEIDMELB INTEGER,
    QTY INTEGER,
    SALE_DWDATEID INTEGER,
    SHIP_DWDATEID INTEGER,
    SALEPRICE INTEGER,
    PRIMARY KEY (DWSALEID)
);
/
DROP SEQUENCE DW_SEQ;
CREATE SEQUENCE DW_SEQ;
/
DROP TABLE GENDERSPELLING CASCADE CONSTRAINTS;
/
CREATE TABLE GENDERSPELLING (
    INVALIDVALUE VARCHAR(30),
    NEWVALUE VARCHAR(1)
);
/
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('MAIL', 'M');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('WOMAN', 'F');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('FEM', 'F');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('FEMALE', 'F');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('MALE', 'M');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('GENTLEMAN', 'M');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('MM', 'M');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('FF', 'F');
INSERT INTO GENDERSPELLING (INVALIDVALUE, NEWVALUE) VALUES
('FEMAIL', 'F');
/
DROP SEQUENCE GENDERSPELLING_SEQ;
CREATE SEQUENCE GENDERSPELLING_SEQ;   
/
INSERT INTO A2ERROREVENT( ERRORID, SOURCE_ROWID, SOURCE_TABLE, ERRORCODE, ACTION )
SELECT A2ERROREVENT_SEQ.NEXTVAL AS ERRORID, ROWID, 'A2PRODUCT', 105, 'SKIP'
FROM A2PRODUCT p
WHERE p.PRODNAME IS NULL;
COMMIT;
/
INSERT INTO A2ERROREVENT ( ERRORID, SOURCE_ROWID, SOURCE_TABLE, ERRORCODE, ACTION )
SELECT A2ERROREVENT_SEQ.NEXTVAL AS ERRORID, ROWID, 'A2PRODUCT', 131, 'MODIFY'
FROM A2PRODUCT p
WHERE p.MANUFACTURERCODE IS NULL;
COMMIT;
/
INSERT INTO A2ERROREVENT ( ERRORID, SOURCE_ROWID, SOURCE_TABLE, ERRORCODE, ACTION )
SELECT A2ERROREVENT_SEQ.NEXTVAL AS ERRORID, ROWID, 'A2PRODUCT', 146, 'MODIFY'
FROM A2PRODUCT p
WHERE p.PRODCATEGORY IS NULL OR p.PRODCATEGORY NOT IN (SELECT c.PRODUCTCATEGORY FROM A2PRODCATEGORY c );
COMMIT;
/