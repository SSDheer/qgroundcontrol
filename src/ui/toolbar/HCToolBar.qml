
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

    function showappSettingsTool() {
        showTool(qsTr("Application Settings"), "HCAppSettings.qml", "/res/resources/HCLogoWhite.svg" /*@Team HCROBO {"/res/QGCLogoWhite"}               */)
    }

//    property int currentToolbar: flyViewToolbar

//    readonly property int flyViewToolbar:   0
//    readonly property int planViewToolbar:  1
//    readonly property int simpleToolbar:    2

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
//            anchors.right:  parent.right
        anchors.bottom: parent.bottom
        anchors.top : parent.top
        anchors.leftMargin: 5
//        Layout.paddingLeft: 5
//            anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.preferredWidth: 100
        Layout.preferredHeight: 22
        id:                     currentButton
//        Layout.preferredHeight: viewButtonRow.height
        source:            "/res/full_logo"   //@Team HCROBO {"/res/QGCLogoFull"}
        fillMode: Image.PreserveAspectFit
        //logo:                   true
        MouseArea{
            anchors.fill : currentButton
            onClicked:              mainWindow.showToolSelectDialog()
        }
    }


    Row{
        spacing: 30
//         anchors.margins:    _toolIndicatorMargins
//         anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
//        padding:5
//        anchors.top: parent.top
        anchors.left: currentButton.right
//        anchors.bottom: parent.bottom
//        anchors.centerIn: parent
//        anchors.top: parent.top
        anchors.centerIn: currentButton.right
        leftPadding: 30
          property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.7

        Text {
            id:signal
//            text: qsTr("Signal")
//            font.family: "Helvetica"
//            font.pointSize: 13
//            color: "black"
//            anchors.bottom: indicator1.bottom
//            leftPadding: 30
            rightPadding: 15


            Loader {
                id:                 indicator1
                anchors.left:       signal.right
//                anchors.right:      parent.left
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                visible: true
                source:           "qrc:/toolbar/RCRSSIIndicator.qml" /*(currentToolbar === flyViewToolbar ?
                                        "qrc:/toolbar/RCRSSIIndicator.qml" :"")*/
    //                                            (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
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
                source:           "qrc:/toolbar/BatteryIndicator.qml" /* (currentToolbar === flyViewToolbar ?
                                        "qrc:/toolbar/BatteryIndicator.qml" :"")*/
    //                                            (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
            }
            }



        Text {
            id: modes
//            text: qsTr("Flight Modes")
//            font.family: "Helvetica"
//            font.pointSize: 13
//            color: "black"
            leftPadding: 40
            rightPadding: 15

//            Item {
//                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
//                height:                 1
//                                anchors.left:       modes.right
//                //                anchors.right:      parent.left
//                                anchors.top:        parent.top
//                                anchors.bottom:     parent.bottom
//            }

//            QGCColoredImage {
//                id:         flightModeIcon
////                anchors.left:       modes.right
//////                anchors.right:      parent.left
////                anchors.top:        parent.top
////                anchors.bottom:     parent.bottom
//                width:      ScreenTools.defaultFontPixelWidth * 2
//                height:     ScreenTools.defaultFontPixelHeight * 0.75
//                fillMode:   Image.PreserveAspectFit
//                mipmap:     true
//                color:      qgcPal.text
//                source:     "/qmlimages/FlightModesComponentIcon.png"
//                visible:    flightModeMenu.visible
//            }
            Item {
                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth / 2
                height:                 1
//                anchors.leftMargin: 25
                visible:                flightModeMenu.visible
            }

            FlightModeMenu {
                id:                     flightModeMenu
                anchors.left:       modes.right
//                anchors.right:      parent.left
//                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                Layout.preferredHeight: _root.height
//                anchors.leftMargin: 25
//                verticalAlignment:      Text.AlignVCenter
                font.pointSize:         _vehicleInAir ?  ScreenTools.largeFontPointSize : ScreenTools.defaultFontPointSize
//                mouseAreaLeftMargin:    -(flightModeMenu.x - flightModeIcon.x)
                visible:                _activeVehicle
                color: "#0c213a"
            }



//            Loader {
////                id:                 indicatorLoader
//                anchors.left:       modes.right
////                anchors.right:      parent.left
//                anchors.top:        parent.top
//                anchors.bottom:     parent.bottom
//                visible: true
//                source:           /* "qrc:/toolbar/BatteryIndicators.qml"*/ (currentToolbar === flyViewToolbar ?
//                                        ":/qml/QGroundControl/Controls/MainStatusIndicator.qml" :"")
//    //                                            (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
//            }
            }

        Text {
            id:gps
//            text: qsTr("GPS Fix")
//            font.family: "Helvetica"
//            font.pointSize: 13
//            color: "black"
            leftPadding: 60
            rightPadding: 15


            Loader {
                id:                 indicatorLoader
                anchors.left:       gps.right
//                anchors.right:      parent.left
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                visible: true
                source:           "qrc:/toolbar/GPSIndicator.qml" /*(currentToolbar === flyViewToolbar ?
                                        "qrc:/toolbar/GPSIndicator.qml" :"")*/
    //                                            (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
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
            onClicked:showappSettingsTool()

//                Loader {
//                id:                 link
////                anchors.left:       gps.right
//////                anchors.right:      parent.left
////                anchors.top:        parent.top
////                anchors.bottom:     parent.bottom
//                visible: true
//                source:           /* "qrc:/toolbar/BatteryIndicators.qml"*/ (currentToolbar === flyViewToolbar ?
//                                        "qrc:/qml/LinkSettings.qml" :"")
//    //                                            (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
//            }





//                {
//                if(loaderId.source == "")
//                    loaderId.source = "LinkSettings.qml"
//                else
//                    loaderId.source = ""
//            }
    }


//        ComboBox {
//            width: 150
////            Text: ComPort
//            displayText: comport
//            anchors.right: disconnectButton.left
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom

//            Loader {
////                id:                 indicatorLoader
////                anchors.left:       gps.right
//////                anchors.right:      parent.left
////                anchors.top:        parent.top
////                anchors.bottom:     parent.bottom
//                visible: true
//                source:           /* "qrc:/toolbar/BatteryIndicators.qml"*/ (currentToolbar === flyViewToolbar ?
//                                        ":/qml/LinkSettings.qml" :"")
//    //                                            (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
//            }



//        }

        QGCButton {
            id:                 disconnectButton
            text:               qsTr("Disconnect")
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
//            color: "#oc213a"
//            leftpadding: 30
//            source:  "/res/full_logo"
            onClicked:         /*indicatorLoader.active = true*/ _activeVehicle.closeVehicle()
//            onClicked: console.log("clicked")
            visible:        true   /* !_activeVehicle && _activeVehicle && _communicationLost && currentToolbar === flyViewToolbar*/

////        QGCFlickable {
//            id:                     toolsFlickable
//            anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
//            anchors.left:           viewButtonRow.right
//            anchors.bottomMargin:   1
//            anchors.top:            parent.top
//            anchors.bottom:         parent.bottom
//            anchors.right:          parent.right
//            contentWidth:           indicatorLoader.x + indicatorLoader.width
//            flickableDirection:     Flickable.HorizontalFlick

//                Loader {
//                    id:                 indicatorLoader
//                    anchors.left:       parent.left
//                    anchors.right:      parent.left
//                    anchors.top:        parent.top
//                    anchors.bottom:     parent.bottom
//                    visible: true
//                    source:           /* "qrc:/toolbar/BatteryIndicators.qml"*/ (currentToolbar === flyViewToolbar ?
//                                            "qrc:/toolbar/GPSIndicator.qml" :"")
////                                            (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
//                }
           }
//        }

}
}




