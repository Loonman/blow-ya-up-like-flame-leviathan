package me.boddez.flameleviathan;

import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import com.google.gson.Gson;

import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {

    public static TextView connectedView;
    public boolean youreAnIdiot; // this should always be public
    private Map<String, Object> dict;

    protected static final int REQUEST_OK = 1;
    private Connection c;
    private String host = "192.168.1.100";
    private int port = 50007;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        dict = new HashMap<String, Object>();
        dict.put("speed", "0");
        dict.put("steer", "0");
        dict.put("aux", false);
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // this is where the app will send stuff to the robot
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode==REQUEST_OK  && resultCode==RESULT_OK) {
            ArrayList<String> receivedSpeech = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
            ((TextView)findViewById(R.id.received_speech)).setText(receivedSpeech.get(0));
            Map<String, Object> toConvert = makeSense(receivedSpeech);
            if (youreAnIdiot) {
                Toast.makeText(getApplicationContext(), "You're an idiot", Toast.LENGTH_LONG).show();
            } else {
                try {
                    dict = toConvert;
                    Object speed = dict.get("speed");
                    Gson gson = new Gson();
                    String json = gson.toJson(dict);
                    Log.d("Writing: ", json);
                    c.write(json + "\r\n", speed);
                }
                catch (Exception e) {
                    // lol
                }
            }
        }
    }

    private Map<String, Object> makeSense(ArrayList<String> received) {

        /*
        Step 1: Do not attempt to understand this function
        Step 2: Attempt to understand it anyway
        Step 3: ???
        Step 4: Cry
        */

        Map<String, Object> newDict = new HashMap<String, Object>(dict);
        String[] words = received.get(0).split("\\s+");

        boolean stop = false;
        boolean moveIsActive = false;
        boolean dontIsActive = false;
        boolean turnIsActive = false;
        boolean sentSpeed = false;
        boolean sentTurn = false;
        boolean positiveSpeed = false;
        boolean setDirection = false; // forward vs backward
        boolean sortaIsActive = false;
        boolean reallyIsActive = false;
        boolean hammer1IsActive = false;
        boolean hammer2IsActive = false;
        boolean strike1IsActive = false;
        boolean strike2IsActive = false;
        boolean hammer = false;
        youreAnIdiot = false;

        for (String word: words) {
            Log.d("Parsing: ", word);

            if (dontIsActive && !word.equals("don't") && !word.equals("move") && !word.equals("drive")) continue;
            if (stop || youreAnIdiot) break;

            switch (word) {
                case "stop":
                    stop = true;
                    newDict.put("speed", "0");
                    newDict.put("steer", "0");
                    Log.d("Logic: ", "stopped");
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
                    if (reallyIsActive) {
                        if (positiveSpeed) {
                            newDict.put("speed", "255");
                        } else {
                            newDict.put("speed", "-255");
                        }
                    } else {
                        // default speed
                        if (positiveSpeed) {
                            newDict.put("speed", "180");
                        } else {
                            newDict.put("speed", "-180");
                        }
                    }
                    sentSpeed = true;
                    Log.d("Logic: ","set speed");
                    break;

                case "slow":
                case "slowly":
                    if (sentSpeed) {
                        youreAnIdiot = true;
                        break;
                    }
                    if (reallyIsActive) {
                        if (positiveSpeed) {
                            newDict.put("speed", "40");
                        } else {
                            newDict.put("speed", "-40");
                        }
                    } else {
                        if (positiveSpeed) {
                            newDict.put("speed", "100");
                        } else {
                            newDict.put("speed", "-100");
                        }
                    }
                    sentSpeed = true;
                    Log.d("Logic: ","set speed");
                    break;

                case "turn":case "steer":
                    turnIsActive = true;
                    break;

                case "left":
                    if (sentTurn) {
                        youreAnIdiot = true;
                    } else if (turnIsActive) {
                        newDict.put("steer","-20");
                        sentTurn = true;
                        Log.d("Logic: ","set steer");
                    }
                    break;

                case "right":
                    if (sentTurn) {
                        youreAnIdiot = true;
                    } else if (turnIsActive) {
                        newDict.put("steer","20");
                        sentTurn = true;
                        Log.d("Logic: ","set steer");
                    }
                    break;

                case "strike":
                    strike1IsActive = true;
                    break;

                case "it's":
                    hammer1IsActive = true;
                    break;

                case "the":
                    strike2IsActive = strike1IsActive;
                    break;

                case "hammer":
                    hammer2IsActive = hammer1IsActive;
                    break;

                case "earth":
                    if(strike2IsActive) {
                        hammer = true;
                        newDict.put("speed", "0");
                        Log.d("Logic: ","hammered");
                    }
                    break;

                case "time":
                    if (hammer2IsActive) {
                        hammer = true;
                        newDict.put("speed", "0");
                        Log.d("Logic: ","hammered");
                    }
                    break;
            }
        }
        if (hammer) {
            newDict.put("aux", true);
        } else {
            newDict.put("aux", false);
        }

        if (moveIsActive && !dontIsActive && !sentSpeed) {
            newDict.put("speed", "180");
            Log.d("Logic: ","set default speed");
        }
        if (!sentTurn) {
            newDict.put("steer", "0");
            Log.d("Logic: ","reset steering");
        }

        return newDict;
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
//        if (id == R.id.action_settings) {
//            return true;
//        }
        if (id == R.id.menu_connect) {
            c = new Connection(host, port);
        }
        if (id == R.id.menu_disconnect) {
            c.disconnect();
        }
        return super.onOptionsItemSelected(item);
    }
}
