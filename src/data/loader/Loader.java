package data.loader;

import java.util.*;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.json.simple.parser.JSONParser;


public class Loader {
    public static final String sqlFile = "src/data/setup.sql";
    public static final String configFile = "config/server.json";


    public static void main(String[] argv) throws Exception
    {
        HashMap<String, String> serverConfig = parseServerConfig();
        loadData(
            serverConfig.get("url"),
            serverConfig.get("username"),
            serverConfig.get("password")
        );
    }

    public static void loadData(String url, String uid, String pw) throws Exception
    {
        System.out.println("Connecting to database.");

        Connection con = DriverManager.getConnection(url, uid, pw);

        try
        {
            // Create statement
            Statement stmt = con.createStatement();

            Scanner scanner = new Scanner(new File(sqlFile));
            // Read commands separated by ;
            scanner.useDelimiter(";");
            while (scanner.hasNext())
            {
                String command = scanner.next();
                if (command.trim().equals(""))
                    continue;
                System.out.println(command);
                try
                {
                    stmt.execute(command);
                }
                catch (Exception e)
                {   // Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
                    System.out.println(e);
                }
            }
            scanner.close();
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
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
