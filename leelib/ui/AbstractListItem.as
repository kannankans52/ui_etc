package leelib.ui
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import leelib.loadUtil.LoadUtil;
	import leelib.util.Out;
	
	
	public class AbstractListItem extends Component
	{
		public static var EVENT_SELECT:String = "ListItem.eventSelect"; 
		public static var EVENT_MOUSEDOWN:String = "ListItem.eventMouseDown";
		
		public var index:int; // used by ListItem 
		public var bubbleSelectEvent:Boolean = true;
		
		protected var _data:Object;
		
		private var _enabled:Boolean;
		
		
		public function AbstractListItem()
		{
			super();
		}
		
		// Rem, subclasses must super.doInit()
		//
		protected override function doInit():void
		{
			enable(true);
		}
		
		public function enable($b:Boolean):void
		{
			_enabled = $b;
			if (_enabled) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false,-1);
			}
			else {
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}

		// Must be implemented in subclass.
		// How you do it is your business.
		//
		public static function calcHeightFor($data:Object, $sizeWidth:Number):Number
		{
			throw new IllegalOperationError("Implement me in your subclass");
		}
		
		public override function kill():void
		{
			enable(false);
			_data = null;
		}
		
		//
		
		public function showDown():void
		{
			// override
		}
		
		public function showUp():void
		{
			// override
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data($o:Object):void
		{
			_data = $o;
			onSetData();
		}

		// Update the view here. 
		// Probably want to call size() afterwards, too.
		//
		protected function onSetData():void
		{
			throw new IllegalOperationError("Override me");
		}
		
		public function cancelMouseDown():void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			showUp();
		}
		
		//
		
		private function onMouseDown(e:*):void
		{
			trace('AbstractListItem.onMouseDown');
			
			showDown();

			this.dispatchEvent(new Event(AbstractListItem.EVENT_MOUSEDOWN, true));
			
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:*):void
		{
			cancelMouseDown();
		}

		private function onMouseUp(e:*):void
		{
			cancelMouseDown();
			
			this.dispatchEvent(new Event(AbstractListItem.EVENT_SELECT, bubbleSelectEvent));
		}
	}
}
