package me.boddez.flameleviathan;

import java.util.TimerTask;

/**
 * Created by sboddez on 15-02-01.
 */

public class SendTask extends TimerTask {

    Connection c;
    String toWrite;

    public SendTask(Connection c, String toWrite) {
        this.c = c;
        this.toWrite = toWrite;
    }

    @Override
    public void run() {
        c.writeBuffer += toWrite;
    }
}
