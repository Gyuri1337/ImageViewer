import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4 as OldControls
import com.ImageList 1.0

Item{
    //properties
    property int buttonCount: 3
    property string timerInterval: timeInterval.displayText

    //signals
    signal reFillImage;
    signal timerStart;
    signal timerStop;
    signal rotateImageLeft;
    signal rotateImageRight;
    signal notSelectiongFolder;
    signal selectingFolder;

    //code
    height: fileLoadingMenu.height
    MenuBar{
        id: fileLoadingMenu
        x: 0
        y: 0
        Menu{
            title: "File"

            Action{
                text: qsTr("&Add")
                onTriggered: {
                    notSelectiongFolder()
                }
            }
        Action{
            text: qsTr("&Add from")
            onTriggered: {
                selectingFolder()
                }
            }
        }
    }
    Rectangle{
        anchors.left: fileLoadingMenu.right
        anchors.top: parent.top
        anchors.right: toolBar.left
        color: "silver"
        height: toolBar.height
    }
    Rectangle{
        anchors.left: toolBar.right
        anchors.top: parent.top
        anchors.right: parent.right
        color: "silver"
        height: toolBar.height
    }

    ToolBar{
        id:toolBar
        height: parent.height
        x: (parent.width / 2) - (fileLoadingMenu.height * parent.buttonCount / 2)
        RowLayout{
            anchors.fill:parent
            ToolSeparator{

            }
            ToolButton{
                icon.source: "./rotateleft.png"
                onClicked: {
                    timerStop()
                    rotateImageLeft()
                }
            }
            ToolButton{
                icon.source: "./resize.png"
                onClicked:{
                    timerStart()
                    reFillImage()
                }
            }
            ToolButton{
                icon.source: "./rotateright.png"
                onClicked: {
                    timerStop
                    rotateImageRight()
                }
            }
            ToolSeparator{

            }

        }
    }
    ToolBar{
        id:animationController
        height: parent.height
        anchors.right: parent.right
        RowLayout{

            ToolButton{
                icon.source: "./play.png"
                onClicked: {    timerStart()
                                sourceList.next()
                                sourceList.imageAdded()
                }

            }
            ToolButton{
                icon.source: "./pause.png"
                onClicked: timerStop()

            }
            ToolButton{
                icon.source: "./stop.png"
                onClicked: {
                    stopTimer()
                    sourceList.stop()
                    sourceList.imageAdded()
                }
            }

            TextField{
                id: timeInterval
                Layout.preferredWidth: 40
                Layout.preferredHeight: parent.height -5
                validator: IntValidator {bottom: 1; top:999}
            }
            CheckBox{
                text: qsTr("Replay")
                checked: false
                onCheckStateChanged: {
                    sourceList.setCheckStateTo(checked)
                }
            }
        }
    }
}
