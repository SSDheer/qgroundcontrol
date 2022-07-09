import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactControls  1.0

Rectangle{
    id: _root_rect
    width: 200; height:210
    color: "#4c596a"
    radius: 4
    property var missionItem
    property int _obj_index
    property int count
    signal remove

    ColumnLayout{
        id: _columnlayout
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
    }
    ComboBox {
        id: record_options
        width: 70
        model: ["None", "Capture", "Record"]

    }
    }

    RowLayout{
    Rectangle {
        id: delay_button
        width: 20
        height: 35
        color: "#4c596a"
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

        RowLayout{
            visible: _obj_index === 0
        Rectangle {
            id: takeof_button
            width: 20
            height: 35
            color: "#4c596a"
            Image{
                height: 30
                fillMode:   Image.PreserveAspectFit
                smooth:     true
                source: "qrc:/qmlimages/takeoff_1.png"
                anchors.centerIn: parent
                }
        }
        ComboBox {
            currentIndex: 0
            id: takeoff_options
            width: 70
            model: { ["None","Takeoff"]}
            onCurrentIndexChanged:{
                console.log("command name check", missionItem.commandName);
                if( _obj_index === 0 && currentIndex == 1) {
                    console.log("Takeoff set");
                    missionItem.setCommand(22);//MAV_CMD_NAV_TAKEOFF
                }
            }
         }

        }

        RowLayout{
            visible: _obj_index === count -1
        Rectangle {
            id: rth_button
            width: 20
            height: 35
            color: "#4c596a"
            Image{
                height: 30
                fillMode:   Image.PreserveAspectFit
                smooth:     true
                source: "qrc:/qmlimages/returntohome.png"
                anchors.centerIn: parent
                }
        }
        ComboBox {
            currentIndex: 0
            id: return_options
            width: 70
            model: {["None", "RTH","Land"]}
            onCurrentIndexChanged:{
                console.log("Index changed combo", currentText);
                console.log("command name check in rth", missionItem.commandName)
                if( _obj_index === count -1  ) {
                    if(currentIndex == 1){
                    console.log("RTH set");
                    missionItem.setCommand(20);//MAV_CMD_NAV_RTH
                    }
                    if(currentIndex == 2){
                         missionItem.setCommand(21);//MAV_CMD_NAV_LAND

                    }
                }
            }
         }

      }
   }
  }
}

