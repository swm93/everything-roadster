import java.io.File;
import java.sql.Statement;
import java.util.Scanner;

import java.sql.Connection;


public class Loader
{
    public static final String sqlFile = "src/data/setup.sql";


    public static void main(String[] argv) throws Exception
    {
        loadData();
    }

    public static void loadData() throws Exception
    {
        Connection con = ConnectionManager.open();

        try
        {
            // create statement
            Statement stmt = con.createStatement();

            // read commands separated by ;
            Scanner scanner = new Scanner(new File(sqlFile));
            scanner.useDelimiter(";");

            while (scanner.hasNext())
            {
                String command = scanner.next();
                if (command.trim().equals(""))
                {
                    continue;
                }

                System.out.println(command);

                try
                {
                    stmt.execute(command);
                }
                catch (Exception e)
                {
                    // keep running on exception
                    // this is mostly for DROP TABLE if table does not exist
                    System.out.println(e);
                }
            }
            scanner.close();
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
        finally
        {
        	ConnectionManager.close();
        }
    }
}
