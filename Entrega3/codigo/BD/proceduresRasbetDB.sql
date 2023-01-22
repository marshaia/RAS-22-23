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
        'idadministrador', adm.utilizador_idutilizador, 'jogos', JSON_ARRAYAGG(jogo_idjogo)) AS jsonStr
        FROM utilizador AS usr
    LEFT JOIN apostador AS aps ON aps.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN especialista AS esp ON esp.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN administrador AS adm ON adm.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN jogo_has_apostador AS jha ON jha.apostador_utilizador_idutilizador = usr.idutilizador
    WHERE usr.email=email AND usr.password=password
    GROUP BY usr.idutilizador;
END &&


DELIMITER &&
CREATE PROCEDURE getUtilizadorInfo(IN idUsr INT)
BEGIN
SELECT json_object('email', email,'nome', nome,'datanascimento', datanascimento,'nif', nif,'cc', cc,'endereco', endereco,'telefone', telefone,
        'valorcarteira', ROUND(valorcarteira, 2), 'idapostador', aps.utilizador_idutilizador, 'idespecialista', esp.utilizador_idutilizador,
        'idadministrador', adm.utilizador_idutilizador, 'jogos', JSON_ARRAYAGG(jogo_idjogo)) AS jsonStr
        FROM utilizador AS usr
    LEFT JOIN apostador AS aps ON aps.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN especialista AS esp ON esp.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN administrador AS adm ON adm.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN jogo_has_apostador AS jha ON jha.apostador_utilizador_idutilizador = usr.idutilizador
    WHERE usr.idutilizador=idUsr
    GROUP BY usr.idutilizador;
END &&

DROP PROCEDURE IF EXISTS createUser; &&
DELIMITER &&
CREATE PROCEDURE createUser(IN email VARCHAR(64), IN password CHAR(64), IN nome VARCHAR(64), IN datanascimento DATE,
							IN nif VARCHAR(16), IN cc VARCHAR(16), IN endereco VARCHAR(64), telefone VARCHAR(64),IN tipo VARCHAR(16), IN sports JSON)
BEGIN
	DECLARE newId INT;
    DECLARE tmpSize INT DEFAULT 0;
    DECLARE idRes INT;
    DECLARE _sport INT;
	DECLARE i INT DEFAULT 0;

	START TRANSACTION;
    
	INSERT INTO utilizador(email,password,nome,datanascimento,nif,cc,endereco,telefone) VALUES 
	(email,password,nome,datanascimento,nif,cc,endereco,telefone);

	SET newId = last_insert_id();

	CASE
		WHEN tipo = 'apostador' THEN 
			INSERT INTO apostador(utilizador_idutilizador,valorcarteira) VALUES (newId,0);

		WHEN tipo = 'especialista' THEN 
			INSERT INTO especialista(utilizador_idutilizador) VALUES (newId);
            
            WHILE i < JSON_LENGTH(sports) DO

				SELECT JSON_UNQUOTE(JSON_EXTRACT(sports, CONCAT('$[',i,']'))) INTO _sport;
				INSERT INTO especialista_has_desporto(especialista_utilizador_idutilizador, desporto_iddesporto) VALUES (newId, _sport);
				SET i = i + 1;

			END WHILE;
			
            DROP TEMPORARY TABLE IF EXISTS tmp;
			CREATE TEMPORARY TABLE tmp (idresultado INT);

			INSERT INTO tmp (idresultado)
            SELECT resultado.idresultado FROM resultado
				JOIN jogo ON jogo.idjogo = resultado.jogo_idjogo
                JOIN desporto ON desporto.iddesporto = jogo.desporto_iddesporto
                JOIN especialista_has_desporto AS ehd ON ehd.desporto_iddesporto = desporto.iddesporto
                WHERE ehd.especialista_utilizador_idutilizador = newId;
			
            SELECT COUNT(*) FROM tmp INTO tmpSize;
            
            SET i = 0;
            WHILE i < tmpSize DO
				SELECT idresultado FROM tmp LIMIT i, 1 INTO idRes;
                INSERT INTO cota(especialista_utilizador_idutilizador, resultado_idresultado, cota) VALUES  (newId, idRes, NULL);
				SET i = i + 1;

			END WHILE;

		WHEN tipo = 'administrador' THEN 
			INSERT INTO administrador(utilizador_idutilizador) VALUES (newId);
		DROP TEMPORARY TABLE IF EXISTS tmp;
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
DELIMITER &&
CREATE PROCEDURE getGames()
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
			INNER JOIN tmp AS result ON result.jogo_idjogo = idjogo
			WHERE (completed = FALSE OR completed IS NULL)
			GROUP BY idjogo;
END &&

DELIMITER &&
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
			INNER JOIN tmp AS result ON result.jogo_idjogo = idjogo
			WHERE completed = FALSE
			GROUP BY idjogo;
END &&

DELIMITER &&
CREATE PROCEDURE getAllAvailableGamesForEspecialista(IN idEsp INT)
BEGIN
SELECT json_object('idjogo', idjogo,'starttime', starttime,'completed', completed,'hometeam', hometeam,'awayteam', awayteam,'score', score,'playerlist', playerlist,
		'winner', winner, 'idcompeticao', competicao_idcompeticao, 'iddesporto', desporto_iddesporto,
        'resultados', JSON_ARRAYAGG(JSON_OBJECT('idresultado', idresultado,'nome',nome,'cota',cota ))) AS jsonStr
        FROM jogo
        INNER JOIN resultado as result ON result.jogo_idjogo = jogo.idjogo
        INNER JOIN cota on cota.resultado_idresultado = result.idresultado
		WHERE (completed = FALSE OR completed IS NULL)  AND cota.especialista_utilizador_idutilizador = idEsp
        GROUP BY idjogo;
END &&


DELIMITER &&
CREATE PROCEDURE getAllApostadores()
BEGIN
	SELECT json_object('idapostador', idutilizador, 'nome', nome) AS jsonStr
		FROM utilizador
		JOIN apostador ON apostador.utilizador_idutilizador = utilizador.idutilizador;
END &&


DELIMITER &&
CREATE PROCEDURE getApostas(IN idUser INT)
BEGIN

	IF idUser > 0 THEN
		SELECT json_object('idaposta', idaposta, 'idUser', utilizador.idutilizador, 'nomeuser', utilizador.nome, 'estado', estado, 'data', aposta.data, 'valor', valor, 'simples', IF (simples = 0, 'false', 'true'), 'resultados', JSON_ARRAYAGG(JSON_OBJECT('idjogo', idjogo, 'nome', res.nome, 'hometeam', hometeam, 'awayteam', awayteam))) AS jsonStr
			FROM utilizador
			JOIN aposta ON aposta.apostador_utilizador_idutilizador = utilizador.idutilizador
			JOIN aposta_has_resultado AS ahr ON ahr.aposta_idaposta = aposta.idaposta
			JOIN resultado AS res ON res.idresultado = ahr.resultado_idresultado
			JOIN jogo ON jogo.idjogo = res.jogo_idjogo
			WHERE utilizador.idutilizador = idUser
            GROUP BY idaposta;
	ELSE
		SELECT json_object('idaposta', idaposta, 'idUser', utilizador.idutilizador, 'nomeuser', utilizador.nome, 'estado', estado, 'data', aposta.data, 'valor', valor, 'simples', IF (simples = 0, 'false', 'true'), 'resultados', JSON_ARRAYAGG(JSON_OBJECT('idjogo', idjogo, 'nome', res.nome, 'hometeam', hometeam, 'awayteam', awayteam))) AS jsonStr
			FROM utilizador
			JOIN aposta ON aposta.apostador_utilizador_idutilizador = utilizador.idutilizador
			JOIN aposta_has_resultado AS ahr ON ahr.aposta_idaposta = aposta.idaposta
			JOIN resultado AS res ON res.idresultado = ahr.resultado_idresultado
			JOIN jogo ON jogo.idjogo = res.jogo_idjogo
            GROUP BY idaposta;
    END IF;
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
	SELECT json_object('data',data,'descricao',descricao,'valor', ROUND(valor, 2)) AS jsonStr FROM transacao
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
		'valorcarteira', ROUND(valorcarteira, 2), 'idapostador', aps.utilizador_idutilizador, 'idespecialista', esp.utilizador_idutilizador,
        'idadministrador', adm.utilizador_idutilizador),'success',success) AS jsonStr
		FROM utilizador AS usr
	LEFT JOIN apostador AS aps ON aps.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN especialista AS esp ON esp.utilizador_idutilizador = usr.idutilizador
    LEFT JOIN administrador AS adm ON adm.utilizador_idutilizador = usr.idutilizador
    WHERE usr.idutilizador=id;
END &&


DROP PROCEDURE IF EXISTS updateCota; &&
DELIMITER &&
CREATE PROCEDURE updateCota(IN idJogo INT, IN idEsp INT, IN cotas JSON)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE _obj JSON;
    DECLARE _res INT;
    DECLARE _valor FLOAT;
    DECLARE k INT DEFAULT 0;
    DECLARE results FLOAT DEFAULT 1;
    DECLARE numApos INT;
    DECLARE idA INT;
    DECLARE idR INT;
    DECLARE numeroRes INT;
    DECLARE numNecess INT;
    DECLARE newcota FLOAT;
    DECLARE numres FLOAT;
    DECLARE _hometeam VARCHAR(64);
    DECLARE _awayteam VARCHAR(64);
    
    SELECT hometeam FROM jogo WHERE jogo.idjogo = idJogo INTO _hometeam;
    SELECT awayteam FROM jogo WHERE jogo.idjogo = idJogo INTO _awayteam;

    START TRANSACTION;

    -- "[{"idresultado": 1002, "cota":20}, {"idresultado": 1001, "cota":-1}]"

	WHILE i < JSON_LENGTH(cotas) DO

		SELECT JSON_UNQUOTE(JSON_EXTRACT(cotas, CONCAT('$[',i,']'))) INTO _obj;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(_obj, '$.idresultado')) INTO _res;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(_obj, '$.cota')) INTO _valor;
        IF _valor > 0 THEN

			UPDATE cota AS c SET c.cota = _valor WHERE c.resultado_idresultado = _res AND c.especialista_utilizador_idutilizador = idEsp;
		END IF;
        SET i = i + 1;
	END WHILE;

    DROP TEMPORARY TABLE IF EXISTS temp;
    CREATE TEMPORARY TABLE temp(idAposta INT);
    INSERT INTO temp(idAposta)
    SELECT aposta.idaposta FROM aposta
    JOIN aposta_has_resultado AS ahr ON ahr.aposta_idaposta = aposta.idaposta
    JOIN resultado AS res ON res.idresultado = ahr.resultado_idresultado
    WHERE res.jogo_idjogo = idJogo
    GROUP BY idaposta;
    
    SELECT COUNT(*) FROM temp INTO numApos;
    
    WHILE k < numApos DO

        SELECT idAposta FROM temp LIMIT k, 1 INTO idA;
        
        DROP TEMPORARY TABLE IF EXISTS restab;
		CREATE TEMPORARY TABLE restab(idres INT, avgcota FLOAT);
		INSERT INTO restab(idres, avgcota)
        SELECT res.idresultado, AVG(c.cota) FROM aposta
			JOIN aposta_has_resultado AS ahr ON ahr.aposta_idaposta = aposta.idaposta
			JOIN resultado AS res ON res.idresultado = ahr.resultado_idresultado
            JOIN cota AS c ON c.resultado_idresultado = res.idresultado
			WHERE aposta.idaposta = idA AND c.cota IS NOT NULL
            GROUP BY res.idresultado;

		SELECT COUNT(*) FROM restab INTO numres;

		SET j = 0;
		SET results = 1.0;
        WHILE j < numres DO

			SELECT avgcota FROM restab LIMIT j, 1 INTO newcota;
			SET results = results * newcota;
			SET j = j + 1;
		END WHILE;

		UPDATE aposta SET cota = results WHERE idaposta = idA;
        SET k = k + 1;
        DROP TEMPORARY TABLE restab;
    END WHILE;

    SELECT COUNT(*) AS n_res FROM (SELECT res.idresultado, COUNT(cota.cota) AS n_cota FROM jogo
		JOIN resultado AS res ON res.jogo_idjogo = jogo.idjogo
        JOIN cota ON cota.resultado_idresultado = res.idresultado
	WHERE jogo.idjogo = idJogo
    GROUP BY resultado_idresultado) AS tabl
    WHERE n_cota > 0 INTO numeroRes;

	SELECT COUNT(*) FROM jogo JOIN resultado AS res ON res.jogo_idjogo = jogo.idjogo WHERE jogo.idjogo = idJogo GROUP BY jogo.idjogo INTO numNecess;

	IF numeroRes = numNecess THEN
		UPDATE jogo SET completed = 0 WHERE jogo.idjogo = idJogo;
	END IF;

    DROP TEMPORARY TABLE temp;
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

DROP PROCEDURE IF EXISTS criaJogo; &&
DELIMITER &&
CREATE PROCEDURE criaJogo(IN adminID INT, IN completed TINYINT, IN iddesporto INT, IN idcompeticao INT, IN starttime VARCHAR(64), IN hometeam VARCHAR(64), IN awayteam VARCHAR(64), IN resultsStr JSON)
BEGIN

	DECLARE parsedate DATETIME;
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE idJogo INT;
    DECLARE numEsp INT;
    DECLARE idEsp INT;
    DECLARE idRes INT;
    DECLARE _obj JSON;
    DECLARE _nome VARCHAR(64);
    
	SELECT STR_TO_DATE(starttime, "%Y-%m-%d %H:%i:%s") INTO parsedate;
    
    DROP TEMPORARY TABLE IF EXISTS tab;
    CREATE TEMPORARY TABLE tab(idespecialista INT);
    INSERT INTO tab(idespecialista)
    SELECT utilizador_idutilizador FROM especialista
		JOIN especialista_has_desporto AS ehd ON ehd.especialista_utilizador_idutilizador = especialista.utilizador_idutilizador
        JOIN desporto AS des ON des.iddesporto = ehd.desporto_iddesporto
        WHERE des.iddesporto = iddesporto;

	INSERT INTO jogo(starttime, completed, hometeam, awayteam, score, playerlist, winner, competicao_idcompeticao, desporto_iddesporto) VALUES
		(parsedate, NULL, hometeam, awayteam, NULL, NULL, NULL, idcompeticao, iddesporto);
	
    SET idJogo = last_insert_id();
	
    SELECT COUNT(*) FROM tab AS Y INTO numEsp;
    SELECT JSON_LENGTH(resultsStr);

    WHILE i < JSON_LENGTH(resultsStr) DO

		SELECT JSON_UNQUOTE(JSON_EXTRACT(resultsStr, CONCAT('$[',i,']'))) INTO _nome;
		INSERT INTO resultado(jogo_idjogo, nome) VALUES (idJogo, _nome);
        
        SET idRes = last_insert_id();
        
        SET j = 0;

        WHILE j < numEsp DO
    
			SELECT * FROM tab LIMIT j, 1 INTO idEsp;
			INSERT INTO cota(resultado_idresultado, especialista_utilizador_idutilizador, cota) VALUES
			(idRes, idEsp, NULL);
            SET j = j + 1;
		END WHILE;

		SET i = i + 1;
	END WHILE;		
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
	SELECT json_object('data',ap.data,'valor', ROUND(ap.valor, 2),'simples',ap.simples,'estado',ap.estado,'resultados',JSON_OBJECT('nome',nome,'hometeam',hometeam,'awayteam',awayteam)) AS jsonStr
		FROM aposta AS ap
        JOIN aposta_has_resultado AS aps ON ap.idaposta= aps.aposta_idaposta
        JOIN resultado AS res ON res.idresultado = aps.resultado_idresultado
        JOIN jogo ON jogo.idjogo = res.jogo_idjogo
        WHERE jogo.idjogo = idGame;
END &&


DELIMITER &&
CREATE PROCEDURE mudaEstadoAposta(IN idAposta INT, IN estado VARCHAR(16))
BEGIN
	UPDATE aposta SET aposta.estado = estado WHERE aposta.idaposta = idAposta;
END &&


DROP PROCEDURE IF EXISTS followGame; &&
DELIMITER &&
CREATE PROCEDURE followGame(IN idJogo INT, IN idApostador INT)
BEGIN
	INSERT INTO jogo_has_apostador(jogo_idjogo, apostador_utilizador_idutilizador) VALUES (idJogo, idApostador);
    SELECT JSON_OBJECT('jogo', JSON_ARRAYAGG(jogo_idjogo)) AS jsonStr
		FROM jogo_has_apostador
		WHERE apostador_utilizador_idutilizador = idApostador
        GROUP BY apostador_utilizador_idutilizador;
       
END &&

DROP PROCEDURE IF EXISTS unfollowGame; &&
DELIMITER &&
CREATE PROCEDURE unfollowGame(IN idJogo INT, IN idApostador INT)
BEGIN
	DECLARE n_games INT DEFAULT 0;

	DELETE FROM jogo_has_apostador WHERE jogo_has_apostador.jogo_idjogo = idjogo AND jogo_has_apostador.apostador_utilizador_idutilizador = idApostador;

    SELECT COUNT(*)
		FROM jogo_has_apostador
		WHERE apostador_utilizador_idutilizador = idApostador
        GROUP BY apostador_utilizador_idutilizador INTO n_games;

	IF n_games > 0 THEN
		SELECT JSON_OBJECT('jogo', JSON_ARRAYAGG(jogo_idjogo)) AS jsonStr
			FROM jogo_has_apostador
			WHERE apostador_utilizador_idutilizador = idApostador
			GROUP BY apostador_utilizador_idutilizador;
	ELSE
		SELECT JSON_OBJECT('jogo', JSON_ARRAY()) AS jsonStr;
	END IF;
END &&


DROP PROCEDURE IF EXISTS terminaJogo; &&
DELIMITER &&
CREATE PROCEDURE terminaJogo(IN idAdmin INT, IN winnerName VARCHAR(64), IN idGame INT, IN newscore VARCHAR(16))
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
    DECLARE valorAposta FLOAT;
    DECLARE valorCota FLOAT;
    DECLARE _hometeam VARCHAR(64);
    DECLARE _awayteam VARCHAR(64);

	START TRANSACTION;

	DROP TABLE IF EXISTS tabela;
    DROP TABLE IF EXISTS linha;

    -- encerra o jogo
    UPDATE jogo SET jogo.completed=1, jogo.winner=winnerName, jogo.score=newscore WHERE jogo.idjogo= idGame;
	SELECT hometeam FROM jogo WHERE jogo.idjogo = idGame INTO _hometeam;
    SELECT awayteam FROM jogo WHERE jogo.idjogo = idGame INTO _awayteam;
    SELECT winner FROM jogo WHERE jogo.idjogo = idGame INTO winnerT;
    
    CREATE TABLE tabela AS
    SELECT idjogo, res.nome, simples, idaposta, apostador_utilizador_idutilizador, aposta.valor, aposta.cota, aposta.numApostas FROM aposta
        JOIN aposta_has_resultado AS aps ON aposta.idaposta= aps.aposta_idaposta
        JOIN resultado AS res ON res.idresultado = aps.resultado_idresultado
        JOIN jogo ON jogo.idjogo = res.jogo_idjogo
        WHERE jogo.idjogo = idGame
	UNION
    SELECT idjogo, NULL AS nome, NULL AS simples, NULL AS idaposta, jogo_has_apostador.apostador_utilizador_idutilizador, NULL AS valor, NULL AS cota, NULL AS numApostas FROM jogo
		JOIN jogo_has_apostador ON jogo.idjogo = jogo_has_apostador.jogo_idjogo
        WHERE jogo.idjogo = idGame;
	
    IF _awayteam <> "Null" THEN
		INSERT notificacao(mensagem) VALUES (CONCAT("Aposta [", _hometeam, " X ", _awayteam, "]: Ganhou")), (CONCAT("Aposta [", _hometeam, " X ", _awayteam, "]: Perdeu")), (CONCAT("Aposta [", _hometeam, " X ", _awayteam, "]: Acertou")), (CONCAT("Jogo [", _hometeam, " X ", _awayteam, "] terminou! Vencedor: ", winnerT));
	ELSE
		INSERT notificacao(mensagem) VALUES (CONCAT("Aposta [", _hometeam, "]: Ganhou")), (CONCAT("Aposta [", _hometeam, "]: Perdeu")), (CONCAT("Aposta [", _hometeam, "]: Acertou")), (CONCAT("Jogo [", _hometeam, "] terminou! Vencedor: ", winnerT));
	END IF;
    
    SET idNotif = last_insert_id();

    SELECT COUNT(*) FROM tabela AS Y INTO numRes;

    WHILE i < numRes DO

        CREATE TABLE linha AS (SELECT * FROM tabela LIMIT i, 1);
        SELECT nome FROM linha into nomeT;
        SELECT simples FROM linha into x;
        SELECT idaposta FROM linha into y;
		SELECT apostador_utilizador_idutilizador FROM linha into idApostador;
        SELECT valor FROM linha into valorAposta;
        SELECT cota FROM linha into valorCota;
        
        IF nomeT = "Null" THEN
        
			INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif + 3, 0);
        ELSE
			IF winnerT = nomeT THEN

				IF x = 1 THEN
					
					UPDATE aposta SET aposta.estado='Fechada', aposta.numApostas = 0 WHERE aposta.idaposta=y;
					INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif, 0);

					IF _awayteam <> "Null" THEN
						CALL updateCarteira(idApostador, ROUND(valorAposta * valorCota, 2), CONCAT("Aposta (", _hometeam, " X ", _awayteam, "), adquiriu: ", ROUND(valorAposta * valorCota, 2)));
					ELSE
						CALL updateCarteira(idApostador, ROUND(valorAposta * valorCota, 2), CONCAT("Aposta (", _hometeam, "), adquiriu: ", ROUND(valorAposta * valorCota, 2)));
					END IF;
					
				ELSE
					SELECT numApostas FROM linha INTO x;
                    select x;

					IF x > 0 THEN
						UPDATE aposta SET aposta.numApostas = aposta.numApostas - 1 WHERE aposta.idaposta=y;
						INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif + 2, 0);
						SET x = x - 1;
					END IF;

					IF x = 0 THEN
						UPDATE aposta SET aposta.estado='Fechada', aposta.numApostas = -1 WHERE aposta.idaposta=y;
						INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif, 0);
						IF _awayteam <> "Null" THEN
							CALL updateCarteira(idApostador, ROUND(valorAposta * valorCota, 2), CONCAT("Aposta (", _hometeam, " X ", _awayteam, "), adquiriu: ", ROUND(valorAposta * valorCota, 2)));
						ELSE
							CALL updateCarteira(idApostador, ROUND(valorAposta * valorCota, 2), CONCAT("Aposta (", _hometeam, "), adquiriu: ", ROUND(valorAposta * valorCota, 2)));
						END IF;
					END IF;
				END IF;
			ELSE
				UPDATE aposta SET aposta.estado='Fechada', aposta.numApostas = -1 WHERE aposta.idaposta=y;
				INSERT apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idApostador, idNotif + 1, 0);
			END IF;	
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
	WHERE apostador_utilizador_idutilizador=idUser AND notificacao_idnotificacao=notificacao.idnotificacao AND visto=0;
END &&

-- Altera o visto da notificação para 1 depois de visto
DELIMITER &&
CREATE PROCEDURE changeVisto(IN idUser INT, IN idNot INT)
BEGIN
	UPDATE apostador_has_notificacao SET visto=1
	WHERE apostador_utilizador_idutilizador=idUser AND notificacao_idnotificacao=idNOT AND visto=0;
	
    CALL getAllUsernotificacoes(idUser);
END &&

-- -----------------------------------------------------
-- PRODEDURES PROMOÇÕES
-- -----------------------------------------------------
DELIMITER &&
CREATE PROCEDURE alterarEstadoPromo(IN idProm INT)
BEGIN
	UPDATE promocao
	SET ativa = IF(ativa = TRUE , FALSE, TRUE) WHERE promocao.idpromocao = idProm; 
END &&



DELIMITER &&
CREATE PROCEDURE criaPromocao(IN des VARCHAR(256))
BEGIN
	INSERT INTO promocao(ativa, descricao) VALUES (FALSE, des);
END &&



DELIMITER &&
CREATE PROCEDURE getAllPromocoes()
BEGIN
	SELECT json_object('idpromocao', idpromocao, 'ativa', ativa, 'descricao', descricao) AS jsonStr FROM promocao;
END &&


DELIMITER &&
CREATE PROCEDURE getAllPromocoesAtivas()
BEGIN
	SELECT json_object('idpromocao', idpromocao, 'descricao', descricao) AS jsonStr FROM promocao WHERE promocao.ativa = TRUE;
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