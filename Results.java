import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class Results {
    public static void main(String[] args) {
        try {
            Scanner races = new Scanner(new File("CSVs/results.csv"));
            Scanner sprint = new Scanner(new File("CSVs/sprint_results.csv"));
            Scanner qualy = new Scanner(new File("CSVs/qualifying.csv"));
            FileWriter f = new FileWriter("ResultsInserts.sql");

            // reading races.csv into results first
            int resultsCounter = 0;
            // column names
            races.nextLine();
            String resultsCommandStart = "INSERT INTO results (driverID, constructorID, raceID, finalPos, carNum) VALUES(";
            String raceResultsCommandStart = "INSERT INTO raceResults (resultID, startPos, numPoints, raceTyep) VALUES(";
            while(races.hasNextLine()) {
                resultsCounter++;
                String line = races.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');
                String correctNullsLine = singleQuotesLine.replace("\\N", "null");

                String[] a = correctNullsLine.split(",");
                //                                                                 v should this be 'position'?
                String resultsCommandEnd = a[2] + "," + a[3] + "," + a[1] + "," + a[6] + "," + a[4] + ");\n";
                // race type is just race for official race?
                String raceResultsCommandEnd = resultsCounter + "," + a[5] + "," + a[9] + ",\'GP\');\n";
                f.write(resultsCommandStart + resultsCommandEnd);
                f.write(raceResultsCommandStart + raceResultsCommandEnd);
            }
            
            // doing sprint results

            // column names
            sprint.nextLine();
            while(sprint.hasNext()) {
                resultsCounter++;
                String line = sprint.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');
                String correctNullsLine = singleQuotesLine.replace("\\N", "null");

                String[] a = correctNullsLine.split(",");

                String resultsCommandEnd = a[2] + "," + a[3] + "," + a[1] + "," + a[6] + "," + a[4] + ");\n";
                String sprintResultsCommandEnd = resultsCounter + "," + a[5] + "," + a[9] + ",\'SR\');\n"; 
            
                f.write(resultsCommandStart + resultsCommandEnd);
                f.write(raceResultsCommandStart + sprintResultsCommandEnd);
            }

            // doing qualy results
            // String resultsCommandStart = "INSERT INTO results (driverID, constructorID, raceID, finalPos, carNum) VALUES(";
            String qualyCommandStart = "INSERT INTO qualifyingResults (resultID, q1Time, q2Time, q3Time) VALUES(";
            // column names
            qualy.nextLine();
            while(qualy.hasNext()) {
                resultsCounter++;
                String line = qualy.nextLine();
                String singleQuotesLine = line.replace('\"', '\'');
                String correctNullsLine = singleQuotesLine.replace("\\N", "null");

                String[] a = correctNullsLine.split(",");

                String resultsCommandEnd = a[2] + "," + a[3] + "," + a[1] + "," + a[5] + "," + a[4] + ");\n";
                
                // reformatting the time to '00:MM:SS.SS' from 'MM:SS.SS'
                String q1;
                // no qualifying time recorded
                if(a[6].equals("null")) {
                    q1 = "null";
                // qualifying time was >= 10 minutes and string is > 10 characters long, so don't append a 0 to minutes time
                } else if(a[6].length() > 10) {
                    q1 = "\'00:" + a[6].substring(1);
                // qualifying time was < 10 minutes, appending an extra 0 so it is '00:0M:SS.SS'
                } else {
                    q1 = "\'00:0" + a[6].substring(1);
                }
                String q2;
                if(a[7].equals("null")) {
                    q2 = "null";
                } else if(a[7].length() > 10) {
                    q2 = "\'00:" + a[7].substring(1);
                } else {
                    q2 = "\'00:0" + a[7].substring(1);
                }
                String q3;
                if(a[8].equals("null")) {
                    q3 = "null";
                } else if(a[8].length() > 10) {
                    q3 = "\'00:" + a[8].substring(1);
                } else {
                    q3 = "\'00:0" + a[8].substring(1);
                }
                String qualyCommandEnd = resultsCounter + "," + q1 + "," + q2 + "," + q3 + ");\n";

                f.write(resultsCommandStart + resultsCommandEnd);
                f.write(qualyCommandStart + qualyCommandEnd);
            }

            races.close();
            qualy.close();
            sprint.close();
            f.close();
        } catch(FileNotFoundException e) {
            System.out.println("Can't find the file to read from.");
        } catch(IOException e) {
            System.out.println("Problem opening file to write to.");
        }
    }
}
