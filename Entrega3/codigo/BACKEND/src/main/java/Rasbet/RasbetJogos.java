package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.Array;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RasbetJogos implements IRasbetJogos{

    private Connection db;
    public RasbetJogos(Connection db){
        this.db = db;
    }

    @Override
    public List<Map<String, Object>> getGamesApostadores() throws SQLException, JsonProcessingException {

        ResultSet dbInfo = db.prepareStatement("CALL getAllAvailableGames();").executeQuery();
        return RasbetUtils.convertToMapList(dbInfo);
    }

    @Override
    public List<Map<String, Object>> getGamesAdmin() throws SQLException, JsonProcessingException {

        ResultSet dbInfo = db.prepareStatement("CALL getGames();").executeQuery();
        return RasbetUtils.convertToMapList(dbInfo);
    }

    @Override
    public List<Map<String, Object>> getAllSports() throws SQLException, JsonProcessingException {

        ResultSet dbInfo = db.prepareStatement("CALL getAllSports();").executeQuery();
        return RasbetUtils.convertToMapList(dbInfo);
    }

    @Override
    public List<Map<String, Object>> getAllCompetitions() throws SQLException, JsonProcessingException {

        ResultSet dbInfo = db.prepareStatement("CALL getAllCompetitions();").executeQuery();
        return RasbetUtils.convertToMapList(dbInfo);
    }

    @Override
    public void terminaJogo(Integer idadmin, Integer idjogo, String winner, String score) throws Exception{

        db.prepareStatement("CALL terminaJogo("+idadmin+",'"+winner+"',"+idjogo+",'"+score+"');").executeQuery();
    }

    @Override
    public List<Map<String, Object>> getEspecialistaGames(Integer token) throws SQLException, JsonProcessingException {
        ResultSet dbInfo = db.prepareStatement("CALL getAllAvailableGamesForEspecialista("+token+");").executeQuery();
        return RasbetUtils.convertToMapList(dbInfo);
    }

    @Override
    public Map<String,Object> modificaOdds(Integer espID, Integer jogoID, List<Object> resultados) throws SQLException, JsonProcessingException {

        String jsonStr = "[";
        for(Object res : resultados){

            String idres = ((Map<String,Object>) res).get("idresultado").toString();
            String valor = ((Map<String,Object>) res).get("cota").toString();
            jsonStr = jsonStr + "{\"idresultado\":" + idres + ", \"cota\":" + valor + "},";
        }

        jsonStr = jsonStr.substring(0, jsonStr.length() - 1) + "]";

        db.prepareStatement("CALL updateCota("+jogoID+","+espID+",'"+jsonStr+"');").executeQuery();
        return new HashMap<String, Object>();
    }

    @Override
    public Map<String,Object> criaJogo(Integer adminID, Boolean completed, Integer iddesporto, Integer idcompeticao, String resultados, String starttime, String hometeam, String awayteam) throws SQLException, JsonProcessingException {

        String awayTeam = null;
        if (awayteam != null) awayTeam = "'" + awayteam + "'";
        db.prepareStatement("CALL criaJogo("+adminID+","+completed+","+iddesporto+","+idcompeticao+",'"+starttime+"','"+hometeam+"',"+awayTeam+",'"+resultados+"');").executeQuery();

        return new HashMap<String, Object>();
    }

    @Override
    public Map<String,Object> startFollowing(Integer idApostador, Integer idJogo) throws SQLException, JsonProcessingException {

        ResultSet dbInfo = db.prepareStatement("CALL followGame(" + idJogo + "," + idApostador + ");").executeQuery();
        return RasbetUtils.convertToObject(dbInfo);
    }

    @Override
    public Map<String,Object> stopFollowing(Integer idApostador, Integer idJogo) throws SQLException, JsonProcessingException {

        ResultSet dbInfo = db.prepareStatement("CALL unfollowGame(" + idJogo + "," + idApostador + ");").executeQuery();
        return RasbetUtils.convertToObject(dbInfo);
    }
}
