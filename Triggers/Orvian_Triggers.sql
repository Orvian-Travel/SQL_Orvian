-- =================================================================
-- TRIGGER 1: Atualização de Data de Aprovação de Pagamento
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
-- TRIGGER 2: Validação de Datas
-- Objetivo: Garantir que a data de fim seja sempre maior que a data de início
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
        RAISERROR('A data de fim deve ser maior que a data de início', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 3: Prevenção de Datas no Passado
-- Objetivo: Impedir a criação de pacotes com data de início no passado
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
        RAISERROR('Não é possível criar pacotes com data de início no passado', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 4: Validação de Quantidade Disponível
-- Objetivo: Garantir que a quantidade disponível seja sempre positiva
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
        RAISERROR('A quantidade disponível deve ser maior que zero', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 5: Verificação de Capacidade Máxima
-- Objetivo: Impedir que a quantidade disponível seja maior que a capacidade máxima do pacote
-- Tabela: TB_PACKAGES_DATES
-- Eventos: INSERT e UPDATE
-- Relacionamento: Verifica contra TB_PACKAGES.MAX_PEOPLE
-- Não executada, conflito com regras de negócios
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
        RAISERROR('A quantidade disponível não pode ser maior que a capacidade máxima do pacote', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 6: Validação de Preço do Pacote
-- Objetivo: Garantir que o preço seja sempre positivo e não seja muito baixo
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
        RAISERROR('O preço do pacote deve ser maior que zero', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 7: Validação de Campos Obrigatórios
-- Objetivo: Garantir que title e destination não sejam vazios ou apenas espaços
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
        RAISERROR('Título e destino não podem ser vazios', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 8: Validação de Duração Mínima
-- Objetivo: Garantir que a duração do pacote seja de pelo menos 1 dia
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
        RAISERROR('A duração do pacote deve ser de pelo menos 1 dia', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 9: Prevenção de Exclusão com Datas Ativas
-- Objetivo: Impedir exclusão de pacotes que possuem datas futuras cadastradas
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
        RAISERROR('Não é possível excluir pacotes que possuem datas futuras cadastradas', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        DELETE FROM TB_PACKAGES WHERE ID IN (SELECT ID FROM deleted)
    END
END
GO
