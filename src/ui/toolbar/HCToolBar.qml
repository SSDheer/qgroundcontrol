
import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QGroundControl.LoginModel            1.0


Rectangle {
    id:     _root
    anchors.right: parent.right

    property int currentToolbar: flyViewToolbar

    readonly property int flyViewToolbar:   0
    readonly property int planViewToolbar:  1
    readonly property int simpleToolbar:    2

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false

    Rectangle{
        anchors.fill: viewButtonRow
//        visible: currentToolbar === flyViewToolbar
        visible: true
        color: "white"
    }
    RowLayout {
//        spacing:30
        id:                     viewButtonRow
        anchors.bottomMargin:   1
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        spacing:                /*20*/ScreenTools.defaultFontPixelWidth*15


    Image {
        anchors.left:  parent.left
        anchors.bottom: parent.bottom
        anchors.top : parent.top
        anchors.leftMargin: 5
        height: parent.height
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.preferredWidth: 100
        Layout.preferredHeight: 22
        id:                     currentButton
        source:            "/res/full_logo"   //@Team HCROBO {"/res/QGCLogoFull"}
        fillMode: Image.PreserveAspectFit
        MouseArea{
            anchors.fill : currentButton
            onClicked:              mainWindow.showToolSelectDialog()
        }
    }


    Row{
        spacing: 30
        anchors.left: currentButton.right
        anchors.centerIn: currentButton.right
        leftPadding: 30
          property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.7

        Text {
            id:signal
            rightPadding: 15


            Loader {
                id:                 indicator1
                anchors.left:       signal.right
//                anchors.right:      parent.left
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                visible: true
                source:           "qrc:/toolbar/RCRSSIIndicator.qml"
            }
        }




        Text {
            id: chargebattery
//            text: qsTr("Battery")
//            font.family: "Helvetica"
//            font.pointSize: 13
//            color: "black"
            leftPadding: 25
            rightPadding: 15



            Loader {
//                id:                 BatteryLoader
                anchors.left:       chargebattery.right
//                anchors.right:      parent.left
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                visible: true
                source:           "qrc:/toolbar/BatteryIndicator.qml"
            }
            }



        Text {
            id: modes
            leftPadding: 40
            rightPadding: 15


            Item {
                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth / 2
                height:                 1
                visible:                flightModeMenu.visible
            }

            FlightModeMenu {
                id:                     flightModeMenu
                anchors.left:       modes.right
                anchors.bottom:     parent.bottom
                Layout.preferredHeight: _root.height
                font.pointSize:         _vehicleInAir ?  ScreenTools.largeFontPointSize : ScreenTools.defaultFontPointSize
                visible:                _activeVehicle
                color: "#0c213a"
            }

            }

        Text {
            id:gps
            leftPadding: 60
            rightPadding: 15


            Loader {
                id:                 indicatorLoader
                anchors.left:       gps.right
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                visible: true
                source:           "qrc:/toolbar/GPSIndicator.qml"
            }
             }

    }

    Button {
            text: "COM Port"
            spacing: 20
            width: 150
            anchors.bottom: parent.bottom
            anchors.right: disconnectButton.left
            anchors.top: parent.top
//            color: "#ffb822"
            onClicked:
                {
                if(loaderId.source == "")
                    loaderId.source = "LinkSettings.qml"
                else
                    loaderId.source = ""
            }
    }



        QGCButton {
            id:                 disconnectButton
            text:               qsTr("Disconnect")
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            onClicked:         /*indicatorLoader.active = true*/ _activeVehicle.closeVehicle()
            visible:        true   /* !_activeVehicle && _activeVehicle && _communicationLost && currentToolbar === flyViewToolbar*/


           }


}
}




