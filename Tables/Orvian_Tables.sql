IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_USERS')
BEGIN
CREATE TABLE TB_USERS (
    ID UNIQUEIDENTIFIER DEFAULT NEWID(),
    NAME VARCHAR(150) NOT NULL,
    EMAIL VARCHAR(150) NOT NULL,
    PASSWORD VARCHAR(255) NOT NULL,
    PHONE VARCHAR(15) NOT NULL,
    DOCUMENT VARCHAR(14) NOT NULL,
    BIRTHDATE DATE NOT NULL,
    ROLE VARCHAR(20) NOT NULL DEFAULT 'USER',
    CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
    UPDATED_AT DATETIME NOT NULL DEFAULT GETDATE()
    PRIMARY KEY(ID)
)
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_PAYMENTS')
BEGIN
CREATE TABLE TB_PAYMENTS(
    ID UNIQUEIDENTIFIER DEFAULT NEWID(),
    VALUE_PAID DECIMAL(10, 2) NOT NULL,
    PAYMENT_METHOD VARCHAR(15) NOT NULL,
    PAYMENT_STATUS VARCHAR(15) NOT NULL,
    PAYMENT_APPROVED_AT DATETIME,
    TAX FLOAT,
    INSTALLMENT INT,
    INSTALLMENT_AMOUNT DECIMAL(10, 2),
    CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
    UPDATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY(ID)
)
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_RESERVATIONS')
BEGIN
CREATE TABLE TB_RESERVATIONS
(
	ID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
	RESERVATION_DATE DATE NOT NULL,
	SITUATION VARCHAR(10) NOT NULL,
	CANCEL_DATE DATE,
	ID_USER UNIQUEIDENTIFIER NOT NULL,
	ID_PACKAGES_DATES UNIQUEIDENTIFIER NOT NULL,

	CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
    UPDATED_AT DATETIME NOT NULL DEFAULT GETDATE()
)
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_RATINGS')
BEGIN
CREATE TABLE TB_RATINGS (
    ID UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    RATE INT NOT NULL CHECK (RATE BETWEEN 1 AND 5), 
    COMMENT VARCHAR(250) NULL,
    ID_RESERVE UNIQUEIDENTIFIER NOT NULL,
    CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
    UPDATED_AT DATETIME NOT NULL DEFAULT GETDATE()
)
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_MEDIAS')
BEGIN
CREATE TABLE TB_MEDIAS (
    ID UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    CONTENT64 VARBINARY(MAX) NOT NULL,
    TYPE VARCHAR(10) NOT NULL CHECK (TYPE IN ('jpg', 'png', 'gif', 'mp4', 'pdf', 'doc', 'other')), 
    PACKAGE_ID UNIQUEIDENTIFIER NOT NULL,
    CREATED_AT DATETIME NOT NULL DEFAULT SYSDATETIME(),
    UPDATED_AT DATETIME NULL
)
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_TRAVELERS')
BEGIN
CREATE TABLE TB_TRAVELERS (
    ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    NAME VARCHAR(150) NOT NULL,
    EMAIL VARCHAR(150) NOT NULL, 
    CPF VARCHAR(14) NOT NULL, 
    BIRTHDATE DATE NOT NULL,
        
    CREATED_AT DATETIME DEFAULT GETDATE(),
    UPDATED_AT DATETIME DEFAULT GETDATE(),

    PRIMARY KEY (ID)
)
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_PACKAGES_DATES')
BEGIN
    CREATE TABLE TB_PACKAGES_DATES(
    ID UNIQUEIDENTIFIER DEFAULT NEWID(),
    [START_DATE] DATE NOT NULl,
    END_DATE DATE NOT NULL,
    QTD_AVAILABLE INT NOT NULL,
    ID_PACKAGE UNIQUEIDENTIFIER NOT NULL, 

    CREATED_AT DATETIME DEFAULT GETDATE(),
    UPDATED_AT DATETIME DEFAULT GETDATE(),
    
    PRIMARY KEY(ID)
    )

END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_PACKAGES')
BEGIN
    CREATE TABLE TB_PACKAGES(
        ID UNIQUEIDENTIFIER DEFAULT NEWID(),
        TITLE VARCHAR(150) NOT NULL,
        DESCRIPTION_PACKAGE VARCHAR(MAX) NOT NULL,
        DESTINATION VARCHAR(50) NOT NULL,
        DURATION INT NOT NULL,
        PRICE DECIMAL(10,2) NOT NULL,
        MAX_PEOPLE INT NOT NULL,

        CREATED_AT DATETIME DEFAULT GETDATE(),
        UPDATED_AT DATETIME DEFAULT GETDATE(),

        PRIMARY KEY(ID)
    )
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_PROMOTIONS')
BEGIN
    CREATE TABLE TB_PROMOTIONS (
        ID UNIQUEIDENTIFIER DEFAULT NEWID() ,
        CODE VARCHAR(50) NULL, -- c�digo/cupom da promo��o
        NAME VARCHAR(100) NOT NULL DEFAULT 'Promo��o', -- Nome da promo��o (ex: "Winter Sale")
        DESCRIPTION VARCHAR(255),   -- opcional: descri��o da promo��o
        START_DATE DATETIME NOT NULL, -- in�cio da validade
        END_DATE DATETIME NOT NULL,   -- fim da validade
        DISCOUNT_PERCENT FLOAT NOT NULL, -- porcentagem de desconto (0-100)
        CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
        UPDATED_AT DATETIME NOT NULL DEFAULT GETDATE(),

        PRIMARY KEY(ID)
    )
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TB_PASSWORD_RESET_TOKENS')
BEGIN
CREATE TABLE TB_PASSWORD_RESET_TOKENS (
    ID UNIQUEIDENTIFIER DEFAULT NEWID(),
    TOKEN VARCHAR(255) NOT NULL,
    USER_EMAIL VARCHAR(150) NOT NULL,
    EXPIRES_AT DATETIME NOT NULL,
    USED BIT NOT NULL DEFAULT 0,
    CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
    UPDATED_AT DATETIME NOT NULL DEFAULT GETDATE(),
    
    PRIMARY KEY(ID)
)
END
GO