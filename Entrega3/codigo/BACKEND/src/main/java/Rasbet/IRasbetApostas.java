package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface IRasbetApostas {

    public List<Map<String,Object>> getHistoricoApostas(Integer idUser) throws SQLException, JsonProcessingException;

    public void createAposta(Integer idUser, boolean simples,float valorTotal,List<Object> resultados, boolean carteira) throws SQLException, JsonProcessingException;

    public Map<String,Object> mudarEstadoAposta (Integer adminID, Integer idAposta, String estado) throws Exception;

    public List<Map<String,Object>> getApostas(Integer idUser) throws Exception;
}
