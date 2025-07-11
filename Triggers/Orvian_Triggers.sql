-- =================================================================
-- TRIGGER 1: Atualiza��o de Data de Aprova��o de Pagamento
-- Objetivo: Atualizar automaticamente o campo PAYMENT_APPROVED_AT quando o status do pagamento mudar para 'approved'
-- Tabela: TB_PAYMENTS
-- Evento: UPDATE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_SET_PAYMENT_APPROVED_AT ON TB_PAYMENTS
AFTER
UPDATE AS BEGIN
SET NOCOUNT ON
    UPDATE TB_PAYMENTS
SET PAYMENT_APPROVED_AT = GETDATE()
FROM TB_PAYMENTS P 
    INNER JOIN INSERTED I ON P.ID = I.ID
    INNER JOIN DELETED D ON D.ID = I.ID
WHERE I.PAYMENT_STATUS = 'aprovado'
    AND (
        D.PAYMENT_STATUS <> 'aprovado'
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_PACKAGE_DATES
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
CREATE OR ALTER TRIGGER TRG_PREVENT_PAST_DATES
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_QTD_AVAILABLE
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE QTD_AVAILABLE < 0)
    BEGIN
        RAISERROR('A quantidade dispon�vel deve ser maior ou igual que zero', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 5: Verifica��o de Capacidade M�xima de Viajantes
-- Objetivo: Impedir que o n�mero de viajantes associados a cada pacote/data exceda a capacidade m�xima do pacote (MAX_PEOPLE em TB_PACKAGES)
-- Tabela: TB_PACKAGES_DATES
-- Eventos: INSERT e UPDATE
-- Relacionamento: Verifica TB_TRAVELERS e TB_PACKAGES.MAX_PEOPLE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_CHECK_MAX_CAPACITY
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        INNER JOIN TB_PACKAGES P ON I.ID_PACKAGE = P.ID
        OUTER APPLY (
            SELECT COUNT(T.ID) AS QTD_VIAJANTES
            FROM TB_RESERVATIONS R
            INNER JOIN TB_TRAVELERS T ON T.ID_RESERVATION = R.ID
            WHERE R.ID_PACKAGES_DATES = I.ID
        ) AS VIAJANTES
        WHERE VIAJANTES.QTD_VIAJANTES > P.MAX_PEOPLE
    )
    BEGIN
        RAISERROR('A QUANTIDADE DE VIAJANTES EXCEDE A CAPACIDADE M�XIMA DO PACOTE.', 16, 1)
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_PACKAGE_PRICE
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_PACKAGE_FIELDS
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_PACKAGE_DURATION
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
CREATE OR ALTER TRIGGER TRG_PREVENT_DELETE_WITH_ACTIVE_DATES
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

-- =================================================================
-- TRIGGER 10: Valida��o de Compatibilidade entre Per�odo das Datas e Dura��o do Pacote
-- Objetivo: Garantir que a diferen�a de dias entre START_DATE e END_DATE em TB_PACKAGES_DATES
--           seja compat�vel com o campo DURATION definido em TB_PACKAGES. Em caso de inconsist�ncia,
--           a opera��o � cancelada e retorna erro.
-- Tabela: TB_PACKAGES_DATES (relacionando com TB_PACKAGES)
-- Evento: INSERT, UPDATE
-- =================================================================

CREATE OR ALTER TRIGGER TRG_TB_PACKAGES_DATES_VALIDATE_DURATION
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        INNER JOIN TB_PACKAGES P ON I.ID_PACKAGE = P.ID
        WHERE DATEDIFF(DAY, I.START_DATE, I.END_DATE) <> P.DURATION
    )
    BEGIN
        RAISERROR (
            'A diferen�a entre START_DATE e END_DATE em TB_PACKAGES_DATES deve ser igual ao DURATION do pacote correspondente em TB_PACKAGES.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

-- =================================================================
-- TRIGGER 11: VALIDA��O DE STATUS DE RESERVA COM PAGAMENTO APROVADO
-- OBJETIVO: IMPEDIR QUE O STATUS DA RESERVA (SITUATION EM TB_RESERVATIONS) SEJA 'RESERVADA'
--           CASO O STATUS DO PAGAMENTO (PAYMENT_STATUS EM TB_PAYMENTS) N�O SEJA 'APROVADO'
-- TABELA: TB_RESERVATIONS
-- EVENTOS: INSERT E UPDATE
-- RELACIONAMENTO: TB_PAYMENTS.ID_RESERVATION -> TB_RESERVATIONS.ID
-- =================================================================
CREATE OR ALTER TRIGGER TRG_RESERVATION_STATUS_PAYMENT_APPROVED
ON TB_RESERVATIONS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        INNER JOIN TB_PAYMENTS P ON P.ID_RESERVATION = I.ID
        WHERE I.SITUATION = 'confirmada'
          AND P.PAYMENT_STATUS <> 'aprovado'
    )
    BEGIN
        RAISERROR('N�O � PERMITIDO DEFINIR O STATUS DA RESERVA COMO ''RESERVADA'' SEM QUE O STATUS DO PAGAMENTO SEJA ''APROVADO''.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 12: ATUALIZA��O DA QUANTIDADE DISPON�VEL EM TB_PACKAGES_DATES
-- OBJETIVO: REDUZIR O CAMPO QTD_AVAILABLE EM TB_PACKAGES_DATES EM 1
--           SEMPRE QUE UMA NOVA RESERVA FOR INSERIDA EM TB_RESERVATIONS
--           PARA A DATA DO PACOTE CORRESPONDENTE
-- TABELA: TB_RESERVATIONS
-- EVENTO: INSERT
-- RELACIONAMENTO: TB_RESERVATIONS.ID_PACKAGES_DATES -> TB_PACKAGES_DATES.ID
-- =================================================================
CREATE OR ALTER TRIGGER TRG_UPDATE_QTD_AVAILABLE
ON TB_RESERVATIONS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Checa antes de atualizar se h� vagas dispon�veis
    IF EXISTS (
        SELECT 1
        FROM TB_PACKAGES_DATES PD
        INNER JOIN INSERTED I ON PD.ID = I.ID_PACKAGES_DATES
        WHERE PD.QTD_AVAILABLE <= 0
    )
    BEGIN
        RAISERROR('N�O H� MAIS VAGAS DISPON�VEIS PARA ESTA DATA DE PACOTE.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- S� decrementa se havia vagas
    UPDATE PD
    SET QTD_AVAILABLE = QTD_AVAILABLE - 1
    FROM TB_PACKAGES_DATES PD
    INNER JOIN INSERTED I ON PD.ID = I.ID_PACKAGES_DATES
    WHERE PD.QTD_AVAILABLE > 0
END
GO

-- =================================================================
-- TRIGGER 13: BLOQUEIO DE EXCLUS�O DE DATAS DE PACOTES COM RESERVAS ATIVAS
-- OBJETIVO: IMPEDIR A EXCLUS�O DE UMA DATA DE PACOTE CASO EXISTA ALGUMA RESERVA VINCULADA A ELA
-- TABELA: TB_PACKAGES_DATES
-- EVENTO: DELETE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_BLOCK_DELETE_PACKAGE_DATE_WITH_RESERVATIONS
ON TB_PACKAGES_DATES
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM DELETED D
        INNER JOIN TB_RESERVATIONS R ON R.ID_PACKAGES_DATES = D.ID
    )
    BEGIN
        RAISERROR('N�O � PERMITIDO EXCLUIR UMA DATA DE PACOTE COM RESERVAS ATIVAS!', 16, 1)
        RETURN
    END

    DELETE FROM TB_PACKAGES_DATES
    WHERE ID IN (SELECT ID FROM DELETED)
END
GO

DISABLE TRIGGER TRG_UPDATE_RESERVATIONS_UPDATED_AT ON TB_RESERVATIONS;
go

-- =================================================================
-- TRIGGER 14: LIBERA��O DE VAGA EM DATA DE PACOTE AO CANCELAR RESERVA
-- OBJETIVO: INCREMENTAR QTD_AVAILABLE EM TB_PACKAGES_DATES AO CANCELAR OU EXCLUIR RESERVA
-- TABELA: TB_RESERVATIONS
-- EVENTO: UPDATE (CANCELAMENTO)
-- =================================================================
CREATE OR ALTER TRIGGER TRG_RELEASE_SPOT_ON_RESERVATION_CANCEL_UPDATE
ON TB_RESERVATIONS
AFTER UPDATE
AS
BEGIN
    -- Libera vaga s� para reservas que mudaram de N�O cancelada para cancelada

    SET NOCOUNT ON;

    UPDATE PD
    SET PD.QTD_AVAILABLE = PD.QTD_AVAILABLE + 1
    FROM TB_PACKAGES_DATES PD
    INNER JOIN INSERTED I ON PD.ID = I.ID_PACKAGES_DATES
    INNER JOIN DELETED D ON I.ID = D.ID
    WHERE I.SITUATION = 'cancelada' AND D.SITUATION <> 'cancelada';
END
GO


-- =================================================================
-- TRIGGER 15: BLOQUEIO DE RESERVAS EM DATAS J� PASSADAS
-- OBJETIVO: IMPEDIR CRIA��O DE RESERVAS PARA DATAS NO PASSADO
-- TABELA: TB_RESERVATIONS
-- EVENTO: INSERT
-- =================================================================
CREATE OR ALTER TRIGGER TRG_BLOCK_RESERVATION_ON_PAST_DATE
ON TB_RESERVATIONS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        INNER JOIN TB_PACKAGES_DATES PD ON I.ID_PACKAGES_DATES = PD.ID
        WHERE PD.[START_DATE] < CAST(GETDATE() AS DATE)
    )
    BEGIN
        RAISERROR('N�O � PERMITIDO RESERVAR PARA UMA DATA J� PASSADA.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 16: Atualiza status da reserva para 'confirmada' ao aprovar pagamento
-- OBJETIVO: Quando um pagamento for inserido ou atualizado para PAYMENT_STATUS = 'aprovado',
--           alterar automaticamente o campo SITUATION da reserva correspondente para 'confirmada'
-- TABELA: TB_PAYMENTS
-- EVENTOS: INSERT E UPDATE
-- RELACIONAMENTO: TB_PAYMENTS.ID_RESERVATION -> TB_RESERVATIONS.ID
-- =================================================================
CREATE OR ALTER TRIGGER TRG_PAYMENT_STATUS_CONFIRM_RESERVATION
ON TB_PAYMENTS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE R
    SET R.SITUATION = 'confirmada'
    FROM TB_RESERVATIONS R
    INNER JOIN INSERTED I ON R.ID = I.ID_RESERVATION
    WHERE I.PAYMENT_STATUS = 'aprovado'
      AND R.SITUATION <> 'confirmada';
END
GO

-- =================================================================
-- TRIGGER 17: Libera vaga s� para reservas deletadas que N�O estavam canceladas
-- OBJETIVO: IMPEDIR A DUPLICA��O DE QTD_AVAILABLE
-- TABELA: TB_RESERVATIONS
-- EVENTO: DELETE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_RELEASE_SPOT_ON_RESERVATION_CANCEL_DELETE
ON TB_RESERVATIONS
AFTER DELETE
AS
BEGIN

    SET NOCOUNT ON;

    -- Libera vaga s� para reservas deletadas que N�O estavam canceladas
    UPDATE PD
    SET PD.QTD_AVAILABLE = PD.QTD_AVAILABLE + 1
    FROM TB_PACKAGES_DATES PD
    INNER JOIN DELETED D ON PD.ID = D.ID_PACKAGES_DATES
    WHERE D.SITUATION <> 'cancelada';
END
GO
