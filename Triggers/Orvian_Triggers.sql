-- =================================================================
-- TRIGGER 1: Atualização de Data de Aprovação de Pagamento
-- Objetivo: Atualizar automaticamente o campo PAYMENT_APPROVED_AT quando o status do pagamento mudar para 'approved'
-- Tabela: TB_PAYMENTS
-- Evento: UPDATE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_SET_PAYMENT_APPROVED_AT ON TB_PAYMENTS
AFTER UPDATE 
AS BEGIN
    SET NOCOUNT ON
    UPDATE TB_PAYMENTS
SET PAYMENT_APPROVED_AT = GETUTCDATE()
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
-- TRIGGER 2: Validação de Datas
-- Objetivo: Garantir que a data de fim seja sempre maior que a data de início
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
CREATE OR ALTER TRIGGER TRG_PREVENT_PAST_DATES
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE START_DATE < CAST(GETUTCDATE() AS DATE))
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_QTD_AVAILABLE
ON TB_PACKAGES_DATES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE QTD_AVAILABLE < 0)
    BEGIN
        RAISERROR('A quantidade disponível deve ser maior ou igual que zero', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 5: Verificação de Capacidade Máxima de Viajantes
-- Objetivo: Impedir que o número de viajantes associados a cada pacote/data exceda a capacidade máxima do pacote (MAX_PEOPLE em TB_PACKAGES)
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
        RAISERROR('A QUANTIDADE DE VIAJANTES EXCEDE A CAPACIDADE MÁXIMA DO PACOTE.', 16, 1)
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_PACKAGE_PRICE
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_PACKAGE_FIELDS
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
CREATE OR ALTER TRIGGER TRG_VALIDATE_PACKAGE_DURATION
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
CREATE OR ALTER TRIGGER TRG_PREVENT_DELETE_WITH_ACTIVE_DATES
ON TB_PACKAGES
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM deleted d
        INNER JOIN TB_PACKAGES_DATES pd ON d.ID = pd.ID_PACKAGE
        WHERE pd.START_DATE >= CAST(GETUTCDATE() AS DATE)
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

-- =================================================================
-- TRIGGER 10: Validação de Compatibilidade entre Período das Datas e Duração do Pacote
-- Objetivo: Garantir que a diferença de dias entre START_DATE e END_DATE em TB_PACKAGES_DATES
--           seja compatível com o campo DURATION definido em TB_PACKAGES. Em caso de inconsistência,
--           a operação é cancelada e retorna erro.
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
            'A diferença entre START_DATE e END_DATE em TB_PACKAGES_DATES deve ser igual ao DURATION do pacote correspondente em TB_PACKAGES.',
            16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO

-- =================================================================
-- TRIGGER 11: VALIDAÇÃO DE STATUS DE RESERVA COM PAGAMENTO APROVADO
-- OBJETIVO: IMPEDIR QUE O STATUS DA RESERVA (SITUATION EM TB_RESERVATIONS) SEJA 'RESERVADA'
--           CASO O STATUS DO PAGAMENTO (PAYMENT_STATUS EM TB_PAYMENTS) NÃO SEJA 'APROVADO'
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
        RAISERROR('NÃO É PERMITIDO DEFINIR O STATUS DA RESERVA COMO ''RESERVADA'' SEM QUE O STATUS DO PAGAMENTO SEJA ''APROVADO''.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

-- =================================================================
-- TRIGGER 12: ATUALIZAÇÃO DA QUANTIDADE DISPONÍVEL EM TB_PACKAGES_DATES
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

    -- Checa antes de atualizar se há vagas disponíveis
    IF EXISTS (
        SELECT 1
        FROM TB_PACKAGES_DATES PD
        INNER JOIN INSERTED I ON PD.ID = I.ID_PACKAGES_DATES
        WHERE PD.QTD_AVAILABLE <= 0
    )
    BEGIN
        RAISERROR('NÃO HÁ MAIS VAGAS DISPONÍVEIS PARA ESTA DATA DE PACOTE.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    -- Só decrementa se havia vagas
    UPDATE PD
    SET QTD_AVAILABLE = QTD_AVAILABLE - 1
    FROM TB_PACKAGES_DATES PD
    INNER JOIN INSERTED I ON PD.ID = I.ID_PACKAGES_DATES
    WHERE PD.QTD_AVAILABLE > 0
END
GO

-- =================================================================
-- TRIGGER 13: BLOQUEIO DE EXCLUSÃO DE DATAS DE PACOTES COM RESERVAS ATIVAS
-- OBJETIVO: IMPEDIR A EXCLUSÃO DE UMA DATA DE PACOTE CASO EXISTA ALGUMA RESERVA VINCULADA A ELA
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
        RAISERROR('NÃO É PERMITIDO EXCLUIR UMA DATA DE PACOTE COM RESERVAS ATIVAS!', 16, 1)
        RETURN
    END

    DELETE FROM TB_PACKAGES_DATES
    WHERE ID IN (SELECT ID FROM DELETED)
END
GO

-- =================================================================
-- TRIGGER 14: LIBERAÇÃO DE VAGA EM DATA DE PACOTE AO CANCELAR RESERVA
-- OBJETIVO: INCREMENTAR QTD_AVAILABLE EM TB_PACKAGES_DATES AO CANCELAR OU EXCLUIR RESERVA
-- TABELA: TB_RESERVATIONS
-- EVENTO: UPDATE (CANCELAMENTO)
-- =================================================================
CREATE OR ALTER TRIGGER TRG_RELEASE_SPOT_ON_RESERVATION_CANCEL_UPDATE
ON TB_RESERVATIONS
AFTER UPDATE
AS
BEGIN
    -- Libera vaga só para reservas que mudaram de NÃO cancelada para cancelada

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
-- TRIGGER 15: BLOQUEIO DE RESERVAS EM DATAS JÁ PASSADAS
-- OBJETIVO: IMPEDIR CRIAÇÃO DE RESERVAS PARA DATAS NO PASSADO
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
        WHERE PD.[START_DATE] < CAST(GETUTCDATE() AS DATE)
    )
    BEGIN
        RAISERROR('NÃO É PERMITIDO RESERVAR PARA UMA DATA JÁ PASSADA.', 16, 1)
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
-- TRIGGER 17: Libera vaga só para reservas deletadas que NÃO estavam canceladas
-- OBJETIVO: IMPEDIR A DUPLICAÇÃO DE QTD_AVAILABLE
-- TABELA: TB_RESERVATIONS
-- EVENTO: DELETE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_RELEASE_SPOT_ON_RESERVATION_CANCEL_DELETE
ON TB_RESERVATIONS
AFTER DELETE
AS
BEGIN

    SET NOCOUNT ON;

    -- Libera vaga só para reservas deletadas que NÃO estavam canceladas
    UPDATE PD
    SET PD.QTD_AVAILABLE = PD.QTD_AVAILABLE + 1
    FROM TB_PACKAGES_DATES PD
    INNER JOIN DELETED D ON PD.ID = D.ID_PACKAGES_DATES
    WHERE D.SITUATION <> 'cancelada';
END
GO

-- =================================================================
-- TRIGGER 18: Atualização de Data de Cancelamento de Reserva
-- Objetivo: Atualizar automaticamente o campo CANCEL_DATE quando o status da reserva mudar para 'cancelada'
-- Tabela: TB_RESERVATIONS
-- Evento: UPDATE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_SET_RESERVATION_CANCEL_DATE
ON TB_RESERVATIONS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE TB_RESERVATIONS
    SET CANCEL_DATE = GETUTCDATE()
    FROM TB_RESERVATIONS R
        INNER JOIN INSERTED I ON R.ID = I.ID
        INNER JOIN DELETED D ON D.ID = I.ID
    WHERE I.SITUATION = 'cancelada'
      AND (D.SITUATION <> 'cancelada' OR D.SITUATION IS NULL);
END
GO

-- =================================================================
-- TRIGGER 19: Atualização de Data de Cancelamento de Reserva
-- Objetivo: Criar uma restrição para que o value_paid, obedeça como funciona
-- do valor total na aplicação.
-- Tabela: TB_PAYMENTS
-- Evento: INSERT E UPDATE
-- =================================================================
CREATE OR ALTER TRIGGER TRG_VALIDATE_VALUE_PAID
ON TB_PAYMENTS
AFTER INSERT, UPDATE
AS
BEGIN
    -- Declara variáveis para capturar os valores
    DECLARE @ValuePaid DECIMAL(10,2)
    DECLARE @ExpectedValue DECIMAL(10,2)
    DECLARE @ReservationId UNIQUEIDENTIFIER
    DECLARE @PaymentId UNIQUEIDENTIFIER
    DECLARE @Difference DECIMAL(10,2)

    -- Verifica cada pagamento alterado/inserido e calcula o valor esperado
    SELECT TOP 1
        @ValuePaid = I.VALUE_PAID,
        @ExpectedValue = ROUND((
            (P.PRICE * QV.QTD_VIAJANTES) -- APENAS travelers, SEM +1 do usuário
            * (1 - (
                COALESCE(PR1.DISCOUNT_PERCENT, 0)
                + COALESCE(PR2.DISCOUNT_PERCENT, 0)
                + CASE WHEN I.PAYMENT_METHOD = 'PIX' THEN 5 ELSE 0 END
              ) / 100.0)
            * (1 + COALESCE(I.TAX, 0) / 100.0)
        ), 2),
        @ReservationId = R.ID,
        @PaymentId = I.ID
    FROM INSERTED I
    INNER JOIN TB_RESERVATIONS R ON R.ID = I.ID_RESERVATION
    INNER JOIN TB_PACKAGES_DATES PD ON PD.ID = R.ID_PACKAGES_DATES
    INNER JOIN TB_PACKAGES P ON P.ID = PD.ID_PACKAGE
    LEFT JOIN TB_PROMOTIONS PR1 ON PR1.ID = P.ID_PROMOTION
    LEFT JOIN TB_PROMOTIONS PR2 ON PR2.ID = I.ID_PROMOTION
    CROSS APPLY (
        SELECT COUNT(*) AS QTD_VIAJANTES -- APENAS travelers, sem +1
        FROM TB_TRAVELERS T
        WHERE T.ID_RESERVATION = R.ID
    ) QV

    -- Calcula a diferença
    SET @Difference = ABS(@ValuePaid - @ExpectedValue)

    -- Se encontrou alguma discrepância maior que 1 centavo, exibe mensagem detalhada e faz rollback
    IF @Difference > 0.01
    BEGIN
        DECLARE @ErrorMessage NVARCHAR(1000)
        
        SET @ErrorMessage = 
            'VALOR INCORRETO! ' +
            'Payment ID: ' + CAST(@PaymentId AS NVARCHAR(36)) + ' | ' +
            'Reservation ID: ' + CAST(@ReservationId AS NVARCHAR(36)) + ' | ' +
            'Valor Pago: R$ ' + FORMAT(@ValuePaid, '0.00') + ' | ' +
            'Valor Esperado: R$ ' + FORMAT(@ExpectedValue, '0.00') + ' | ' +
            'Diferença: R$ ' + FORMAT(@Difference, '0.00') + ' | ' +
            'QTD_TRAVELERS: ' + CAST((SELECT COUNT(*) FROM TB_TRAVELERS T WHERE T.ID_RESERVATION = @ReservationId) AS NVARCHAR(10))
        
        RAISERROR(@ErrorMessage, 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO

-- =========================================================================
-- TRIGGER 20: TRG_VALIDATE_MAX_DISCOUNT
-- OBJETIVO: IMPEDIR QUE A SOMA DOS DESCONTOS (PROMOÇÃO DO PACOTE + CUPOM DO PAGAMENTO)
--           ULTRAPASSE 80% DO VALOR BRUTO DA RESERVA AO REALIZAR PAGAMENTO
--           (EVITA ABUSO DE DESCONTOS E GARANTE INTEGRIDADE DAS REGRAS DE NEGÓCIO)
-- =========================================================================
CREATE OR ALTER TRIGGER TRG_VALIDATE_MAX_DISCOUNT
ON TB_PAYMENTS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se algum pagamento inserido ou alterado está violando a regra de desconto máximo
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        INNER JOIN TB_RESERVATIONS R ON R.ID = I.ID_RESERVATION
        INNER JOIN TB_PACKAGES_DATES PD ON PD.ID = R.ID_PACKAGES_DATES
        INNER JOIN TB_PACKAGES P ON P.ID = PD.ID_PACKAGE
        LEFT JOIN TB_PROMOTIONS PR1 ON PR1.ID = P.ID_PROMOTION    -- Promoção vinculada ao pacote
        LEFT JOIN TB_PROMOTIONS PR2 ON PR2.ID = I.ID_PROMOTION    -- Cupom aplicado ao pagamento
        WHERE (COALESCE(PR1.DISCOUNT_PERCENT, 0) + COALESCE(PR2.DISCOUNT_PERCENT, 0)) > 80
    )
    BEGIN
        RAISERROR('A soma dos descontos das promoções não pode ultrapassar 80%% do valor bruto!', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
END
GO