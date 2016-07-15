package com.rpg.framework.loading
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getTimer;

	/** 没测试本地存储 */	
	public class VideoItem extends LoadingItem 
	{
        private var nc:NetConnection;
        public var stream : NetStream;
        public var dummyEventTrigger : Sprite;
        public var _checkPolicyFile : Boolean;
        public var pausedAtStart : Boolean = false;
        public var _metaData : Object;
        
        /** Indicates if we've already fired an event letting users know that the netstream can
        *   begin playing (has enough buffer to play with no interruptions)
        *   @private
        */
        public var _canBeginStreaming : Boolean = false;
        
        
		public function VideoItem(url : String, type : String, name : String)
		{
			super(url, type, name);
			bytesTotal = bytesLoaded = 0;
		}
        
		public override function load() : void
		{
			super.load();
			
		    nc = new NetConnection();
		    nc.connect(null);
            stream = new NetStream(nc);
            stream.addEventListener(IOErrorEvent.IO_ERROR	 , onErrorHandler, false, 0, false);
            stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus   , false, 0, false);
            dummyEventTrigger = new Sprite();
            dummyEventTrigger.addEventListener(Event.ENTER_FRAME, createNetStreamEvent, false, 0, false);
            var customClient:Object = new Object();
            customClient.onCuePoint = function(...args):void{};
            customClient.onMetaData = onVideoMetadata;
            customClient.onPlayStatus = function(...args):void{};
            stream.client = customClient;
            
            try
            {
            	stream.play(_urlRequest, _checkPolicyFile);
            }
            catch(e : SecurityError)
            {
            	super.onSecurityErrorHandler(createErrorEvent(e));
            }
            
            stream.seek(0);
		}
		
        public function createNetStreamEvent(evt : Event) : void
        {
            if(bytesTotal == bytesLoaded && bytesTotal > 8)
            {
            	// done loading: clean up, trigger on complete
                if (dummyEventTrigger) dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, createNetStreamEvent, false);
                // maybe the video is in cache, and we need to trigger CAN_BEGIN_PLAYING:
                fireCanBeginStreamingEvent();
                var completeEvent : Event = new Event(Event.COMPLETE);
                onCompleteHandler(completeEvent);
            }
            else if(bytesTotal == 0 && stream && stream.bytesTotal > 4)
            {
            	// just sa
                var startEvent : Event = new Event(Event.OPEN);
                onStartedHandler(startEvent);
				bytesLoaded = stream.bytesLoaded;
				bytesTotal  = stream.bytesTotal;
            }
            else if (stream)
            {
                var event : ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, stream.bytesLoaded, stream.bytesTotal);
                // if it's a video, check if we predict that time until finish loading
                   // is enough to play video back
                   
                   if (/*isVideo()  && */metaData && !_canBeginStreaming)
                   {
                       var timeElapsed : int = getTimer() - _responseTime;
                       // se issue 49 on this hack
                       if (timeElapsed > 100)
                       {
                           var currentSpeed : Number = bytesLoaded / (timeElapsed/1000);
                           // calculate _bytes remaining, before the super onProgressHandler fires
						   bytesRemaining = bytesTotal - bytesLoaded;
                           // be cautios, give a 20% error margin for estimated download time:
                           var estimatedTimeRemaining : Number = bytesRemaining / (currentSpeed * 0.8);
                           var videoTimeToDownload : Number = metaData.duration - stream.bufferLength;
                            if (videoTimeToDownload > estimatedTimeRemaining)
                            {
                            	fireCanBeginStreamingEvent();
                            }
                       }
                       
                   }
                super.onProgressHandler(event)
            }
        }
        
		protected override function onCompleteHandler(evt : Event) : void 
		{
			content = stream;
            super.onCompleteHandler(evt);
        }
        
		protected override function onStartedHandler(evt : Event) : void
		{
			content = stream;
            if(pausedAtStart && stream)
			{
                stream.pause();
            }
            super.onStartedHandler(evt);
        }
        
		public override function stop() : void
		{
            try
			{
                if(stream)
				{
                    stream.close();
                }
            }
			catch(e : Error){}
            super.stop();
        }
        
		protected override function cleanListeners() : void 
        {
            if (stream) 
			{
                stream.removeEventListener(IOErrorEvent.IO_ERROR    , super.onErrorHandler, false);
                stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus		  , false);
            }
            if(dummyEventTrigger)
            {
                dummyEventTrigger.removeEventListener(Event.ENTER_FRAME, createNetStreamEvent, false);
                dummyEventTrigger = null;
            }
        }
        
//		public override function isVideo(): Boolean
//		{
//		    return true;
//		}
//		public override function isStreamable() : Boolean
//		{
//		    return true;
//		}
        
		public override function dispose() : void
		{
			super.dispose();
            if(stream)
            {
                //stream.client = null;
            }
            this.stream = null;
        }
        
        internal function onNetStatus(evt : NetStatusEvent) : void
        {
            if(!stream)
            {
                return;
            }
            stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false);
            if(evt.info.code == "NetStream.Play.Start")
            {
				content = stream;
                var e : Event = new Event(Event.OPEN);
                onStartedHandler(e);
            }
            else if(evt.info.code == "NetStream.Play.StreamNotFound")
            {
                onErrorHandler(createErrorEvent(new Error("[VideoItem] NetStream not found at " + this.url)));
            }
        }
        
        internal function onVideoMetadata(evt : *):void
		{
            _metaData = evt;
        }
        
        public function get metaData() : Object 
		{ 
            return _metaData; 
        }
        
        public function get checkPolicyFile() : Object 
		{ 
            return _checkPolicyFile; 
        }
        
        private function fireCanBeginStreamingEvent() : void
		{
            if(_canBeginStreaming)
			{
                return;
            }
            _canBeginStreaming = true;
            var evt : Event    = new Event(BulkLoader.CAN_BEGIN_PLAYING);
            dispatchEvent(evt);
        }
        
        public function get canBeginStreaming() : Boolean
		{
            return _canBeginStreaming;
        }
	}
}
