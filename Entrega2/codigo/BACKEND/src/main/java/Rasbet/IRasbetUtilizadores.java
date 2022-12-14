package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface IRasbetUtilizadores {

    public Integer isValidSessionToken(String token);

    public Integer getNumeroUsersOnline();

    public Map<String,Object> login(String email, String password) throws Exception;

    public Map<String,Object> getUserInfo(Integer idUser) throws Exception;

    public Map<String,Object> registerUser(String email, String password, String nome, String datanascimento, String nif, String cc, String endereco, String telefone, String tipo) throws Exception;

    public Map<String,Object> editUserInfo(Integer idUser,String email,String nome, String endereco, String telefone) throws Exception;

    public Map<String,Object> editUserPassword(Integer idUser,String oldPassword,String newPassword) throws Exception;

    public Map<String,Object> logout(String token);
}
