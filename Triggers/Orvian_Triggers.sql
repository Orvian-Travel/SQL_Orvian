-- =================================================================
-- TRIGGER 1: Atualiza��o de Data de Aprova��o de Pagamento
-- Objetivo: Atualizar automaticamente o campo PAYMENT_APPROVED_AT quando o status do pagamento mudar para 'approved'
-- Tabela: TB_PAYMENTS
-- Evento: UPDATE
-- =================================================================
CREATE TRIGGER TRG_SET_PAYMENT_APPROVED_AT ON TB_PAYMENTS
AFTER
UPDATE AS BEGIN
SET NOCOUNT ON
    UPDATE TB_PAYMENTS
SET PAYMENT_APPROVED_AT = GETDATE()
FROM TB_PAYMENTS P 
    INNER JOIN INSERTED I ON P.ID = I.ID
    INNER JOIN DELETED D ON D.ID = I.ID
WHERE I.PAYMENT_STATUS = 'approved'
    AND (
        D.PAYMENT_STATUS <> 'approved'
        OR D.PAYMENT_STATUS IS NULL
    );
END
GO

-- =================================================================
-- TRIGGER 2: Valida��o de Datas
-- Objetivo: Garantir que a data de fim seja sempre maior que a data de in�cio
-- Tabela: TB_PACKAGES_DATES
-- Eventos: INSERT e UPDATE
-- =================================================================
CREATE TRIGGER TRG_VALIDATE_PACKAGE_DATES
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE END_DATE <= START_DATE)
    BEGIN
        RAISERROR('A data de fim deve ser maior que a data de in�cio', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 3: Preven��o de Datas no Passado
-- Objetivo: Impedir a cria��o de pacotes com data de in�cio no passado
-- Tabela: TB_PACKAGES_DATES
-- Eventos: INSERT e UPDATE
-- =================================================================
CREATE TRIGGER TRG_PREVENT_PAST_DATES
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE START_DATE < CAST(GETDATE() AS DATE))
    BEGIN
        RAISERROR('N�o � poss�vel criar pacotes com data de in�cio no passado', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 4: Valida��o de Quantidade Dispon�vel
-- Objetivo: Garantir que a quantidade dispon�vel seja sempre positiva
-- Tabela: TB_PACKAGES_DATES
-- Eventos: INSERT e UPDATE
-- =================================================================
CREATE TRIGGER TRG_VALIDATE_QTD_AVAILABLE
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE QTD_AVAILABLE <= 0)
    BEGIN
        RAISERROR('A quantidade dispon�vel deve ser maior que zero', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 5: Verifica��o de Capacidade M�xima
-- Objetivo: Impedir que a quantidade dispon�vel seja maior que a capacidade m�xima do pacote
-- Tabela: TB_PACKAGES_DATES
-- Eventos: INSERT e UPDATE
-- Relacionamento: Verifica contra TB_PACKAGES.MAX_PEOPLE
-- N�o executada, conflito com regras de neg�cios
-- =================================================================
CREATE TRIGGER TRG_CHECK_MAX_CAPACITY
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        INNER JOIN TB_PACKAGES p ON i.ID_PACKAGE = p.ID
        WHERE i.QTD_AVAILABLE > p.MAX_PEOPLE
    )
    BEGIN
        RAISERROR('A quantidade dispon�vel n�o pode ser maior que a capacidade m�xima do pacote', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 6: Valida��o de Pre�o do Pacote
-- Objetivo: Garantir que o pre�o seja sempre positivo e n�o seja muito baixo
-- Tabela: TB_PACKAGES
-- Eventos: INSERT e UPDATE
-- =================================================================
CREATE TRIGGER TRG_VALIDATE_PACKAGE_PRICE
ON TB_PACKAGES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE PRICE < 0.01)
    BEGIN
        RAISERROR('O pre�o do pacote deve ser maior que zero', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 7: Valida��o de Campos Obrigat�rios
-- Objetivo: Garantir que title e destination n�o sejam vazios ou apenas espa�os
-- Tabela: TB_PACKAGES
-- Eventos: INSERT e UPDATE
-- =================================================================
CREATE TRIGGER TRG_VALIDATE_PACKAGE_FIELDS
ON TB_PACKAGES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE LTRIM(RTRIM(TITLE)) = '' OR LTRIM(RTRIM(DESTINATION)) = '')
    BEGIN
        RAISERROR('T�tulo e destino n�o podem ser vazios', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 8: Valida��o de Dura��o M�nima
-- Objetivo: Garantir que a dura��o do pacote seja de pelo menos 1 dia
-- Tabela: TB_PACKAGES
-- Eventos: INSERT e UPDATE
-- =================================================================
CREATE TRIGGER TRG_VALIDATE_PACKAGE_DURATION
ON TB_PACKAGES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE DURATION < 1)
    BEGIN
        RAISERROR('A dura��o do pacote deve ser de pelo menos 1 dia', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 9: Preven��o de Exclus�o com Datas Ativas
-- Objetivo: Impedir exclus�o de pacotes que possuem datas futuras cadastradas
-- Tabela: TB_PACKAGES
-- Eventos: DELETE
-- Relacionamento: Verifica TB_PACKAGES_DATES
-- =================================================================
CREATE TRIGGER TRG_PREVENT_DELETE_WITH_ACTIVE_DATES
ON TB_PACKAGES
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM deleted d
        INNER JOIN TB_PACKAGES_DATES pd ON d.ID = pd.ID_PACKAGE
        WHERE pd.START_DATE >= CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR('N�o � poss�vel excluir pacotes que possuem datas futuras cadastradas', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        DELETE FROM TB_PACKAGES WHERE ID IN (SELECT ID FROM deleted)
    END
END
GO
