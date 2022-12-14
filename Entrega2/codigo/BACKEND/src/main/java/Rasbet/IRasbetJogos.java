package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface IRasbetJogos {

    public List<Map<String,Object>> getAllAvaliableGames() throws SQLException, JsonProcessingException;

    public List<Map<String,Object>> getAllSports() throws SQLException, JsonProcessingException;

    public List<Map<String,Object>> getAllCompetitions() throws SQLException, JsonProcessingException;

    public void terminaJogo(Integer idadmin, Integer idjogo, String msg, String winner, String score) throws Exception;
}
