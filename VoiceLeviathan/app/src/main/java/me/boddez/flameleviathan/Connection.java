package me.boddez.flameleviathan;

/**
 * Created by sboddez on 15-01-31.
 */

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;
import com.google.gson.Gson;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class Connection extends Thread {

    private Socket socket;
    private DataOutputStream out;
//    private BufferedReader in;
    public static int connected = 0;
    private String writeBuffer = "";

    String host;
    int port;

    public Connection(String host, int port) {

        this.host = host;
        this.port = port;

        this.start();
    }

    @Override
    public void run() {
        if (connected != 1) {
            try {
                this.socket = new Socket(host, port);
                this.out = new DataOutputStream(this.socket.getOutputStream());
                if (this.out == null) {
                    Log.d("Connection", "shit's null bruh");
                }
                connected = 1;
                while (connected == 1) {
                    if (!this.writeBuffer.isEmpty()) {
                        try {
                            byte[] bytes = this.writeBuffer.getBytes();
                            out.writeInt(bytes.length);
                            out.write(bytes);
                            out.flush();
                        }
                        catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void write(String toWrite) {
        Log.d("Connection:write", "trying to write");
        this.writeBuffer += toWrite;
    }

    public void disconnect() {
        try {
            socket.close();
            out.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        connected = 0;
    }
}
