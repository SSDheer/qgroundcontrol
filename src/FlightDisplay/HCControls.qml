import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

GridLayout {
    id : grid
    anchors.fill: parent
    rows    : 12
    columns : 12
    property double colMulti : grid.width / grid.columns
    property double rowMulti : grid.height / grid.rows
    function prefWidth(item){
        return colMulti * item.Layout.columnSpan
    }
    function prefHeight(item){
        return rowMulti * item.Layout.rowSpan
    }

    Rectangle {
        color : 'gray'
        Layout.rowSpan   : 12
        Layout.columnSpan: 2
        Layout.topMargin: 2
        Layout.bottomMargin: 5
        Layout.preferredWidth  : grid.prefWidth(this)
        Layout.preferredHeight : grid.prefHeight(this)
    }
//    Rectangle {
//        color : 'white'
//        Layout.rowSpan   : 10
//        Layout.columnSpan: 10
//        Layout.preferredWidth  : grid.prefWidth(this)
//        Layout.preferredHeight : grid.prefHeight(this)
//    }
    Rectangle {
        id : greenRect
        color : 'green'
        Layout.rowSpan : 2
        Layout.columnSpan : 12
        Layout.preferredWidth  : grid.prefWidth(this)
        Layout.preferredHeight : grid.prefHeight(this)
    }
}
