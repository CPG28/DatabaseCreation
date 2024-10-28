import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.Scanner;

public class PartakeIn {
    
    public static void main(String[] args) {

        HashSet<Integer>[] teamRace = new HashSet[1000]; 
        for (int i = 0; i < 1000; i++) {
            teamRace[i] = new HashSet<>();
        }

        try {
            Scanner s = new Scanner(new File("DatabaseCreation/CSVs/results.csv"));
            FileWriter f = new FileWriter("PartakeInInserts.sql");
            // first line with the column names
            s.nextLine();
            int lastID = 0;

            
            String commandStart = "INSERT INTO partakeIn (teamID, raceID) VALUES(";
            while(s.hasNextLine()) {
                String line = s.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');

                String[] a = singleQuotesLine.split(",");
                
                
                Integer teamID = Integer.parseInt(a[3]);
                lastID = teamID;
                Integer raceID = Integer.parseInt(a[1]);
                teamRace[teamID].add(raceID);
                
            }
            for(int i = 1; i < lastID +1; i++){
                for (Integer element : teamRace[i]) {
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
