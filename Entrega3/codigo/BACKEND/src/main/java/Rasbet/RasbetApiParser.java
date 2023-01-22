package Rasbet;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RasbetApiParser implements Runnable{

    private static Connection db;
    private static Map<String,Integer> especialistaSeen = new HashMap<>();
    private static Map<String,Integer> jogosSeen = new HashMap<>();
    private static Map<String,Integer> resultadoJogo = new HashMap<>();
    private static int idEsp = 2100;
    private static int idJogo = 10100;
    private static int idResul = 10100;
    public RasbetApiParser(Connection db) {
        RasbetApiParser.db = db;
    }

    public void run() {
        try{

            int timeout = 15000; //20seconds
            URL url = new URL("http://ucras.di.uminho.pt/v1/games");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setConnectTimeout(timeout);
            System.out.println("Contacting API... @ '"+url.toString()+"' (Max "+timeout/1000+" seconds)");
            con.setRequestMethod("GET");

            byte[] data = con.getInputStream().readAllBytes();
            ObjectMapper mapper = new ObjectMapper();
            List<Object> res = mapper.readValue(StandardCharsets.UTF_8.decode(ByteBuffer.wrap(data)).toString(), List.class);
            //VOU PERCORRER 3 VEZES, IDC

            //VÊ OS ESPECIALISTAS E CRIA
            for (Object jogoRaw : res){
                Map<String,Object> jogo = (Map<String,Object>) jogoRaw;
                List<Object> bookMakerList = (List<Object>) jogo.get("bookmakers");
                for (Object bookMakerRaw : bookMakerList){
                    Map<String,Object> bookMaker = (Map<String,Object>) bookMakerRaw;
                    String name = bookMaker.get("key").toString();

                    if(!especialistaSeen.containsKey(name)){
                        try {
                            RasbetApiParser.db.prepareStatement("CALL apiNewEspecialista(" + idEsp + ",'" + name + "');").executeQuery();
                        }
                        catch (Exception e){

                        }
                        especialistaSeen.put(name,idEsp);
                        idEsp++;
                    }
                }
            }

            //VÊ OS JOGOS E CRIA
            for (Object jogoRaw : res){
                Map<String,Object> jogo = (Map<String,Object>) jogoRaw;
                List<Object> bookMakerList = (List<Object>) jogo.get("bookmakers");
                Map<String,Object> bookMaker = (Map<String,Object>) bookMakerList.get(0);

                String id = jogo.get("id").toString();
                if(!jogosSeen.containsKey(id)){
                    jogosSeen.put(id,idJogo);
                }

                String jsonStr = "[";
                List<Map<String,Object>> listOutcomesWeird = (List<Map<String,Object>>) bookMaker.get("markets");
                for(Map<String,Object> outcomesWeird : listOutcomesWeird){
                    List<Map<String,Object>> listOutcomes = (List<Map<String,Object>>) outcomesWeird.get("outcomes");
                    for(Map<String,Object> outcome : listOutcomes){

                        String resultName = outcome.get("name").toString();
                        String idRes = idJogo+resultName;
                        if(!resultadoJogo.containsKey(idRes)){
                            resultadoJogo.put(idRes,idResul);
                            jsonStr += "{\"idRes\":"+idResul+", \"nome\":\""+resultName+"\"},";
                            idResul++;
                        }

                    }
                }

                jsonStr = jsonStr.substring(0,jsonStr.length()-1);
                jsonStr += "]";

                LocalDateTime date = LocalDateTime.parse(jogo.get("commenceTime").toString().substring(0,jogo.get("commenceTime").toString().length()-1));
                String strDate = date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                try {
                    RasbetApiParser.db.prepareStatement("CALL apiNewJogoFutebol(" + idJogo + ",'" + jogo.get("homeTeam").toString() + "','" + jogo.get("awayTeam").toString() + "','" + strDate + "'," + jogo.get("completed").toString() + ",'" + jsonStr + "');").executeQuery();
                }catch (Exception e){

                }
                idJogo++;
            }


            //VÊ AS COTAS E DEFINE
            for (Object jogoRaw : res){
                Map<String,Object> jogo = (Map<String,Object>) jogoRaw;
                List<Object> bookMakerList = (List<Object>) jogo.get("bookmakers");

                int bdIDJogo = jogosSeen.get(jogo.get("id").toString());

                for (Object bookMakerRaw : bookMakerList){
                    Map<String,Object> bookMaker = (Map<String,Object>) bookMakerRaw;
                    String name = bookMaker.get("key").toString();

                    Integer bdIDEsp = especialistaSeen.get(name);

                    List<Map<String,Object>> listOutcomesWeird = (List<Map<String,Object>>) bookMaker.get("markets");
                    for(Map<String,Object> outcomesWeird : listOutcomesWeird){
                        List<Map<String,Object>> listOutcomes = (List<Map<String,Object>>) outcomesWeird.get("outcomes");
                        for(Map<String,Object> outcome : listOutcomes){

                            String resultName = outcome.get("name").toString();
                            int bdIDRes = resultadoJogo.get(bdIDJogo+resultName);

                            try{
                                RasbetApiParser.db.prepareStatement("CALL apiSetCota("+bdIDEsp+","+bdIDRes+","+outcome.get("price").toString()+");").executeQuery();
                            }catch (Exception e){

                            }

                        }
                    }
                }
            }

            System.out.println("API games Loaded Successfully");


        }catch (SocketTimeoutException e){
            System.out.println("API FETCH FAILED: Timeout Exceeded.");
        }
        catch (Exception e){
            System.out.println("API FETCH FAILED: "+e);
        }
    }
}
