using System;
using System.IO;
//using System.Collections;
//using System.ComponentModel;
//using System.Drawing;
using System.Windows.Forms;

using Flash.External;

namespace IntrovertIM_CSharp
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class AppForm : System.Windows.Forms.Form
	{
		#region Private Fields

		private bool appReady = false;
		private bool swfReady = false;
		private ExternalInterfaceProxy proxy;

		#endregion

		#region Constructor

		public AppForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			String swfPath = Directory.GetCurrentDirectory() + Path.DirectorySeparatorChar + "IntrovertIMApp.swf";
			this.IntrovertIMApp.LoadMovie(0, swfPath);

			// Create the proxy and register this app to receive notification when the proxy receives
			// a call from ActionScript
			proxy = new ExternalInterfaceProxy(IntrovertIMApp);
			proxy.ExternalInterfaceCall += new ExternalInterfaceCallEventHandler(proxy_ExternalInterfaceCall);

			appReady = true;
		}

		#endregion

		#region Event Handling

		/// <summary>
		/// Called when the "Send" button is clicked by the user.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void SendButton_Click(object sender, System.EventArgs e)
		{
			sendMessage(MessageText.Text);
		}


		/// <summary>
		/// Called by the proxy when an ActionScript ExternalInterface call
		/// is made by the SWF
		/// </summary>
		/// <param name="sender">The object raising the event</param>
		/// <param name="e">The event arguments associated with the event</param>
		/// <returns>The response to the function call.</returns>
		private object proxy_ExternalInterfaceCall(object sender, ExternalInterfaceCallEventArgs e)
		{
			switch (e.FunctionCall.FunctionName)
			{
				case "isReady":
					return isReady();
				case "setSWFIsReady":
					setSWFIsReady();
					return null;
				case "newMessage":
					newMessage((string)e.FunctionCall.Arguments[0]);
					return null;
				case "statusChange":
					statusChange();
					return null;
				default:
					return null;
			}
		}


		#endregion

		#region Methods called by Flash Player

		/// <summary>
		/// Called to check if the page has initialized and JavaScript is available
		/// </summary>
		/// <returns></returns>
		private bool isReady()
		{
			return appReady;
		}

		/// <summary>
		/// Called to notify the page that the SWF has set it's callbacks
		/// </summary>
		private void setSWFIsReady()
		{
			// record that the SWF has registered it's functions (i.e. that C#
			// can safely call the ActionScript functions)
			swfReady = true;

			updateStatus();
		}

		/// <summary>
		/// Called to notify C# of a new message from the SWF IM client
		/// </summary>
		/// <param name="message"></param>
		private void newMessage(string message)
		{
			// append the message text to the end of the transcript
			string textToAppend = String.Format("The Other Person: {0}{1}", message, Environment.NewLine);
			Transcript.AppendText(textToAppend);
		}

		/// <summary>
		/// Called to notify the page that the SWF user's availability (status) has changed
		/// </summary>
		private void statusChange()
		{
			updateStatus();
		}

		#endregion

		#region Other Private Methods

		/// <summary>
		/// Called when the "Send" button is pressed; the value in the
		/// MessageText text field is passed in as a parameter.
		/// </summary>
		/// <param name="message">The message to send.</param>
		private void sendMessage(string message)
		{
			if (swfReady)
			{
				// if the SWF has registered it's functions, add the message text to
				// the local transcript, send it to the SWF file to be processed
				// there, and clear the message text field.
				string localText = String.Format("You: {0}{1}", message, Environment.NewLine);
				Transcript.AppendText(localText);
				MessageText.Clear();
				// call the newMessage function in ActionScript
				proxy.Call("newMessage", message);
			}
		}

		/// <summary>
		/// Calls the ActionScript function to get the current "availability"
		/// status and writes it into the text field.
		/// </summary>
		private void updateStatus()
		{
			Status.Text = (string)proxy.Call("getStatus");
		}

		#endregion

		#region Controls

		private AxShockwaveFlashObjects.AxShockwaveFlash IntrovertIMApp;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox Status;
		private System.Windows.Forms.TextBox Transcript;
		private System.Windows.Forms.TextBox MessageText;
		private System.Windows.Forms.Button SendButton;

		#endregion

		#region Miscellaneous

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new AppForm());
		}

		
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#endregion

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(AppForm));
			this.IntrovertIMApp = new AxShockwaveFlashObjects.AxShockwaveFlash();
			this.label1 = new System.Windows.Forms.Label();
			this.Status = new System.Windows.Forms.TextBox();
			this.Transcript = new System.Windows.Forms.TextBox();
			this.MessageText = new System.Windows.Forms.TextBox();
			this.SendButton = new System.Windows.Forms.Button();
			((System.ComponentModel.ISupportInitialize)(this.IntrovertIMApp)).BeginInit();
			this.SuspendLayout();
			// 
			// IntrovertIMApp
			// 
			this.IntrovertIMApp.Enabled = true;
			this.IntrovertIMApp.Location = new System.Drawing.Point(16, 16);
			this.IntrovertIMApp.Name = "IntrovertIMApp";
			this.IntrovertIMApp.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("IntrovertIMApp.OcxState")));
			this.IntrovertIMApp.Size = new System.Drawing.Size(600, 300);
			this.IntrovertIMApp.TabIndex = 0;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(0, 352);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(144, 22);
			this.label1.TabIndex = 1;
			this.label1.Text = "The Other Person\'s Status";
			this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			// 
			// Status
			// 
			this.Status.Location = new System.Drawing.Point(152, 352);
			this.Status.Name = "Status";
			this.Status.ReadOnly = true;
			this.Status.Size = new System.Drawing.Size(224, 20);
			this.Status.TabIndex = 2;
			this.Status.Text = "";
			// 
			// Transcript
			// 
			this.Transcript.Location = new System.Drawing.Point(16, 384);
			this.Transcript.Multiline = true;
			this.Transcript.Name = "Transcript";
			this.Transcript.ReadOnly = true;
			this.Transcript.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
			this.Transcript.Size = new System.Drawing.Size(600, 200);
			this.Transcript.TabIndex = 3;
			this.Transcript.Text = "";
			// 
			// MessageText
			// 
			this.MessageText.Location = new System.Drawing.Point(16, 592);
			this.MessageText.Name = "MessageText";
			this.MessageText.Size = new System.Drawing.Size(512, 20);
			this.MessageText.TabIndex = 4;
			this.MessageText.Text = "";
			// 
			// SendButton
			// 
			this.SendButton.Location = new System.Drawing.Point(544, 592);
			this.SendButton.Name = "SendButton";
			this.SendButton.Size = new System.Drawing.Size(72, 22);
			this.SendButton.TabIndex = 5;
			this.SendButton.Text = "Send";
			this.SendButton.Click += new System.EventHandler(this.SendButton_Click);
			// 
			// AppForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(632, 630);
			this.Controls.Add(this.SendButton);
			this.Controls.Add(this.MessageText);
			this.Controls.Add(this.Transcript);
			this.Controls.Add(this.Status);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.IntrovertIMApp);
			this.Name = "AppForm";
			this.Text = "Introvert IM (C# Edition)";
			((System.ComponentModel.ISupportInitialize)(this.IntrovertIMApp)).EndInit();
			this.ResumeLayout(false);

		}
		#endregion
	}
}
