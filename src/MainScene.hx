import haxegon.*;

class MainScene {

	public static var level:Int=0;
	
	public var wonTimer:Int=-1;

	var levels :Array<Array<Array<Int>>> = 
	[



		[
			[1,1,2],
			[0,1,1],
			[2,1,1]
		],
		[
			[1,0,0],
			[2,2,2],
			[1,1,1],
			[0,0,1]
		],


		[
			[1,2,2,2,0],
			[1,1,1,0,0],
			[0,1,1,1,1],
			[0,0,0,1,1],
		],
		

	];


	var moving:Int=0;//0 = horizontal(lower), 1 = vertical(upper)
	var state:Array<Array<Int>>;
	
	var undoBuffer:Array<Array<Array<Int>>>;
	var undoBuffer_movement:Array<Int>;
	
	function reset(){
		init();
				
	}
	

	function copyState(levelToCopy:Array<Array<Int>>):Array<Array<Int>>{
		var result = new Array<Array<Int>>();
		for (i in 0...levelToCopy.length){
			var row = levelToCopy[i];
			result.push(row.slice(0));
		}
		return result;
	}

	function init(){		
		wonTimer=-1;	
		state = new Array<Array<Int>>();
		state = copyState(levels[level]);
		undoBuffer = new Array<Array<Array<Int>>>();
		undoBuffer_movement = new Array<Int>();
	}	
 
	function printState(){
		var result="\n";
		for (j in 0...state.length){
			var row = state[j];
			for (i in 0...row.length){
				result+=row[i];
			}
			result+="\n";
		}
		trace(result);
	}

	function doMove(dx:Int,dy:Int){
		var couldMove:Bool=false;
		var moved:Bool=true;

		var oldState = copyState(state);
		while(moved){
			moved=false;
			for (j in 0...state.length){
				var row = state[j];
				for (i in 0...row.length){
					var cell = row[i];
					if (cell!=2){
						continue;
					}
					var from_x = i;
					var from_y = j;
					var to_x = i+dx;
					var to_y = j+dy;
					
					if (to_x<0 || to_x>=row.length||to_y<0 || to_y>=state.length){
						continue;
					}
					
					var to_cell	= state[to_y][to_x];
					
					if (to_cell==0){
						var success:Bool=false;
					 	while(true){
					 		to_x+=dx;
					 		to_y+=dy;
							if (to_x<0 || to_x>=row.length||to_y<0 || to_y>=state.length){								
								break;
							}
							to_cell	= state[to_y][to_x];
							if (to_cell==1){
								success=true;
								break;
							}
							if (to_cell==0){
								continue;
							}
							//must've been a player, so cancel
							break;
					 	}
						if (success){

						} else {
							continue;
						}
					}

					if (to_cell==1){
						state[to_y][to_x]=3;
						state[from_y][from_x]=1;
						moved=true;
						couldMove=true;
					}
				}
			}
		}


		for (j in 0...state.length){
			var row = state[j];
			for (i in 0...row.length){
				var cell = row[i];
				if (cell==3){
					row[i]=2;
				}
			}
		}

		if (couldMove){
			undoBuffer.push(oldState);
			undoBuffer_movement.push(moving);
		}
		printState();
	}

	function getPlayerCoords():Array<Array< Int> >{
		var result:Array<Array<Int>> = [];
		for (j in 0...state.length){
			var row = state[j];
			for (i in 0...row.length){
				var cell = row[i];
				if (cell==2){
					result.push([i,j]);
				}
			}
		}
		return result;
	}

	function checkWon():Array<Array<Int>>{
		var conflicts:Array<Array<Int> > = [];
		var coords:Array<Array<Int> > = getPlayerCoords();
		for (i in 0...coords.length){
			var a = coords[i];
			for (j in (i+1)...coords.length){
				var b = coords[j];
				if ((a[0]<b[0] && a[1]<b[1])
				   ||  (a[0]>b[0] && a[1]>b[1]) ){
					   //we're good
				} else {
					conflicts.push([i,j]);
				}   
			}
		}
		return conflicts;
	}

	function update()
	{
		if (wonTimer<0){

			if (haxegon.Input.justpressed(Key.ESCAPE)){
				Scene.change(Main);
			}
			
			if (haxegon.Input.justpressed(Key.DOWN)){
				if( moving==0){	
					undoBuffer.push(copyState(state));
					undoBuffer_movement.push(moving);
					moving=1;
				}
			} 
			if (haxegon.Input.justpressed(Key.UP)){
				if (moving==1){
					undoBuffer.push(copyState(state));
					undoBuffer_movement.push(moving);
					moving=0;
				}
			} 

			if (haxegon.Input.justpressed(Key.LEFT)){
				if (moving==0){
					doMove(-1,0);
				} else {
					doMove(0,-1);
				}			
			} 
			if (haxegon.Input.justpressed(Key.RIGHT)){
				if (moving==0){
					doMove(1,0);
				} else {
					doMove(0,1);
				}
			} 
			if (haxegon.Input.justpressed(Key.Z)||haxegon.Input.justpressed(Key.U)){
				if (undoBuffer.length>2){
					state = undoBuffer.pop();
					moving = undoBuffer_movement.pop();
				} else if (undoBuffer.length==1){
					state = copyState(undoBuffer[0]);
					moving = undoBuffer_movement[0];
				}
			} 
			if (haxegon.Input.justpressed(Key.R)){
				if (undoBuffer.length>1){
					undoBuffer.push(copyState(state));
					undoBuffer_movement.push(moving);

					state = copyState(undoBuffer[0]);
					moving = undoBuffer_movement[0];
				}
			} 
		}

		var padding_h:Int=80;
		var padding_v_t:Int=100;
		var padding_v_b:Int=50;
		var play_w=haxegon.Gfx.screenwidth-2*padding_h;
		var play_h=haxegon.Gfx.screenheight-padding_v_t-padding_v_b;
		
		
		Text.size=2;
		Text.display(Text.CENTER,40,S("Level "+(level+1)+" von 3","Level "+(level+1)+" of 3"),  Col.GRAY);

		Gfx.linethickness=10;
		for (j in 0...state.length){
			var row = state[j];
			for (i in 0...row.length){
				var cell = row[i];
				
				if (cell==0){
					continue;
				} 


				var xx = padding_h+i*play_w/(row.length-1);
				var xy = padding_v_t+play_h; 
				var yx = padding_h+j*play_w/(state.length-1);
				var yy = padding_v_t;


				var col = Col.GRAY;


				Gfx.drawline(xx,xy,yx,yy,col,0.8);
			}
		}


		for (j in 0...state.length){
			var row = state[j];
			for (i in 0...row.length){
				var cell = row[i];
				
				if (cell==0){
					continue;
				} 


				var xx = padding_h+i*play_w/(row.length-1);
				var xy = padding_v_t+play_h; 
				var yx = padding_h+j*play_w/(state.length-1);
				var yy = padding_v_t;


				if (cell==2) {

					var col = Col.ORANGE;
					Gfx.linethickness=4;
					if (moving==0){
						Gfx.drawcircle(yx,yy,20,col,0.8);
					} else {
						Gfx.drawcircle(xx,xy,20,col,0.8);
					}
					Gfx.linethickness=10;
		
					var col = 0x00ff00;
					Gfx.drawline(xx,xy,yx,yy,col,0.8);
				}
			}
		}

		var conflicts = checkWon();
		if (conflicts.length==0 && wonTimer<0){
			wonTimer=30;

			Particle.GenerateParticles(
				{
					min:0,
					max:Gfx.screenwidth,
				},
				{
					min:0,
					max:Gfx.screenheight,
				},
				"part",
				50,
				0,
				-10,
				{
					min:1,
					max:1
				},
				{
					min:0,
					max:360
				},
				{
					min:-50, max:50
				},
				{
					min:-100, max:-100
				},
				{
					min:20,
					max:20
				},
				{
					min:1,max:1
				},
				{
					min:0,max:0
				}
			);
		
		}
		var coords:Array<Array<Int>> = getPlayerCoords();

		for (i in 0...conflicts.length){
			var player_a_index = conflicts[i][0];
			var player_b_index = conflicts[i][1];

			var player_a_coords = coords[player_a_index];
			var player_b_coords = coords[player_b_index];


			var axx = padding_h+player_a_coords[0]*play_w/(state[0].length-1);
			var axy = padding_v_t+play_h; 
			var ayx = padding_h+player_a_coords[1]*play_w/(state.length-1);
			var ayy = padding_v_t;

			var bxx = padding_h+player_b_coords[0]*play_w/(state[0].length-1);
			var bxy = padding_v_t+play_h; 
			var byx = padding_h+player_b_coords[1]*play_w/(state.length-1);
			var byy = padding_v_t;


			Gfx.drawline(axx,axy,ayx,ayy,Col.ORANGE,1.0);
			Gfx.drawline(bxx,bxy,byx,byy,Col.ORANGE,1.0);

		}

		for (i in 0...conflicts.length){
			var player_a_index = conflicts[i][0];
			var player_b_index = conflicts[i][1];

			var player_a_coords = coords[player_a_index];
			var player_b_coords = coords[player_b_index];


			var axx = padding_h+player_a_coords[0]*play_w/(state[0].length-1);
			var axy = padding_v_t+play_h; 
			var ayx = padding_h+player_a_coords[1]*play_w/(state.length-1);
			var ayy = padding_v_t;

			var bxx = padding_h+player_b_coords[0]*play_w/(state[0].length-1);
			var bxy = padding_v_t+play_h; 
			var byx = padding_h+player_b_coords[1]*play_w/(state.length-1);
			var byy = padding_v_t;


			var d1 = Math.abs(bxx-axx);
			var d2 = Math.abs(ayx-byx);

			var r = d1/(d1+d2);

			var px = (1-r)*(axx)+r*(ayx);
			var py = (1-r)*(axy)+r*(ayy);


			Gfx.fillcircle(px,py,10,Col.RED,1.0);
		}

		if (wonTimer>0){
			wonTimer--;
			if (wonTimer==0){
				level++;
				if (level==3){
					Scene.change(GameWon);
				} else {
					reset();
				}
			}
		}
	}
}
