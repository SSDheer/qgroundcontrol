/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQml.Models 2.12

import QGroundControl           1.0
import QGroundControl.Controls  1.0
import QGroundControl.LoginModel 1.0


ToolStripActionList {
    id: _root

    signal displayPreFlightChecklist
    signal flyingChanged

    model: [
        ToolStripAction {
            text:           qsTr("Plan")
            iconSource:     "/qmlimages/Plan.svg"
//            onTriggered:    mainWindow.showPlanView()
            visible: mainWindow.showPlanView()
        },
        PreFlightCheckListShowAction { onTriggered: displayPreFlightChecklist() },
        GuidedActionTakeoff { },
        GuidedActionLand { },
        GuidedActionRTL { },
        GuidedActionPause { },
        GuidedActionActionList { },

        ToolStripAction{
            text: qsTr("Reboot")
            iconSource:       "/qmlimages/restart.svg"
            enabled: _missionController.isInsertTakeoffValid
            //enabled: true
            visible: HCLoginModel.isAdvanceUser
            onTriggered: {
               _activeVehicle.rebootVehicle()
            }

        }
    ]




}

