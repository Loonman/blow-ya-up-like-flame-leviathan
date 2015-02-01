package me.boddez.flameleviathan;

/**
 * Created by sboddez on 15-01-31.
 */

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;
import com.google.gson.Gson;
import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class Connection extends Thread {

    private Socket socket;
    private DataOutputStream out;
//    private BufferedReader in;
    private String writeBuffer = "";
    public boolean connected = false;

    String host;
    int port;

    public Connection(String host, int port) {

        this.host = host;
        this.port = port;
        this.start();
    }

    @Override
    public void run() {
        if (!connected) {
            try {
                this.socket = new Socket(host, port);
                this.out = new DataOutputStream(this.socket.getOutputStream());
                connected = true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        try {
            while (connected) {
                if (!this.writeBuffer.isEmpty()) {
                    try {
                        byte[] bytes = this.writeBuffer.getBytes();
                        out.writeInt(bytes.length);
                        out.write(bytes);
                        out.flush();
                        this.writeBuffer = "";
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

    public void write(String toWrite) {
        this.writeBuffer += toWrite;
    }

    public void disconnect() {
        try {
            out.close();
            socket.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
