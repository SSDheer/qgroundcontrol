import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQml                    2.2
import QtQuick.Layouts              1.11

import QGroundControl           1.0
import QGroundControl.Controls  1.0
import QGroundControl.Palette           1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.SettingsManager   1.0

Item {

    id: _root
    property var userId: null
    property var password: null
    QGCPalette{
        id: qgcPal
        colorGroupEnabled: enabled
    }
    Rectangle{


        anchors.centerIn: parent
        anchors.fill: _loginFormContainer



        ColumnLayout{
            id: _loginFormContainer
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.minimumWidth:  200
            Layout.minimumHeight:  200

            QGCLabel{
                id: userIdLabel
                text: "Enter the user Id:"
                Layout.alignment: Qt.AlignCenter
                visible : true
            }

//            QGCTextField{
//                text: userId? (userId.value ? userId.value : "") : ""
//                visible: true
//                showUnits: false
//                anchors.left: parent.left
//                anchors.top: parent.top
//                anchors.bottom: parent.bottom

//                onAccepted:{
//                    userId.value = text
//                }

//                onEditingFinished:{
//                    userId.value = text
//                }
//            }
        }



    }

}
