package Rasbet;

import java.util.List;
import java.util.Map;

public interface IRasbetNotificacoes {

    public List<Map<String, Object>> getNotificacoes (Integer usrID) throws Exception;

    public Map<String, Object> eliminaNotificacao (Integer usrID, Integer notifID) throws Exception;

    public void mandaNotifUsers(Integer usrId, String msg, String users) throws Exception;

}
