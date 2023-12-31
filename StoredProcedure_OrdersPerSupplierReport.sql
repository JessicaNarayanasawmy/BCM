--Order status report
CREATE OR REPLACE PROCEDURE JNABCM.ORDER_STATUS_REPORT 
(P_ORDER_STATUS OUT SYS_REFCURSOR) 
AS 
BEGIN 
OPEN P_ORDER_STATUS FOR
SELECT 
TO_NUMBER(SUBSTR(PO.PO_REF,3,3)) AS Order_Reference,
SUBSTR(TO_CHAR(PO.ORDER_DATE),4,6) AS Order_Period,
INITCAP(COMPANY) AS Supplier_Name,
TO_CHAR(PO.ORDER_AMOUNT, 'fm99G999G999D00') AS Order_Total_Amount,
PO.STATUS AS Order_Status,
POL.PINV_REF AS Invoice_Reference,
TO_CHAR(PIV.INV_AMOUNT, 'fm99G999G999D00') AS Invoice_Total_Amount,
CASE
    WHEN POL.STATUS = 'Paid'
        THEN 'Ok'
    WHEN POL.STATUS = 'Pending'
        THEN 'To follow up'
    ELSE 'To Verify'
END Action
FROM PORDER PO
INNER JOIN SUPPLIER SUP
ON PO.SUPPLIER_REF=SUP.SUPPLIER_REF
INNER JOIN PINVOICEL POL
ON PO.PO_REF=POL.PO_REF
INNER JOIN PINVOICE PIV
ON POL.PINV_REF=PIV.PINV_REF
GROUP BY 
TO_NUMBER(SUBSTR(PO.PO_REF,3,3)),
SUBSTR(TO_CHAR(PO.ORDER_DATE),4,6),
INITCAP(COMPANY),
TO_CHAR(PO.ORDER_AMOUNT, 'fm99G999G999D00'),
PO.STATUS,
POL.PINV_REF,
TO_CHAR(PIV.INV_AMOUNT, 'fm99G999G999D00'),
CASE
    WHEN POL.STATUS = 'Paid'
        THEN 'Ok'
    WHEN POL.STATUS = 'Pending'
        THEN 'To follow up'
    ELSE 'To Verify'
END;
END ORDER_STATUS_REPORT;
