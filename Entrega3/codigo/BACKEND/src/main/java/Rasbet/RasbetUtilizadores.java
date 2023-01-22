package Rasbet;

import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static Rasbet.RasbetUtils.hashStringSHA256;

public class RasbetUtilizadores implements IRasbetUtilizadores {

    private Connection db;
    private Map<String,Integer> utilizadores = new HashMap<>();
    public RasbetUtilizadores(Connection connection){
        this.db = connection;
    }


    @Override
    public Integer isValidSessionToken(String token) {
        if (utilizadores.containsKey(token)){
            return utilizadores.get(token);
        };
        return null;
    }

    public Integer getNumeroUsersOnline() {
        return this.utilizadores.size();
    }






    public Map<String,Object> login(String email, String password) throws Exception {

        String hashedPass = hashStringSHA256(password);
        ResultSet dbInfo = db.prepareStatement("CALL loginUtilizador('"+email+"','"+hashedPass+"');").executeQuery();

        Map<String,Object> usr = RasbetUtils.convertToObject(dbInfo);
        usr = setTokenAndEncargo(usr);

        return usr;
    }

    @Override
    public Map<String, Object> getUserInfo(Integer usrID) throws Exception {

        ResultSet dbInfo = db.prepareStatement("CALL getUtilizadorInfo("+usrID+");").executeQuery();
        Map<String,Object> usr = RasbetUtils.convertToObject(dbInfo);
        usr = setTokenAndEncargo(usr);

        return usr;
    }

    @Override
    public Map<String,Object> logout(String token) {
        this.utilizadores.remove(token);
        return new HashMap<>();
    }

    @Override
    public Map<String, Object> registerUser(String email, String password, String nome, String datanascimento, String nif, String cc, String endereco, String telefone, String tipo, String sports) throws Exception {
        String hashedPass = hashStringSHA256(password);

        if (!tipo.equals("apostador") && !tipo.equals("especialista") && !tipo.equals("administrador")){
            throw new Exception("Tipo Inválido");
        }

        ResultSet dbInfo = db.prepareStatement("CALL createUser('"+email+"','"+hashedPass+"','"+nome+"','"+datanascimento+"','"+nif+"','"+cc+"','"+endereco+"','"+telefone+"','"+tipo+"', '"+sports+"');").executeQuery();
        Map<String,Object> usr = RasbetUtils.convertToObject(dbInfo);
        usr = setTokenAndEncargo(usr);

        return usr;
    }

    @Override
    public Map<String, Object> editUserInfo(Integer userId, String email, String nome, String endereco, String telefone) throws Exception {

        ResultSet dbInfo = db.prepareStatement("CALL updateUser("+userId+",'"+email+"','"+nome+"','"+endereco+"','"+telefone+"');").executeQuery();
        Map<String,Object> usr = RasbetUtils.convertToObject(dbInfo);

        return usr;
    }

    @Override
    public Map<String,Object> editUserPassword(Integer userId, String oldPassword, String newPassword) throws Exception {

        ResultSet dbInfo = db.prepareStatement("CALL getHashedPassword("+userId+");").executeQuery();
        Map<String,Object> passObj = RasbetUtils.convertToObject(dbInfo);

        if (!passObj.get("hashedpassword").equals(hashStringSHA256(oldPassword))) throw new Exception("Password Antiga Incorreta");
        db.prepareStatement("CALL updateUserPassword("+userId+",'"+hashStringSHA256(newPassword)+"');").executeQuery();

        return new HashMap<>();
    }

    private Map<String,Object> setTokenAndEncargo(Map<String,Object> usr) throws NoSuchAlgorithmException {
        String idUsr = "",token = "",encargo = "";
        if(usr.get("idadministrador") != null){
            idUsr = usr.get("idadministrador").toString();
            token = hashStringSHA256(idUsr);
            encargo = "administador";
        }
        else if(usr.get("idespecialista") != null){
            idUsr = usr.get("idespecialista").toString();
            token = hashStringSHA256(idUsr);
            encargo = "especialista";
        }
        else if(usr.get("idapostador") != null){
            idUsr = usr.get("idapostador").toString();
            token = hashStringSHA256(idUsr);
            encargo = "apostador";
        }

        utilizadores.put(token,Integer.valueOf(idUsr));
        usr.put("encargo",encargo);
        usr.put("token",token);
        return usr;
    }


    public static Map<String,Object> setTokenAndEncargoStatic(Map<String,Object> usr) throws NoSuchAlgorithmException {
        String idUsr = "",token = "",encargo = "";
        if(usr.get("idadministrador") != null){
            idUsr = usr.get("idadministrador").toString();
            token = hashStringSHA256(idUsr);
            encargo = "administador";
        }
        else if(usr.get("idespecialista") != null){
            idUsr = usr.get("idespecialista").toString();
            token = hashStringSHA256(idUsr);
            encargo = "especialista";
        }
        else if(usr.get("idapostador") != null){
            idUsr = usr.get("idapostador").toString();
            token = hashStringSHA256(idUsr);
            encargo = "apostador";
        }

        usr.put("encargo",encargo);
        usr.put("token",token);
        return usr;
    }

    @Override
    public List<Map<String,Object>> getAllApostadores() throws Exception{

        ResultSet dbInfo = db.prepareStatement("CALL getAllApostadores();").executeQuery();
        List<Map<String, Object>> res = RasbetUtils.convertToMapList(dbInfo);

        return res;
    }
}