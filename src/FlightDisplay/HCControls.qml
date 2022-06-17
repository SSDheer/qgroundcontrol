import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

Rectangle{
    id: waypoint_rect
    width: 200; height: 100
    color: "#4c596a"
    radius: 4

    Rectangle {
        id: land_button
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 5
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
    Text {
        id: lat_text
        text: "Lat :"
        color: "#acb7ce"
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: land_button.right
        anchors.leftMargin: 2
        font.pointSize: 8
        font.bold: true
        }
    Text {
        id: long_text
        text: "Long :"
        color: "#acb7ce"
        anchors.topMargin: 2
        anchors.top: lat_text.bottom
        anchors.left: land_button.right
        anchors.leftMargin: 2
        font.pointSize: 8
        font.bold: true
        }
    Rectangle {
        id: record_button
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 100
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
        anchors.left: record_button.right
        anchors.leftMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 8

    }

    Rectangle {
        id: delay_button
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5
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
    ComboBox {
        id: delay_options
        width: 60
        model: ["None", "Capture", "Record"]
        anchors.left: delay_button.right
        anchors.leftMargin: 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
    }

    Rectangle {
        id: takeof_button

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 100
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
        id: takeoff_options
        width: 70
        model: ["Take Off", "Set Home", "RTH"]
        anchors.left: takeof_button.right
        anchors.leftMargin: 3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

    }
}

