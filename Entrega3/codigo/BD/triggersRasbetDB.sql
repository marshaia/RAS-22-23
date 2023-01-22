USE rasbetDB;

DROP TRIGGER IF EXISTS notifica_jogadores;

DELIMITER &&
CREATE TRIGGER notifica_jogadores AFTER UPDATE
ON cota FOR EACH ROW
BEGIN

	DECLARE _awayteam VARCHAR(64) DEFAULT "";
	DECLARE _hometeam VARCHAR(64) DEFAULT "";
    DECLARE _resNome VARCHAR(64) DEFAULT "";
    DECLARE k INT DEFAULT 0;
    DECLARE tab_size INT DEFAULT 0;
    DECLARE idNotif INT DEFAULT 0;
    DECLARE idUtil INT DEFAULT 0;
    DECLARE n_followers INT DEFAULT 0;

	DROP TEMPORARY TABLE IF EXISTS tab;
	CREATE TEMPORARY TABLE tab (utilizador_idutilizador INT, hometeam VARCHAR (64), awayteam VARCHAR (64), resNome VARCHAR(64));
    INSERT INTO tab (utilizador_idutilizador, hometeam, awayteam, resNome)
		SELECT ap.utilizador_idutilizador, jo.hometeam, jo.awayteam, res.nome AS resNome FROM apostador AS ap
		JOIN jogo_has_apostador AS jha ON jha.apostador_utilizador_idutilizador = ap.utilizador_idutilizador
		JOIN jogo AS jo ON jha.jogo_idjogo = jo.idjogo
		JOIN resultado AS res ON res.jogo_idjogo = jo.idjogo
		JOIN cota AS c ON res.idresultado = c.resultado_idresultado
		WHERE NEW.especialista_utilizador_idutilizador = c.especialista_utilizador_idutilizador AND NEW.resultado_idresultado = c.resultado_idresultado;

	SELECT COUNT(*) FROM tab INTO n_followers;

	If n_followers > 0 THEN
    
		SELECT hometeam FROM tab LIMIT 1 INTO _hometeam;
		SELECT awayteam FROM tab LIMIT 1 INTO _awayteam;
		SELECT resNome FROM tab LIMIT 1 INTO _resNome;
		
		
		INSERT INTO notificacao(mensagem) VALUES (CONCAT("Jogo ", _hometeam, " X ", _awayteam, ", alteração da cota em : ", _resNome));
		SET idNotif = last_insert_id();

		DROP TEMPORARY TABLE IF EXISTS temp;
		CREATE TEMPORARY TABLE temp (utilizador_idutilizador INT);
		INSERT INTO temp (utilizador_idutilizador)
		SELECT utilizador_idutilizador FROM tab
		GROUP BY utilizador_idutilizador;

		SELECT COUNT(*) FROM temp INTO tab_size;

		WHILE k < tab_size DO

			SELECT utilizador_idutilizador FROM (SELECT * FROM temp LIMIT k, 1) AS T INTO idUtil;

			INSERT INTO apostador_has_notificacao(apostador_utilizador_idutilizador, notificacao_idnotificacao, visto) VALUES (idUtil, idNotif, 0);
			SET k = k + 1;
		END WHILE;
		DROP TEMPORARY TABLE temp;
	END IF;

    DROP TEMPORARY TABLE tab;
END &&