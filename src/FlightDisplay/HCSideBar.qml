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
    readonly property int   _decimalPlaces:     8
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
    property bool   arm_check: _activeVehicle ? true : false
    property bool   disarm_check: true
    property bool   takeoff_check: true
    property bool   rth_check: true
    property bool   land_check: true


    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property bool _armed: _activeVehicle ? _activeVehicle.armed : false
    property bool _flying:              _activeVehicle ? _activeVehicle.flying : false

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
                width:250; height: 160
                color: "#0c213a"
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 5
                    anchors.leftMargin: 20
                    font.bold: true
                    font.pointSize: 12
                    color: "#acb7ce"
                    text: qsTr("Controls")
                    }
                Rectangle {
                    id: arm_button
                    width: 90
                    height: 35
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 35
                    anchors.leftMargin: 20
                    radius: 4
//                    enabled: true
                    enabled: arm_check ? true : false
                    color: arm_button.enabled ? "#acb7ce" : "#4c596a"
                    MessageDialog{
                        id:         arm_Dialog
                        visible:    false
                        icon:       StandardIcon.Warning
                        standardButtons: StandardButton.Yes | StandardButton.No
                        title:      qsTr("Arm Configuration")
                        text:      qsTr("Is this really what you want?")

                        onYes: {
                            if(_activeVehicle){
                                console.log(" vehicle is active")
                                if (forceArm) {
                                    mainWindow.forceArmVehicleRequest()
                                    console.log("forcearm_active")
                                    if(_activeVehicle.armed){
                                    arm_check = false }
                                } else {
                                    mainWindow.armVehicleRequest()
                                    console.log("armvehicle");
                                    if(_activeVehicle.armed){
                                    arm_check = false }
                                }
                            forceArm = false
                        }
                            arm_Dialog.visible = false
                            _root.visible = true
                        }
                        onNo: arm_Dialog.visible = false
                    }
                    MouseArea {
                        onPressAndHold: forceArm = true
                        anchors.fill:   parent
                        onClicked:
                        {
                            if(enabled){
                                arm_Dialog.visible = true
                            }
                        }
                    }
                    Text {
                        text: "Arm"
                        color: "#0c213a"
                        anchors.fill:           parent
                        horizontalAlignment:    Text.AlignHCenter
                        verticalAlignment:      Text.AlignVCenter
                        font.pointSize: 10
                        font.bold: true
                        }
                     }
                Rectangle {
                    id: disarm_button
                    width: 90
                    height: 35
                    anchors.left: arm_button.right
                    anchors.leftMargin: 20
                    anchors.top: arm_button.top
                    anchors.bottom: arm_button.bottom
                    enabled: { if(_activeVehicle && _activeVehicle.armed && disarm_check) {
                                arm_button.enabled ? false : true
                                }
                                else {false}
                            }

                    color: disarm_button.enabled ? "#acb7ce" : "#4c596a"
                    radius: 4
                    MessageDialog{
                        id:         disarm_Dialog
                        visible:    false
                        icon:       StandardIcon.Warning
                        standardButtons: StandardButton.Yes | StandardButton.No
                        title:      qsTr("Disarm Configuration")
                        text:      qsTr("Is this really what you want?")

                        onYes: {
                            if(_activeVehicle){
//                                disarm_check = false
                            if (_armed) {
                                console.log("Vehicle is armed!");
                                mainWindow.disarmVehicleRequest()
                                if(!_activeVehicle.armed){
                                disarm_check = false
                                arm_check = true}
                            }
                        }
                            disarm_Dialog.visible = false
                            _root.visible = true
                        }
                        onNo: disarm_Dialog.visible = false
                    }
                    MouseArea {
                        onPressAndHold: forceArm = true
                        anchors.fill: parent
                        onClicked:
                            {
                            if(enabled){
                                disarm_Dialog.visible = true
                                }
                            }
                    }
                    Text {
                        text: " Disarm "
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
                    width: 60
                    height: 35
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: arm_button.bottom
                    anchors.topMargin: 20
                    enabled: { if(_activeVehicle && _activeVehicle.armed && takeoff_check) {
                                true
                                }
                                else {false}
                            }
                    color: takeoff_button.enabled ? "#acb7ce" : "#4c596a"
                    radius: 4
                    MessageDialog{
                        id:         takeoff_Dialog
                        visible:    false
                        icon:       StandardIcon.Warning
                        standardButtons: StandardButton.Yes | StandardButton.No
                        title:      qsTr("Take Off Configuration")
                        text:      qsTr("Is this really what you want?")

                        onYes: {
                            var altitudeChange = 10
                            guidedController.executeAction(3, _root.actionData, altitudeChange, _root.optionChecked)
                            takeoff_check = false

                            takeoff_Dialog.visible = false
                        }
                        onNo: takeoff_Dialog.visible = false
                    }
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
                            if(enabled){
                                takeoff_Dialog.visible = true
                                }
                        }
                    }

                    }

                    Text {
                        text: "Take Off"
                        anchors.top: takeoff_button.bottom
                        anchors.topMargin: 2
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: takeoff_button.enabled ? "#acb7ce" : "#4c596a"
                        font.pointSize: 10
                        font.bold: true
                        }

                    Rectangle {
                        id: return_to_home_button
                        width: 60
                        height: 35
                        anchors.left: takeoff_button.right
                        anchors.leftMargin: 12
                        anchors.top: takeoff_button.top
                        anchors.bottom: takeoff_button.bottom
                        radius: 4
//                        enabled: true
                        enabled: { if(_activeVehicle && _activeVehicle.flying && rth_check) {
                                    true
                                    }
                                    else {false}
                                }
                        color: return_to_home_button.enabled ? "#acb7ce" : "#4c596a"
                        Image{
                            id: returntohome_logo
                            height: 20
                            fillMode:   Image.PreserveAspectFit
                            smooth:     true
                            source: "qrc:/qmlimages/returntohome.png"
                            anchors.centerIn: parent
                            }
                    ColorOverlay{
                    anchors.fill: returntohome_logo
                    source: returntohome_logo
                    color: "#0c213a" }
                    MessageDialog{
                        id:         rth_Dialog
                        visible:    false
                        icon:       StandardIcon.Warning
                        standardButtons: StandardButton.Yes | StandardButton.No
                        title:      qsTr("RTH Configuration")
                        text:      qsTr("Is this really what you want?")

                        onYes: {
                            var altitudeChange = 10
                            guidedController.executeAction(1, _root.actionData, altitudeChange, _root.optionChecked)
                            rth_Dialog.visible = false
                            rth_check = false
                        }
                        onNo: rth_Dialog.visible = false
                    }

                    MouseArea {
                        anchors.fill:   parent
                        onClicked: {
                            if(enabled){
                                rth_Dialog.visible = true
                            }
                        }
                    }
                    }
                    Text {
                        text: "RTH"
                        color: return_to_home_button.enabled ? "#acb7ce" : "#4c596a"
                        anchors.top: return_to_home_button.bottom
                        anchors.topMargin: 2
                        anchors.left: takeoff_button.right
                        anchors.leftMargin: 30
                        font.pointSize: 10
                        font.bold: true
                        }

                    Rectangle {
                        id: land_button
                        width: 60
                        height: 35
                        anchors.left: return_to_home_button.right
                        anchors.leftMargin: 12
                        anchors.top: return_to_home_button.top
                        anchors.bottom: return_to_home_button.bottom
                        radius: 4
                        enabled: { if(_activeVehicle && _activeVehicle.flying && land_check) {
                                    true
                                    }
                                    else {false}
                                }
                        color: land_button.enabled ? "#acb7ce" : "#4c596a"
                        MessageDialog{
                            id:         land_Dialog
                            visible:    false
                            icon:       StandardIcon.Warning
                            standardButtons: StandardButton.Yes | StandardButton.No
                            title:      qsTr("Land Configuration")
                            text:      qsTr("Is this really what you want?")

                            onYes: {
                                var altitudeChange = 10
                                guidedController.executeAction(2, _root.actionData, altitudeChange, _root.optionChecked)
                                land_check = false
                                land_Dialog.visible = false
                            }
                            onNo: land_Dialog.visible = false
                        }
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
                                if(enabled){
                                    land_Dialog.visible = true
                                }
                            }
                        }
                        }

                        Text {
                            text: "Land"
                            color: land_button.enabled ? "#acb7ce" : "#4c596a"
                            anchors.top: land_button.bottom
                            anchors.topMargin: 2
                            anchors.left: return_to_home_button.right
                            anchors.leftMargin: 22
                            font.pointSize: 10
                            font.bold: true
                            }
//                        Rectangle {
//                            id: sethome_button
//                            x: 20; y: 115
//                            anchors.top: takeoff_button.bottom
//                            anchors.topMargin: 32
//                            width: 60
//                            height: 35
//                            radius:         4
//                            color: "#acb7ce"
//                            Image{
//                                id: set_home_logo
//                                height: 20
//                                fillMode:   Image.PreserveAspectFit
//                                smooth:     true
//                                source: "qrc:/qmlimages/home_1.png"
////                                sourceSize: Qt.size(parent.width, parent.height)
//                                anchors.centerIn: parent
//                                }
//                        ColorOverlay{
//                        anchors.fill: set_home_logo
//                        source: set_home_logo

//                        color: "#0c213a" }
//                        MouseArea {
//                            anchors.fill:   parent
//                            onClicked: {
////                                _activeVehicle.sendCommand(179,1,true)
//                                _activeVehicle.sendCommand(defaultComponentId,179,true,1);
//                            }
//                        }
//                        }
//                        Text {
//                            text: "Set Home"
//                            x: 17; y: 135
//                            color: "#acb7ce"
//                            anchors.topMargin: 6
//                            anchors.top: set_home_logo.bottom
//                            font.pointSize: 10
//                            font.bold: true
//                            }

        } // Controls Rectangle
        Rectangle{ width:250; height:1
                   color: "white"
        }
        Rectangle{ id: camera_controls
                    width:250; height: 260
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
                                mainWindow.showPopupDialogFromComponent(preFlightChecklistPopup)
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
                QGCButton{
                    id:start_mission
                    Layout.fillWidth:   true
                    height:25
//                    color:"#acb7ce"
                    enabled: waypoint_check ? true : false
                    background: Rectangle {
                        color: pause_mission.enabled ? "#acb7ce" : "#4c596a"
                    }
                    MouseArea {
                        anchors.fill:   parent
                        onClicked: {
                            var altitudeChange = 10
                            guidedController.executeAction(12, _root.actionData, altitudeChange, _root.optionChecked)
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
                QGCButton{
                    id:resume_mission
                    Layout.fillWidth:   true
                    height:25
                    enabled: waypoint_check ? true : false
                    background: Rectangle {
                        color: pause_mission.enabled ? "#acb7ce" : "#4c596a"
                    }
                    MouseArea{
                        anchors.fill:   parent
                        onClicked: {
                            globals.guidedControllerFlyView.executeAction(globals.guidedControllerFlyView.actionResumeMission, null, null)
                            hideDialog()
                        }
                    }
                    Text {
                        text: qsTr("Resume Mission")
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: "#0c213a"
                        font.pointSize: 10
                        font.bold: true
                    }
                }
                QGCButton{
                    id:pause_mission
                    Layout.fillWidth:   true
                    height:25
                    background: Rectangle {
                        color: pause_mission.enabled ? "#acb7ce" : "#4c596a"
                    }
                    enabled: waypoint_check ? true : false
                    MouseArea{
                        anchors.fill:   parent
                        onClicked: {
                            var altitudeChange = 10
                            guidedController.executeAction(17, _root.actionData, altitudeChange, _root.optionChecked)
                        }
                    }
                    Text {
                        text: qsTr("Pause Mission")
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 25
                        color: "#0c213a"
                        font.pointSize: 10
                        font.bold: true
                    }
                }
                QGCButton {
                    id:          uploadButton
                    Layout.fillWidth:   true
                    enabled: waypoint_check && !_controllerSyncInProgress
                    background: Rectangle {
                        color: pause_mission.enabled ? "#acb7ce" : "#4c596a"
                    }
                    Text {
                        text:        _controllerDirty ? qsTr("Upload Required") : qsTr("Upload")
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        color: "#0c213a"
                        font.pointSize: 10
                        font.bold: true
                    }
//                    enabled:     !_controllerSyncInProgress
//                    visible:     !_controllerOffline && !_controllerSyncInProgress && !uploadCompleteText.visible
                    primary:     _controllerDirty
                    onClicked:    _planMasterController.upload()
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
                    id: clear
                    Layout.fillWidth:   true
                    Layout.columnSpan:  2
                    background: Rectangle {
                        color: pause_mission.enabled ? "#acb7ce" : "#4c596a"
                    }
                    Text {
                        text: qsTr("Clear")
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 25
                        color: "#0c213a"
                        font.pointSize: 10
                        font.bold: true
                    }
                    enabled:            waypoint_check && !_planMasterController.offline && !_planMasterController.syncInProgress
                    visible:            !QGroundControl.corePlugin.options.disableVehicleConnection
                    onClicked: {
//                        dropPanel.hide()
                        mainWindow.showComponentDialog(clearVehicleMissionDialog, text, mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                    }
                }
                QGCLabel {
                    id:                     uploadCompleteText
                    font.pointSize:         ScreenTools.largeFontPointSize
                    text:                   qsTr("Done")
                    visible:                false
                }
            }
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
                            var removeVIIndex = listview_id.currentIndex
                            _missionController.removeVisualItem(removeVIIndex)
                            if (removeVIIndex >= _missionController.visualItems.count) {
                                removeVIIndex--
                            }
                        }
                    } // delegate
                } // Listview
            } // Listview Rectangle
        }// Mission controls Rectangle
    } //Column
} //Item
