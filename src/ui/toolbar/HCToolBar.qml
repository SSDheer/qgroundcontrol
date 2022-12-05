
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

//    property var _commandDialog: commandDialog
    property var    missionItem         ///< MissionItem associated with this editor
    property var    map                 ///< Map control
    property var    masterController
    property var    _vehicleInAir:      _activeVehicle ? _activeVehicle.flying || _activeVehicle.landing : false

    function showappSettingsTool() {
        showTool(qsTr("Application Settings"), "HCAppSettings.qml", "/res/resources/HCLogoWhite.svg" /*@Team HCROBO {"/res/QGCLogoWhite"}               */)
    }





//    Component {
//        id: commandDialog

//        MissionCommandDialog {
//            vehicle:                    masterController.controllerVehicle
//            missionItem:                _root.missionItem
//            map:                        _root.map
//            // FIXME: Disabling fly through commands doesn't work since you may need to change from an RTL to something else
//            flyThroughCommandsAllowed:  true //_missionController.flyThroughCommandsAllowed
//        }
//    }




//    property int currentToolbar: flyViewToolbar

//    readonly property int flyViewToolbar:   0
//    readonly property int planViewToolbar:  1
//    readonly property int simpleToolbar:    2

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false

    Rectangle{
//        anchors.fill: viewButtonRow
//        visible: currentToolbar === flyViewToolbar
        id:                     viewButtonRow
        anchors.bottomMargin:   1
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
//        spacing:                /*20*/ScreenTools.defaultFontPixelWidth/2
        visible: true
        color: "white"
    }
//    RowLayout {
////        spacing:30
//        id:                     viewButtonRow
//        anchors.bottomMargin:   1
//        anchors.top:            parent.top
//        anchors.bottom:         parent.bottom
//        anchors.left: parent.left
//        anchors.right: parent.right
//        spacing:                /*20*/ScreenTools.defaultFontPixelWidth/2


    Image {
        anchors.left:  parent.left
        anchors.bottom: parent.bottom
        anchors.top : parent.top
        anchors.leftMargin: 5
//        height: parent.height
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
//        Layout.preferredWidth: 30
//        Layout.preferredHeight: 22
        id:                     currentButton
        source:            "/res/full_logo"   //@Team HCROBO {"/res/QGCLogoFull"}
        fillMode: Image.PreserveAspectFit
        width: 100
            height:30
        //logo:                   true
        MouseArea{
            anchors.fill : currentButton
            onClicked:              mainWindow.showToolSelectDialog()
        }
    }


//    QGCFlickable {
//        id:                     toolsFlickable
//        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
//        anchors.left:           viewButtonRow.right
//        anchors.bottomMargin:   1
//        anchors.top:            parent.top
//        anchors.bottom:         parent.bottom
//        anchors.right:          parent.right
//        contentWidth:           indicatorLoader.x + indicatorLoader.width
//        flickableDirection:     Flickable.HorizontalFlick

            Loader {
                id:                 indicatorLoader
//                anchors.left:       parent.left
                anchors.left: flightModeMenu.right
                anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
                anchors.right:      parent.right
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                source:             /*currentToolbar === flyViewToolbar ?*/
                                        "qrc:/toolbar/MainToolBarIndicators.qml" /*:*/
//                                        (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
            }

            Item {
                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth / 2
                height:                 2
                visible:                flightModeMenu.visible
            }

            FlightModeMenu {
                id:                     flightModeMenu
                horizontalAlignment:    Text.AlignHCenter
                verticalAlignment:      Text.AlignVCenter
                anchors.left:       currentButton.right
                anchors.bottomMargin: 15
                anchors.leftMargin: 20
                anchors.bottom:     parent.bottom
                Layout.preferredHeight: _root.height
                font.pointSize:         _vehicleInAir ?  ScreenTools.largeFontPointSize : ScreenTools.defaultFontPointSize
                visible:                _activeVehicle
                color: "#0c213a"
            }
//    }


    /*Row*//*{
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
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                visible: true
                source:           "qrc:/toolbar/RCRSSIIndicator.qml"
            }
        }



        Text {
            id: chargebattery
            leftPadding: 25
            rightPadding: 15



            Loader {
                anchors.left:       chargebattery.right
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

        Loader{
            id: mesindicator
            anchors.left: indicatorLoader.right
            anchors.top:parent.top
            anchors.bottom: parent.bottom
            source:  "qrc:/toolbar/MessageIndicator.qml"
        }

    }*/


        QGCButton {
            id:                 disconnectButton
            text:               qsTr("Disconnect")
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: comportbutton.left
            onClicked:         /*indicatorLoader.active = true*/ _activeVehicle.closeVehicle()
            visible:       /* true */  /* !_activeVehicle &&*/ _activeVehicle /*&& _communicationLost*/ /*&& currentToolbar === flyViewToolbar*/


           }
        Button {
                id: comportbutton
                text: "COM Port"
                spacing: 20
                width: 90
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.top: parent.top
    //            color: "#ffb822"
                onClicked:showappSettingsTool()
//                QGCMouseArea {
//                    fillItem:   parent
//                    onClicked:  mainWindow.showComponentDialog(commandDialog, qsTr("Select Mission Command"), mainWindow.showDialogDefaultWidth, StandardButton.Cancel)
//                }

        }

}

