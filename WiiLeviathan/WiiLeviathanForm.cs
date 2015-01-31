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

namespace WiiLeviathan
{
    public partial class WiiLeviathanForm : Form
    {
        Wiimote wiimote = new Wiimote();
        public WiiLeviathanForm()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //wiimoteInfo1.Wiimote = wiimote;

            wiimote.WiimoteChanged += wiimote_WiimoteChanged;
            wiimote.WiimoteExtensionChanged += wiimote_WiimoteExtensionChanged;
            wiimote.Connect();
            wiimote.SetReportType(InputReport.IRAccel, true);
            wiimote.SetLEDs(checkBox1.Checked, checkBox2.Checked, checkBox3.Checked, checkBox4.Checked);

        }
        
        private void changeLEDS()
        {
            wiimote.SetLEDs(checkBox1.Checked, checkBox2.Checked, checkBox3.Checked, checkBox4.Checked);
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void wiimote_WiimoteChanged(object sender, WiimoteChangedEventArgs args)
        {
            //wiimoteInfo1.UpdateState(args);
        }

        private void wiimote_WiimoteExtensionChanged(object sender, WiimoteExtensionChangedEventArgs args)
        {
            //wiimoteInfo1.UpdateExtension(args);

            if (args.Inserted)
                wiimote.SetReportType(InputReport.IRExtensionAccel, true);
            else
                wiimote.SetReportType(InputReport.IRAccel, true);
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            wiimote.Disconnect();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                string[] led = textBox1.Text.Split(',');
                if (led.Length == 4)
                {
                    try
                    {
                        bool[] ledbool = new bool[] { };
                        for(int i = 0; i<4; i++)
                        {
                            Console.WriteLine(Convert.ToBoolean(led[i]));
                            ledbool[i] = Convert.ToBoolean(led[i]);
                        }
                        wiimote.SetLEDs(ledbool[0], ledbool[1], ledbool[2], ledbool[3]);
                    }
                    catch
                    {
                        MessageBox.Show("Could not change led values");
                    }
                }
            }
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            changeLEDS();
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            changeLEDS();
        }

        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {
            changeLEDS();
        }

        private void checkBox4_CheckedChanged(object sender, EventArgs e)
        {
            changeLEDS();
        }
    }
}
