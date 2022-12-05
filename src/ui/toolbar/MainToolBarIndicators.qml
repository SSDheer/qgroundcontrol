/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick 2.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0

//-------------------------------------------------------------------------
//-- Toolbar Indicators
Row {
    id:                 indicatorRow
    anchors.top:        parent.top
    anchors.bottom:     parent.bottom
    anchors.left:       parent.left
    anchors.right:      parent.right
    anchors.margins:    _toolIndicatorMargins
    spacing:            ScreenTools.defaultFontPixelWidth * 2

    property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.7
    Repeater {
        id:     appRepeater
        model:  QGroundControl.corePlugin.toolBarIndicators
        Loader {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             modelData
            visible:            item.showIndicator
        }
    }

    Repeater {
        model: _activeVehicle ? _activeVehicle.toolIndicators : []
        Loader {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             modelData
            visible:            item.showIndicator
        }
    }

    Repeater {
        model: _activeVehicle ? _activeVehicle.modeIndicators : []
        Loader {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             modelData
            visible:            item.showIndicator
        }
    }

//    function showappSettingsTool() {
//        showTool(qsTr("Application Settings"), "HCAppSettings.qml", "/res/resources/HCLogoWhite.svg" /*@Team HCROBO {"/res/QGCLogoWhite"}               */)
//    }

//    QGCButton {
//        id:                 disconnectButton
//        text:               qsTr("Disconnect")
//        anchors.top: parent.top
//        anchors.bottom: parent.bottom
//        anchors.right: comportbutton.left
//        onClicked:         /*indicatorLoader.active = true*/ _activeVehicle.closeVehicle()
//        visible:       /* true */  /* !_activeVehicle &&*/ _activeVehicle /*&& _communicationLost*/ /*&& currentToolbar === flyViewToolbar*/


//       }
//    Button {
//            id: comportbutton
//            text: "COM Port"
//            spacing: 20
//            width: 150
//            anchors.bottom: parent.bottom
//            anchors.right: parent.right
//            anchors.top: parent.top
////            color: "#ffb822"
//            onClicked:showappSettingsTool()
//    }




}
