CREATE OR REPLACE FUNCTION GET_SUPPLIER(P_COMPANY VARCHAR) 
RETURN VARCHAR
IS
    V_SUPPLIER VARCHAR(10):='';
BEGIN
    for i in (SELECT distinct SUPPLIER_REF FROM SUPPLIER WHERE COMPANY=P_COMPANY) loop
        V_SUPPLIER:=i.SUPPLIER_REF;
    end loop;
    RETURN V_SUPPLIER;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;

--Purchase order migration
CREATE OR REPLACE PROCEDURE JNABCM.MIGRATE_PORDER IS
BEGIN
INSERT INTO PORDER
SELECT 
ORDER_REF, 
CASE 
    WHEN LENGTH(TRIM(TRANSLATE(SUBSTR(ORDER_DATE,4,2), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ' ')))IS NULL THEN
        TO_DATE(ORDER_DATE,'DD-Mon-YY')
    ELSE
        TO_DATE(ORDER_DATE,'DD/MM/YYYY')
END, 
GET_SUPPLIER(SUPPLIER_NAME), 
TO_NUMBER(replace(ORDER_TOTAL_AMOUNT,',')), 
ORDER_DESCRIPTION, 
ORDER_STATUS 
FROM XXBCM_ORDER_MGT WHERE LENGTH(ORDER_REF)=5; 
END;


