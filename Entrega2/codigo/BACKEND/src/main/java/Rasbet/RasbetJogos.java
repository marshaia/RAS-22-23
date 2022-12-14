package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class RasbetJogos implements IRasbetJogos{

    private Connection db;
    public RasbetJogos(Connection db){
        this.db = db;
    }

    @Override
    public List<Map<String, Object>> getAllAvaliableGames() throws SQLException, JsonProcessingException {

        ResultSet dbInfo = db.prepareStatement("CALL getAllAvailableGames();").executeQuery();
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
    public void terminaJogo(Integer idadmin, Integer idjogo, String msg, String winner, String score) throws Exception{

        db.prepareStatement("CALL terminaJogo("+idadmin+",'"+msg+"','"+winner+"',"+idjogo+",'"+score+"');").executeQuery();
    }

}
