import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class Races {
    public static void main(String[] args) {
        try {
            Scanner s = new Scanner(new File("CSVs/races.csv"));
            FileWriter f = new FileWriter("RacesInserts.sql");
            // first line with the column names
            s.nextLine();

            String commandStart = "INSERT INTO races (raceID, circuitID, season, raceNum, raceName, raceDate) VALUES(";

            while (s.hasNextLine()) {
                String line = s.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');

                String[] a = singleQuotesLine.split(",");

                String commandEnd = a[0] + "," + a[3] + "," + a[1] + "," + a[2] + "," + a[4] + "," + a[5] + ");\n";

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
