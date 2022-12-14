-- -----------------------------------------------------
-- PRODEDURES
-- -----------------------------------------------------
USE rasbetDB;


-- -----------------------------------------------------
-- PRODEDURES USERS
-- -----------------------------------------------------
DELIMITER &&
CREATE PROCEDURE loginUtilizador(IN email VARCHAR(64),IN password CHAR(64))
BEGIN
SELECT json_object('email', email,'nome', nome,'datanascimento', datanascimento,'nif', nif,'cc', cc,'endereco', endereco,'telefone', telefone,
		'valorcarteira', valorcarteira, 'idapostador', aps.utilizador_idutilizador, 'idespecialista', esp.utilizador_idutilizador,
        'idadministrador', adm.utilizador_idutilizador) AS jsonStr
		FROM utilizador AS usr
	LEFT JOIN apostador AS aps ON aps.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN especialista AS esp ON esp.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN administrador AS adm ON adm.utilizador_idutilizador = usr.idutilizador
    WHERE usr.email=email AND usr.password=password;
END &&


CREATE PROCEDURE getUtilizadorInfo(IN idUsr INT)
BEGIN
SELECT json_object('email', email,'nome', nome,'datanascimento', datanascimento,'nif', nif,'cc', cc,'endereco', endereco,'telefone', telefone,
		'valorcarteira', valorcarteira, 'idapostador', aps.utilizador_idutilizador, 'idespecialista', esp.utilizador_idutilizador,
        'idadministrador', adm.utilizador_idutilizador) AS jsonStr
		FROM utilizador AS usr
	LEFT JOIN apostador AS aps ON aps.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN especialista AS esp ON esp.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN administrador AS adm ON adm.utilizador_idutilizador = usr.idutilizador
    WHERE usr.idutilizador=idUsr;
END &&


CREATE PROCEDURE createUser(IN email VARCHAR(64), IN password CHAR(64), IN nome VARCHAR(64), IN datanascimento DATE,
							IN nif VARCHAR(16), IN cc VARCHAR(16), IN endereco VARCHAR(64), telefone VARCHAR(64),IN tipo VARCHAR(16))
BEGIN
	DECLARE newId INT;

	START TRANSACTION;
    
	INSERT INTO utilizador(email,password,nome,datanascimento,nif,cc,endereco,telefone) VALUES 
	(email,password,nome,datanascimento,nif,cc,endereco,telefone);

	SET newId = last_insert_id();

	CASE
		WHEN tipo = 'apostador' THEN 
			INSERT INTO apostador(utilizador_idutilizador,valorcarteira) VALUES (newID,0);
		WHEN tipo = 'especialista' THEN 
			INSERT INTO especialista(utilizador_idutilizador) VALUES (newID);
		WHEN tipo = 'administrador' THEN 
			INSERT INTO administador(utilizador_idutilizador) VALUES (newID);
		ELSE ROLLBACK;
	END CASE;

	COMMIT;

	CALL getUtilizadorInfo(newId); 
END &&
                

CREATE PROCEDURE updateUser(IN idUsr INT, IN email VARCHAR(64), IN nome VARCHAR(64), IN endereco VARCHAR(64), telefone VARCHAR(64))
BEGIN

	UPDATE utilizador AS u SET u.email = email, u.nome = nome, u.endereco = endereco, u.telefone = telefone
		WHERE u.idutilizador = idUsr;
        
	CALL getUtilizadorInfo(idUsr);

END &&


CREATE PROCEDURE getHashedPassword(IN idUsr INT)
BEGIN

	SELECT JSON_OBJECT('hashedpassword',password) AS jsonStr FROM utilizador WHERE utilizador.idutilizador = idUsr;

END &&


CREATE PROCEDURE updateUserPassword(IN idUsr INT,IN newPass CHAR(64))
BEGIN

	UPDATE utilizador AS u SET u.password = newPass
		WHERE u.idutilizador = idUsr;

END &&



-- -----------------------------------------------------
-- PRODEDURES GETS
-- -----------------------------------------------------
CREATE PROCEDURE getAllAvailableGames()
BEGIN

DROP TEMPORARY TABLE IF EXISTS tmp;
CREATE TEMPORARY TABLE tmp (idresultado int,jogo_idjogo int,nome varchar(64), cota float);

INSERT INTO tmp (idresultado,jogo_idjogo,nome,cota)
SELECT idresultado,jogo_idjogo,nome, avg(cota) as cota
        FROM resultado as result
        INNER JOIN cota ON cota.resultado_idresultado = result.idresultado
        GROUP BY idresultado;
        
SELECT json_object('idjogo', idjogo,'starttime', starttime,'completed', completed,'hometeam', hometeam,'awayteam', awayteam,'score', score,'playerlist', playerlist,
		'winner', winner, 'idcompeticao', competicao_idcompeticao, 'iddesporto', desporto_iddesporto,
        'resultados', JSON_ARRAYAGG(JSON_OBJECT('idresultado', idresultado,'nome',nome,'cota',cota ))) AS jsonStr
        FROM jogo
        INNER JOIN tmp as result ON result.jogo_idjogo = idjogo
		WHERE completed = false
        GROUP BY idjogo;
END &&


CREATE PROCEDURE getAllAvailableGamesForEspecialista(IN idEsp INT)
BEGIN
SELECT json_object('idjogo', idjogo,'starttime', starttime,'completed', completed,'hometeam', hometeam,'awayteam', awayteam,'score', score,'playerlist', playerlist,
		'winner', winner, 'idcompeticao', competicao_idcompeticao, 'iddesporto', desporto_iddesporto,
        'resultados', JSON_ARRAYAGG(JSON_OBJECT('idresultado', idresultado,'nome',nome,'cota',cota ))) AS jsonStr
        FROM jogo
        INNER JOIN resultado as result ON result.jogo_idjogo = jogo.idjogo
        INNER JOIN cota on cota.resultado_idresultado = result.idresultado
		WHERE completed = false AND cota.especialista_utilizador_idutilizador = idEsp
        GROUP BY idjogo;
END &&


CREATE PROCEDURE getAllSports()
BEGIN
        
SELECT json_object('iddesporto', iddesporto,'nome', nome,'individual', individual,'empate', empate) AS jsonStr FROM desporto;
	
END &&


CREATE PROCEDURE getAllCompetitions()
BEGIN
        
SELECT json_object('idcompeticao', idcompeticao,'nome', nome,'iddesporto', desporto_iddesporto) AS jsonStr FROM competicao;
	
END &&


CREATE PROCEDURE getHistoricoTransacao(IN id int)
BEGIN
	SELECT json_object('data',data,'descricao',descricao,'valor',valor) AS jsonStr FROM transacao
		WHERE apostador_utilizador_idutilizador = id
		ORDER BY data DESC;
END &&


CREATE PROCEDURE getHistoricoApostas(IN id int)
BEGIN
	SELECT JSON_OBJECT('data',ap.data,'valor',ap.valor,'simples',ap.simples,'estado',ap.estado,'resultados',JSON_ARRAYAGG(JSON_OBJECT('nome',nome,'hometeam',hometeam,'awayteam',awayteam))) as jsonStr
	FROM aposta AS ap
		INNER JOIN aposta_has_resultado AS apR ON ap.idaposta = apR.aposta_idaposta
        INNER JOIN resultado AS res ON res.idresultado = apR.resultado_idresultado
        INNER JOIN jogo ON jogo.idjogo = res.jogo_idjogo
		WHERE ap.apostador_utilizador_idutilizador = id
        GROUP BY ap.idaposta
        ORDER BY ap.data DESC;
END&&


-- -----------------------------------------------------
-- PRODEDURES UPDATES
-- -----------------------------------------------------
CREATE PROCEDURE updateCarteira(IN id int,IN valor float,IN descricao VARCHAR(64))
BEGIN
	DECLARE actValor FLOAT;
    DECLARE success boolean default True;
    DECLARE userInfo varchar(2048);
    START TRANSACTION;
    
	INSERT INTO transacao(valor,data,descricao,apostador_utilizador_idutilizador) VALUES
	(valor,now(),descricao,id);

	UPDATE apostador SET apostador.valorcarteira = apostador.valorcarteira + valor
		WHERE apostador.utilizador_idutilizador = id;
        
	SELECT valorcarteira INTO actValor FROM apostador
		WHERE apostador.utilizador_idutilizador = id;
    
    IF actValor < 0 
    THEN ROLLBACK; SET success = False; 
    ELSE COMMIT;
    END IF;

	SELECT json_object('user',json_object('email', email,'nome', nome,'datanascimento', datanascimento,'nif', nif,'cc', cc,'endereco', endereco,'telefone', telefone,
		'valorcarteira', valorcarteira, 'idapostador', aps.utilizador_idutilizador, 'idespecialista', esp.utilizador_idutilizador,
        'idadministrador', adm.utilizador_idutilizador),'success',success) AS jsonStr
		FROM utilizador AS usr
	LEFT JOIN apostador AS aps ON aps.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN especialista AS esp ON esp.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN administrador AS adm ON adm.utilizador_idutilizador = usr.idutilizador
    WHERE usr.idutilizador=id;
END &&

CREATE PROCEDURE updateOdds(IN idesp INT, IN idOdds JSON)
BEGIN
    DECLARE i int default 0;
    DECLARE _value JSON;
    DECLARE _key int default 0;

    START TRANSACTION;
    
    WHILE i < JSON_LENGTH(idOdds) DO
        SELECT JSON_EXTRACT(idOdds, CONCAT('$[',i,']')) INTO _value; -- -{"id": "1001", "value": "2"}
        SELECT JSON_UNQUOTE(JSON_EXTRACT(_value, '$.id')) INTO _key;
        UPDATE cota AS c SET c.cota=JSON_UNQUOTE(JSON_EXTRACT(_value, '$.value'))
        WHERE c.especialista_utilizador_idutilizador=idesp AND c.resultado_idresultado=_key;
        SET i = i + 1;
    END WHILE;
    COMMIT;
END &&





-- -----------------------------------------------------
-- PRODEDURES CREATE
-- -----------------------------------------------------

DELIMITER &&
CREATE PROCEDURE criaAposta(IN iduser INT,IN idresultados JSON, IN simples BOOLEAN,IN valor FLOAT)
BEGIN
    DECLARE i int default 0;
    DECLARE j int default 0;
    DECLARE actIdResult INT;
    DECLARE idAposta int;
    DECLARE valorCota FLOAT default 1;
    DECLARE aux FLOAT default 1;
    
	DROP TEMPORARY TABLE IF EXISTS temp;
	CREATE TEMPORARY TABLE temp (idresultado int,jogo_idjogo int,nome varchar(64), cota float);
	INSERT INTO temp (idresultado,jogo_idjogo,nome,cota)
	SELECT idresultado,jogo_idjogo,nome, avg(cota) as cota
			FROM resultado as result
			INNER JOIN cota ON cota.resultado_idresultado = result.idresultado
			GROUP BY result.idresultado;
        
    START TRANSACTION;
    
	IF simples = 1 THEN
    
		SELECT JSON_EXTRACT(idresultados,CONCAT('$[',0,']')) INTO actIdResult;
		SELECT cota FROM temp WHERE temp.idresultado = actIdResult INTO valorCota;
	
    ELSE
		WHILE j < JSON_LENGTH(idresultados) DO
		
			SELECT JSON_EXTRACT(idresultados,CONCAT('$[',j,']')) INTO actIdResult;
            SELECT cota FROM temp WHERE temp.idresultado = actIdResult INTO aux;
            SET valorCota = valorCota * aux;
            SET j = j + 1;
		END WHILE;
	END IF;
	
	INSERT aposta(simples,valor,data,apostador_utilizador_idutilizador,estado, numApostas, cota) VALUES
                (simples,valor,now(),iduser,'Aberta', JSON_LENGTH(idresultados), valorCota);
    SET idaposta = last_insert_id();
    WHILE i < JSON_LENGTH(idresultados) DO
    
         SELECT JSON_UNQUOTE(JSON_EXTRACT(idresultados,CONCAT('$[',i,']'))) INTO actIdResult;
         INSERT aposta_has_resultado(aposta_idaposta,resultado_idresultado) VALUES
             (idaposta,actIdResult);
        SELECT i + 1 INTO i;
    END WHILE;
    COMMIT;
END &&
-- -----------------------------------------------------
-- PRODEDURES NOTIFICATION
-- -----------------------------------------------------
DELIMITER &&
CREATE PROCEDURE mandarNotificacoes(IN idAdmin INT, IN msg VARCHAR(256), IN listaUsers JSON)
BEGIN
	DECLARE i int default 0;
    DECLARE utilizador int;
    DECLARE idNotif int;

    START TRANSACTION;

	INSERT notificacao(mensagem, administrador_utilizador_idutilizador) VALUES (msg, idAdmin);
    SET idNotif = last_insert_id();
    
    WHILE i < JSON_LENGTH(listaUsers) DO

		SELECT JSON_UNQUOTE(JSON_EXTRACT(listaUsers, CONCAT('$[',i,']'))) INTO utilizador;
		INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (utilizador, idNotif, 0);
		SET i = i + 1;
	END WHILE;
	COMMIT;
END &&



DELIMITER &&
CREATE PROCEDURE apostasJogo(IN idGame INT)
BEGIN
	SELECT json_object('data',ap.data,'valor',ap.valor,'simples',ap.simples,'estado',ap.estado,'resultados',JSON_OBJECT('nome',nome,'hometeam',hometeam,'awayteam',awayteam)) AS jsonStr
		FROM aposta AS ap
        JOIN aposta_has_resultado AS aps ON ap.idaposta= aps.aposta_idaposta
        JOIN resultado AS res ON res.idresultado = aps.resultado_idresultado
        JOIN jogo ON jogo.idjogo = res.jogo_idjogo
        WHERE jogo.idjogo = idGame;
END &&



DELIMITER &&
CREATE PROCEDURE terminaJogo(IN idAdmin INT, IN msg VARCHAR(256), IN winnerName VARCHAR(64), IN idGame INT, IN newscore VARCHAR(16))
BEGIN
    DECLARE i int default 0;
    DECLARE idNotif int default 1;
    DECLARE utilizador int;
    DECLARE numRes int default 1;
    DECLARE x int default 0;
    DECLARE y int default 0;
	DECLARE nomeT VARCHAR(64);
    DECLARE winnerT VARCHAR(64);
    DECLARE idApostador int default 0;
    DECLARE valorAposta int default 0;
    DECLARE valorCota int default 0;

	START TRANSACTION;

	DROP TABLE IF EXISTS tabela;
    DROP TABLE IF EXISTS linha;

    -- encerra o jogo
    UPDATE jogo SET jogo.completed=1, jogo.winner=winnerName, jogo.score=newscore WHERE jogo.idjogo= idGame;
    
    CREATE TABLE tabela AS
    SELECT * FROM aposta
        JOIN aposta_has_resultado AS aps ON aposta.idaposta= aps.aposta_idaposta
        JOIN resultado AS res ON res.idresultado = aps.resultado_idresultado
        JOIN jogo ON jogo.idjogo = res.jogo_idjogo
        WHERE jogo.idjogo = idGame;
	
	INSERT notificacao(mensagem, administrador_utilizador_idutilizador) VALUES (CONCAT("Aposta (", msg, "): Ganhou"), idAdmin), (CONCAT("Aposta (", msg, "): Perdeu"), idAdmin), (CONCAT("Aposta (", msg, "): Acertou"), idAdmin);
    SET idNotif = last_insert_id();

    SELECT COUNT(*) FROM tabela AS Y INTO numRes;

    WHILE i < numRes DO

        CREATE TABLE linha AS (SELECT * FROM tabela LIMIT 0, 1);
        SELECT winner FROM linha into winnerT;
        SELECT nome FROM linha into nomeT;
        SELECT simples FROM linha into x;
        SELECT idaposta FROM linha into y;
		SELECT apostador_utilizador_idutilizador FROM linha into idApostador;
        SELECT valor FROM linha into valorAposta;
        SELECT cota FROM linha into valorCota;

        IF winnerT = nomeT THEN

            IF x = 1 THEN
                
                UPDATE aposta SET aposta.estado='Fechada', aposta.numApostas = 0 WHERE aposta.idaposta=y;
                INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif, 0);
                CALL updateCarteira(idApostador, valorAposta * valorCota, CONCAT("Aposta (", msg, "): Ganhou ", valorAposta * valorCota));

            ELSE
                (SELECT numApostas FROM linha LIMIT i, 1) into x;

                IF x > 0 THEN
                    UPDATE aposta SET aposta.numApostas = aposta.numApostas - 1 WHERE aposta.idaposta=y;
                    INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif + 2, 0);
                    SET x = x - 1;
				END IF;

				IF x = 0 THEN
					UPDATE aposta SET aposta.estado='Fechada', aposta.numApostas = -1 WHERE aposta.idaposta=y;
                    INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif, 0);
                    CALL updateCarteira(idApostador, valorAposta * valorCota, CONCAT("Aposta (", msg, "): Ganhou ", valorAposta * valorCota));
                END IF;
            END IF;
        ELSE
            UPDATE aposta SET aposta.estado='Fechada', aposta.numApostas = -1 WHERE aposta.idaposta=y;
            INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif + 1, 0);
        END IF;
		DROP TABLE linha;
        SET i = i + 1;

    END WHILE;
	DROP TABLE tabela;
    COMMIT;
END &&


-- Com o id de um user retorna as notificações desse User
DELIMITER &&
CREATE PROCEDURE getAllUsernotificacoes(IN idUser INT)
BEGIN
SELECT JSON_OBJECT("idnotificacao",notificacao_idnotificacao,"descricao",notificacao.mensagem, "visto", visto) AS jsonStr
FROM apostador_has_notificacao 
INNER JOIN notificacao
WHERE apostador_utilizador_idutilizador=idUser AND notificacao_idnotificacao=notificacao.idnotificacao;
END &&

-- Altera o visto da notificação para 1 depois de visto
DELIMITER &&
CREATE PROCEDURE changeVisto(IN idUser INT, IN idNot INT)
BEGIN
UPDATE apostador_has_notificacao
SET visto=1
WHERE apostador_utilizador_idutilizador=idUser AND notificacao_idnotificacao=idNOT AND visto=0;
END &&

-- -----------------------------------------------------
-- PRODEDURES PROMOÇÕES
-- -----------------------------------------------------
DELIMITER &&
CREATE PROCEDURE descPromocao(IN idProm INT)
BEGIN
SELECT JSON_OBJECT("idProm", promocao.idpromocao,"descricao", promocao.descricao) AS jsonStr
FROM promocao
WHERE idpromocao = idProm AND ativa=1;
END &&

DELIMITER &&
CREATE PROCEDURE onPromocao(IN idProm INT)
BEGIN
UPDATE promocao
SET ativa = 1
WHERE idpromocao = idProm AND ativa = 0;
END &&

DELIMITER &&
CREATE PROCEDURE offPromocao(IN idProm INT)
BEGIN
UPDATE promocao
SET ativa = 0
WHERE idpromocao = idProm AND ativa = 1;
END &&






















-- ----------------------------------------------------
-- API
-- ---------------------------------------------------
CREATE PROCEDURE apiNewEspecialista(IN id Int,IN nome VARCHAR(64))
BEGIN    
	DECLARE idItr int;
    DECLARE done INT DEFAULT 0;
    DECLARE itrDesp CURSOR FOR SELECT iddesporto from desporto;
    DECLARE itrResult CURSOR FOR SELECT idresultado from resultado;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
	INSERT INTO utilizador(idutilizador,email,password,nome,datanascimento,nif,cc,endereco,telefone) VALUES 
	(id,concat(nome,'@gmail.com'),'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',nome,'1980-01-01','999999999','999999999',concat(nome,' Street'),'999999999');
	INSERT INTO especialista(utilizador_idutilizador) VALUES (id);
    
    OPEN itrDesp;
    FETCH itrDesp INTO idItr;
    WHILE (done = 0) DO    
		INSERT INTO especialista_has_desporto(especialista_utilizador_idutilizador,desporto_iddesporto) VALUES (id,idItr);
        FETCH itrDesp INTO idItr;
	END WHILE;
    CLOSE itrDesp;
    
    SET done = 0;
	OPEN itrResult;
    FETCH itrResult INTO idItr;
    WHILE (done = 0) DO    
		INSERT INTO cota(especialista_utilizador_idutilizador,resultado_idresultado,cota) VALUES (id,idItr,null);
        FETCH itrResult INTO idItr;
	END WHILE;
    CLOSE itrResult;
END &&


CREATE PROCEDURE apiSetCota(IN idEsp Int,IN idResult INT,IN cota float)
BEGIN    
	UPDATE cota SET cota.cota = cota
		WHERE especialista_utilizador_idutilizador = idEsp AND resultado_idresultado = idResult;
END &&


CREATE PROCEDURE apiNewJogoFutebol(IN idjogo Int,IN hometeam VARCHAR(64),IN awayteam VARCHAR(64),IN starttime DATETIME,IN completed boolean,resultados JSON)
BEGIN        
	DECLARE idRes INT;
    DECLARE nomeRes VARCHAR(64);
    DECLARE i INT DEFAULT 0;
    DECLARE actIdEsp int;
    DECLARE done INT DEFAULT 0;
    DECLARE itr CURSOR FOR SELECT utilizador_idutilizador from especialista;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	INSERT INTO jogo(idjogo,hometeam,awayteam,starttime,completed,desporto_iddesporto) VALUES 
	(idjogo,hometeam,awayteam,starttime,completed,101);
    
    WHILE i < JSON_LENGTH(resultados) DO
         SELECT JSON_UNQUOTE(JSON_EXTRACT(resultados,CONCAT('$[',i,'].idRes'))) INTO idRes;
         SELECT JSON_UNQUOTE(JSON_EXTRACT(resultados,CONCAT('$[',i,'].nome'))) INTO nomeRes;
         INSERT INTO resultado(idresultado,jogo_idjogo,nome) VALUES 
			(idRes,idjogo,nomeRes);
            
		SET done = 0;
        OPEN itr;
		FETCH itr INTO actIdEsp;
		WHILE (done = 0) DO    
			INSERT INTO cota(especialista_utilizador_idutilizador,resultado_idresultado) VALUES (actIdEsp,idRes);
			FETCH itr INTO actIdEsp;
		END WHILE;
		CLOSE itr;
            
        SELECT i + 1 INTO i;
    END WHILE;
    
END &&