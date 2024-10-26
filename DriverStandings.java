import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class DriverStandings {
    public static void main(String[] args) {
        try {
            Scanner s = new Scanner(new File("CSVs/driver_standings.csv"));
            FileWriter f = new FileWriter("DriverStandingInserts.sql");
            // first line with the column names
            s.nextLine();

            String commandStart = "INSERT INTO driverStandings (raceID, driverID, standingsPos, numWins, totalPoints) VALUES(";

            while (s.hasNextLine()) {
                String line = s.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');

                String[] a = singleQuotesLine.split(",");

                String commandEnd = a[1] + "," + a[2] + "," + a[4] + "," + a[6] + "," + a[3] + ");\n";

                f.write(commandStart + commandEnd);
            }
            s.close();
            f.close();
        } catch (FileNotFoundException e) {
            System.out.println("Can't find the file to read from.");
        } catch (IOException e) {
            System.out.println("Problem opening file to write to.");
        }
    }
}
