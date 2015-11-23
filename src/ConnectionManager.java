import java.util.HashMap;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.json.simple.parser.JSONParser;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class ConnectionManager
{
    public static final String configFile = "config/server.json";
    private static Connection connection = null;


    public static Connection open() throws IOException, ParseException, SQLException
    {
    	System.out.println("Connecting to database.");

        if (connection == null)
        {
            HashMap<String, String> serverConfig = parseServerConfig();

            connection = DriverManager.getConnection(
                serverConfig.get("url"),
                serverConfig.get("username"),
                serverConfig.get("password")
            );
        }

        return connection;
    }

    public static void close() throws SQLException
    {
    	System.out.println("Disconnecting from database.");

        if (connection != null)
        {
            connection.close();
        }

        connection = null;
    }

    private static HashMap<String, String> parseServerConfig() throws IOException, ParseException
    {
        HashMap<String, String> data = new HashMap<String, String>();

        JSONParser parser = new JSONParser();
        byte[] encodedJson = Files.readAllBytes(Paths.get(configFile));
        String jsonString = new String(encodedJson, StandardCharsets.UTF_8);
        JSONObject json = (JSONObject)parser.parse(jsonString);

        data.put("url", (String)json.get("url"));
        data.put("username", (String)json.get("username"));
        data.put("password", (String)json.get("password"));

        return data;
    }
}
