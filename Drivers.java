import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class Drivers {
    public static void main(String[] args) {
        try {
            Scanner s = new Scanner(new File("DatabaseCreation/CSVs/drivers.csv"));
            FileWriter f = new FileWriter("DriversInserts.sql");
            // first line with the column names
            s.nextLine();
            String commandStart = "INSERT INTO drivers (driverID, driverNationality, driverNumber, driverFirstName, driverLastName, dob) VALUES(";

            while(s.hasNextLine()) {
                String line = s.nextLine();
                // System.out.println(line);
                String singleQuotesLine = line.replace('\"', '\'');
                // System.out.println(singleQuotesLine);
                String correctNullsLine = singleQuotesLine.replace("\\N", "null");

                String[] a = correctNullsLine.split(",");
                
                String commandEnd = a[0] + "," + a[7] + "," + a[2] + "," + a[4] + "," + a[5] + "," + a[6] + ");\n";

                f.write(commandStart + commandEnd);
            }
            s.close();
            f.close();
        } catch(FileNotFoundException e) {
            System.out.println("Can't find the file to read from.");
        } catch(IOException e) {
            System.out.println("Problem opening file to write to.");
        } catch(Exception e) {
            System.out.println(e);
        }
    }
}
