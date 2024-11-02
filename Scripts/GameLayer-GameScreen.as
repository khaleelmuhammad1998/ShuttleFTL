// Libraries
import flash.events.Event;
import flash.events.TouchEvent;
import flash.events.KeyboardEvent;
import flash.display.MovieClip;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import flash.events.MouseEvent;
import fl.motion.MotionEvent;

stop();

// Function for generating a random number.
function randomizeNumber(NumberMin: Number, NumberMax: Number): Number {
	return (Math.floor(Math.random() * (NumberMax - NumberMin + 1)) + NumberMin);
}

// Function to clamp number between two values.
function clampNumber(Value:Number, NumberMin:Number, NumberMax:Number): Number {
    return Math.max(NumberMin, Math.min(NumberMax, Value));
}

// Declaration of variables.
var GameInitialised: Boolean = false;
var GamePaused: Boolean = true;
var GamePauseLayer: Array = [new PauseLayer(), new ButtonResume()];
var GameTutorial: Boolean = true;
var GameTutorialUICheck: Boolean = false;
var GameTutorialLayer: MovieClip = new TutorialGuide();
var GameHUDClearance: Number = 120; // Variable for value of Stage Y beyond which touch/mouse input should be detected to control the player.
var GameLaneCenter: Number = stage.width / 2;
var GameLaneLeft: Number = GameLaneCenter - (GameLaneCenter / 2);
var GameLaneRight: Number = GameLaneCenter + (GameLaneCenter / 2);
var GameLaneDifference: Number = GameLaneCenter / 2;
var GameLevel: Number = 0;
var GameSpeedMin: Number = 15;
var GameSpeedMax: Number = 20;
var GameHealthMax: Number = 3;
var Score: Number = 0;
var PlayerSpeed: Number = GameSpeedMin;
var PlayerHealth: Number = GameHealthMax;
var Players: Array = [new Player(), new Player2(), new Player3(), new Player4(), new Player5()];
var PlayerNumber: Number = randomizeNumber(0, 4);
var PlayerCurrentPosition: Number = Players[PlayerNumber].x;
var PlayerHeightPosition: Number = 540;
var Opponents: Array = [new PowerUp(), new PowerUp2(), new PowerUp3(), new Opponent1(), new Opponent2(), new Opponent3(), new Opponent4(), new Opponent5()];
var Opponents2: Array = [new Opponent1(), new Opponent2(), new Opponent3(), new Opponent4(), new Opponent5()];
var OpponentNumber: Number = randomizeNumber(3, (Opponents.length - 1));
var Opponent2Number: Number = randomizeNumber(0, (Opponents2.length - 1));
var	Opponent2Enabled: Number = 0;
var OpponentBasePosition: Number = -32;
var SoundScoreVariable: Sound = new (SoundScore);
var SoundPowerUpVariable: Sound = new (SoundPowerUp);
var SoundEndVariable: Sound = new (SoundEnd);
var ExplosionVariable: MovieClip = new Explosion();

// Code to start the game.
startGame();

// Function to update game level.
function updateGameLevel() {
	if (Score <= 10) {
		GameTutorial = true;
		GameSpeedMin = 15;
		GameSpeedMax = 20;
		GameHealthMax = 3;
		PlayerHeightPosition = 540;
		GameLevel = 0;
	} else if (Score <= 100) {
		GameTutorial = false;
		GameSpeedMin = 20;
		GameSpeedMax = 25;
		GameHealthMax = 3;
		PlayerHeightPosition = 540;
		GameLevel = 1;
	} else if (Score <= 250) {
		GameSpeedMin = 25;
		GameSpeedMax = 30;
		GameHealthMax = 3;
		PlayerHeightPosition = 520;
		GameLevel = 2;
	} else if (Score <= 500) {
		GameSpeedMin = 30;
		GameSpeedMax = 35;
		GameHealthMax = 5;
		PlayerHeightPosition = 520;
		GameLevel = 3;
	} else {
		GameSpeedMin = 35;
		GameSpeedMax = 40;
		GameHealthMax = 5;
		PlayerHeightPosition = 500;
		GameLevel = 4;
	}
}

// Function to position the player based on input.
function positionPlayer(value: String) {
	if (value == "left" && Players[PlayerNumber].x > GameLaneLeft) {
		Players[PlayerNumber].y = PlayerHeightPosition;
    	Players[PlayerNumber].x = Players[PlayerNumber].x - GameLaneDifference;
		PlayerCurrentPosition = Players[PlayerNumber].x;
	} else if (value == "right" && Players[PlayerNumber].x < GameLaneRight) {
		Players[PlayerNumber].y = PlayerHeightPosition;
		Players[PlayerNumber].x = Players[PlayerNumber].x + GameLaneDifference;
		PlayerCurrentPosition = Players[PlayerNumber].x;
	}
}

// Function for updating game's speed.
function updatePlayerSpeed() {
	if (PlayerSpeed < GameSpeedMax) {
		PlayerSpeed++;
	} else {
		PlayerSpeed = GameSpeedMax;
	}
}

// Function for resetting opponents.
function resetOpponents() {
	// Code to reset the opponents.
	Opponents[OpponentNumber].y = OpponentBasePosition;
	Opponents[OpponentNumber].x = GameLaneCenter;
	Opponents2[Opponent2Number].y = OpponentBasePosition;
	Opponents2[Opponent2Number].x = GameLaneCenter;

	// Code to shuffle opponents.
	if (GameLevel == 0) {
		OpponentNumber = randomizeNumber(3, (Opponents.length - 1));
	} else {
		OpponentNumber = randomizeNumber(0, (Opponents.length - 1));
	}
	Opponent2Number = randomizeNumber(0, (Opponents2.length - 1));

	// Code to activate opponents.
	Opponents[OpponentNumber].x = (randomizeNumber(1, 3)) * GameLaneDifference;
	Opponent2Enabled = randomizeNumber(0, 1);
	Opponents2[Opponent2Number].x = (randomizeNumber(1, 3)) * GameLaneDifference;
	if (Opponent2Enabled == 1 && Opponents2[Opponent2Number].x == Opponents[OpponentNumber].x) {
		Opponent2Enabled = 0;
		Opponents2[Opponent2Number].x = GameLaneCenter;
	}
}

// Function to add and remove the tutorial layer.
function tutorialGameUI(value: Boolean) {
	if (value == true && GameTutorial == true && GameTutorialUICheck == false) {
		stage.addChild(GameTutorialLayer);
		GameTutorialLayer.x = 180;
		GameTutorialLayer.y = 400;
		GameTutorialUICheck = true;
	} else if (value == false && GameTutorial == false && GameTutorialUICheck == true) {
		stage.removeChild(GameTutorialLayer);
		GameTutorialUICheck = false;
	}
}

// Function to generate UI when game is paused.
function pauseGameUI() {
	if (GamePaused == true) {
		stage.addChild(GamePauseLayer[0]);
		stage.addChild(GamePauseLayer[1]);
		GamePauseLayer[1].x = 180;
		GamePauseLayer[1].y = 320;
		GamePauseLayer[1].addEventListener(MouseEvent.CLICK, pauseButton);
	} else {		
		GamePauseLayer[1].removeEventListener(MouseEvent.CLICK, pauseButton);
		stage.removeChild(GamePauseLayer[1]);
		stage.removeChild(GamePauseLayer[0]);
	}
}

// Function for game's UI.
// Gameplay Event Number 0 = Negative, 1 = Neutral, 2 = Score, 3 = PlayerSpeed, 4 = PlayerHealth
function gameUI(GameplayEventNumber: Number, PositiveUpdate: Boolean) {
	var ColourWhite = 0xFFFFFF;
	var ColourRed = 0xFF4488;
	var GameLevelUI = "BASIC";

	TextScore.text = String(Score);
	TextScore.textColor = ColourWhite;
	TextSpeed.text = String(PlayerSpeed);
	TextSpeed.textColor = ColourWhite;
	TextHealth.text = String(PlayerHealth);
	TextHealth.textColor = ColourWhite;
	if (GameplayEventNumber == 0) {
		TextScore.textColor = ColourRed;
		TextSpeed.textColor = ColourRed;
		TextHealth.textColor = ColourRed;
	} else if (GameplayEventNumber == 2) {
		TextScore.textColor = 0x00CCFF;
	} else if (GameplayEventNumber == 3) {
		if (PositiveUpdate == true) {
			TextSpeed.textColor = 0x00FFFF;
		} else {
			TextSpeed.textColor = ColourRed;
		}
	} else if (GameplayEventNumber == 4) {
		if (PositiveUpdate == true) {
			TextHealth.textColor = 0x00FFCC;
		} else {
			TextHealth.textColor = ColourRed;
		}
	}

	switch (GameLevel) {
		case 0: {
			GameLevelUI = "BASIC";
			tutorialGameUI(true);
			break;
		}
		case 1: {
			GameLevelUI = "EASY";
			tutorialGameUI(false);
			break;
		}
		case 2: {
			GameLevelUI = "MID";
			break;
		}
		case 3: {
			GameLevelUI = "HARD";
			break;
		}
		case 4: {
			GameLevelUI = "FTL";
			break;
		}
	}
	TextLevel.text = GameLevelUI;
}

// Function for playing game's sound effects.
// Gameplay Event Number 0 = Negative, 1 = Neutral, 2 = Positive
function gameSoundEffect(GameplayEventNumber: Number) {
	if (SoundEnabled == true) {
		if (GameplayEventNumber == 0) {
			SoundEndVariable.play();
		} else if (GameplayEventNumber == 1) {
			SoundScoreVariable.play();
		} else if (GameplayEventNumber == 2) {
			SoundPowerUpVariable.play();
		}
	}
}

// Function to start the game.
function startGame() {
	stage.focus = this;
	stage.frameRate = 30;
	switch (ControlPreference) {
		case 0: {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyInputManager);
			break;
		}
		case 1: {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseInputManager);
			break;
		}
		case 2: {
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchInputManager);
			break;
		}
	}
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	ButtonPause.addEventListener(MouseEvent.CLICK, pauseButton);
	stage.addEventListener(Event.ENTER_FRAME, gameManager);

	if (GameInitialised == false) {
		// Code to setup the player.
		Players[PlayerNumber].x = GameLaneCenter;
		PlayerCurrentPosition = Players[PlayerNumber].x;
		stage.addChild(Players[PlayerNumber]);
		Players[PlayerNumber].y = PlayerHeightPosition;

		// Code to spawn opponents and power ups.
		for (var index: int = 0; index < Opponents.length; index++) {
		   	Opponents[index].x = GameLaneCenter;
		   	Opponents[index].y = OpponentBasePosition;
		   	stage.addChild(Opponents[index]);
		}
		for (index = 0; index < Opponents2.length; index++) {
		   	Opponents2[index].x = GameLaneCenter;
		   	Opponents2[index].y = OpponentBasePosition;
		   	stage.addChild(Opponents2[index]);
		}
		stage.addChild(AntiCheatCover);
		GameInitialised = true;
	}
	gameUI(1, false);
	GamePaused = false;	
}

// Function to pause the game.
function pauseGame() {
	if (GamePaused == false) {
		stage.removeEventListener(Event.ENTER_FRAME, gameManager);
		GamePaused = true;
	} else {
		stage.addEventListener(Event.ENTER_FRAME, gameManager);
		GamePaused = false;
	}
	pauseGameUI();
}

// Function to respond to pause button.
function pauseButton(event: MouseEvent) {
	pauseGame();
}

// Function to end the game.
function endGame(event: Event) {
	GamePaused = true;
	switch (ControlPreference) {
	case 0: {
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyInputManager);
		break;
	}
	case 1: {
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseInputManager);
		break;
	}
	case 2: {
		stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchInputManager);
		break;
	}
	}
	ButtonPause.removeEventListener(MouseEvent.CLICK, pauseButton);
	stage.removeEventListener(Event.ENTER_FRAME, gameManager);
	stage.frameRate = 30;

	// Code to remove opponents and power ups.
	for (var index: int = 0; index < Opponents.length; index++) {
		if (Opponents[index].y == OpponentBasePosition) {
	   		stage.removeChild(Opponents[index]);
		}
	}
	for (index = 0; index < Opponents2.length; index++) {
		if (Opponents2[index].y == OpponentBasePosition) {
	   		stage.removeChild(Opponents2[index]);
		}
	}
	stage.removeChild(AntiCheatCover);

	// Code to add explosion effect to player.
	stage.removeChild(Players[PlayerNumber]);
	stage.addChild(ExplosionVariable);
	ExplosionVariable.y = PlayerHeightPosition;
	ExplosionVariable.x = PlayerCurrentPosition;

	// Code to remove tutorial layer, if enabled.
	if (GameTutorial == true && GameTutorialUICheck == true) {
		GameTutorial = false;
		tutorialGameUI(false);
	}

	// Code to change scene.
	gotoAndStop(1, "End Screen");
}

// Function for controlling the playable character using keyboard.
function keyInputManager(event: KeyboardEvent) {
    if (event.keyCode == Keyboard.LEFT && GamePaused == false) {
		positionPlayer("left");
	} else if (event.keyCode == Keyboard.RIGHT && GamePaused == false) {
		positionPlayer("right");
	} else if (event.keyCode == Keyboard.ESCAPE) {
		pauseGame();
	}
}

// Function for controlling the playable character using mouse.
function mouseInputManager(event: MouseEvent) {
	if (GamePaused == false) {
    	if (event.stageX <= GameLaneCenter && event.stageY > GameHUDClearance) {
			positionPlayer("left");
		} else if (event.stageX > GameLaneCenter && event.stageY > GameHUDClearance) {
			positionPlayer("right");
		}
	}
}

// Function for controlling the playable character using touch screen.
function touchInputManager(event: TouchEvent) {
	if (GamePaused == false) {
    	if (event.stageX <= GameLaneCenter && event.stageY > GameHUDClearance) {
			positionPlayer("left");
		} else if (event.stageX > GameLaneCenter && event.stageY > GameHUDClearance) {
			positionPlayer("right");
		}
	}
}

// Function for managing the game.
function gameManager(event: Event) {
	if (stage.frameRate != 30) {
		stage.frameRate = 30;
	}

	Opponents[OpponentNumber].y = Opponents[OpponentNumber].y + PlayerSpeed;
	if (Opponent2Enabled == 1) {
		Opponents2[Opponent2Number].y = Opponents2[Opponent2Number].y + PlayerSpeed;
	}
	if (Opponents[OpponentNumber].y > PlayerHeightPosition || Opponents2[Opponent2Number].y > PlayerHeightPosition) {
		Score = Score + 1 + Opponent2Enabled;
		resetOpponents();
		gameUI(1, false);
		gameSoundEffect(1);
		updatePlayerSpeed();
	}

	// Conditions for altering game's behaviour.
	if ((Players[PlayerNumber].hitTestObject(Opponents[OpponentNumber]) && OpponentNumber > 2) || Players[PlayerNumber].hitTestObject(Opponents2[Opponent2Number])) {
		if (PlayerHealth > 1) {
			PlayerHealth--;
			resetOpponents();
			gameUI(4, false);
			gameSoundEffect(1);
			updatePlayerSpeed();
		} else {
			gameUI(0, false);
			gameSoundEffect(0);
			endGame(event);
		}
	} else if (Players[PlayerNumber].hitTestObject(Opponents[0])) {
		Score = Score + 10;
		resetOpponents();
		gameUI(2, true);
		gameSoundEffect(2);
		updatePlayerSpeed();
	} else if (Players[PlayerNumber].hitTestObject(Opponents[1])) {
		if (PlayerSpeed >= 20) {
			PlayerSpeed = clampNumber((PlayerSpeed - 3), GameSpeedMin, GameSpeedMax);
		} else {
			updatePlayerSpeed();
		}
			gameUI(3, true);
			gameSoundEffect(2);
		resetOpponents();
	} else if (Players[PlayerNumber].hitTestObject(Opponents[2])) {
		if (PlayerHealth < GameHealthMax) {
			PlayerHealth++;
		}
		gameUI(4, true);
		gameSoundEffect(2);
		resetOpponents();
		updatePlayerSpeed();
	}
	updateGameLevel();
}