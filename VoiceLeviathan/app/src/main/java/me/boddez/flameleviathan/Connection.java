package me.boddez.flameleviathan;

/**
 * Created by sboddez on 15-01-31.
 */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.net.Socket;
import com.google.gson.Gson;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class Connection extends Thread {

    private Socket socket;
    private BufferedWriter out;
//    private BufferedReader in;
    public static int connected = 0;

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
                this.out = new BufferedWriter(new OutputStreamWriter(this.socket.getOutputStream()));
                if (this.out == null) {
                    Log.d("Connection", "shit's null bruh");
                }
                connected = 1;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void write(String toWrite) {
        try {
            out.write(toWrite + "\n");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void disconnect() {
        try {
            socket.close();
            out.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
