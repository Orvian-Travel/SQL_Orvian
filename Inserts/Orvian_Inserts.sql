-- =========================================================================
-- SAMPLE INSERTS INTO TB_USERS COM CONSTRAINTS ATENDIDAS
-- =========================================================================
INSERT INTO TB_USERS (NAME, EMAIL, PASSWORD, PHONE, DOCUMENT, BIRTHDATE, ROLE, CREATED_AT, UPDATED_AT)
VALUES
	('Alice Johnson',  'alice.j@email.com',   'senha123', '(11) 91234-5678', '123.456.789-01', '1990-05-14', 'USER',      GETDATE(), GETDATE()),
	('Bob Williams',   'bob.w@email.com',     'senha123', '(21) 92345-6789', '234.567.890-12', '1985-11-23', 'ADMIN',     GETDATE(), GETDATE()),
	('Carol Smith',    'carol.s@email.com',   'senha123', '(31) 93456-7890', '345.678.901-23', '1992-07-12', 'ATENDENTE', GETDATE(), GETDATE()),
	('David Brown',    'david.b@email.com',   'senha123', '(41) 94567-8901', '456.789.012-34', '1983-03-29', 'USER',      GETDATE(), GETDATE()),
	('Eva Green',      'eva.g@email.com',     'senha123', '(51) 95678-9012', '567.890.123-45', '1994-12-05', 'USER',      GETDATE(), GETDATE()),
	('Frank Miller',   'frank.m@email.com',   'senha123', '(61) 96789-0123', 'AB123456',       '1982-06-30', 'ATENDENTE', GETDATE(), GETDATE()),
	('Grace Lee',      'grace.l@email.com',   'senha123', '(71) 97890-1234', 'BC234567',       '1996-09-18', 'USER',      GETDATE(), GETDATE()),
	('Henry Adams',    'henry.a@email.com',   'senha123', '(81) 98901-2345', '678.901.234-56', '1987-01-10', 'ADMIN',     GETDATE(), GETDATE()),
	('Irene Clark',    'irene.c@email.com',   'senha123', '(91) 99012-3456', '789.012.345-67', '1993-04-22', 'ATENDENTE', GETDATE(), GETDATE()),
	('Jack Turner',    'jack.t@email.com',    'senha123', '(12) 90123-4567', '890.123.456-78', '1989-08-15', 'USER',      GETDATE(), GETDATE());
GO

-- ===========================================================
-- insert para criar 20 usuarios, todos usando CPF como DOCUMENT
-- ===========================================================
INSERT INTO TB_USERS (NAME, EMAIL, DOCUMENT, PHONE, BIRTHDATE, PASSWORD) VALUES 
('Jennifer Clarice Baptista','jennifer_clarice_baptista@dbacomp.com','666.320.171-93','(86) 99279-8537','04/13/2007','SdFrECpWGY'),
('Pedro Henrique Ruan Matheus Campos','pedrohenriquecampos@saa.com','389.035.839-06','(44) 99795-6490','05/03/1978','PkgmgRsTqw'),
('Ruan César Galvão','ruancesargalvao@albap.com','130.704.389-54','(95) 98541-1439','05/11/1984','dSq4FTdUDx'),
('Manuela Ester Andrea Vieira','manuelaestervieira@abcautoservice.com','938.410.432-91','(82) 98627-7596','06/15/1970','6Kze1CME68'),
('Alícia Stefany Andrea da Cruz','alicia_dacruz@isometro.com','088.389.607-98','(61) 99939-4903','02/03/1961','eYE1H2N06Z'),
('Mariane Nicole Alessandra Nascimento','mariane_nascimento@oliveiracontabil.com','854.868.709-65','(31) 99934-3370','07/04/1987','9XycMy6BR2'),
('Cláudia Elisa Alves','claudiaelisaalves@tirel.com','191.624.876-47','(48) 99742-4869','04/10/1985','JxsxJWYoSc'),
('Bárbara Isabella Luiza Almada','barbara_isabella_almada@ambev.com','433.640.769-01','(27) 98871-8392','04/26/1976','ONGTcanTuz'),
('Pedro Henrique Nathan Cláudio da Rosa','pedro-darosa95@arysta.com','985.797.895-91','(85) 99747-8529','01/05/1976','NaBfN4mZwu'),
('Benjamin Breno Kaique Alves','benjamin.breno.alves@renovacao.com','261.461.439-44','(21) 98851-2826','10/06/1947','eCNopBKGat'),
('Isadora Aline Pinto','isadora.aline.pinto@iaru.com','858.238.306-10','(84) 99525-5629','05/05/2007','nuo0feY5kR'),
('Lara Raquel Gabrielly Ferreira','lara-ferreira83@geometrabte.com','819.544.648-51','(68) 99297-8528','03/02/2007','uzF5y6gqYB'),
('Hugo Osvaldo Melo','hugo_melo@cenia.com','113.821.894-43','(67) 98649-0159','12/05/1965','paJ9n34dWD'),
('Sônia Esther da Cunha','sonia_dacunha@glaudeimar.com','530.938.877-04','(99) 98190-8463','12/05/1988','S0kENGRByj'),
('Joana Carolina Fabiana Melo','joanacarolinamelo@wredenborg.com','710.033.854-94','(63) 98837-3539','02/07/1985','9zTmzchsMb'),
('Guilherme Benício Mendes','guilherme-mendes79@dvdja.com','038.301.990-74','(83) 99574-3183','03/03/2004','gsA84zGiKy'),
('Matheus Lucca Souza','matheus-souza92@jammer.com','148.202.081-52','(15) 99857-2753','04/01/2007','WefTXdDWay'),
('Martin Renato Peixoto','martin.renato.peixoto@fanger.com','649.712.299-06','(63) 98416-1825','08/07/1987','6BkgZcs39e'),
('Fabiana Alícia Barros','fabiana-barros70@torrez.com','108.955.290-41','(67) 98999-4403','06/02/1948','T38g5RGlRH'),
('Luiz Edson Pereira','luiz-pereira95@hubersuhner.com','743.695.258-70','(96) 99158-3132','03/03/1963','af5U5jBaBq')
GO

SELECT * FROM TB_USERS
GO

-- =========================================================================
-- SAMPLE INSERTS INTO TB_PACKAGES COM TODAS AS CONSTRAINTS ATENDIDAS
-- =========================================================================
INSERT INTO TB_PACKAGES (TITLE, DESCRIPTION_PACKAGE, DESTINATION, DURATION, PRICE, MAX_PEOPLE, CREATED_AT, UPDATED_AT)
VALUES
('Praias do Nordeste', 'Pacote de 7 dias nas melhores praias do Nordeste brasileiro.', 'Nordeste', 7, 3500.00, 30, GETDATE(), GETDATE()),

('Aventura na Chapada Diamantina', 'Trilhas, cachoeiras e aventura para quem ama natureza.', 'Chapada Diamantina', 5, 2200.00, 20, GETDATE(), GETDATE()),

('Férias em Gramado', 'Venha curtir o charme europeu do sul do Brasil em Gramado.', 'Gramado', 4, 1850.00, 25, GETDATE(), GETDATE()),

('Bonito Encantado', 'Conheça rios cristalinos e grutas em Bonito, MS.', 'Bonito', 6, 2900.00, 20, GETDATE(), GETDATE()),

('Rio de Janeiro Inesquecível', 'Visite o Cristo Redentor, Pão de Açúcar e praias.', 'Rio de Janeiro', 3, 1450.00, 50, GETDATE(), GETDATE()),

('Pantanal Selvagem', 'Safári fotográfico e experiências únicas no Pantanal.', 'Pantanal', 8, 4800.00, 18, GETDATE(), GETDATE()),

('Amazônia Profunda', 'Imersão ecológica na floresta Amazônica com guias locais.', 'Amazônia', 10, 4950.00, 15, GETDATE(), GETDATE()),

('Serra Gaúcha Gastronômica', 'Degustação de vinhos e culinária típica na serra gaúcha.', 'Serra Gaúcha', 3, 1600.00, 24, GETDATE(), GETDATE()),

('Ilha Grande dos Sonhos', 'Passeios de barco e trilhas em meio à natureza paradisíaca.', 'Ilha Grande', 5, 2100.00, 40, GETDATE(), GETDATE()),

('Lençóis Maranhenses Surreal', 'Explore o deserto das águas em um cenário único.', 'Lençóis Maranhenses', 6, 2650.00, 35, GETDATE(), GETDATE());


SELECT * FROM TB_PACKAGES;

-- =========================================================================
-- SAMPLE INSERTS INTO TB_PACKAGE_DATES
-- Cada linha segue os IDs da imagem e as DURATION, com datas a partir de 10/07/2025
-- =========================================================================
-- =========================================================================
-- SAMPLE INSERTS INTO TB_PACKAGE_DATES (corrigido com QTD_AVAILABLE)
-- IDs conforme imagem enviada, datas após hoje (09/07/2025), duração correta, QTD_AVAILABLE sugerido conforme exemplo dos pacotes
-- =========================================================================

INSERT INTO TB_PACKAGES_DATES (ID, ID_PACKAGE, START_DATE, END_DATE, QTD_AVAILABLE, CREATED_AT, UPDATED_AT)
VALUES
	(NEWID(), 'B6B18026-D1D7-453D-B5FB-0F73BFC9B5F0', '2025-07-15', '2025-07-21', 20, GETDATE(), GETDATE()), -- Bonito Encantado (6 dias)
	(NEWID(), '2FDD951A-C989-417C-BCE6-1C862C814F35', '2025-07-22', '2025-07-30', 18, GETDATE(), GETDATE()), -- Pantanal Selvagem (8 dias)
	(NEWID(), '559105C3-D16A-42B1-A6DB-52F0238174A2', '2025-08-01', '2025-08-08', 30, GETDATE(), GETDATE()), -- Praias do Nordeste (7 dias)
	(NEWID(), 'DD35D5BE-8D06-4886-9126-5C61BC9ED0D8', '2025-08-10', '2025-08-13', 50, GETDATE(), GETDATE()), -- Rio de Janeiro Inesquecível (3 dias)
	(NEWID(), '9661951B-F916-4A5F-B26D-7806FCDADDD4', '2025-08-15', '2025-08-20', 20, GETDATE(), GETDATE()), -- Aventura na Chapada Diamantina (5 dias)
	(NEWID(), 'C44E2DC7-96FB-4E9F-9F1F-95976DB6C4CC', '2025-08-22', '2025-08-26', 25, GETDATE(), GETDATE()), -- Férias em Gramado (4 dias)
	(NEWID(), '5E409536-788B-4742-802D-CCA413185E75', '2025-09-01', '2025-09-11', 15, GETDATE(), GETDATE()), -- Amazônia Profunda (10 dias)
	(NEWID(), 'E0408017-1D56-40D6-8289-E2CBD36816D0', '2025-09-12', '2025-09-18', 35, GETDATE(), GETDATE()), -- Lençóis Maranhenses Surreal (6 dias)
	(NEWID(), '948A084E-F0BF-4DF4-B15F-F629A441325A', '2025-09-20', '2025-09-25', 40, GETDATE(), GETDATE()); -- Ilha Grande dos Sonhos (5 dias)
GO

SELECT * FROM TB_PACKAGES_DATES
GO

-- ===========================================================
-- inserindo reservas no TB_RESERVATIONS usando ID real de TB_PACKAGE_DATES
-- ===========================================================
-- ===========================================================
-- inserindo reservas no TB_RESERVATIONS usando os NOVOS IDs de usuário e de TB_PACKAGE_DATES cedidos acima
-- ===========================================================

INSERT INTO TB_RESERVATIONS (ID_USER, ID_PACKAGES_DATES, RESERVATION_DATE, SITUATION) VALUES
	('539D77CA-0C61-4A8C-B7C1-09D3EA4F61C4', 'A55B2082-C4BF-4999-A1B1-148833CD2A5B', GETDATE(), 'confirmado'),
	('897AA4D9-4F45-42D1-AA59-0C6230E8D803', 'EAAD3BCA-9167-4316-890E-504723FB8EA1', GETDATE(), 'confirmado'),
	('EF64DB05-BCBF-4635-8059-11467CBB2217', '0FF16F99-86AE-4066-ADB4-6094C45A2622', GETDATE(), 'confirmado'),
	('299F8423-EB5D-40CB-939C-15924D257A3B', 'CE643D9A-6C67-44E6-A78C-634B8452D6A4', GETDATE(), 'confirmado'),
	('1AB53B66-A0A2-4516-9D7C-1D7F5FA20714', 'B0DFB333-34CE-4B1F-B37A-7BC18F4C115D', GETDATE(), 'confirmado'),
	('AC5854F4-E71A-4952-A884-1D94D16C3E90', '0575AD61-9D8A-4C62-8004-8ACBB19917E0', GETDATE(), 'confirmado'),
	('DE0AEA77-F48E-4399-9816-255842F2F4B2', 'A4D6F74D-2F08-41BB-8A57-B636534F2D75', GETDATE(), 'confirmado'),
	('35B5AD3E-0DEC-4055-902E-2ECF39A4DA26', '3F580A07-D982-4A24-81C7-D5019DF8E659', GETDATE(), 'confirmado'),
	('5F9A4A80-BCB0-44DD-9F5E-30BA0309B02D', '0F565BED-E6E4-4380-B38D-E057262B8F3A', GETDATE(), 'confirmado'),
	('3504CEAF-515F-453E-ADEA-34A3D30A6330', 'F89E5740-BA24-4B4A-80E1-E5BA1528D513', GETDATE(), 'confirmado'),
	('DC9456FD-6F49-4DB6-8ED5-35607079DB1D', 'A55B2082-C4BF-4999-A1B1-148833CD2A5B', GETDATE(), 'confirmado'),
	('F6096CE5-5D42-4339-967F-3CBBA7FC8169', 'EAAD3BCA-9167-4316-890E-504723FB8EA1', GETDATE(), 'confirmado'),
	('50D2F525-CECD-43BD-88BA-4CBB65B7541F', '0FF16F99-86AE-4066-ADB4-6094C45A2622', GETDATE(), 'confirmado'),
	('341FB88B-AF75-4816-B204-5906FFBDBFCC', 'CE643D9A-6C67-44E6-A78C-634B8452D6A4', GETDATE(), 'confirmado'),
	('DACB2521-AB24-4ED4-9393-5D36DE653B3D', 'B0DFB333-34CE-4B1F-B37A-7BC18F4C115D', GETDATE(), 'confirmado'),
	('AFDA1E72-0F29-423A-A5AC-5F27FE1BCF15', '0575AD61-9D8A-4C62-8004-8ACBB19917E0', GETDATE(), 'confirmado'),
	('95583CD8-3828-4003-853E-75FC3337D047', 'A4D6F74D-2F08-41BB-8A57-B636534F2D75', GETDATE(), 'confirmado'),
	('FA1C6D5F-A296-4A4B-BF8D-76E0C486A110', '3F580A07-D982-4A24-81C7-D5019DF8E659', GETDATE(), 'confirmado'),
	('C670ABBF-BF15-4AE7-8059-8E6511DC3B0D', '0F565BED-E6E4-4380-B38D-E057262B8F3A', GETDATE(), 'confirmado');
GO

-- Está com erro de propósito, da regra onde reserva só pode está confirmada se o pagamento for aprovado

INSERT INTO TB_RESERVATIONS (ID_USER, ID_PACKAGES_DATES, RESERVATION_DATE, SITUATION) VALUES
	('539D77CA-0C61-4A8C-B7C1-09D3EA4F61C4', 'A55B2082-C4BF-4999-A1B1-148833CD2A5B', GETDATE(), 'PENDENTE'),
	('897AA4D9-4F45-42D1-AA59-0C6230E8D803', 'EAAD3BCA-9167-4316-890E-504723FB8EA1', GETDATE(), 'PENDENTE'),
	('EF64DB05-BCBF-4635-8059-11467CBB2217', '0FF16F99-86AE-4066-ADB4-6094C45A2622', GETDATE(), 'PENDENTE'),
	('299F8423-EB5D-40CB-939C-15924D257A3B', 'CE643D9A-6C67-44E6-A78C-634B8452D6A4', GETDATE(), 'PENDENTE'),
	('1AB53B66-A0A2-4516-9D7C-1D7F5FA20714', 'B0DFB333-34CE-4B1F-B37A-7BC18F4C115D', GETDATE(), 'PENDENTE'),
	('AC5854F4-E71A-4952-A884-1D94D16C3E90', '0575AD61-9D8A-4C62-8004-8ACBB19917E0', GETDATE(), 'PENDENTE'),
	('DE0AEA77-F48E-4399-9816-255842F2F4B2', 'A4D6F74D-2F08-41BB-8A57-B636534F2D75', GETDATE(), 'PENDENTE'),
	('35B5AD3E-0DEC-4055-902E-2ECF39A4DA26', '3F580A07-D982-4A24-81C7-D5019DF8E659', GETDATE(), 'PENDENTE'),
	('5F9A4A80-BCB0-44DD-9F5E-30BA0309B02D', '0F565BED-E6E4-4380-B38D-E057262B8F3A', GETDATE(), 'PENDENTE'),
	('3504CEAF-515F-453E-ADEA-34A3D30A6330', 'F89E5740-BA24-4B4A-80E1-E5BA1528D513', GETDATE(), 'PENDENTE'),
	('DC9456FD-6F49-4DB6-8ED5-35607079DB1D', 'A55B2082-C4BF-4999-A1B1-148833CD2A5B', GETDATE(), 'PENDENTE'),
	('F6096CE5-5D42-4339-967F-3CBBA7FC8169', 'EAAD3BCA-9167-4316-890E-504723FB8EA1', GETDATE(), 'PENDENTE'),
	('50D2F525-CECD-43BD-88BA-4CBB65B7541F', '0FF16F99-86AE-4066-ADB4-6094C45A2622', GETDATE(), 'PENDENTE'),
	('341FB88B-AF75-4816-B204-5906FFBDBFCC', 'CE643D9A-6C67-44E6-A78C-634B8452D6A4', GETDATE(), 'PENDENTE'),
	('DACB2521-AB24-4ED4-9393-5D36DE653B3D', 'B0DFB333-34CE-4B1F-B37A-7BC18F4C115D', GETDATE(), 'PENDENTE'),
	('AFDA1E72-0F29-423A-A5AC-5F27FE1BCF15', '0575AD61-9D8A-4C62-8004-8ACBB19917E0', GETDATE(), 'PENDENTE'),
	('95583CD8-3828-4003-853E-75FC3337D047', 'A4D6F74D-2F08-41BB-8A57-B636534F2D75', GETDATE(), 'PENDENTE'),
	('FA1C6D5F-A296-4A4B-BF8D-76E0C486A110', '3F580A07-D982-4A24-81C7-D5019DF8E659', GETDATE(), 'PENDENTE'),
	('C670ABBF-BF15-4AE7-8059-8E6511DC3B0D', '0F565BED-E6E4-4380-B38D-E057262B8F3A', GETDATE(), 'PENDENTE');
GO

SELECT * FROM TB_RESERVATIONS
GO

-- ===========================================================
-- Inserindo no TB_RATING com os ID gerados nas reservas
-- ===========================================================
INSERT INTO TB_RATINGS (RATE, COMMENT, ID_RESERVE) VALUES 
	(5, 'Experiência maravilhosa, super recomendo!', '99629741-11CD-47C2-A1B9-020C419A6ABF'),
	(4, 'Viagem incrível e atendimento excelente.', 'B45F729E-9D27-4C1E-9B0D-0E39CDD6F7D1'),
	(5, 'Tudo perfeito! Voltarei mais vezes.', '0B4D050B-0684-46EE-B7B6-13A412831DD2'),
	(3, 'Gostei bastante, mas poderia ter mais opções de passeios.', '2D22E84A-DF7E-4B4F-B91B-1A76972E41C6'),
	(5, 'Simplesmente inesquecível, parabéns à equipe!', '9EDE2372-52E4-47B2-BEE3-214C46DAFF95'),
	(4, 'Muito bom, paisagens lindas, recomendo.', '0D7DAEF9-EA96-4680-862A-2DFDF1F2C506'),
	(5, 'Atendimento nota 10, superou expectativas.', '7B70E677-27F4-4E38-A106-2E3B8A2239E6'),
	(4, 'Passeios bem organizados e guias atenciosos.', 'F1736279-F226-4AA8-A06C-447D371A3F47'),
	(5, 'Viagem dos sonhos, só gratidão!', '532D4E47-16B4-4FE8-8E95-44A5E4FE0F80'),
	(3, 'Tudo certo, mas o transporte atrasou um pouco.', '9128F77A-5549-48A2-95A1-5478CA44AED5'),
	(4, 'Equipe prestativa e roteiro bem elaborado.', '40C25383-6580-4FEB-82F3-6D57FDF66713'),
	(5, 'Amei cada momento, recomendo para todos!', '015E5414-F301-45FE-9DCE-9B07EFC88BAE'),
	(5, 'Foi tudo incrível! Quero repetir logo.', 'B1F974A0-E989-4AB0-ABC1-ACE35091DB43'),
	(4, 'Ótima experiência, lugares lindos.', '7C1F1DB3-5EFF-4708-9A72-B64E5683D96E'),
	(5, 'Organização impecável, parabéns!', '49B15A92-14C1-4AD2-8028-BF1F911C0D8F'),
	(3, 'Gostei, mas esperava mais opções de lazer.', '04163FDD-F8D1-4BAB-9A20-C55463901178'),
	(4, 'Muito bom, atendimento excelente.', '8521B334-62D9-4B7B-8BFC-C6A108CF4AFA'),
	(5, 'Viagem perfeita, só elogios!', 'D15803D8-2D37-4A20-A50B-ED95E45EE6D4'),
	(5, 'Tudo maravilhoso, do início ao fim.', '0A95A0FE-9255-4ADE-9906-EDD933721BF4');
GO

SELECT * FROM TB_RATINGS
GO

-- ===========================================================
-- Inserindo 10 pagamentos válidos em TB_PAYMENTS conforme constraints fornecidas
-- ===========================================================

INSERT INTO TB_PAYMENTS (
    ID, VALUE_PAID, PAYMENT_METHOD, PAYMENT_STATUS, PAYMENT_APPROVED_AT, TAX, DISCOUNT, DISCOUNT_REASON, 
    INSTALLMENT, INSTALLMENT_AMOUNT, CREATED_AT, UPDATED_AT, ID_RESERVATION
) VALUES
	(NEWID(), 1200.00, 'crédito', 'aprovado', GETDATE(), 60.00, 100.00, 'Cupom BlackFriday', 3, 400.00, GETDATE(), GETDATE(), '99629741-11CD-47C2-A1B9-020C419A6ABF'),
	(NEWID(), 850.00, 'pix', 'aprovado', GETDATE(), 42.00, NULL, NULL, NULL, NULL, GETDATE(), GETDATE(), 'B45F729E-9D27-4C1E-9B0D-0E39CDD6F7D1'),
	(NEWID(), 980.00, 'débito', 'aprovado', GETDATE(), 49.00, 20.00, 'Desconto fidelidade', NULL, NULL, GETDATE(), GETDATE(), '0B4D050B-0684-46EE-B7B6-13A412831DD2'),
	(NEWID(), 2000.00, 'boleto', 'pendente', NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), GETDATE(), '2D22E84A-DF7E-4B4F-B91B-1A76972E41C6'),
	(NEWID(), 3000.00, 'pix', 'aprovado', GETDATE(), 120.00, 250.00, 'Cupom especial', 4, 750.00, GETDATE(), GETDATE(), '9EDE2372-52E4-47B2-BEE3-214C46DAFF95'),
	(NEWID(), 750.00, 'crédito', 'aprovado', GETDATE(), NULL, NULL, NULL, 1, 750.00, GETDATE(), GETDATE(), '0D7DAEF9-EA96-4680-862A-2DFDF1F2C506'),
	(NEWID(), 1600.00, 'crédito', 'aprovado', GETDATE(), NULL, 150.00, 'Promoção', 2, 800.00, GETDATE(), GETDATE(), '7B70E677-27F4-4E38-A106-2E3B8A2239E6'),
	(NEWID(), 2200.00, 'boleto', 'pendente', NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), GETDATE(), 'F1736279-F226-4AA8-A06C-447D371A3F47'),
	(NEWID(), 500.00, 'débito', 'aprovado', GETDATE(), 25.00, NULL, NULL, 1, 500.00, GETDATE(), GETDATE(), '532D4E47-16B4-4FE8-8E95-44A5E4FE0F80'),
	(NEWID(), 3100.00, 'pix', 'cancelado', NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), GETDATE(), '9128F77A-5549-48A2-95A1-5478CA44AED5');
GO

SELECT * FROM TB_PAYMENTS;

-- ===========================================================
-- Inserindo 20 viajantes, um para cada reserva, respeitando as constraints de email e CPF
-- ===========================================================
INSERT INTO TB_TRAVELERS (ID, NAME, EMAIL, CPF, BIRTHDATE, ID_RESERVATION, CREATED_AT, UPDATED_AT) VALUES
	(NEWID(), 'Ana Paula Souza', 'anapaula.souza1@email.com', '123.456.789-00', '1990-03-15', '99629741-11CD-47C2-A1B9-020C419A6ABF', GETDATE(), GETDATE()),
	(NEWID(), 'Bruno Henrique Lima', 'bruno.lima2@email.com', '234.567.890-11', '1988-07-23', 'B45F729E-9D27-4C1E-9B0D-0E39CDD6F7D1', GETDATE(), GETDATE()),
	(NEWID(), 'Carla Regina Silva', 'carla.silva3@email.com', '345.678.901-22', '1995-11-12', '0B4D050B-0684-46EE-B7B6-13A412831DD2', GETDATE(), GETDATE()),
	(NEWID(), 'Daniel Souza', 'daniel.souza4@email.com', '456.789.012-33', '1983-01-22', '2D22E84A-DF7E-4B4F-B91B-1A76972E41C6', GETDATE(), GETDATE()),
	(NEWID(), 'Elisa Andrade', 'elisa.andrade5@email.com', '567.890.123-44', '1992-05-10', '9EDE2372-52E4-47B2-BEE3-214C46DAFF95', GETDATE(), GETDATE()),
	(NEWID(), 'Felipe Oliveira', 'felipe.oliveira6@email.com', '678.901.234-55', '1987-09-18', '0D7DAEF9-EA96-4680-862A-2DFDF1F2C506', GETDATE(), GETDATE()),
	(NEWID(), 'Gabriela Araújo', 'gabriela.araujo7@email.com', '789.012.345-66', '2000-12-30', '7B70E677-27F4-4E38-A106-2E3B8A2239E6', GETDATE(), GETDATE()),
	(NEWID(), 'Henrique Cardoso', 'henrique.cardoso8@email.com', '890.123.456-77', '1985-06-27', 'F1736279-F226-4AA8-A06C-447D371A3F47', GETDATE(), GETDATE()),
	(NEWID(), 'Isabela Martins', 'isabela.martins9@email.com', '901.234.567-88', '1998-02-14', '532D4E47-16B4-4FE8-8E95-44A5E4FE0F80', GETDATE(), GETDATE()),
	(NEWID(), 'João Victor Ramos', 'joao.ramos10@email.com', '012.345.678-99', '1991-10-09', '9128F77A-5549-48A2-95A1-5478CA44AED5', GETDATE(), GETDATE()),
	(NEWID(), 'Karen Dias', 'karen.dias11@email.com', '111.222.333-44', '1996-04-05', '40C25383-6580-4FEB-82F3-6D57FDF66713', GETDATE(), GETDATE()),
	(NEWID(), 'Leonardo Mendes', 'leonardo.mendes12@email.com', '222.333.444-55', '1982-08-16', '015E5414-F301-45FE-9DCE-9B07EFC88BAE', GETDATE(), GETDATE()),
	(NEWID(), 'Marina Tavares', 'marina.tavares13@email.com', '333.444.555-66', '1997-07-21', 'B1F974A0-E989-4AB0-ABC1-ACE35091DB43', GETDATE(), GETDATE()),
	(NEWID(), 'Nicolas Farias', 'nicolas.farias14@email.com', '444.555.666-77', '1993-12-11', '7C1F1DB3-5EFF-4708-9A72-B64E5683D96E', GETDATE(), GETDATE()),
	(NEWID(), 'Olívia Cunha', 'olivia.cunha15@email.com', '555.666.777-88', '1989-03-03', '49B15A92-14C1-4AD2-8028-BF1F911C0D8F', GETDATE(), GETDATE()),
	(NEWID(), 'Paulo Noronha', 'paulo.noronha16@email.com', '666.777.888-99', '1994-10-25', '04163FDD-F8D1-4BAB-9A20-C55463901178', GETDATE(), GETDATE()),
	(NEWID(), 'Renata Gouveia', 'renata.gouveia17@email.com', '777.888.999-00', '1986-01-30', '8521B334-62D9-4B7B-8BFC-C6A108CF4AFA', GETDATE(), GETDATE()),
	(NEWID(), 'Samuel Rocha', 'samuel.rocha18@email.com', '888.999.000-11', '1999-05-13', 'D15803D8-2D37-4A20-A50B-ED95E45EE6D4', GETDATE(), GETDATE()),
	(NEWID(), 'Tatiane Amaral', 'tatiane.amaral19@email.com', '999.000.111-22', '1984-11-18', '0A95A0FE-9255-4ADE-9906-EDD933721BF4', GETDATE(), GETDATE()),
	(NEWID(), 'Vinícius Prado', 'vinicius.prado20@email.com', '000.111.222-33', '1990-06-02', '015E5414-F301-45FE-9DCE-9B07EFC88BAE', GETDATE(), GETDATE());
GO

SELECT * FROM TB_TRAVELERS;
