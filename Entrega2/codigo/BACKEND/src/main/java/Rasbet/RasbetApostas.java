package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class RasbetApostas implements IRasbetApostas{

    Connection db;

    public RasbetApostas(Connection db){
        this.db = db;
    }

    @Override
    public List<Map<String, Object>> getHistoricoApostas(Integer idUser) throws SQLException, JsonProcessingException {
        ResultSet dbInfo = db.prepareStatement("CALL getHistoricoApostas("+idUser+");").executeQuery();
        List<Map<String, Object>> res = RasbetUtils.convertToMapList(dbInfo);

        return res;
    }

    @Override
    public void createAposta(Integer idUser, boolean simples, float valorTotal, List<Object> items, boolean carteira) throws SQLException {
        float pago = 0;
        if(simples){
            for(Object it : items){
                Map<String,Object> actResult = ((Map<String,Object>) ((Map<String,Object>) it).get("resultado"));
                String jsonStr = "["+actResult.get("idresultado").toString()+"]";
                db.prepareStatement("CALL criaAposta("+idUser+",'"+jsonStr+"',true,"+((Map<String,Object>) it).get("valor")+");").executeQuery();
                pago += Float.parseFloat(((Map<String,Object>) it).get("valor").toString());
            }
        }
        else {
            String jsonStr = "[";
            for(Object it : items){
                Map<String,Object> actResult = ((Map<String,Object>) ((Map<String,Object>) it).get("resultado"));
                jsonStr += actResult.get("idresultado").toString()+",";
            }
            jsonStr = jsonStr.substring(0,jsonStr.length()-1)+"]";
            db.prepareStatement("CALL criaAposta("+idUser+",'"+jsonStr+"',false,"+valorTotal+");").executeQuery();
            pago = valorTotal;
        }

        pago = -pago;
        if(carteira){
            db.prepareStatement("CALL updateCarteira("+idUser+","+pago+",'Aposta');").executeQuery();
        }
    }


    @Override
    public List<Map<String,Object>> apostasDoJogo(Integer usrID, Integer idjogo) throws Exception {

        ResultSet dbInfo = db.prepareStatement("CALL apostasJogo("+idjogo+");").executeQuery();
        List<Map<String, Object>> res = RasbetUtils.convertToMapList(dbInfo);

        return res;
    }
}
