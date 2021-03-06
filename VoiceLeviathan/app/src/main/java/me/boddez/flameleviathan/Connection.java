package me.boddez.flameleviathan;

/**
 * Created by sboddez on 15-01-31.
 */

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.util.Timer;
import java.util.TimerTask;

import com.google.gson.Gson;
import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

public class Connection extends Thread {

    private Socket socket;
    private DataOutputStream out;
//    private BufferedReader in;
    public String writeBuffer = "";
    public boolean connected = false;
    private Timer timer;

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

                timer = new Timer();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        try {
            while (connected) {
                if (!this.writeBuffer.isEmpty()) {
                    try {
                        byte[] bytes = this.writeBuffer.getBytes("UTF-8");
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

    public void write(String toWrite, Object speed) {
        if (speed == null || ((int)speed) == 0) {
            // do it once
            Log.d("Write: ", "doing it once");
            timer.cancel();
            this.writeBuffer += toWrite;
            this.writeBuffer += "\r\n";
        } else {
            // do it lots of times
            Log.d("Write: ", "doing it lots of times");
            timer.cancel();
            timer = new Timer();
            timer.schedule(new SendTask(this, toWrite), 0, 250);
        }
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
