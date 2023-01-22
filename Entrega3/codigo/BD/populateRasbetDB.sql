-- -----------------------------------------------------
-- Indicacao da base de dados de trabalho
-- -----------------------------------------------------
USE rasbetDB;


-- -----------------------------------------------------
-- TABELAS DE USERS E NOTIFICACOES
-- -----------------------------------------------------


-- -----------------------------------------------------
-- Povoamento da tabela Utilizadores
-- -----------------------------------------------------
INSERT INTO utilizador(idutilizador, email, password, nome, datanascimento, nif, cc, endereco, telefone) VALUES
(1001, 'apostador@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Apostador RasBet', '2021-01-01', 999999999, 88888888, 'Rasbet Street', '999999999'),
(1002, 'vic@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Vicente Gonçalves Moreira', '2001-02-12', 999999999, 88888888, 'Rua do Vic, Nº100 2ºDTO', '999999999'),
(1003, 'sebastiao@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'D.Sebatião de Portugal', '1554-01-20', 999999999, 88888888, 'Portugal', '999999999'),
(2001, 'especialista@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Especialista', '2021-01-01', 999999999, 88888888, 'Rasbet Street', '999999999'),
(2002, 'jose@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'José Carvalho', '1990-12-31', 999999999, 88888888, 'Avenida dos Aliados, nº1', '999999999'),
(3001, 'admin@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Admin', '2021-01-01', 999999999, 88888888, 'Rasbet Street', '999999999');

-- -----------------------------------------------------
-- Povoamento da tabela Apostadores
-- -----------------------------------------------------
INSERT INTO apostador(utilizador_idutilizador, valorcarteira) VALUES
(1001, 0),
(1002, 500),
(1003, 0);
-- -----------------------------------------------------
-- Povoamento da tabela Especialista
-- -----------------------------------------------------
INSERT INTO especialista(utilizador_idutilizador) VALUES
(2001),
(2002);
-- -----------------------------------------------------
-- Povoamento da tabela Administrador
-- -----------------------------------------------------
INSERT INTO administrador(utilizador_idutilizador) VALUES
(3001);


-- -----------------------------------------------------
-- Povoamento da tabela Transacao
-- -----------------------------------------------------
INSERT INTO transacao(idtransacao, apostador_utilizador_idutilizador,valor,data,descricao) VALUES
(101, 1002, 300,'2021-09-20 10:20:35','MbWay'),
(102, 1002, -100,'2021-10-10 20:11:42','Transferência Bancária'),
(103, 1002, 300,'2021-10-16 18:47:10','MultiBanco');


-- -----------------------------------------------------
-- Povoamento da tabela Notificacao
-- -----------------------------------------------------
INSERT INTO notificacao(idnotificacao, mensagem) VALUES
(101, 'Se estás a ler isto, Parabéns! As notificações parecem estar a dar!'),
(102, 'Portugal Venceu!');

-- -----------------------------------------------------
-- Povoamento da tabela Apostador_has_notificacao
-- -----------------------------------------------------
INSERT INTO apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao,visto) VALUES
(1002, 101, False),
(1001, 102, False),
(1002, 102, False);

-- -----------------------------------------------------
-- Povoamento da tabela Promocao
-- -----------------------------------------------------
INSERT INTO promocao(idpromocao,ativa,descricao) VALUES
(101, False, 'Promoção de Natal!'),
(102, False, 'Promoção de Novo Utilizador'),
(103, False, 'Promoção de Páscoa'),
(104, True, 'Promoção de Ano Novo');












-- -----------------------------------------------------
-- TABELAS DE USERS E NOTIFICACOES
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Povoamento da tabela Desporto
-- -----------------------------------------------------
INSERT INTO desporto(iddesporto, nome, individual, empate) VALUES
(101, 'Futebol', False, True),
(102, 'Basketball', False, False),
(103, 'Ténis', True, False),
(104, 'MotoGP', True, False);


-- -----------------------------------------------------
-- Povoamento da tabela Competicao
-- -----------------------------------------------------
INSERT INTO competicao(idcompeticao, nome, desporto_iddesporto) VALUES
(101, 'Liga Portuguesa', 101),
(102, 'Liga Europa', 101),
(103, 'Liga dos Campeões', 101),
(201, 'Liga de Basketball', 102),
(301, 'Liga de Ténis', 103),
(401, 'Liga de MotoGP', 104);


-- -----------------------------------------------------
-- Povoamento da tabela Jogo
-- -----------------------------------------------------
INSERT INTO jogo(idjogo, starttime, completed, hometeam, awayteam, score, playerlist, winner, competicao_idcompeticao, desporto_iddesporto) VALUES
(10001, '2023-02-15 20:00:00', False, "Club Brugge", "Benfica", null, null, null, 103, 101),
(10002, '2023-02-22 20:00:00', False, "Inter", "FC Porto", null, null, null, 103, 101),
(10003, '2023-01-15 15:30:00', False, "Benfica", "Sporting", null, null, null, 101, 101),
(10004, '2023-01-15 15:30:00', False, "Braga", "Boavista", null, null, null, 101, 101),
(20001, '2022-10-21 00:30:00', False, "Milwaukee Bucks", "Philadelphia 76ers", null, null, null, 201, 102),
(20002, '2022-10-21 00:30:00', False, "LA Clippers", "LA Lakers", null, null, null, null, 102),
(30001, '2023-01-10 10:45:00', False, 'Carlos Alcaraz', 'Rafael Nadal', null, '["Carlos Alcaraz", "Rafael Nadal"]', null, 301, 103),
(30002, '2023-01-16 16:15:00', False, 'Rafael Nadal', 'Stefanos Tsitsipas', null, '["Rafael Nadal", "Stefanos Tsitsipas"]', null, null, 103),
(40001, '2023-02-22 09:45:00', False, 'Corrida Barcelona', null, null, '["Luca Marini", "Fabio Quartararo", "Maverick Vinales", "Takaaki Najagami", "Brad Binder"]', null, 401, 104),
(40002, '2023-02-28 11:15:00', False, 'Corrida Portimão', null, null, '["Fabio Quartararo", "Raul Fernandez", "Brad Binder", "Augusto Fernandez", "Takaaki Najagami"]', null, null, 104);

-- -----------------------------------------------------
-- Povoamento da tabela Resultados
-- -----------------------------------------------------
INSERT INTO resultado(idresultado, jogo_idjogo, nome) VALUES
(10001, 10001, "Club Brugge"), (10002, 10001, "Benfica"),  (10003, 10001, "Empate"),
(10004, 10002, "Inter"),       (10005, 10002, "FC Porto"), (10006, 10002, "Empate"),
(10007, 10003, "Benfica"),     (10008, 10003, "Sporting"), (10009, 10003, "Empate"),
(10010, 10004, "Braga"),       (10011, 10004, "Boavista"), (10012, 10004, "Empate"),

(10013, 20001, "Milwaukee Bucks"), (10014, 20001, "Philadelphia 76ers"), 
(10015, 20002, "LA Clippers"),     (10016, 20002, "LA Lakers"),

(10017, 30001, "Carlos Alcaraz"),  (10018, 30001, "Rafael Nadal"),
(10019, 30002, "Rafael Nadal"),    (10020, 30002, "Stefanos Tsitsipas"),

(10021, 40001, "Luca Marini"),        (10022, 40001, "Fabio Quartararo"),  (10023, 40001, "Maverick Vinales"),   (10024, 40001, "Takaaki Najagami"),  (10025, 40001, "Brad Binder"),
(10026, 40002, "Fabio Quartararo"),   (10027, 40002, "Raul Fernandez"),    (10028, 40002, "Brad Binder"),        (10029, 40002, "Augusto Fernandez"), (10030, 40002, "Takaaki Najagami");

-- -----------------------------------------------------
-- Povoamento da tabela Cota
-- -----------------------------------------------------
INSERT INTO cota(resultado_idresultado, especialista_utilizador_idutilizador, cota) VALUES
(10001, 2001, null), (10002, 2001, null), (10003, 2001, null), (10001, 2002, 1.4), (10002, 2002, 3.1), (10003, 2002, 2.5), 
(10004, 2001, null), (10005, 2001, null), (10006, 2001, null), (10004, 2002, 1.4), (10005, 2002, 3.1), (10006, 2002, 2.5),
(10007, 2001, null), (10008, 2001, null), (10009, 2001, null), (10007, 2002, 1.4), (10008, 2002, 3.1), (10009, 2002, 2.5),
(10010, 2001, null), (10011, 2001, null), (10012, 2001, null), (10010, 2002, 1.4), (10011, 2002, 3.1), (10012, 2002, 2.5),

(10013, 2001, 1.1), (10014, 2001, 1.3),
(10015, 2001, 1), (10016, 2001, 1.5), 

(10017, 2001, 1.2), (10018, 2001, 1.7),
(10019, 2001, 1.8), (10020, 2001, 2), 

(10021, 2001, null), (10022, 2001, null), (10023, 2001, null), (10024, 2001, null), (10025, 2001, null),
(10021, 2002, 1.1),  (10022, 2002, 2.2),  (10023, 2002, 2.7),  (10024, 2002, 6),    (10025, 2002, 3.7),
(10026, 2001, null), (10027, 2001, null), (10028, 2001, null), (10029, 2001, null), (10030, 2001, null),
(10026, 2002, 1.1),  (10027, 2002, 2.2),  (10028, 2002, 2.7),  (10029, 2002, 6),    (10030, 2002, 3.7);




-- -----------------------------------------------------
-- Povoamento da tabela especialista_has_desporto
-- -----------------------------------------------------
INSERT INTO especialista_has_desporto(especialista_utilizador_idutilizador, desporto_iddesporto) VALUES
(2001, 101), (2001, 102), (2001, 103), (2001, 104),
(2002, 101), (2002, 104);


-- -----------------------------------------------------
-- Povoamento da tabela jogo_has_apostador
-- -----------------------------------------------------
INSERT INTO jogo_has_apostador(jogo_idjogo, apostador_utilizador_idutilizador) VALUES
(10001, 1001);





-- -----------------------------------------------------
-- Povoamento da tabela Aposta
-- -----------------------------------------------------
INSERT INTO aposta(idaposta, apostador_utilizador_idutilizador, simples, valor, data, estado, numApostas, cota) VALUES
(10001, 1001, True, 15, "2022-11-20 18:40:21","Aberta", 1, 1.4),
(10002, 1001, False, 30, "2022-11-22 10:23:54","Aberta", 2, 4.34),
(10003, 1002, True, 100, "2022-11-18 16:52:21","Aberta", 1, 2.2);


-- -----------------------------------------------------
-- Povoamento da tabela aposta_has_resultado
-- -----------------------------------------------------
INSERT INTO aposta_has_resultado(aposta_idaposta, resultado_idresultado) VALUES
(10001, 10010),
(10002, 10014),
(10002, 10015),
(10003, 10022);

