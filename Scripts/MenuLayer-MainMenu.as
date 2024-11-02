import flash.events.MouseEvent;
import flash.net.SharedObject;

stop();

// Declaration of variables.
var SavedGameHighScore: SharedObject = null;
var SavedGameSoundEnabled: SharedObject = null;
var SoundEnabled: Boolean = true;
var SavedGameControlPreference: SharedObject = null;
var ControlPreference: Number = 1;

// Function to read saved game file.
function readSavedGame() {
	SavedGameHighScore = SharedObject.getLocal("HighScore.ShuttleFTLSavedGame");
	if(SavedGameHighScore.data.HighScore == null) {
		SavedGameHighScore.data.HighScore = 0;
	} else {
		TextHighScore.text = String(SavedGameHighScore.data.HighScore);
	}
	SavedGameSoundEnabled = SharedObject.getLocal("SoundEnabled.ShuttleFTLSavedGame");
	if(SavedGameSoundEnabled.data.SoundEnabled == null) {
		SavedGameSoundEnabled.data.SoundEnabled = SoundEnabled;
	} else {
		SoundEnabled = SavedGameSoundEnabled.data.SoundEnabled;
		if (SoundEnabled == true) {
			TextOptionSoundStatus.text = "ON";
			TextOptionSoundStatus.textColor = 0x00FFCC;
		} else {
			TextOptionSoundStatus.text = "OFF";
			TextOptionSoundStatus.textColor = 0xFF4488;
		}
	}
	SavedGameControlPreference = SharedObject.getLocal("ControlPreference.ShuttleFTLSavedGame");
	if(SavedGameControlPreference.data.ControlPreference == null) {
		SavedGameControlPreference.data.ControlPreference = ControlPreference;
	} else {
		ControlPreference = SavedGameControlPreference.data.ControlPreference;
	}
	switch (ControlPreference) {
		case 0: {
			TextOptionControlPreference.text = "KEYS";
			break;
		}
		case 1: {
			TextOptionControlPreference.text = "MOUSE";
			break;
		}
		case 2: {
			TextOptionControlPreference.text = "TOUCH";
			break;
		}
	}
}
readSavedGame();

// Function to remove button listeners when leaving Main Menu.
function removeButtonListeners() {
	ButtonPlay.removeEventListener(MouseEvent.CLICK, startGameScreen);	
	ButtonOptionSound.removeEventListener(MouseEvent.CLICK, toggleSound);
	ButtonOptionControl.removeEventListener(MouseEvent.CLICK, toggleControl);
	ButtonHelp.removeEventListener(MouseEvent.CLICK, GoToHelpScreen);
	ButtonAbout.removeEventListener(MouseEvent.CLICK, GoToAboutScreen);
}

// Function to toggle game's sound effects on or off.
function toggleSound(event: MouseEvent) {
	if (SoundEnabled == true) {
		SoundEnabled = false;
		TextOptionSoundStatus.text = "OFF";
		TextOptionSoundStatus.textColor = 0xFF4488;
	} else {
		SoundEnabled = true;
		TextOptionSoundStatus.text = "ON";
		TextOptionSoundStatus.textColor = 0x00FFCC;
	}
	SavedGameSoundEnabled.data.SoundEnabled = SoundEnabled;
	SavedGameSoundEnabled.flush();
}
ButtonOptionSound.addEventListener(MouseEvent.CLICK, toggleSound);

// Function to toggle game's control.
function toggleControl(event: MouseEvent) {
	if (ControlPreference == 0) {
		ControlPreference = 1;
		TextOptionControlPreference.text = "MOUSE";
	} else if (ControlPreference == 1) {
		ControlPreference = 2;
		TextOptionControlPreference.text = "TOUCH";
	} else if (ControlPreference == 2) {
		ControlPreference = 0;
		TextOptionControlPreference.text = "KEYS";
	}
	SavedGameControlPreference.data.ControlPreference = ControlPreference;
	SavedGameControlPreference.flush();
}
ButtonOptionControl.addEventListener(MouseEvent.CLICK, toggleControl);

// Function for Play button.
function startGameScreen(event: MouseEvent) {
	removeButtonListeners();
	gotoAndStop(1,"Game Screen");
}
ButtonPlay.addEventListener(MouseEvent.CLICK, startGameScreen);

// Function for Help button.
function GoToHelpScreen(e:MouseEvent) {
	removeButtonListeners();
	gotoAndStop(1,"Help Screen");
}
ButtonHelp.addEventListener(MouseEvent.CLICK, GoToHelpScreen);

// Function for About button.
function GoToAboutScreen(e:MouseEvent) {
	removeButtonListeners();
	gotoAndStop(1,"About Screen");
}
ButtonAbout.addEventListener(MouseEvent.CLICK, GoToAboutScreen);