package Rasbet;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

public class RasbetNotificacoes implements IRasbetNotificacoes{

    private Connection db;

    public RasbetNotificacoes(Connection db){
        this.db = db;
    }

    @Override
    public List<Map<String,Object>> getNotificacoes(Integer usrID) throws Exception {

        ResultSet dbInfo = db.prepareStatement("CALL getAllUsernotificacoes("+usrID+");").executeQuery();
        List<Map<String, Object>> notifs = RasbetUtils.convertToMapList(dbInfo);

        return notifs;
    }

    @Override
    public Map<String, Object> eliminaNotificacao (Integer usrID, Integer notifID) throws Exception {

        ResultSet dbInfo = db.prepareStatement("CALL changeVisto("+usrID+","+notifID+");").executeQuery();
        Map<String, Object> res = RasbetUtils.convertToObject(dbInfo);

        return res;
    }


    @Override
    public void mandaNotifUsers(Integer idadmin, String msg, String users) throws Exception {

        db.prepareStatement("CALL mandarNotificacoes("+idadmin+",'"+msg+"','"+users+"');").executeQuery();
    }

}
