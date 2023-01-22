package Rasbet;

import java.util.List;
import java.util.Map;

public interface IRasbetPromocoes {

    public List<Map<String, Object>> getPromocoes (Integer adminID) throws Exception;

    public List<Map<String, Object>> getPromocoesAtivas (Integer adminID) throws Exception;

    public void alteraEstadoPromocao (Integer adminID, Integer promoID) throws Exception;

    public void criaPromocao(Integer adminID, String msg) throws Exception;

}
