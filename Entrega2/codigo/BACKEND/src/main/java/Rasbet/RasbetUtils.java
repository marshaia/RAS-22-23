package Rasbet;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RasbetUtils {

    public static List<Map<String,Object>> convertToMapList(ResultSet set) throws SQLException, JsonProcessingException {

        List<Map<String, Object>> res = new ArrayList();
        ObjectMapper mapper = new ObjectMapper();

        while(set.next()){
            res.add(mapper.readValue(set.getString("jsonStr"), HashMap.class));
        }

        return res;
    }

    public static Map<String,Object> convertToObject(ResultSet set) throws SQLException, JsonProcessingException {

        ObjectMapper mapper = new ObjectMapper();
        set.next();
        return mapper.readValue(set.getString("jsonStr"), HashMap.class);
    }



    public static String hashStringSHA256(String str) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashed = digest.digest(
                str.getBytes(StandardCharsets.UTF_8));
        return toHexString(hashed);
    }


    private static String toHexString(byte[] hash)
    {
        // Convert byte array into signum representation
        BigInteger number = new BigInteger(1, hash);

        // Convert message digest into hex value
        StringBuilder hexString = new StringBuilder(number.toString(16));

        // Pad with leading zeros
        while (hexString.length() < 64)
        {
            hexString.insert(0, '0');
        }

        return hexString.toString();
    }

}


