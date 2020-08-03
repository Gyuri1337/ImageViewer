import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4 as OldControls
import com.ImageList 1.0
Window {
    property bool _selectFolder: false
    property var filter: _selectFolder ? [] : ["Images JPEG (*.jpg)"]
    property var buttonHeight: 100
    property var buttonWidth: 200
    property var smallSpace: 3

    id: window
    visible: true
    width: 800
    height: 500
    //***********************************************************************************************************************
    //************************************Image AREA**************************
    //***********************************************************************************************************************
    Rectangle   {
        id: imageArea
        anchors.left: listArea.right
        anchors.top: barArea.bottom
        width: parent.width - listArea.width
        height: parent.height - barArea.height

        Image{
            id: actualImage
            smooth: false
            fillMode: Image.PreserveAspectFit
            property real zoomRatio: 0.8
            property real myWidth: parent.width
            property real myHeight: parent.height
            width: myWidth
            height: myHeight
            source: "image://live/image"
            DropArea{
                anchors.fill: parent

            }

            MouseArea{
                property real newPointX: 0 // for more clear Code, new Point is relative to image and
                property real newPointY: 0 // shows where the zooming point will be after the zoom
                property real imageCenterX: parent.width /2
                property real imageCenterY: parent.height / 2
                anchors.fill: parent
                hoverEnabled: true
                id: imageMouse
                onWheel: {
                    var delta = wheel.angleDelta.y / 120.0
                    if(delta == 1) // +ZOOM
                    {
                        parent.myWidth = parent.width / parent.zoomRatio
                        parent.myHeight = parent.height / parent.zoomRatio
                        newPointX = (mouseX)/parent.zoomRatio
                        newPointY = (mouseY)/parent.zoomRatio
                        parent.x = parent.x -(newPointX- mouseX)
                        parent.y = parent.y -(newPointY - mouseY)
                    }
                    else // -ZOOM
                    {
                        parent.myWidth = parent.width * parent.zoomRatio
                        parent.myHeight = parent.height * parent.zoomRatio
                        newPointX = (mouseX)*parent.zoomRatio
                        newPointY = (mouseY)*parent.zoomRatio
                        parent.x = parent.x +(mouseX- newPointX)
                        parent.y = parent.y +(mouseY - newPointY)
                    }
                }
                onReleased:{
                    console.log(imageCenterX)

                }

                drag{
                    target: actualImage
                    axis: Drag.XAndYAxis
                    minimumX: -imageCenterX
                    minimumY: -imageCenterY
                    maximumX: imageCenterX + parent.parent.width - parent.width
                    maximumY: imageCenterY + parent.parent.height - parent.height


                }
            }
        }
        GroupBox {
                id: button
                anchors.centerIn: parent
                height: buttonHeight* buttonCount * marigin
                width: buttonWidth * marigin
                property int buttonCount: 2
                property real marigin: 1.13
                hoverEnabled: true
                Repeater
                {
                    x: parent.left - width
                    y: parent.top - (width)
                    model: ["Please select directory of images","Please select one or more images"]
                    Button {
                        background: Rectangle{
                        color: "silver"
                        border.width: 1
                        border.color: "blue"
                        radius: 20
                        }
                        y: index* (buttonHeight + smallSpace)
                        anchors.left: parent.left
                        height: buttonHeight
                        width: buttonWidth
                        text: modelData
                        onClicked: {
                            _selectFolder = (index == 0) ? false : true
                            filedialog.open();
                        }
                    }
                }
                MouseArea{
                    hoverEnabled: true
                }
        }
    }
    //***********************************************************************************************************************
    //************************************Bar AREA**************************
    //***********************************************************************************************************************
    Item{
        id: barArea
        anchors.top: parent.top
        anchors.left: parent.left
        height: fileLoadingMenu.height
        width: parent.width
        property int buttonCount: 3
        MenuBar{
            id: fileLoadingMenu
            x: 0
            y: 0

            Menu{
                title: "File"
                Action{
                    text: qsTr("&Add")
                    onTriggered: {
                        _selectFolder = false
                        filedialog.open();
                    }
                }
            Action{
                text: qsTr("&Add from")
                onTriggered: {
                    _selectFolder = true
                    filedialog.open();
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
            x: (parent.parent.width / 2) - (fileLoadingMenu.height * parent.buttonCount / 2)
            RowLayout{
                anchors.fill:parent
                ToolSeparator{

                }
                ToolButton{
                    icon.source: "file:///C:/Users/Workswell 1/Documents/ImageViewer/61007.png"
                    onClicked: {myTimer.running = false
                        sourceList.rotate(-90)
                    }
                }
                ToolButton{
                    icon.source: "file:///C:/Users/Workswell 1/Documents/ImageViewer/resize.png"
                    onClicked:{
                        myTimer.running = false
                        reFillActualImage()
                    }
                }
                ToolButton{
                    icon.source: "file:///C:/Users/Workswell 1/Documents/ImageViewer/61077.png"
                    onClicked: {
                        myTimer.running = false
                        sourceList.rotate(90)
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
                    icon.source: "file:///C:/Users/Workswell 1/Documents/ImageViewer/play.png"
                    onClicked: {myTimer.running = true
                    }

                }
                ToolButton{
                    icon.source: "file:///C:/Users/Workswell 1/Documents/ImageViewer/pause.png"
                    onClicked: myTimer.running = false
                }
                ToolButton{
                    icon.source: "file:///C:/Users/Workswell 1/Documents/ImageViewer/stop.png"
                    onClicked: {
                        myTimer.running = false
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
    //***********************************************************************************************************************
    //************************************List AREA**************************
    //***********************************************************************************************************************
    Item{
        id: listArea
        anchors.left: parent.left
        anchors.top: barArea.bottom
        height: parent.height - barArea.height
        width: parent.width / 4

        Rectangle{
            id:listBackground
            height: parent.height
            width:parent.width
            anchors.fill: parent
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
                    property string col: "black"
                    wrapMode: TextInput.Wrap
                    verticalAlignment: TextInput.AlignLeft

                    color: textMouse.containsMouse ? "blue" : "black"
                    text:{
                        fileName
                    }

                    width: parent.width - 20
                    height: parent.height
                    MouseArea{
                        id: textMouse
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        anchors.fill:   parent
                        onPressed:      {
                            parent.color = "red"
                            console.log("PRESSED")
                            if(mouse.button === Qt.RightButton)
                            {
                                option_menu.popup()
                            }
                        }
                        onReleased:     parent.color = "black"
                        onClicked:      {
                            if(mouse.button === Qt.LeftButton){
                            console.log("image clicked on " + index)
                            myTimer.running = false;
                            sourceList.changeImage(index)

                            console.log(mouse.button)
                           }
                        }



                    }
                }
                Button{
                    background: Rectangle{
                        border.width: 1
                        border.color: "blue"
                        radius: 20
                    }

                    width:          20
                    x:              parent.width - 20
                    height:         parent.height
                    text:           "X"
                    onClicked:      {
                        console.log("deletimage clicked on " + index)
                        myTimer.running = false;
                        sourceList.deleteImage(index)

                    }
                }
            }
        }
    }

    minimumHeight: barArea.height + buttonHeight * 3
    minimumWidth: 2*animationController.width+toolBar.width + 45
    Menu{
        id: option_menu

        MenuItem{
            text: "Delete All"
            onTriggered: {
                myTimer.running = false;
                 sourceList.deleteAll();
                sourceList.imageDeleted()
                sourceList.actualFilesChanged()
            }
        }
    }

    FileDialog {
            id: filedialog // select pictures
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
                _list.addFileSourceFromSavedPaths()
            }
            else // Single select or folder
            {
                path= Qt.platform.os == "osx" ? path.replace(/^(file:\/{2})/,"") : path.replace(/^(file:\/{3})|(qrc:\/{2})/,"");
                if(filedialog.selectFolder === true)
                {
                    sourceList.addFileSourceFromFolder(path)
                }
                else
                {
                    sourceList.addFileSource(path)
                }
                console.log(path)
            }
            }
    }
    Item {
        id:sourceListConnections
        Connections{
            target: sourceList
            onImageAdded:{
                if(sourceList.actualFiles.length ===0)
                {
                    console.log("empty")
                    myTimer.running = false;
                }
                else
                {
                actualImage.source = "image://live/image" + Math.random()
                console.log("imageAdded called");
                button.visible = false;
                reFillActualImage();
                imageArea.visible = true;
                }
            }
            onImageDeleted:{
                console.log("onDeleted called")
                button.visible = true;
                imageArea.visible = false;
            }
            onAnimationEnded:{
                console.log("endeddddd")
                myTimer.running = false
            }
        }
    }
    function reFillActualImage()
    {
        actualImage.anchors.fill = actualImage.parent
        actualImage.anchors.fill = null
        return 0
    }
    Timer{
        id: myTimer
        interval: (parseInt(timeInterval.displayText) * 1000) > 0 ? (parseInt(timeInterval.displayText) * 1000) : 1000 // miliseconds to seconds
        running: false
        repeat: true
        onTriggered: {
            sourceList.next()
            sourceList.imageAdded()
        }

    }
}


