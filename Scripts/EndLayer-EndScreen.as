import flash.events.MouseEvent;

stop();

// Code for showing the final score.
TextScoreFinal.text = String(Score);

// Funtion for analysing high score.
function analyseHighScore() {
	if (Score > SavedGameHighScore.data.HighScore) {
		SavedGameHighScore.data.HighScore = Score;
		SavedGameHighScore.flush();
		TextHighScore.text = String(SavedGameHighScore.data.HighScore);
		TextHighScoreStatus.text = String("HIGH SCORE!");
	} else {
		TextHighScore.text = String(SavedGameHighScore.data.HighScore);
		TextHighScoreStatus.text = String("");
	}
}
analyseHighScore();

// Function to clear the end screen before leaving the scene.
function clearEndScreen() {
	stage.removeChild(ExplosionVariable);
	if (Opponents[OpponentNumber].y != OpponentBasePosition) {
		Opponents[OpponentNumber].y = OpponentBasePosition;
		Opponents[OpponentNumber].x = GameLaneCenter;
		stage.removeChild(Opponents[OpponentNumber]);
	}
	if (Opponents2[Opponent2Number].y != OpponentBasePosition) {
		Opponents2[Opponent2Number].y = OpponentBasePosition;
		Opponents2[Opponent2Number].x = GameLaneCenter;
		stage.removeChild(Opponents2[Opponent2Number]);
	}
}

// Function for Retry button.
function restartGameScreen(event: MouseEvent) {
	clearEndScreen();
	ButtonRetry.removeEventListener(MouseEvent.CLICK, restartGameScreen);
	gotoAndStop(1,"Game Screen");
}
ButtonRetry.addEventListener(MouseEvent.CLICK, restartGameScreen);

// Function for Home button.
function GoToMainMenuFromEndScreen(event: MouseEvent) {
	clearEndScreen();
	ButtonHome.removeEventListener(MouseEvent.CLICK, GoToMainMenuFromEndScreen);
	gotoAndStop(1,"Main Menu");
}
ButtonHome.addEventListener(MouseEvent.CLICK, GoToMainMenuFromEndScreen);