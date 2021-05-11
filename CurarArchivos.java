import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class CurarArchivos {
    public static void main(String[] args) {
        
        var clientFiles = new File("./cliente").listFiles();
        var serverFiles = new File("./servidor").listFiles();
        
        var files = new File[clientFiles.length + serverFiles.length];
        System.arraycopy(clientFiles, 0, files, 0, clientFiles.length);
        System.arraycopy(serverFiles, 0, files, clientFiles.length, serverFiles.length);

        for (var file : files) {
            if (file.getPath().toLowerCase().endsWith(".frx")) {
                file.delete();
                continue;
            }
            try {
                file.renameTo(new File(file.getPath().toLowerCase()));
        
                var fis = new FileInputStream(file);
                var bytes = fis.readAllBytes();
                fis.close();


                var toLowerCase = new String(bytes).toLowerCase();

                var fos = new FileOutputStream(file);
                fos.write(toLowerCase.getBytes());
                fos.close();

            } catch (FileNotFoundException e) {
                
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        System.out.println("Listo!");
    }
}