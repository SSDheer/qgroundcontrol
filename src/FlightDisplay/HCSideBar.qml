import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         2.1
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Vehicle 1.0
import QGroundControl.FactSystem 1.0
import QGroundControl.FactControls 1.0


Item { id: _root

    property int    action
    property var    actionData
    property var    mapIndicator
    property bool   hideTrigger:        false
    property alias  optionText:         optionCheckBox.text
    property alias  optionChecked:      optionCheckBox.checked
    property var    guidedController:  _guidedController
    property var    _guidedController:      globals.guidedControllerFlyView

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property bool _armed: _activeVehicle ? _activeVehicle.armed : false
    property bool forceArm: false
    property int defaultComponentId: _activeVehicle? _activeVehicle.defaultComponentId() : 1

    property bool _emergencyAction: action === guidedController.actionEmergencyStop

    Component.onCompleted: guidedController.confirmDialog = this
    QGCCheckBox {
        id:                 optionCheckBox
        Layout.alignment:   Qt.AlignHCenter
        text:               ""
        visible:            text !== ""
    }
    Column{
        Rectangle{ id: controls
                width:250; height: 200
                color: "#0c213a"
                Text {
                    x: 20; y: 5
                    font.bold: true
                    font.pointSize: 12
                    color: "#acb7ce"
                    text: qsTr("Controls")
                    }
                Rectangle {
                    id: arm_button
                    x: 20; y:35
                    width: 130
                    height: 35
                    color: "#acb7ce"
                    radius:         4
                    MouseArea {
                        onPressAndHold: forceArm = true
                        anchors.fill:   parent
                        onClicked:
                            {
                            if(_activeVehicle){
                            if (_armed) {
                                console.log("Vehicle is armed!");
                                mainWindow.disarmVehicleRequest()
                            } else {
                                if (forceArm) {
                                    mainWindow.forceArmVehicleRequest()
                                } else {
                                    mainWindow.armVehicleRequest()
                                    console.log("armvehicle");
                                }
                            }
                            forceArm = false
                            mainWindow.hideIndicatorPopup()

                            var altitudeChange = 0

                            hideTrigger = false
                            guidedController.executeAction(_root.action, _root.actionData, altitudeChange, _root.optionChecked)
                            if (mapIndicator) {
                                mapIndicator.actionConfirmed()
                                mapIndicator = undefined
                            }


                        }
                            _root.visible = true
                        }
                    }
                    Text {
                        text: "Arm / Disarm"
                        color: "#0c213a"
                        anchors.fill:           parent
                        horizontalAlignment:    Text.AlignHCenter
                        verticalAlignment:      Text.AlignVCenter
                        font.pointSize: 10
                        font.bold: true
                        }
                     }
                Rectangle {
                    id: takeoff_button
//                    x: 20; y:35
                    anchors.leftMargin: 20
                    anchors.left: arm_button.right
                    anchors.top: arm_button.top
                    anchors.bottom: arm_button.bottom
                    width: 60
                    height: 35
                    color: "#acb7ce"
                    radius:         4
                    Image{
                        height: 20
                        fillMode:   Image.PreserveAspectFit
                        smooth:     true
                        source: "qrc:/qmlimages/takeoff_2.png"
                        anchors.centerIn: parent
                        }
                    MouseArea {
                        anchors.fill:   parent
                        onClicked: {
                            var altitudeChange = 10
                            guidedController.executeAction(3, _root.actionData, altitudeChange, _root.optionChecked)
                        }
                    }

                    }

                    Text {
                        text: "Take Off"
                        x: 170; y: 55
                        color: "#acb7ce"
                        anchors.topMargin: 2
                        anchors.top: takeoff_button.bottom
                        font.pointSize: 10
                        font.bold: true
                        }
                    Rectangle {
                        id: land_button
                        x: 170; y: 115
                        anchors.top: takeoff_button.bottom
                        anchors.topMargin: 32
                        width: 60
                        height: 35
                        radius:         4
                        color: "#acb7ce"
                        Image{
                            height: 20
                            fillMode:   Image.PreserveAspectFit
                            smooth:     true
                            source: "qrc:/qmlimages/land_1.png"
                            anchors.centerIn: parent
                            }
                        MouseArea {
                            anchors.fill:   parent
                            onClicked: {
                                var altitudeChange = 10
                                guidedController.executeAction(2, _root.actionData, altitudeChange, _root.optionChecked)
                            }
                        }
                        }

                        Text {
                            text: "Land"
                            x: 180; y: 135
                            color: "#acb7ce"
                            anchors.topMargin: 2
                            anchors.top: land_button.bottom
                            font.pointSize: 10
                            font.bold: true
                            }
                        Rectangle {
                            id: sethome_button
                            x: 20; y: 115
                            anchors.top: takeoff_button.bottom
                            anchors.topMargin: 32
                            width: 60
                            height: 35
                            radius:         4
                            color: "#acb7ce"
                            Image{
                                id: set_home_logo
                                height: 20
                                fillMode:   Image.PreserveAspectFit
                                smooth:     true
                                source: "qrc:/qmlimages/home_1.png"
//                                sourceSize: Qt.size(parent.width, parent.height)
                                anchors.centerIn: parent
                                }
                        ColorOverlay{
                        anchors.fill: set_home_logo
                        source: set_home_logo

                        color: "#0c213a" }
                        MouseArea {
                            anchors.fill:   parent
                            onClicked: {
//                                _activeVehicle.sendCommand(179,1,true)
                                _activeVehicle.sendCommand(defaultComponentId,179,true,1);
                            }
                        }
                        }
                        Text {
                            text: "Set Home"
                            x: 17; y: 135
                            color: "#acb7ce"
                            anchors.topMargin: 6
                            anchors.top: set_home_logo.bottom
                            font.pointSize: 10
                            font.bold: true
                            }
                        Rectangle {
                            id: return_to_home_button
                            x: 90; y: 115
                            anchors.top: takeoff_button.bottom
                            anchors.topMargin: 32
                            width: 60
                            height: 35
                            radius:         4
                            color: "#acb7ce"
                            Image{
                                id: returntohome_logo
                                height: 20
                                fillMode:   Image.PreserveAspectFit
                                smooth:     true
                                source: "qrc:/qmlimages/returntohome.png"
//                                sourceSize: Qt.size(parent.width, parent.height)
                                anchors.centerIn: parent
                                }
                        ColorOverlay{
                        anchors.fill: returntohome_logo
                        source: returntohome_logo
                        color: "#0c213a" }
                        MouseArea {
                            anchors.fill:   parent
                            onClicked: {
                                var altitudeChange = 10
                                guidedController.executeAction(1, _root.actionData, altitudeChange, _root.optionChecked)
                            }
                        }
                        }
                        Text {
                            text: "RTH"
                            x: 110; y: 135
                            color: "#acb7ce"
                            anchors.topMargin: 6
                            anchors.top: returntohome_logo.bottom
                            font.pointSize: 10
                            font.bold: true
                            }

        }
        Rectangle{ width:250; height:1
                   color: "white"
        }
        Rectangle{ id: camera_controls
                    width:250; height: 280
                    color: "#0c213a"
                    Text {
                        x: 20; y: 10
                        font.bold: true
                        font.pointSize: 12
                        color: "#acb7ce"
                        text: qsTr("Camera Controls")
                    }
                    Rectangle{ id: gimbal_controls_rect
//                        x: 20; y:40
                        anchors.top: parent.top
                        anchors.topMargin: 35
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        width:210; height:200
                        color: "#1d3148"
                        radius: 2
                        Column{
                            spacing: 8
//                            x:10;y:10
                            anchors.top: parent.top
                            anchors.topMargin: 10
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            Rectangle{
                                id: pan_rect
                                width:180
                                height:50
                                color: "#1d3148"
                                Column{
                                    spacing:2
                                    Text {
                                        id: pan_id
                                        text: qsTr("Pan")
                                        color: "#acb7ce"
                                        font.pointSize: 12
                                     }
                                    Rectangle{
                                    width:170; height:30
                                    color: "#4c596a"
                                    Slider{
                                        id:                 pan_slider
                                        height: parent.height
                                        width:              ScreenTools.defaultFontPixelWidth * 25


                                        }
                                    }
                                }
                            }
                            Rectangle{
                                id: tilt_rect
                                width:180
                                height:50
                                color: "#1d3148"
                                Column{
                                    spacing:2
                                    Text {
                                        id: tilt_id
                                        text: qsTr("Tilt")
                                        color: "#acb7ce"
                                        font.pointSize: 12
                                     }
                                    Rectangle{
                                    width:170; height:30
                                    color: "#4c596a"
                                    Slider{
                                        id:                 tilt_slider
                                        width:              ScreenTools.defaultFontPixelWidth * 25
                                        height: parent.height
                                        }
                                    }
                                }
                            }
                            Rectangle{
                                id: zoom_rect
                                width:180
                                height:50
                                color: "#1d3148"
                                Column{
                                    spacing:2
                                    Text {
                                        id: zoom_id
                                        text: qsTr("Zoom")
                                        color: "#acb7ce"
                                        font.pointSize: 12
                                     }
                                    Rectangle{
                                    width:170; height:30
                                    color: "#4c596a"
                                    Slider{
                                        id:                 zoom_slider
                                        width:              ScreenTools.defaultFontPixelWidth * 25
                                        height: parent.height
                                        }
                                    }
                                }
                            }

                        }
                    }
        }
        Rectangle{ width:250; height:1
                   color: "white"
        }
        Rectangle{ id: mission_controls
                    width: 250; height: 600
                    color: "#0c213a"
                    Text {
                        x: 20; y: 5
                        font.bold: true
                        font.pointSize: 12
                        color: "#acb7ce"
                        text: "Mission Controls"
                        }
                    Rectangle{

                        id:start_mission
                        x:20; y:35
                        radius:4
                        width:90; height:40
                        color:"#acb7ce"
                        MouseArea{}
                        Column{
                            spacing:4
                            anchors.centerIn: parent
                            Text {
                                text: qsTr("Start")
                                color: "#0c213a"
                                font.pointSize: 10
                                font.bold: true
                                }
                            Text {
                                text: qsTr("Mission")
                                color: "#0c213a"
                                font.pointSize: 10
                                font.bold: true
                                }}
                        }

                    Rectangle{

                        id:end_mission
                        x:20; y:35
                        radius:4
                        width:90; height:40
                        color:"#acb7ce"
                        anchors.leftMargin: 20
                        anchors.left: start_mission.right
                        anchors.top: start_mission.top
                        anchors.bottom: start_mission.bottom
                        MouseArea{}
                        Column{
                            spacing:4
                            anchors.centerIn: parent
//                            anchors.verticalCenter: parent.verticalCenter
//                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                text: qsTr("End")
                                color: "#0c213a"
                                font.pointSize: 10
                                font.bold: true
                                }
                            Text {
                                text: qsTr("Mission")
                                color: "#0c213a"
                                font.pointSize: 10
                                font.bold: true
                                }}
                            }
                    Rectangle{
                        id: container_id
                        width: 200; height: 400
                        anchors.top: start_mission.bottom
                        anchors.topMargin: 10
                        anchors.left:parent.left
                        anchors.leftMargin: 15

                        ListView{
                            id: listview_id
                            anchors.fill: parent
                            model:5
                            clip: true
                            flickableDirection: Flickable.VerticalFlick
                            boundsBehavior: Flickable.StopAtBounds
//                            Layout.fillWidth: true
//                            Layout.fillHeight: true
                            ScrollBar.vertical: ScrollBar {}
                            delegate: HCControls{}
/*                            delegate:Button{
                            width:50}*/}
                    }

//                    HCControls{
//                    id: view_id
////                    anchors.fill: parent
//                    anchors.top: start_mission.bottom
//                    anchors.topMargin: 10
//                    anchors.left: parent.left
//                    anchors.leftMargin: 20
//            }


        }
    }
}




