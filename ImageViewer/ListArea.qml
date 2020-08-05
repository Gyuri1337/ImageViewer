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
    id:listArea
    //Signals
    signal stopTimer()

    //Code
    Rectangle{
        id:listBackground
        height: parent.height
        width:parent.width
        anchors.fill: parent
        color: "#333333"
    }
    ListView {
        id: listView
        model: sourceList.actualFiles
        anchors.top: parent.top
        width: parent.width
        height: parent.height

        delegate: Rectangle {
            width: parent.width
            height: 25
            TextField{
                property string col: "white"
                wrapMode: TextInput.Wrap
                verticalAlignment: TextInput.AlignLeft
                background: Rectangle{
                    color: "#333333"
                    border.width: 1
                    border.color: "orange"
                }
                color: textMouse.containsMouse ? "blue" : "white"
                text: fileName
                width: parent.width - 20
                height: parent.height
                MouseArea{
                    id: textMouse
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    hoverEnabled: true
                    anchors.fill: parent
                    onReleased: {
                        parent.color = "white"
                    }
                    onPressed: {
                        parent.color = "red"
                        if(mouse.button === Qt.RightButton)
                        {
                            option_menu.popup()
                        }
                    }
                    onClicked: {
                        if(mouse.button === Qt.LeftButton){
                        sourceList.changeImage(index)
                        stopTimer()
                        }
                    }
                }
            }
            Button{
                width:          20
                x:              parent.width - 20
                height:         parent.height
                contentItem: Text{
                    text: "X"
                    color: "white"
                }
                background: Rectangle{
                    border.width: 1
                    border.color: "silver"
                    color: "#333333"
                }
                onClicked:      {
                    stopTimer()
                    sourceList.deleteImage(index)

                }
            }
        }
    }
    Menu{
        id: option_menu
        MenuItem{
            text: "Delete All"
            onTriggered: {
                stopTimer()
                sourceList.deleteAll();
                sourceList.imageDeleted()
                sourceList.actualFilesChanged()
            }
        }
    }
}

