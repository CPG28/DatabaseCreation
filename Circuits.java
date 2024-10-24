import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class Circuits {
    public static void main(String[] args) {
        try {
            Scanner s = new Scanner(new File("circuits.csv"));
            FileWriter f = new FileWriter("CircuitsInserts.sql");
            // first line with the column names
            s.nextLine();
            
            String commandStart = "INSERT INTO circuits (circuitAltitude, circuitLongitude, circuitLatitude, circuitCountry, circuitName) VALUES(";

            while(s.hasNextLine()) {
                String line = s.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');

                String[] a = singleQuotesLine.split(",");
                
                String commandEnd = a[7] + "," + a[6] + "," + a[5] + "," + a[4] + "," + a[2] + ");\n";

                f.write(commandStart + commandEnd);
            }
            s.close();
            f.close();
        } catch(FileNotFoundException e) {
            System.out.println("Can't find the file to read from.");
        } catch(IOException e) {
            System.out.println("Problem opening file to write to.");
        }
    }
}
