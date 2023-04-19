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

//waypoint editor code

Rectangle{
    id: _root_rect
//    visible:            missionItem.isCurrentItem
    readonly property bool  _waypointsOnlyMode: QGroundControl.corePlugin.options.missionWaypointsOnly
    property var    map                 ///< Map control
    property var missionItem
    property var    masterController
    property var    _missiondisplay : globals.missiondisplay
    property bool   flyThroughCommandsAllowed
    property var    cameraCalc
    property bool   _currentItem:               missionItem.isCurrentItem

    property real   _margin:                    ScreenTools.defaultFontPixelWidth / 2


    signal remove

    width: 226; height: 530 /*485*/
    color: "#4c596a"
//    radius: 4
    radius:         _radius
//    opacity:        _currentItem ? 1.0 : 0.7
//    border.width:   _readyForSave ? 0 : 2
//    border.color:   qgcPal.warningText
    property int _obj_index
    property int count
    property bool   _readyForSave:              missionItem.readyForSaveState === VisualMissionItem.ReadyForSave

    property var itemList

    FocusScope {
        id:             currentItemScope
        anchors.fill:   parent

        MouseArea {
            anchors.fill:   parent
            onClicked: {
                currentItemScope.focus = true
                _root.clicked()
            }
        }
    }


    ColumnLayout{
        id: _columnlayout
        anchors.left: parent.left
        anchors.leftMargin: 5

// delete button(start)

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
//                visible:        missionItem.sequenceNumber !== 0
                visible:               true
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
// delete button(end)

// latitude and longitude for each waypoint(start)

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
//        font.bold: true
        }

    Text {
        id: long_text
        text: (missionItem !== null) ? "Long :" + missionItem.coordinate.longitude : "Long :"
        color: "#acb7ce"
        font.pointSize: 8
//        font.bold: true
        }
    }
    }
// latitude and longitude for each waypoint(end)


//Altitude setting for launch point (start)
    RowLayout{
        visible:           missionItem.sequenceNumber === 0
    Text {
        id: alt_text3
        text:  "Alt :"
        color: "#acb7ce"
        font.pointSize: 8
//        font.bold: true
        }

    FactTextField {
        fact:               QGroundControl.settingsManager.appSettings.defaultMissionItemAltitude
        Layout.fillWidth:   true
    }


    }
//Altitude setting for launch point (end)


//Altitude setting for each waypoint(start)

    RowLayout{
        id: wayalt
        visible:           missionItem.sequenceNumber !== 0
    Text {
        id: alt_text
        text:  "Alt :"
        color: "#acb7ce"
        font.pointSize: 8
//        font.bold: true
        }
    FactTextField {
        id:                 altField
        Layout.fillWidth:   true
        fact:               missionItem.altitude
    }

    }
//Altitude setting for each waypoint(end)





// waypoint command editor(start)

    ColumnLayout{
        anchors.leftMargin: 10
        RowLayout{
        Rectangle {
            id: rth_button
            width: 20
            height: 35
            color: "#4c596a"
            visible: true /*_obj_index === 1 || _obj_index === count -1*/
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
                visible:                !commandLabel.visible

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

            QGCLabel {
                id:                     commandLabel
                anchors.verticalCenter: parent.verticalCenter
                width:                  commandPicker.width
                height:                 commandPicker.height
//                visible:                !missionItem.isCurrentItem || !missionItem.isSimpleItem || _waypointsOnlyMode || missionItem.isTakeoffItem
                visible:                 !missionItem.isSimpleItem
                verticalAlignment:      Text.AlignVCenter
                text:                   missionItem.commandName
                anchors.left: home.right
                anchors.leftMargin: 20
//                color:                  _outerTextColor
            }
        }
      }
    }

// waypoint command editor(end)


// delay feature for each waypoint(start)
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


    SectionHeader {
        id:             statsHeader
        anchors.left:   parent.left
        anchors.right:  parent.right
        text:           qsTr("Patterns")
    }

//pattern altitude and spacing setting(start)

        RowLayout{
//            visible: /*patterns.checked*/ surveypattern &&  missionItem.sequenceNumber !== 0
    //    Text {
    //        id: alt_text1
    //        text:  "Alt :"
    //        color: "#acb7ce"
    //        font.pointSize: 8
    ////        font.bold: true
    //        }

        CameraCalcGrid {
            Layout.fillWidth:               true
            cameraCalc:                     missionItem.cameraCalc
            distanceToSurfaceLabel:         qsTr("Altitude")
            sideDistanceLabel:              qsTr("Spacing")
        }

    }

//pattern altitude and spacing setting(end)

//pattern width
        RowLayout {
            QGCLabel { text: qsTr("width   ") }
            FactTextField {
                fact:               missionItem.corridorWidth
                Layout.fillWidth:   true
            }
        }

//pattern angle setting
    QGCLabel { text: qsTr("Angle") }
    FactTextField {
        fact:                   missionItem.gridAngle
        Layout.fillWidth:       true
        onUpdated:              angleSlider.value = missionItem.gridAngle.value
    }

    QGCSlider {
        id:                     angleSlider
        minimumValue:           0
        maximumValue:           359
        stepSize:               1
        tickmarksEnabled:       false
        Layout.fillWidth:       true
        Layout.columnSpan:      2
        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 1.5
        onValueChanged:         missionItem.gridAngle.value = value
        Component.onCompleted:  value = missionItem.gridAngle.value
        updateValueWhileDragging: true
    }

// distance
    QGCLabel {
        text:       qsTr("Turnaround dist")
        visible:    !forPresets
    }
    FactTextField {
        Layout.fillWidth:   true
        fact:               missionItem.turnAroundDistance
        visible:            !forPresets
    }

//patterns points rotate

    RowLayout{
        anchors.left:   parent.left
//        anchors.leftMargin: 5
        spacing:        _margin
//        visible: /*patterns.checked*/ surveypattern &&  missionItem.sequenceNumber !== 0
//        Item {
//            height: ScreenTools.defaultFontPixelHeight / 2
//            width:  1
//        }
        QGCButton{
           id:rotate
           Layout.preferredWidth: 110
           Layout.preferredHeight: 30
          background: Rectangle {
           color : "#acb7ce"
          }
          MouseArea {
              anchors.fill:   parent
              onClicked:missionItem.rotateEntryPoint()
          }
          Text {
              text: qsTr("Rotate")
              anchors.fill:           parent
              horizontalAlignment:    Text.AlignHCenter
              verticalAlignment:      Text.AlignVCenter
              color: "#0c213a"
              font.pointSize: 10
          }
        }

//    QGCButton {
//        text:       qsTr("Rotate entry point")
////        color: "#0c213a"
//        background: Rectangle {
//        color : "#acb7ce"
//        }
//        onClicked:  missionItem.rotateEntryPoint()
//    }
    }
// delay feature for each waypoint(end)








  }
}

