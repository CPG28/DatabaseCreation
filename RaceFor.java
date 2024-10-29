import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;
import java.util.HashSet;


public class RaceFor {
    public static void main(String[] args) {

        HashSet<Integer>[] driverTeam = new HashSet[1000]; 
        for (int i = 0; i < 1000; i++) {
            driverTeam[i] = new HashSet<>();
        }

        try {
            Scanner s = new Scanner(new File("CSVs/results.csv"));
            FileWriter f = new FileWriter("RaceForInserts.sql");
            // first line with the column names
            s.nextLine();
            int lastID = 0;

            
            String commandStart = "INSERT INTO raceFor (driverID, constructorID) VALUES(";
            while(s.hasNextLine()) {
                String line = s.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');

                String[] a = singleQuotesLine.split(",");
                
                
                Integer driverID = Integer.parseInt(a[2]);
                lastID = driverID;
                Integer teamID = Integer.parseInt(a[3]);
                driverTeam[driverID].add(teamID);
                
            }
            for(int i = 1; i < lastID +1; i++){
                for (Integer element : driverTeam[i]) {
                    String commandEnd = i + ", " + element + ");\n";
                    f.write(commandStart + commandEnd);
                }
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
