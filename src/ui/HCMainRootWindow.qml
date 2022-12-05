import QtQuick          2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.LoginModel    1.0
import QtGraphicalEffects 1.0
ApplicationWindow {
    id:             mainWindow
    minimumWidth:   ScreenTools.isMobile ? Screen.width  : Math.min(ScreenTools.defaultFontPixelWidth * 100, Screen.width)
    minimumHeight:  ScreenTools.isMobile ? Screen.height : Math.min(ScreenTools.defaultFontPixelWidth * 50, Screen.height)
    visible:        true
    title: "HCGroundControl"

    Component.onCompleted: {
        //-- Full screen on mobile or tiny screens
        if (ScreenTools.isMobile || Screen.height / ScreenTools.realPixelDensity < 120) {
            mainWindow.showFullScreen()
        } else {
            width   = ScreenTools.isMobile ? Screen.width  : Math.min(250 * Screen.pixelDensity, Screen.width)
            height  = ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)
        }

        // Start the sequence of first run prompt(s)
        firstRunPromptManager.nextPrompt()
    }



   HCSideBar{
        id:   hcsideBar
        anchors.fill:  parent
    }
   header: HCToolBar{
    id: hctoolbar
    height:  ScreenTools.toolbarHeight*0.75}

   Rectangle{
       id:messagealert
       x: 255
       y: 10
       color:"#e3ecff"
       width:700
       height:30

       Text {
           id: msg
           text: qsTr("Alert Zone")
           color:"#176afd"
           x:8
           y:8

       }
       Loader{
       source: "qrc:/toolbar/MessageIndicator.qml"
       }
   }
   Image{
       id: downloads_logo
       x:980
       y:10
       source: "qrc:/InstrumentValueIcons/folder-outline.svg"
//        color: "#ffb822"
   }

   ColorOverlay {
           anchors.fill: downloads_logo
           source: downloads_logo
           color: "#ffb822"
       }

       Text {
           id: download
           anchors.top: downloads_logo.bottom
           anchors.topMargin: 1
           text: qsTr("Downloads")
           x:970
           y:18
           color: "#ffb822"
       }
  }
