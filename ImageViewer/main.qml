import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4 as OldControls
import com.ImageList 1.0

Window {
    //functions
    function reFillActualImage()
    {
        imageArea.reFill()
    }
    function startTimer(){
        myTimer.running = true;
    }

    //properties
    property bool _selectFolder: false
    property var filter: _selectFolder ? [] : ["Images JPEG (*.jpg)"]
    property var buttonHeight: 100
    property var buttonWidth: 200
    property var smallSpace: 3

    //code
    id: window
    visible: true
    width: 800
    height: 500
    minimumHeight: barArea.height + buttonHeight * 4
    minimumWidth:  barArea.height * 18
    //Image Area
    ImageArea{
        id: imageArea
        anchors.left: listArea.right
        anchors.top: barArea.bottom
        width: parent.width - listArea.width
        height: parent.height - barArea.height
        onOpenFileDialog: {
            fileDialog.open()
        }
    }
    //List Area
    ListArea{
        id: listArea
        anchors.left: parent.left
        anchors.top: barArea.bottom
        height: parent.height - barArea.height
        width: parent.width / 4
        onStopTimer: {
            myTimer.running = false
        }
    }
    //Bar Area
    BarArea {
        id: barArea
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        onSelectingFolder: {
            _selectFolder = true
             fileDialog.open()
        }
        onNotSelectiongFolder: {
            _selectFolder = false
            fileDialog.open()
        }
        onTimerStart: {
            myTimer.start()
        }
        onTimerStop: {
            myTimer.stop()
        }
        onRotateImageLeft: {
            imageArea.rotateLeft()
        }
        onRotateImageRight: {
            imageArea.rotateRight()
        }
        onReFillImage: {
            reFillActualImage()
        }
    }

    //File dialog for selectiong files or folders
    FileDialog {
            id: fileDialog // select pictures
            title: "Please select one or more pictures"
            selectMultiple: true
            selectFolder: _selectFolder
            nameFilters: filter
            onAccepted: {
                var path = fileUrl.toString();
                if(path.length === 0)  // Multiple selecting
                {
                    for (var i = 0; i < fileUrls.length; i++)
                    {
                        path= Qt.platform.os == "osx" ? fileUrls[i].replace(/^(file:\/{2})/,"") : fileUrls[i].replace(/^(file:\/{3})|(qrc:\/{2})/,"");
                        sourceList.addFileSource(path)
                    }
                }
                else // Single select or folder
                {
                    path= Qt.platform.os == "osx" ? path.replace(/^(file:\/{2})/,"") : path.replace(/^(file:\/{3})|(qrc:\/{2})/,"");
                    if(fileDialog.selectFolder === true)
                    {
                        sourceList.addFileSourceFromFolder(path)
                    }
                    else
                    {
                        sourceList.addFileSource(path)
                    }
                }
            }
    }

    //Timer
    Timer{
        id: myTimer
        interval: (parseInt(barArea.getTimerInerval) * 1000) > 0 ? (parseInt(barArea.getTimerInterval) * 1000) : 1000 // miliseconds to seconds
        running: false
        repeat: true
        onTriggered: {
            sourceList.next()
            sourceList.imageAdded()    
        }
    }

    //Connections
    Connections{
        target: sourceList
        onImageAdded:{
            if(sourceList.actualFiles.length ===0)
            {
                myTimer.running = false;
            }
            else
            {
                console.log("imageAdded")
                imageArea.addRandomMathToSource()
                imageArea.changeToImage()
                reFillActualImage();
            }
        }
        onImageDeleted:{
            imageArea.changeToButton()
        }
        onAnimationEnded:{
            myTimer.running = false
        }
    }
}


