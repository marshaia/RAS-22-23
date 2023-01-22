package Rasbet;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

public class RasbetPromocoes implements IRasbetPromocoes{

    private Connection db;

    public RasbetPromocoes(Connection db){
        this.db = db;
    }


    @Override
    public List<Map<String, Object>> getPromocoes (Integer adminID) throws Exception {
        ResultSet dbInfo = db.prepareStatement("CALL getAllPromocoes();").executeQuery();
        List<Map<String, Object>> promos = RasbetUtils.convertToMapList(dbInfo);

        return promos;
    }

    public List<Map<String, Object>> getPromocoesAtivas (Integer adminID) throws Exception {
        ResultSet dbInfo = db.prepareStatement("CALL getAllPromocoesAtivas();").executeQuery();
        List<Map<String, Object>> promos = RasbetUtils.convertToMapList(dbInfo);

        return promos;
    }

    @Override
    public void alteraEstadoPromocao (Integer adminID, Integer promoID) throws Exception {
        db.prepareStatement("CALL alterarEstadoPromo("+promoID+");").executeQuery();
    }

    @Override
    public void criaPromocao(Integer adminID, String msg) throws Exception {
        db.prepareStatement("CALL criaPromocao('"+msg+"');").executeQuery();
    }

}