-- Supplier numeric sequence
CREATE SEQUENCE SUPPLIER_SEQ
  START WITH 1 -- The initial value for the sequence
  INCREMENT BY 1 -- The increment value, in this case, it will auto-increment by 1
  MINVALUE 1 -- The minimum value the sequence can have
  MAXVALUE 9999999999 -- The maximum value the sequence can have
  NOCYCLE; -- Specify NOCYCLE to prevent the sequence from cycling back to the MINVALUE after reaching the MAXVALUE.
  
--Get mobile phone
CREATE OR REPLACE FUNCTION GET_MOBILE(STRPHONE VARCHAR) 
RETURN NUMBER
IS
    MOBILE NUMBER := 0;
BEGIN
    -- Split strphone
    If TRIM(LENGTH(STRPHONE))=8 and SUBSTR(STRPHONE,1,1)='5' THEN 
       MOBILE:=TO_NUMBER(STRPHONE); 
    Elsif TRIM(LENGTH(STRPHONE))>8 and SUBSTR(STRPHONE,1,1)='5' THEN
        MOBILE:=TO_NUMBER(SUBSTR(STRPHONE,1,8)); 
    Elsif TRIM(LENGTH(STRPHONE))>8 and SUBSTR(STRPHONE,1,1)<>'5' THEN
        IF SUBSTR(REGEXP_SUBSTR(STRPHONE, '[^,]+',1,2),1,1)='5' Then
            MOBILE:=REGEXP_SUBSTR(STRPHONE, '[^,]+',1,2);
        End if;
    Else
        MOBILE:=NULL;
    End if;
    -- return mobile number
    RETURN MOBILE;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;

--Get duplicate supplier
CREATE OR REPLACE FUNCTION GET_DUPLICATE(SRHCOMP VARCHAR) 
RETURN VARCHAR
IS
    DUPLICATA VARCHAR(80):=NULL;
BEGIN
    for i in (SELECT distinct COMPANY FROM SUPPLIER WHERE COMPANY=SRHCOMP) loop
        DUPLICATA:=i.COMPANY;
        DBMS_OUTPUT.PUT_LINE(DUPLICATA);
    end loop;
    RETURN DUPLICATA;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;

--Get phone
CREATE OR REPLACE FUNCTION GET_PHONE(STRPHONE VARCHAR) 
RETURN NUMBER
IS
    PHONE NUMBER := 0;
BEGIN
    -- Split strphone
    If TRIM(LENGTH(STRPHONE))=7 and SUBSTR(STRPHONE,1,1)<>'5' THEN 
       PHONE:=TO_NUMBER(STRPHONE); 
    Elsif TRIM(LENGTH(STRPHONE))>7 and SUBSTR(STRPHONE,1,1)<>'5' THEN
        PHONE:=TO_NUMBER(SUBSTR(STRPHONE,1,7)); 
    Elsif TRIM(LENGTH(STRPHONE))>7 and SUBSTR(STRPHONE,1,1)='5' THEN
        If SUBSTR(REGEXP_SUBSTR(STRPHONE, '[^,]+',1,2),1,1)<>'5' Then
            PHONE:=REGEXP_SUBSTR(STRPHONE, '[^,]+',1,2);
        Else
           PHONE:=NULL; 
        End if;
    Else
        PHONE:=NULL;
    End if;
    -- return phone number
    RETURN PHONE;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;

--------------------------------------------------------------------------------
--Supplier migration
CREATE OR REPLACE PROCEDURE JNABCM.MIGRATE_SUPPLIER IS
BEGIN
    for i in (SELECT distinct SUPPLIER_NAME,SUPP_CONTACT_NAME,SUPP_ADDRESS,SUPP_CONTACT_NUMBER,SUPP_EMAIL FROM XXBCM_ORDER_MGT) loop
        DBMS_OUTPUT.PUT_LINE(i.SUPPLIER_NAME);

        If GET_DUPLICATE(i.SUPPLIER_NAME) IS NULL Then
            INSERT INTO SUPPLIER
                (SUPPLIER_REF,COMPANY,CONTACT,ADD_LIN1,ADD_LIN2,ADD_LIN3,ADD_LIN4,COUNTRY,MOBILE,PHONE,EMAIL)
            VALUES(
                CASE
                    WHEN LENGTH(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)))=5 THEN 
                        CONCAT(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)),TO_CHAR(SUPPLIER_SEQ.NEXTVAL,'fm00000'))
                    WHEN LENGTH(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)))=4 THEN 
                        CONCAT(CONCAT(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)),'0'),TO_CHAR(SUPPLIER_SEQ.NEXTVAL,'fm00000'))
                    WHEN LENGTH(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)))=3 THEN 
                        CONCAT(CONCAT(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)),'00'),TO_CHAR(SUPPLIER_SEQ.NEXTVAL,'fm00000'))      
                    WHEN LENGTH(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)))=2 THEN 
                        CONCAT(CONCAT(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)),'000'),TO_CHAR(SUPPLIER_SEQ.NEXTVAL,'fm00000'))      
                    WHEN LENGTH(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)))=1 THEN 
                        CONCAT(CONCAT(TRIM(SUBSTR(i.SUPPLIER_NAME, 1, 5)),'0000'),TO_CHAR(SUPPLIER_SEQ.NEXTVAL,'fm00000')) 
                    ELSE 
                        CONCAT('00000',TO_CHAR(SUPPLIER_SEQ.NEXTVAL,'fm00000')) 
                END,            
                TRIM(i.SUPPLIER_NAME),
                TRIM(i.SUPP_CONTACT_NAME),
                NVL(TRIM(CONCAT(REGEXP_SUBSTR(REGEXP_REPLACE(i.SUPP_ADDRESS,'(-){1,}', ''), '[^,]+',1,1),REGEXP_SUBSTR(i.SUPP_ADDRESS, '[^,]+',1,2))),'-'),
                NVL(TRIM(REGEXP_SUBSTR(i.SUPP_ADDRESS, '[^,]+',1,3)),'-'),
                NVL(TRIM(REGEXP_SUBSTR(i.SUPP_ADDRESS, '[^,]+',1,4)),'-'),
                NVL(TRIM(REGEXP_SUBSTR(REGEXP_REPLACE(i.SUPP_ADDRESS,'(Mauritius){1,}', ''), '[^,]+',1,5)),'-'),
                NVL(TRIM(REGEXP_SUBSTR(REGEXP_REPLACE(i.SUPP_ADDRESS,'(Pamplemousses){1,}', 'Mauritius'), '[^,]+',1,5)),'-'),
                GET_MOBILE(regexp_replace(replace(i.SUPP_CONTACT_NUMBER,'.'), '[[:space:]]*','')),
                GET_PHONE(regexp_replace(replace(i.SUPP_CONTACT_NUMBER,'.'), '[[:space:]]*','')),
                TRIM(i.SUPP_EMAIL));
       End if;
    end loop;
END;
