import flash.events.MouseEvent;

stop();

// Function for Home button.
function GoToMainMenuFromAboutScreen(event: MouseEvent) {
	ButtonHome.removeEventListener(MouseEvent.CLICK, GoToMainMenuFromAboutScreen);
	gotoAndStop(1,"Main Menu");
}
ButtonHome.addEventListener(MouseEvent.CLICK, GoToMainMenuFromAboutScreen);