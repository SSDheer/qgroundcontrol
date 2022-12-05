import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.2
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactControls  1.0
import QGroundControl.SettingsManager   1.0
import QGroundControl.Palette       1.0

Rectangle{
    id: _root_rect
    readonly property bool  _waypointsOnlyMode: QGroundControl.corePlugin.options.missionWaypointsOnly
    property var    map                 ///< Map control
    property var missionItem
    property var    masterController
    property var    _missiondisplay : globals.missiondisplay
    property bool   flyThroughCommandsAllowed



    signal remove

    width: 200; height:240
    color: "#4c596a"
    radius: 4
    property int _obj_index
    property int count

    property var itemList

    ColumnLayout{
        id: _columnlayout
        RowLayout{
        Rectangle {
            id: delete_button
            width: 20
            height: 35
            color: "#4c596a"
            Image{
                height: 20
                fillMode:   Image.PreserveAspectFit
                smooth:     true
                source: "/res/TrashDelete.svg"
//                visible:                _currentItem && missionItem.sequenceNumber !== 0
                visible: true
                anchors.left : parent.left
                anchors.leftMargin:  2
                anchors.centerIn: parent

                }
            MouseArea {
                 anchors.fill:   parent
                 onClicked:  remove()
             }
        }
        Text {
            id: waypoint_text
            text: "Waypoint"
            color: "#acb7ce"
            font.pointSize: 10
            font.bold: true
            }
    }


    RowLayout{
    Rectangle {
        id: land_button
        width: 20
        height: 35
        color: "#4c596a"
        Image{
            height: 30
            fillMode:   Image.PreserveAspectFit
            smooth:     true
            source: "qrc:/qmlimages/location_1.png"
            anchors.leftMargin:  5
            anchors.centerIn: parent
            }
    }
    ColumnLayout{
    Text {
        id: lat_text
        text: (missionItem !== null) ? "Lat :" + missionItem.coordinate.latitude : "Lat :"
        color: "#acb7ce"
        font.pointSize: 8
        font.bold: true
        }

    Text {
        id: long_text
        text: (missionItem !== null) ? "Long :" + missionItem.coordinate.longitude : "Long :"
        color: "#acb7ce"
        font.pointSize: 8
        font.bold: true
        }
    }
    }

    RowLayout{
    Text {
        id: alt_text
        text:  "Alt :"
        color: "#acb7ce"
        font.pointSize: 8
        font.bold: true
        }
    FactTextField {
        id:                 altField
        Layout.fillWidth:   true
        fact:               missionItem.altitude

//                    visible:     false
    }
    }

    ColumnLayout{

//        RowLayout{
//            visible: _obj_index === 0
//        Rectangle {
//            id: takeof_button
//            width: 20
//            height: 35
//            color: "#4c596a"
//            Image{
//                height: 30
//                fillMode:   Image.PreserveAspectFit
//                smooth:     true
//                source: "qrc:/qmlimages/takeoff_1.png"
//                anchors.centerIn: parent
//                }
//        }
//        ComboBox {
//            currentIndex: 0
//            id: takeoff_options
//            width: 70
//            model: { ["None","Takeoff"]}
//            onCurrentIndexChanged:{
////                console.log("command name check", missionItem.commandName);
//                if( _obj_index === 0 && currentIndex == 1) {
//                    console.log("Takeoff set");
//                    console.log("missionItem",missionItem);
//                    missionItem.setCommand(22);//MAV_CMD_NAV_TAKEOFF

//                }
//            }
//         }

//        }

        RowLayout{
            visible: _obj_index === 1|| _obj_index === count -1
        Rectangle {
            id: rth_button
            width: 20
            height: 35
            color: "#4c596a"
            Image{
                id: home
                height: 30
                fillMode:   Image.PreserveAspectFit
                smooth:     true
                source: "qrc:/qmlimages/returntohome.png"
                anchors.centerIn: parent
                }
            Item {
                id:                     commandPicker
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: home.right
                anchors.leftMargin: 20
                height:                 50/*ScreenTools.implicitComboBoxHeight*/
                width:                  innerLayout.width

                RowLayout {
                    id:                     innerLayout
                    anchors.verticalCenter: parent.verticalCenter
                    spacing:                _padding

                    property real _padding: ScreenTools.comboBoxPadding

                    QGCLabel { text: missionItem.commandName }

                    QGCColoredImage {
                        height:             ScreenTools.defaultFontPixelWidth
                        width:              height
                        fillMode:           Image.PreserveAspectFit
                        smooth:             true
                        antialiasing:       true
                        color:              qgcPal.text
                        source:             "/qmlimages/arrow-down.png"
                    }
                }

                QGCMouseArea {
                    fillItem:   parent
                    onClicked:  mainWindow.showComponentDialog(commandDialog, qsTr("Select Mission Command"), mainWindow.showDialogDefaultWidth, StandardButton.Cancel)
                }



                Component {
                    id: commandDialog


                    HCView {
                        vehicle:                    _planMasterController.controllerVehicle
                        missionItem:                _root_rect.missionItem
                        map:                        _root_rect.map
                        // FIXME: Disabling fly through commands doesn't work since you may need to change from an RTL to something else
                        flyThroughCommandsAllowed:  true //_missionController.flyThroughCommandsAllowed
                    }
                }
            }



        }
//        QGCViewDialog {
//            id: root_view


//            QGCPalette { id: qgcPal }

//            Label {
//                id:                 categoryLabel
//                anchors.baseline:   return_options.baseline
//                text:               qsTr("Category:")
//            }
//            Component {
//                id: commandDialog

//                MissionCommandDialog {
//                    vehicle:                    masterController.controllerVehicle
//                    missionItem:                _root.missionItem
//                    map:                        _root.map
//                    // FIXME: Disabling fly through commands doesn't work since you may need to change from an RTL to something else
//                    flyThroughCommandsAllowed:  true //_missionController.flyThroughCommandsAllowed
//                }
//            }


//        ComboBox {
//            currentIndex: 0
//            id: return_options
//            width: 70
////            model:  mavCmdInfo.friendlyName
////            model:              QGroundControl.missionCommandTree.categoriesForVehicle(_planMasterController.controllerVehicle)

////            model: {["None", "RTH","Land"]}
////            model: QGroundControl.missionCommandTree.getCommandsForCategory(_planMasterController.controllerVehicle, missionItem.category, true);
////            model:              QGroundControl.missionCommandTree.categoriesForVehicle(_planMasterController.controllerVehicle)

////            function categorySelected(category) {
//////                commandList.model = QGroundControl.missionCommandTree.getCommandsForCategory(_planMasterController.controllerVehicle, category, true)
////            }

////            Component.onCompleted: {
////                var category  = missionItem.category
////                currentIndex = find(category)
////                categorySelected(category)
////            }

////            onActivated: categorySelected(textAt(index))

//         /*   ListView {
//                id:                 commandList
////                anchors.margins:    ScreenTools.defaultFontPixelHeight
////                anchors.left:       parent.left
////                anchors.right:      parent.right
////                anchors.top:        return_options.bottom
////                anchors.bottom:     parent.bottom
////                spacing:            ScreenTools.defaultFontPixelHeight / 2
//                orientation:        ListView.Vertical
//                clip:               true

//                delegate: Rectangle {
//                    width:  parent.width
//                    height: commandColumn.height + ScreenTools.defaultFontPixelHeight
//                    color:  qgcPal.button

//                    property var    mavCmdInfo: modelData
//                    property color  textColor:  qgcPal.buttonText

//                    Column {
//                        id:                 commandColumn
//                        anchors.margins:    ScreenTools.defaultFontPixelWidth
//                        anchors.left:       parent.left
//                        anchors.right:      parent.right
//                        anchors.top:        parent.top

//                        Label {
//                            text:           mavCmdInfo.friendlyName
//                            color:          textColor
//                            font.family:    ScreenTools.demiboldFontFamily
//                        }

//                        Label {
//                            anchors.margins:    ScreenTools.defaultFontPixelWidth
//                            anchors.left:       parent.left
//                            anchors.right:      parent.right
//                            text:               mavCmdInfo.description
//                            wrapMode:           Text.WordWrap
//                            color:              textColor
//                        }
//                    }

//                    MouseArea {
//                        anchors.fill:   parent
//                        onClicked: {
//                            missionItem.setMapCenterHintForCommandChange(map.center)
//                            missionItem.command = mavCmdInfo.command
//                            _root_rect.reject()
//                        }
//                    }
//                }
//            }*/ // QGCListView
//            onCurrentIndexChanged:{
//                console.log("Index changed combo", currentText);
////                console.log("command name check in rth", missionItem.commandName)
////                console.log("Count value : ", count, " -- " , itemList.count);
//                if( _obj_index === itemList.count - 1) {
//                    console.log("Current index value : ", currentIndex);
//                    if(currentIndex == 1){
//                    console.log("RTH set");
//                        console.log("missionItem",missionItem);
////                    missionCmdModel =

////                    missionItem.command = ;//MAV_CMD_NAV_RTL(20)


//                    }
//                    if(currentIndex == 2){
//                        console.log("missionItem",missionItem);
//                         missionItem.setCommand(MAV_CMD_NAV_LAND);//MAV_CMD_NAV_LAND
////                        guidedController.executeAction(2, _root.actionData, altitudeChange, _root.optionChecked)

//                    }
//                }else{
//                    console.log( "Object Index is :" , _obj_index);
//                }
//            }
//         }
        }

        }
//   }


    RowLayout{
    Rectangle {
        id: delay_button
        width: 20
        height: 35
        color: "#4c596a"
        visible: true
        Image{
            height: 30
            fillMode:   Image.PreserveAspectFit
            smooth:     true
            source: "qrc:/qmlimages/time_1.png"
            anchors.centerIn: parent
            }
    }
    FactTextField {
        id:                 delayFeild
        Layout.fillWidth:   true
        fact:  missionItem.delayFact
    }
    }




    RowLayout{
    Rectangle {
        id: record_button
        width: 20
        height: 35
        color: "#4c596a"
        Image{
            height: 30
            fillMode:   Image.PreserveAspectFit
            smooth:     true
            source: "qrc:/qmlimages/record_1.png"
            anchors.centerIn: parent
            }
//        MouseArea{
//            anchors.fill:   parent
//            onClicked: remove()
//        }
    }
    ComboBox {
        id: record_options
        width: 70
        model: ["None", "Capture", "Record"]

    }
    }

  }
}

