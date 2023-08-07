DROP TABLE PINVOICE;
DROP TABLE PORDERL;
DROP TABLE PORDER;
DROP TABLE SUPPLIER;

CREATE TABLE SUPPLIER(
SUPPLIER_REF	VARCHAR(10)     PRIMARY KEY,
COMPANY		    VARCHAR(80) 	NOT NULL,
CONTACT		    VARCHAR(80) 	NOT NULL,
ADD_LIN1	    VARCHAR(50) 	NOT NULL,
ADD_LIN2	    VARCHAR(50) 	NOT NULL,
ADD_LIN3	    VARCHAR(50) 	NOT NULL,
ADD_LIN4	    VARCHAR(50) 	NOT NULL,
COUNTRY		    VARCHAR(50) 	NOT NULL,
MOBILE		    INT,
PHONE		    INT,
EMAIL		    VARCHAR(100) 	NOT NULL
);
