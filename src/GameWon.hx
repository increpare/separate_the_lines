class GameWon {

	function reset(){
		init();
	}
	
	private var score:Int;
	function init(){
		//initial all globals here

	}	

	function update() {	
		var h = Gfx.screenheight;
		var w = Gfx.screenwidth;
		Text.wordwrap=w;

		Text.size=GUI.titleTextSize;
		Text.display(Text.CENTER,h/5+10,S("DU HAST GEWONNEN","YOU WON"), 0x93dfde);
		Text.size=1;

		if (IMGUI.button( Text.CENTER,Math.round(h/3+20),S("Yuhuu!","Woo!"))
				|| haxegon.Input.justpressed(Key.SPACE) || haxegon.Input.justpressed(Key.ENTER) || haxegon.Input.justpressed(Key.X)   ){

			Scene.change(Main);
		}

		if (haxegon.Input.justpressed(Key.ESCAPE)){
			Scene.change(Main);
		}
	}
}
