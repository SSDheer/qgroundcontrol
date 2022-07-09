import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         2.1
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0
import QtQuick.Window           2.2


import QGroundControl                   1.0
import QGroundControl.Controls          1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Vehicle           1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FlightMap         1.0
import QGroundControl.Controllers       1.0
import QGroundControl.ShapeFileHelper   1.0
import QGroundControl.Airspace          1.0
import QGroundControl.Airmap            1.0
import QGroundControl.Palette           1.0



Item { id: _root

    property int    action
    property var    actionData
    property var    mapIndicator
    readonly property int   _decimalPlaces:             8
    property bool   hideTrigger:        false
    property alias  optionText:         optionCheckBox.text
    property alias  optionChecked:      optionCheckBox.checked
    property var    guidedController:  _guidedController
    property var    _guidedController:      globals.guidedControllerFlyView
    property var    _planMasterController: globals.planMasterControllerPlanView
    property var    _missionController:                 _planMasterController.missionController
    property var    _visualItems:                       _missionController.visualItems

    property  var   editorMapCenter:  _editorMapCenter
    property  var   _planViewCenter:  globals.editorMapPlanVieww
    property  var   _editorMapCenter: _planViewCenter.center

    property bool   mission_enableTrigger

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property bool _armed: _activeVehicle ? _activeVehicle.armed : false
    property bool forceArm: false
    property int defaultComponentId: _activeVehicle? _activeVehicle.defaultComponentId() : 1

    property bool _emergencyAction: action === guidedController.actionEmergencyStop

    property bool   _controllerValid:           _planMasterController !== undefined && _planMasterController !== null
    property bool   _controllerOffline:         _controllerValid ? _planMasterController.offline : true
    property var    _controllerDirty:           _controllerValid ? _planMasterController.dirty : false
    property var    _controllerSyncInProgress:  _controllerValid ? _planMasterController.syncInProgress : false
    property real   _controllerProgressPct:     _controllerValid ? _planMasterController.missionController.progressPct : 0

    Component.onCompleted: guidedController.confirmDialog = this
    QGCCheckBox {
        id:                 optionCheckBox
        Layout.alignment:   Qt.AlignHCenter
        text:               ""
        visible:            text !== ""
    }

    Component {
        id: clearVehicleMissionDialog
        QGCViewMessage {
            message: qsTr("Are you sure you want to remove all mission items and clear the mission from the vehicle?")
            function accept() {
                _planMasterController.removeAllFromVehicle()
                _missionController.setCurrentPlanViewSeqNum(0, true)
//                hideDialog()
            }
        }
    }

    function updateAirspace(reset) {
        if(_airspaceEnabled) {
            var coordinateNW = editorMap.toCoordinate(Qt.point(0,0), false /* clipToViewPort */)
            var coordinateSE = editorMap.toCoordinate(Qt.point(width,height), false /* clipToViewPort */)
            if(coordinateNW.isValid && coordinateSE.isValid) {
                QGroundControl.airspaceManager.setROI(coordinateNW, coordinateSE, true /*planView*/, reset)
            }
        }
    }

    function mapCenter() {
//        var coordinate = editorMap.center
        var coordinate = _editorMapCenter
        coordinate.latitude  = coordinate.latitude.toFixed(_decimalPlaces)
        coordinate.longitude = coordinate.longitude.toFixed(_decimalPlaces)
        coordinate.altitude  = coordinate.altitude.toFixed(_decimalPlaces)
        return coordinate
    }

    function insertTakeItemAfterCurrent() {
        var nextIndex = _missionController.currentPlanViewVIIndex + 1
        _missionController.insertTakeoffItem(mapCenter(), nextIndex, true /* makeCurrentItem */)
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

        } // Controls Rectangle
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
                            } // Pan Rectangle
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
                            } // Tilt Rectangle
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
                            } // Zoom Rectangle

                        } // column
                     } // gimbale control - Rectangle
        } // Camera controls - Rectangle

        Rectangle{ width:250; height:1
                   color: "white"
        }
        Connections {
            target: _controllerValid ? _planMasterController.missionController : null
            onProgressPctChanged: {
                if (_controllerProgressPct === 1) {
                    uploadCompleteText.visible = true
                    resetProgressTimer.start()
                } else if (_controllerProgressPct > 0) {
                    progressBar.visible = true
                }
            }
        }
        Timer {
            id:             resetProgressTimer
            interval:       5000
            onTriggered: {
                progressBar.visible = true
                uploadCompleteText.visible = false
            }
        }

        QGCLabel {
            id:                     progressBar
            anchors.fill:           parent
            font.pointSize:         ScreenTools.largeFontPointSize
            visible:                false
        }
        Rectangle{ id: mission_controls
                    width: 250; height: 600
                    color: "#0c213a"
                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left:parent.left
                        anchors.leftMargin: 15
                        font.bold: true
                        font.pointSize: 12
                        color: "#acb7ce"
                        text: "Mission Controls"
                        }
                    ColumnLayout{
                        id: mission_options
                        anchors.top: parent.top
                        anchors.topMargin: 30
                        anchors.left:parent.left
                        anchors.leftMargin: 15
                        RowLayout{
                        CheckBox{
                            id: waypoints_start_check
                            onToggled: {
                                if(checkState === Qt.Checked){
                                    mission_enableTrigger = true
                                console.log(" checkbox checked true")}
                                if(checkState === Qt.Unchecked){
                                    mission_enableTrigger = false
                                console.log(" checkbox Unchecked true")}
                            }

                        }
                        Text {
                                text: qsTr("Mission Mode")
                                color: "#acb7ce"
                                font.pointSize: 10
                                font.bold: true
                        }
                        }

                        Rectangle{
                            id:start_mission
                            radius:4
                            Layout.fillWidth:   true
//                            width:110;
                            height:25
                            color:"#acb7ce"
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                             insertTakeItemAfterCurrent()
                                }
                            }
                            Text {
                                text: qsTr("Start Mission")
                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.left: parent.left
                                anchors.leftMargin: 35
                                color: "#0c213a"
                                font.pointSize: 10
                                font.bold: true
                                }
                            }

                        Rectangle{
                            id:end_mission
                            radius:4
                            Layout.fillWidth:   true
                            height:25
                            color:"#acb7ce"
                            MouseArea{}
                            Text {
                                text: qsTr("End Mission")
                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.left: parent.left
                                anchors.leftMargin: 35
                                color: "#0c213a"
                                font.pointSize: 10
                                font.bold: true
                                }
                                }
                        QGCButton {
                            id:          uploadButton
                            //                            anchors.top:text_mission.bottom
                            Layout.fillWidth:   true
                            Text {
                                text:        _controllerDirty ? qsTr("Upload Required") : qsTr("Upload")
                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.left: parent.left
                                anchors.leftMargin: 25
                                color: "#0c213a"
                                font.pointSize: 10
                                font.bold: true
                            }
                            enabled:     !_controllerSyncInProgress
//                                   visible:     !_controllerOffline && !_controllerSyncInProgress && !uploadCompleteText.visible
                            primary:     _controllerDirty
                            visible:     true
                            onClicked:   _planMasterController.upload()
                            PropertyAnimation on opacity {
                                easing.type:    Easing.OutQuart
                                from:           0.5
                                to:             1
                                loops:          Animation.Infinite
                                running:        _controllerDirty && !_controllerSyncInProgress
                                alwaysRunToEnd: true
                                duration:       2000
                            }
                        }

                        QGCButton {
                            text:               qsTr("Clear")
                            Layout.fillWidth:   true
                            Layout.columnSpan:  2
//                            enabled:            !_planMasterController.offline && !_planMasterController.syncInProgress
//                            visible:            !QGroundControl.corePlugin.options.disableVehicleConnection
                            visible:            true
                            onClicked: {
//                                dropPanel.hide()
                                mainWindow.showComponentDialog(clearVehicleMissionDialog, text, mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                            }
                        }
                        QGCLabel {
                            id:                     uploadCompleteText
                            font.pointSize:         ScreenTools.largeFontPointSize
                            text:                   qsTr("Done")
                            visible:                false
                        }
                    } // Column Layout

                    Rectangle{
                        id: container_id
                        width: 200; height: 400
                        anchors.top: mission_options.bottom
                        anchors.topMargin: 10
                        anchors.left:parent.left
                        anchors.leftMargin: 15

                        ListView{
                            id: listview_id
                            anchors.fill: parent
                            model:_missionController.visualItems
                            orientation:ListView.Vertical
                            clip: true
                             highlightRangeMode: ListView.StrictlyEnforceRange
                            spacing:ScreenTools.defaultFontPixelHeight / 4
                            flickableDirection: Flickable.VerticalFlick
                            boundsBehavior: Flickable.StopAtBounds
                            ScrollBar.vertical: ScrollBar {}
                            delegate: HCControls{
                                missionItem: object
                                _obj_index: listview_id.currentIndex
                                count: listview_id.count
                                onRemove: {
                                    var removeVIIndex = index
                                    _missionController.removeVisualItem(removeVIIndex)
                                    if (removeVIIndex >= _missionController.visualItems.count) {
                                        removeVIIndex--
                                    }
                                }
                            } // delegate
                        } // ListView
                    } // Delegate - Rectangle
                } // Mission controls - Rectangle
    } //Column
} //Item


