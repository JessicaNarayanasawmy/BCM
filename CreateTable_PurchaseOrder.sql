CREATE TABLE PORDER(
PO_REF          VARCHAR(5)      PRIMARY KEY,
ORDER_DATE		DATE 	        NOT NULL,
SUPPLIER_REF    VARCHAR(10) 	NOT NULL,
ORDER_AMOUNT	NUMBER          NOT NULL,
DESCRIPTION	    VARCHAR(50),
STATUS          VARCHAR(7)      NOT NULL,
CONSTRAINT FK_PO_SUP
    FOREIGN KEY (SUPPLIER_REF)
    REFERENCES SUPPLIER(SUPPLIER_REF)
);

