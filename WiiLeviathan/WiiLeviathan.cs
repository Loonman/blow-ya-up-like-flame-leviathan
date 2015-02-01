using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
			int xSpeed=0;
			int ySpeed=0;
            Console.Write("Ycal: ");
            Console.WriteLine(yCal.ToString());
			while (true) 
			{
			    if(Math.Abs(getWeight(wiimote) - weightCal) >= 50)
			    {
				    Console.WriteLine("J");
			    }
			    if (getY(wiimote) < (yCal- 3))
			    {
                   //This should be forward
	 			   ySpeed = Math.Min(Convert.ToInt32(Math.Ceiling(getY(wiimote)+.5) * 255 / -12),255);
			    }
			    if (getY(wiimote) > (yCal + 3))
			    {
                    //This should be Backwards
				    ySpeed = Math.Max(Convert.ToInt32(Math.Floor(getY(wiimote) - .5) * 255 / -12), -255);
			    }
			    if (getX(wiimote) > (xCal + 1))
			    {
				    xSpeed = Math.Max(Convert.ToInt32(Math.Floor((getX(wiimote) - .5) * 30 / 12)), -30);
			    }
			    if (getX(wiimote) < (xCal - 1))
			    {
				    xSpeed = Math.Min(Convert.ToInt32(Math.Ceiling((getX(wiimote) + .5 )* 30 /12)), 30);
			    }
			    Console.Write("X: ");
			    Console.WriteLine(xSpeed.ToString());
			    Console.Write("Y: ");
			    Console.WriteLine(ySpeed.ToString());
                System.Threading.Thread.Sleep(500);
                
			}
        }
    }
}
