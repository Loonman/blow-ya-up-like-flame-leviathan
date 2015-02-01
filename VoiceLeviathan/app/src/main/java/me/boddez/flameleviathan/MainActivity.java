package me.boddez.flameleviathan;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.app.Activity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {

    public static TextView connectedView;

    protected static final int REQUEST_OK = 1;
    private Connection c;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
//        findViewById(R.id.button).setOnClickListener(this);
        connectedView = (TextView) findViewById(R.id.connectedView);
        connectedView.setText("Not connected");
    }

//    @Override
//    public void onClick(View v) {
//        Intent i = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
//        i.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, "en-US");
//        try {
//            startActivityForResult(i, REQUEST_OK);
//        } catch (Exception e) {
//            Toast.makeText(this, "Error initializing speech to text engine.", Toast.LENGTH_LONG).show();
//        }
//    }

    public void connect(View v) {
        c = new Connection("192.168.1.100", 50007);
        if (Connection.connected == 1) {
            connectedView.setText("Connected");
        } else {
            connectedView.setText("Not connected");
        }
    }

    public void speak(View v) {
        Intent i = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        i.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, "en-US");
        try {
            startActivityForResult(i, REQUEST_OK);
        } catch (Exception e) {
            Toast.makeText(this, "Error initializing speech to text engine.", Toast.LENGTH_LONG).show();
        }
    }

    public void sendw(View v) {
        this.c.write("w");
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // this is where the app will send stuff to the robot
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode==REQUEST_OK  && resultCode==RESULT_OK) {
            ArrayList<String> receivedSpeech = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
            ((TextView)findViewById(R.id.received_speech)).setText(receivedSpeech.get(0));

            c.write("w");
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
