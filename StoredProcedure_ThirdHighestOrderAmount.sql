--Third highest order amount report
CREATE OR REPLACE FUNCTION GET_INV_LIST(P_ORDER VARCHAR,P_SUPPLIER VARCHAR) 
RETURN VARCHAR
IS
    INV_LIST VARCHAR;
BEGIN
    for i in (SELECT INVPO_REF FROM PINVOICE WHERE SUPPLIER_REF=P_SUPPLIER AND INVPO_REF LIKE CONCAT('INV_',P_ORDER)) loop
        INV_LIST:=INV_LIST || ', ' || i.INVPO_REF;
    end loop;
    RETURN INV_LIST;
    EXCEPTION WHEN OTHERS THEN RETURN NULL;
END;

CREATE OR REPLACE PROCEDURE JNABCM.THIRD_HIGHEST_ORDER 
(P_THIRD_HIGHEST_ORDER OUT SYS_REFCURSOR) 
AS 
BEGIN 
OPEN P_THIRD_HIGHEST_ORDER FOR
SELECT *
FROM (select ORDER_LIST.*, rownum rnum from
             (SELECT 
                TO_NUMBER(SUBSTR(PO.PO_REF,3,3)) AS Order_Reference,
                CONCAT(INITCAP(to_char(ORDER_DATE, 'MONTH')),CONCAT(to_char(ORDER_DATE, 'DD'),CONCAT(', ',to_char(ORDER_DATE, 'YYYY')))) AS Order_Date,
                UPPER(COMPANY) AS Supplier_Name,
                TO_CHAR(PO.ORDER_AMOUNT, 'fm99G999G999D00') AS Order_Total_Amount,
                PO.STATUS AS Order_Status,
                POL.PINV_REF AS Invoice_Reference,
                GET_INV_LIST(PO.PO_REF,COMPANY) AS Invoice_References
                FROM PORDER PO
                INNER JOIN SUPPLIER SUP
                ON PO.SUPPLIER_REF=SUP.SUPPLIER_REF
                INNER JOIN PINVOICEL POL
                ON PO.PO_REF=POL.PO_REF
                INNER JOIN PINVOICE PIV
                ON POL.PINV_REF=PIV.PINV_REF
                GROUP BY 
                TO_NUMBER(SUBSTR(PO.PO_REF,3,3)),
                CONCAT(INITCAP(to_char(ORDER_DATE, 'MONTH')),CONCAT(to_char(ORDER_DATE, 'DD'),CONCAT(', ',to_char(ORDER_DATE, 'YYYY')))),
                UPPER(COMPANY),
                TO_CHAR(PO.ORDER_AMOUNT, 'fm99G999G999D00'),
                PO.STATUS,
                POL.PINV_REF) ORDER_LIST
      where rownum <= 3 )
WHERE rnum >= 3;

END THIRD_HIGHEST_ORDER;
