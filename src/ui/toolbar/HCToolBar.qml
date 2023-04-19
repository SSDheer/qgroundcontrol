
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


//this function includes application settings feature

    function showappSettingsTool() {
        showTool(qsTr("Application Settings"), "HCAppSettings.qml", "/res/resources/HCLogoWhite.svg" /*@Team HCROBO {"/res/QGCLogoWhite"}               */)
    }



    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false

    Rectangle{
        id:                     viewButtonRow
        anchors.bottomMargin:   1
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: true
        color: "white"
    }

//hcrobotics logo
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


//toolbar indicators(battery,gps,message indicator)
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

//flight modes

            FlightModeMenu {
                id:                     flightModeMenu
                horizontalAlignment:    Text.AlignHCenter
                verticalAlignment:      Text.AlignVCenter
                anchors.left:       currentButton.right
                anchors.bottomMargin: 15
                anchors.leftMargin: 30
                anchors.bottom:     parent.bottom
                Layout.preferredHeight: _root.height
                font.pointSize:         _vehicleInAir ?  ScreenTools.largeFontPointSize : ScreenTools.defaultFontPointSize
                visible:                _activeVehicle
                color: "#0c213a"
            }
//    }



//disconnect Button
        QGCButton {
            id:                 disconnectButton
            text:               qsTr("Disconnect")
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: comportbutton.left
            onClicked:         /*indicatorLoader.active = true*/ _activeVehicle.closeVehicle()
            visible:       /* true */  /* !_activeVehicle &&*/ _activeVehicle /*&& _communicationLost*/ /*&& currentToolbar === flyViewToolbar*/


           }

//comm port Button
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


        }
        Rectangle {
            anchors.bottom: parent.bottom
            height:         _root.height * 0.05
            width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
            color:          qgcPal.colorGreen
            visible:        true
        }

}

