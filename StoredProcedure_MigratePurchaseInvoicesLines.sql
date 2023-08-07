--Purchase invoice line migration
CREATE OR REPLACE PROCEDURE JNABCM.MIGRATE_PINVOICEL IS
BEGIN
INSERT INTO PINVOICEL
(
)
SELECT
;
END;


--PINV_REF          VARCHAR(12)     NOT NULL,
--PINV_LINE		        NUMBER          NOT NULL,
--PO_REF              VARCHAR(5)      NOT NULL,
--PO_LINE		        NUMBER          NOT NULL,
--LINE_AMOUNT	        NUMBER(8,2)     NOT NULL,
--STATUS              VARCHAR(10)     NOT NULL,    
--HOLD_REASON         VARCHAR(10),            
--LINE_DESCRIPTION    VARCHAR(50),
--PAY_REF             VARCHAR(6),