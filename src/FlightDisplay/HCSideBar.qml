import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0
import QGroundControl.ScreenTools 1.0

Item {
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
                        anchors.fill:   parent
                        onClicked: {
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
//                    Source:"qrc:/qmlimages/takeoff_2.png"
                    color: "#acb7ce"
                    radius:         4
                    Image{
                        fillMode:   Image.PreserveAspectFit
                        smooth:     true
                        source: "qrc:/qmlimages/takeoff_2.png"
                        anchors.centerIn: parent
                        }
                    MouseArea {
                        anchors.fill:   parent
                        onClicked: {
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
                            fillMode:   Image.PreserveAspectFit
                            smooth:     true
                            source: "qrc:/qmlimages/land_1.png"
                            anchors.centerIn: parent
                            }
                        MouseArea {
                            anchors.fill:   parent
                            onClicked: {
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
                        Image{
                            id: set_home_logo
                            x:15; y:100
                            width:  60
                            height: 35
                            fillMode:   Image.PreserveAspectFit
                            smooth:     true
                            source: "qrc:/qmlimages/home_1.png"
                            }
                        Text {
                            text: "Set Home"
                            x: 15; y: 135
                            color: "#acb7ce"
                            anchors.topMargin: 4
                            anchors.top: set_home_logo.bottom
                            font.pointSize: 10
                            font.bold: true
                            }
                        Image{
                            id: returntohome_logo
                            anchors.left: set_home_logo.right
                            anchors.leftMargin: 8
                            anchors.top: set_home_logo.top
                            anchors.bottom: set_home_logo.bottom
//                            x:15; y:100
                            width:      60
                            height: 35
                            fillMode:   Image.PreserveAspectFit
                            smooth:     true
                            source: "qrc:/qmlimages/returntohome.png"
                            }
                        Text {
                            text: "RTH"
                            x: 100; y: 135
                            color: "#acb7ce"
                            anchors.topMargin: 4
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
                        x: 20; y:40
                        width:210; height:200
                        color: "#1d3148"
                        radius: 2
                        Column{
                            spacing: 8
                            x:10;y:10
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
                                    width:170; height:20
                                    color: "#4c596a"
                                    Slider{
                                        id:                 pan_slider
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
                                    width:170; height:20
                                    color: "#4c596a"
                                    Slider{
                                        id:                 tilt_slider
                                        width:              ScreenTools.defaultFontPixelWidth * 25
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
                                    width:170; height:20
                                    color: "#4c596a"
                                    Slider{
                                        id:                 zoom_slider
                                        width:              ScreenTools.defaultFontPixelWidth * 25
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
//                        Rectangle{ id:first_point
//                                x:20; y:85
//                                width:200; height:100
//                                color:"#4c596a"
//                                Text { x:10;y:10
//                                    text: qsTr("1st Point")
//                                    color: "#0c213a"
//                                    font.pointSize: 12
//                                }
//                        }
             }

        }
}



