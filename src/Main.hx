class Main {

	function reset(){
		setup();
	}
	
	function setup(){
		MainScene.level=0;
		if (Save.exists("highscore")){
			score = Save.loadvalue("highscore");
		} else {
			score=0;
		}

		state.sprache = Save.loadvalue("language");
		if (state.sprache==0){
			state.sprache=0;//ok does't do much			
		}	
	}
	private var score:Int;
	function init(){
		//initial all globals here

		Particle.enable();
		setup();
	}	

	function update() {	
		var h = Gfx.screenheight;
		var w = Gfx.screenwidth;
		Text.wordwrap=w;

		Text.size=GUI.titleTextSize;
		Text.display(Text.CENTER,h/5+40-15,S("Trenn die Linien","Separate the Lines"), 0x93dfde);
		Text.size=1;

Text.display((Text.CENTER),4*h/5-30-15-5,S("von Paco Criado und increpare","by Paco Criado and increpare"), 0x93dfde);

Text.display((Text.CENTER),Math.round(h/3+20)+10-15,S("Pfeiltasten zu bewegen\nZ Undo\nR Neustart","Arrow keys to move\nZ Undo\nR restart"), 0x93dfde);


		if (IMGUI.button( Text.CENTER,Math.round(h/3+20)-15+50,S("Fang an!","Start!"))
				|| haxegon.Input.justpressed(Key.SPACE) || haxegon.Input.justpressed(Key.ENTER) || haxegon.Input.justpressed(Key.X)   ){

			Scene.change(MainScene);
		}


		if (IMGUI.schalter( Text.CENTER,Math.round(h/3+60)+50-15,
		S("deu","deu"),
		S("eng","eng"),
		1-state.sprache)){
			state.sprache=1-state.sprache;
			Save.savevalue("language",state.sprache);
		}

		
	}
}
