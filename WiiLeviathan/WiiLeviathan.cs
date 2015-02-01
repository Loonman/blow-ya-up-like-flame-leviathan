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
			for (int i = 0; i < 10; i++)
			{
				weightCal += getWeight(wiimote);
				xCal += getX(wiimote);
				yCal += getY(wiimote);
				System.Threading.Thread.Sleep(250);
			}
			weightCal = weightCal / 10;
			xCal = xCal / 10;
			yCal = yCal / 10;
			Int16 xSpeed=0;
			Int16 ySpeed=0;
			while (true) 
			{
			    if(Math.Abs(getWeight(wiimote) - weightCal) >= 50)
			    {
				    Console.WriteLine("J");
			    }
			    if (getY(wiimote) < (yCal-.5))
			    {
	 			   ySpeed = Convert.ToInt16(Math.Ceiling(getY(wiimote)+.5) * 255 / -12);
			    }
			    if (getY(wiimote) > (yCal + .5))
			    {
				    ySpeed = Convert.ToInt16(Math.Floor(getY(wiimote) - .5) * 255 / 12);
			    }
			    if (getX(wiimote) > (xCal + .5))
			    {
				    xSpeed = Convert.ToInt16(Math.Floor((getX(wiimote) - .5) * 255 / 12));
			    }
			    if (getX(wiimote) < (xCal - .5))
			    {
				    xSpeed = Convert.ToInt16(Math.Ceiling((getX(wiimote) + .5 )*255/12));
			    }
			    Console.Write("X: ");
			    Console.WriteLine(xSpeed.ToString());
			    Console.Write("Y: ");
			    Console.WriteLine(ySpeed.ToString());
			}
        }
    }
}
