package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class RasbetBilling implements IRasbetBilling{

    Connection db;

    public RasbetBilling(Connection db){
        this.db = db;
    }

    public Map<String,Object> createTransaction(Integer idUser,float valor,String descricao) throws Exception {

        ResultSet dbInfo = db.prepareStatement("CALL updateCarteira("+idUser+",'"+valor+"','"+descricao+"');").executeQuery();
        Map<String,Object> res = RasbetUtils.convertToObject(dbInfo);

        if(res.get("success").toString().equals("0"))
            throw new Exception("Montante inválido");

        return (Map<String,Object>) res.get("user");
    }

    public List<Map<String, Object>> getHistoricoTransactions(Integer idUser) throws SQLException, JsonProcessingException {
        ResultSet dbInfo = db.prepareStatement("CALL getHistoricoTransacao("+idUser+");").executeQuery();
        List<Map<String, Object>> res = RasbetUtils.convertToMapList(dbInfo);

        return res;
    }
}
