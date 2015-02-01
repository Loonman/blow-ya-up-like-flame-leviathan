using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Sockets;
using System.Web.Helpers;
using Newtonsoft.Json;
using WiimoteLib;

namespace WiiLeviathanConsole
{
	class WiiLeviathan
	{

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
		static void Main(string[] args)
		{
			Wiimote wiimote = new Wiimote();
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
			int turn=0;
			int speed=0;
            Console.Write("Ycal: ");
            Console.WriteLine(yCal.ToString());

            Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

            //This works allegedly.... 
            byte[] byteaddress = new byte[] { 192, 168, 1, 100 };
            IPAddress address = new IPAddress(byteaddress);

            IPEndPoint endpoint = new IPEndPoint(address, 50007);
            //....ignorant
            socket.Connect(endpoint);
            int jump = 0;


			while (true) 
			{
                jump = 0;
                //Get and print the Jump event and constantly updating x,y speeds with deadzones
			    if(Math.Abs(getWeight(wiimote) - weightCal) >= 50)
			    {
                    jump = 1;
			    }
			    if (getY(wiimote) < (yCal- 3))
			    {
                   //This should be forward
	 			   speed = Math.Min(Convert.ToInt32(Math.Ceiling(getY(wiimote)+.5) * 255 / -12),255);
			    }
			    if (getY(wiimote) > (yCal + 3))
			    {
                    //This should be Backwards
				    speed = Math.Max(Convert.ToInt32(Math.Floor(getY(wiimote) - .5) * 255 / -12), -255);
			    }
			    if (getX(wiimote) > (xCal + 1))
			    {
				    turn = Math.Max(Convert.ToInt32(Math.Floor((getX(wiimote) - .5) * 30 / 12)), -30);
			    }
			    if (getX(wiimote) < (xCal - 1))
			    {
				    turn = Math.Min(Convert.ToInt32(Math.Ceiling((getX(wiimote) + .5 )* 30 /12)), 30);
			    }
			    Console.Write("X: ");
			    Console.WriteLine(turn.ToString());
			    Console.Write("Y: ");
			    Console.WriteLine(speed.ToString());
                Dictionary<string, int> dick = new Dictionary<string,int>();
                dick.Add("speed", speed);
                dick.Add("steer", turn);
                dick.Add("aux", jump);
                string JsonString = JsonConvert.SerializeObject(dick);
                Console.WriteLine(JsonString);
                

                byte[] data = Encoding.ASCII.GetBytes(JsonString);
                socket.Send(data);
                System.Threading.Thread.Sleep(250);
			}
            socket.Close();
        }
    }
}
