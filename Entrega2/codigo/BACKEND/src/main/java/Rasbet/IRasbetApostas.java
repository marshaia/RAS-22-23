package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface IRasbetApostas {

    public List<Map<String,Object>> getHistoricoApostas(Integer idUser) throws SQLException, JsonProcessingException;

    public void createAposta(Integer idUser, boolean simples,float valorTotal,List<Object> resultados, boolean carteira) throws SQLException, JsonProcessingException;

    public List<Map<String, Object>> apostasDoJogo(Integer usrId, Integer game) throws Exception;
}
