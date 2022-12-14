package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface IRasbetBilling {

    public Map<String,Object> createTransaction(Integer idUser, float valor, String descricao) throws Exception;

    public List<Map<String,Object>> getHistoricoTransactions(Integer idUser) throws SQLException, JsonProcessingException;
}
