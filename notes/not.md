
    MouseArea {
		anchors {
			fill: parent

			topMargin: 0
			bottomMargin: 0
		}
		hoverEnabled: true

		//onExited: musicwindow.visible = false
			
	}


	            HoverHandler {}
            TapHandler { onTapped: MprisService.playPause()}
