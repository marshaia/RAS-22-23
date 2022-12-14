package com.example.javabackend;

import Rasbet.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.*;

@SpringBootApplication
@RestController
public class JavaBackendApplication {
    private static Connection db;
    private static IRasbetUtilizadores rasbetUtilizadores;
    private static IRasbetJogos rasbetJogos;
    private static IRasbetBilling rasbetBilling;
    private static IRasbetApostas rasbetApostas;
    private static IRasbetNotificacoes rasbetNotificacoes;


    public static void main(String[] args) {

        try {
            db = DriverManager.getConnection("jdbc:mysql://localhost:3306/rasbetDB", "javaBackend", "123456");
            rasbetUtilizadores = new RasbetUtilizadores(db);
            rasbetJogos = new RasbetJogos(db);
            rasbetBilling = new RasbetBilling(db);
            rasbetApostas = new RasbetApostas(db);
            rasbetNotificacoes = new RasbetNotificacoes(db);

            Thread t = new Thread(new RasbetApiParser(db));
            t.start();

            SpringApplication.run(JavaBackendApplication.class, args);
        }catch (Exception e){
            System.out.println("Upsi: "+e);
            System.exit(1);
        }
    }

    @Configuration
    public class WebConfiguration implements WebMvcConfigurer {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**").allowedMethods("*");
        }
    }




    // ------------------------------------------------------------
    // ---------- USERS - -----------------------------------------
    // ------------------------------------------------------------
    @PostMapping("/register")
    public Map<String,Object> register(@RequestBody Map<String,Object> body) {

        try {
            return rasbetUtilizadores.registerUser(body.get("email").toString(),body.get("password").toString(),body.get("nome").toString(),
                                            body.get("datanascimento").toString(),body.get("nif").toString(),body.get("cc").toString(),
                                            body.get("endereco").toString(),body.get("telefone").toString(),body.get("tipo").toString());
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }

    }

    @PostMapping("/login")
    public Map<String,Object> login(@RequestBody Map<String,Object> body) {

        String type = body.get("type").toString();

        try {
            if(type.equals("token")){
                Integer usrId = rasbetUtilizadores.isValidSessionToken(body.get("token").toString());
                if(usrId != null) return rasbetUtilizadores.getUserInfo(usrId);
                else throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
            else
                return rasbetUtilizadores.login(body.get("email").toString(),body.get("password").toString());
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,"ERROR: "+e);
        }

    }

    @PostMapping("/logout")
    public Map<String,Object> logout(@RequestBody Map<String,Object> body) {

        try {
            return rasbetUtilizadores.logout(body.get("token").toString());
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }

    }


    @PostMapping("/editInfo")
    public Map<String,Object> editarPerfil(@RequestBody Map<String,Object> body) {

        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(body.get("token").toString());
            if(usrId != null){
                return rasbetUtilizadores.editUserInfo(usrId,body.get("email").toString(),body.get("nome").toString(),
                    body.get("endereco").toString(),body.get("telefone").toString());
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }

    }

    @PostMapping("/editPassword")
    public Map<String, Object> editarPassword(@RequestBody Map<String,Object> body) {

        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(body.get("token").toString());
            if(usrId != null){
                return rasbetUtilizadores.editUserPassword(usrId,body.get("oldPassword").toString(),body.get("newPassword").toString());
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }

    }

    @GetMapping("/admin/usersOnline")
    public Integer numberUsersOnline(@RequestHeader Map<String, Object> headers) {
        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(headers.get("token").toString());
            if(usrId != null) {
                return rasbetUtilizadores.getNumeroUsersOnline();
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }












    // ------------------------------------------------------------
    // ---------- BILLING -----------------------------------------
    // ------------------------------------------------------------
    @PostMapping("/movimento")
    public Map<String,Object> movimentoSaldo(@RequestBody Map<String,Object> body) {

        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(body.get("token").toString());
            if(usrId != null){
                Map<String,Object> res = rasbetBilling.createTransaction(usrId,Float.parseFloat(body.get("valor").toString()),body.get("descricao").toString());
                return RasbetUtilizadores.setTokenAndEncargoStatic(res);
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }

    @GetMapping("/historico/transacoes")
    public List<Map<String,Object>> historicoTransact(@RequestHeader Map<String,Object> headers) {
        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(headers.get("token").toString());
            if(usrId != null){
                return rasbetBilling.getHistoricoTransactions(usrId);
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }










    // ------------------------------------------------------------
    // ---------- APOSTAS -----------------------------------------
    // ------------------------------------------------------------
    @GetMapping("/historico/apostas")
    public List<Map<String,Object>> historicoAposta(@RequestHeader Map<String,Object> headers) {

        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(headers.get("token").toString());
            if(usrId != null){
                return rasbetApostas.getHistoricoApostas(usrId);
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }

    @PostMapping("/criarAposta")
    public Map<String, Object> criaAposta(@RequestBody Map<String, Object> body) {

        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(body.get("token").toString());
            if(usrId != null) {
                boolean simples = true,carteira = true;
                if (body.get("simples").toString().equals("0")) simples = false;
                if (body.get("carteira").toString().equals("0")) simples = false;
                ObjectMapper mapper = new ObjectMapper();
                List<Object> items = mapper.readValue(body.get("items").toString(),List.class);
                rasbetApostas.createAposta(usrId,simples,Float.parseFloat(body.get("valorTotal").toString()),items,carteira);
                return new HashMap<>();
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }


    @PostMapping("/admin/apostas")
    public List<Map<String, Object>> apostasJogo(@RequestBody Map<String, Object> headers) {
        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(headers.get("token").toString());
            if(usrId != null) {
                return rasbetApostas.apostasDoJogo(usrId, Integer.parseInt(headers.get("game").toString()));
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }














    // ------------------------------------------------------------
    // ---------- JOGOS -------------------------------------------
    // ------------------------------------------------------------
    @GetMapping("/jogos")
    public List<Map<String,Object>> getGames() {

        try {
            return rasbetJogos.getAllAvaliableGames();
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,"ERROR: "+e);
        }

    }

    @GetMapping("/desportos")
    public List<Map<String,Object>> getSports() {

        try {
            return rasbetJogos.getAllSports();
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,"ERROR: "+e);
        }

    }

    @GetMapping("/competicoes")
    public List<Map<String,Object>> getCompetitions() {

        try {
            return rasbetJogos.getAllCompetitions();
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,"ERROR: "+e);
        }

    }

    @PostMapping("/admin/jogos")
    public void terminaJogo(@RequestBody Map<String, Object> headers) {
        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(headers.get("token").toString());
            if(usrId != null) {
                rasbetJogos.terminaJogo(usrId, Integer.parseInt(headers.get("game").toString()), headers.get("msg").toString(), headers.get("winner").toString(), headers.get("score").toString());
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }











    // ------------------------------------------------------------
    // ---------------------- NOTIFICAÇÕES ------------------------
    // ------------------------------------------------------------
    @GetMapping("/notificacoes")
    public List<Map<String,Object>> getNotificacoes(@RequestHeader Map<String,Object> headers) {

        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(headers.get("token").toString());
            if(usrId != null){
                return rasbetNotificacoes.getNotificacoes(usrId);
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }

    @PostMapping("/notificacoes")
    public Map<String,Object> eliminaNotificacao(@RequestBody Map<String,Object> body) {

        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(body.get("token").toString());
            if(usrId != null){
                return rasbetNotificacoes.eliminaNotificacao(usrId, Integer.parseInt(body.get("idnotificacao").toString()));
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }

    @PostMapping("/admin/notificacoes")
    public void notificaUsers(@RequestBody Map<String, Object> headers) {
        try {
            Integer usrId = rasbetUtilizadores.isValidSessionToken(headers.get("token").toString());
            if(usrId != null) {
                rasbetNotificacoes.mandaNotifUsers(usrId, headers.get("msg").toString(), headers.get("users").toString());
            }
            else {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
            }
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"ERROR: "+e);
        }
    }


}
