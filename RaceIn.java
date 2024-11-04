import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.Scanner;

public class RaceIn {
    public static void main(String[] args) {

        HashSet<Integer>[] driverRace = new HashSet[1000]; 
        for (int i = 0; i < 1000; i++) {
            driverRace[i] = new HashSet<>();
        }

        try {
            Scanner s = new Scanner(new File("CSVs/results.csv"));
            FileWriter f = new FileWriter("RaceInInserts.sql");
            // first line with the column names
            s.nextLine();
            int largestID = 0;

            
            String commandStart = "INSERT INTO raceIn (driverID, raceID) VALUES(";
            while(s.hasNextLine()) {
                String line = s.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');

                String[] a = singleQuotesLine.split(",");
                
                
                Integer driverID = Integer.parseInt(a[2]);
                if(driverID > largestID){
                    largestID = driverID;
                }
                Integer teamID = Integer.parseInt(a[1]);
                driverRace[driverID].add(teamID);
                
            }
            for(int i = 1; i < largestID +1; i++){
                for (Integer element : driverRace[i]) {
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
