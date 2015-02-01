using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using WiimoteLib;
using System.Web.Helpers;
using Newtonsoft.Json;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using System.Diagnostics;

namespace WiiLeviathanNowWithFlameLeviathan
{
    public partial class FlameLeviathan : Form
    {
        public FlameLeviathan()
        {
            InitializeComponent();
        }
        
		public static float getWeight(Wiimote wiimote)
		{
			return wiimote.WiimoteState.BalanceBoardState.WeightLb;
		}
		public static float getX(Wiimote wiimote)
		{
			return wiimote.WiimoteState.BalanceBoardState.CenterOfGravity.X;
		}
		public static float getY(Wiimote wiimote)
		{
			return wiimote.WiimoteState.BalanceBoardState.CenterOfGravity.Y;
		}

        public class leviathanserver
        {
            Socket socket;
            Wiimote wiimote;
            public void WiiLeviathanServer()
            {
                wiimote = new Wiimote();
                wiimote.Connect();
                wiimote.SetReportType(InputReport.IRAccel, true);
                wiimote.SetLEDs(true, true, true, true);
                //Calibration loop
                float weightCal = 0;
                float xCal = 0;
                float yCal = 0;
                for (int i = 0; i < 100; i++)
                {
                    weightCal += getWeight(wiimote);
                    xCal += getX(wiimote);
                    yCal += getY(wiimote);
                }
                weightCal = weightCal / 100;
                xCal = xCal / 100;
                yCal = yCal / 100;
                int turn = 0;
                int speed = 0;
                Console.Write("Ycal: ");
                Console.WriteLine(yCal.ToString());

                socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

                //This works allegedly.... 
                byte[] byteaddress = new byte[] { 10, 161, 1, 100 };
                IPAddress address = new IPAddress(byteaddress);

                IPEndPoint endpoint = new IPEndPoint(address, 50007);
                //....ignorant

                Connect:
                try
                {
                    socket.Connect(endpoint);
                }
                catch
                {
                    var result = MessageBox.Show("Failed to Connect, Trying again");
                    goto Connect;      
                }

                bool jump = false;
                while (true)
                {
                    jump = false;
                    //Get and print the Jump event and constantly updating x,y speeds with deadzones
                    if (Math.Abs(getWeight(wiimote) - weightCal) >= 50)
                    {
                        jump = true;
                    }
                    if (getY(wiimote) < (yCal - 1))
                    {
                        //This should be forward
                        speed = Math.Min(Convert.ToInt32(Math.Ceiling(getY(wiimote) + 3) * 255 / -12), 255);
                    }
                    if (getY(wiimote) > (yCal + 1))
                    {
                        //This should be Backwards
                        speed = Math.Max(Convert.ToInt32(Math.Floor(getY(wiimote) - 3) * 255 / -12), -255);
                    }
                    //This should be left
                    if (getX(wiimote) > (xCal + 1))
                    {
                        turn = Math.Max(Convert.ToInt32(Math.Floor((getX(wiimote) - 3) * 20 / 12)), -20);
                    }
                    //This should be right
                    if (getX(wiimote) < (xCal - 1))
                    {
                        turn = Math.Min(Convert.ToInt32(Math.Ceiling((getX(wiimote) + 3) * 20 / 12)), 20);
                    }
                    
                    //Make dictionary of speed, steer and aux
                    Dictionary<string, object> dick = new Dictionary<string, object>();
                    dick.Add("speed", speed);
                    dick.Add("steer", turn);
                    dick.Add("aux", jump);


                    string JsonString = JsonConvert.SerializeObject(dick);

                    byte[] data = Encoding.ASCII.GetBytes(JsonString);
                    socket.Send(data);
                    System.Threading.Thread.Sleep(250);
                }

            }
            public void closeSock()
            {
                socket.Close();
            }
            public void closeWiimote()
            {
                wiimote.Disconnect();
            }
            public void Kill()
            {
                System.Diagnostics.Process.GetCurrentProcess().Kill();
            }
        }
        private void Form1_Load(object sender, EventArgs e)
        {
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
        //Initialize the new thread
        leviathanserver oServer = new leviathanserver();
        Thread oThread; 

        private void Form1_closeClick(object sender, FormClosedEventArgs e)
        {
            oServer.closeWiimote();
            oServer.closeSock();
            oThread.Abort();
            Application.ExitThread();

            
        }


        private void button1_Click(object sender, EventArgs e)
        {
            //Start a new thread
            oThread = new Thread(new ThreadStart(oServer.WiiLeviathanServer));
            oThread.Start();
            while (!oThread.IsAlive);
            Thread.Sleep(1);
            //Deal with exceptions by removing the button and exceptions ;)
            button1.Hide();

        }
    }
}
