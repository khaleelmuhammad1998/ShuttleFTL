import flash.events.MouseEvent;

stop();

// Function for Home button.
function GoToMainMenuFromHelpScreen(event: MouseEvent) {
	ButtonHome.removeEventListener(MouseEvent.CLICK, GoToMainMenuFromHelpScreen);
	gotoAndStop(1,"Main Menu");
}
ButtonHome.addEventListener(MouseEvent.CLICK, GoToMainMenuFromHelpScreen);