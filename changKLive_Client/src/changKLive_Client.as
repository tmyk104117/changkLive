package
{
	
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.aswing.AsWingManager;
	import org.aswing.JOptionPane;

	public class changKLive_Client extends Sprite
	{
		var ns:NetStream;
		var nc:NetConnection = new NetConnection();
		var video:Video = new Video();		
		private var startPublish:PushButton = new PushButton();
		private var serverName:InputText = new InputText();	
		private var serverPath:String;
		private var streamName:String = '' ;
		private var streamUrl:String = '' ;
		var text:TextArea = new TextArea();
		public function changKLive_Client()
		{
			nc.client = new MetaData();
			video.width = 450 ;
			video.height = 337 ;		
			AsWingManager.initAsStandard(this);
			addChild(video);
			serverName.width = 460 ;
			serverName.height = 30 ;
			serverName.y = 360 ;
			addChild(serverName);
			startPublish.y = 390 ;
			startPublish.label = "Play";
			addChild(startPublish);
			startPublish.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
			text.y = 490 ;
			text.width = 460 ;
			addChild(text);
		}
		
		
		private function onAsyncError(e:Event):void
		{
			
		}
		
		private function onMouseUp(e:MouseEvent):void
		{				
			serverPath = serverName.text ; 
			if (serverPath.indexOf("rtmp") < 0 || serverPath.length <= 0)
			{
				JOptionPane.showMessageDialog("消息", "地址不对");
			}else {

				 streamUrl = serverPath.slice(0, serverPath.indexOf("?"));
				 streamName = serverPath.substring( serverPath.indexOf("=")+1);
				receiveStream(streamUrl)
			}
			

		}
		
		private function receiveStream(url):void
		{
			nc.connect(url);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus)			
		}
		

		private function onNetStatus(e:NetStatusEvent):void
		{
			text.text = text.text + e.info.code+"\n";
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					ns = new NetStream(nc);
					ns.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);					
					video.attachNetStream(ns);
					ns.play(streamName);
					ns.client = new MetaData();
					break;
				case "NetStream.Play.Start":
					
					break;
			}
		}
		
		public function onMetaData(o:*):void
		{
			
		}
				
	}
}