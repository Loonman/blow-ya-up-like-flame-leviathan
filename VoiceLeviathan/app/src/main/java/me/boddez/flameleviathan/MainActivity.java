package me.boddez.flameleviathan;

import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.app.Activity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
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

    public void connect() {
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
        this.c.write("w\n");
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // this is where the app will send stuff to the robot
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode==REQUEST_OK  && resultCode==RESULT_OK) {
            ArrayList<String> receivedSpeech = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
            ((TextView)findViewById(R.id.received_speech)).setText(receivedSpeech.get(0));
            Map<String, String> toConvert = makeSense(receivedSpeech);
        }
    }

    private Map<String, String> makeSense(ArrayList<String> received) {
        Map<String, String> dict = new HashMap<String, String>();
        String[] words = received.get(0).split("\\s+");

        boolean stop = true;
        boolean moveIsActive = false;
        boolean dontIsActive = false;
        boolean turnIsActive = false;
        boolean sentSpeed = false;
        boolean sentTurn = false;
        boolean positiveSpeed = false;
        boolean setDirection = false; // forward vs backward
        boolean sortaIsActive = false;
        boolean reallyIsActive = false;
        boolean youreAnIdiot = false;

        for (String word: words) {

            if (dontIsActive && !word.equals("don't")) continue;
            if (stop) break;
            if (youreAnIdiot) {
                Toast.makeText(getApplicationContext(), "You're an idiot", Toast.LENGTH_LONG).show();
                break;
            }

            switch (word) {
                case "stop":
                    stop = true;
                    dict.put("speed", "0");
                    break;

                case "don't":
                    dontIsActive = !dontIsActive;
                    break;

                case "move":
                case "drive":
                    if (dontIsActive) {
                        stop = true;
                    } else {
                        moveIsActive = true;
                    }
                    break;

                case "forward":
                case "forwards":
                    if (setDirection) {
                        youreAnIdiot = true;
                    } else {
                        positiveSpeed = moveIsActive;
                        setDirection = true;
                    }
                    break;

                case "backward":
                case "backwards":
                    if (setDirection) {
                        youreAnIdiot = true;
                    } else {
                        positiveSpeed = !moveIsActive;
                        setDirection = true;
                    }
                    break;

                case "sorta":
                case "kinda":
                case "relatively":
                case "somewhat":
                case "moderately":
                case "pretty":
                    if (reallyIsActive) {
                        youreAnIdiot = true;
                    } else {
                        sortaIsActive = true;
                    }
                    break;

                case "really":
                case "super":
                case "extra":
                case "ultra":
                case "mega":
                    if (sortaIsActive) {
                        youreAnIdiot = true;
                    } else {
                        reallyIsActive = true;
                    }
                    break;

                case "fast":
                case "quick":
                case "quickly":
                    if (sentSpeed) {
                        youreAnIdiot = true;
                        break;
                    }
                    if (sortaIsActive) {
                        if (positiveSpeed) {
                            dict.put("speed", "180");
                        } else {
                            dict.put("speed", "-180");
                        }
                    } else if (reallyIsActive) {
                        if (positiveSpeed) {
                            dict.put("speed", "255");
                        } else {
                            dict.put("speed", "-255");
                        }
                    }
                    sentSpeed = true;
                    break;

                case "slow":
                case "slowly":
                    if (sentSpeed) {
                        youreAnIdiot = true;
                        break;
                    }
                    if (sortaIsActive) {
                        if (positiveSpeed) {
                            dict.put("speed", "100");
                        } else {
                            dict.put("speed", "-100");
                        }

                    } else if (reallyIsActive) {
                        if (positiveSpeed) {
                            dict.put("speed", "40");
                        } else {
                            dict.put("speed", "-40");
                        }
                    }
                    sentSpeed = true;
                    break;

                case "turn":case "steer":
                    turnIsActive = true;
                    break;

                case "left":
                    if (sentTurn) {
                        youreAnIdiot = true;
                    } else {
                        dict.put("steer","-30");
                        sentTurn = true;
                    }
                    break;

                case "right":
                    if (sentTurn) {
                        youreAnIdiot = true;
                    } else {
                        dict.put("steer","30");
                        sentTurn = true;
                    }
                    break;
            }
        }
        return dict;
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
        if (id == R.id.menu_connect) {
            connect();
        }

        return super.onOptionsItemSelected(item);
    }
}
