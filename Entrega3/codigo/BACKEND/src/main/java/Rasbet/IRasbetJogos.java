package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.Array;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface IRasbetJogos {

    public List<Map<String, Object>> getGamesApostadores() throws SQLException, JsonProcessingException;

    public List<Map<String,Object>> getGamesAdmin() throws SQLException, JsonProcessingException;

    public List<Map<String,Object>> getAllSports() throws SQLException, JsonProcessingException;

    public List<Map<String,Object>> getAllCompetitions() throws SQLException, JsonProcessingException;

    public void terminaJogo(Integer idadmin, Integer idjogo, String winner, String score) throws Exception;

    public List<Map<String, Object>> getEspecialistaGames(Integer espID) throws SQLException, JsonProcessingException;

     public Map<String,Object> modificaOdds(Integer espID, Integer jogoID, List<Object> resultados) throws SQLException, JsonProcessingException;

    public Map<String,Object> criaJogo(Integer adminID, Boolean completed, Integer iddesporto, Integer idcompeticao, String resultados, String starttime, String hometeam, String awayteam) throws SQLException, JsonProcessingException;

    public Map<String,Object> startFollowing(Integer idApostador, Integer idJogo) throws SQLException, JsonProcessingException;

    public Map<String,Object> stopFollowing(Integer idApostador, Integer idJogo) throws SQLException, JsonProcessingException;
}
