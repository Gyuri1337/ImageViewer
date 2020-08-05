import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.4
import QtQuick.Extras 1.4
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 1.4 as OldControls
import com.ImageList 1.0

Rectangle   {
    //Signals
    signal openFileDialog;

    //Functions
    function reFill(){
        actualImage.anchors.fill = actualImage.parent
        actualImage.anchors.fill = null
        actualImage.scale = 1
    }
    function changeToButton(){
        button.visible = true;
        actualImage.visible =false;
    }
    function changeToImage(){
        actualImage.visible= true;
        button.visible = false;
    }
    function addRandomMathToSource(){
        actualImage.source = actualImage.source + Math.random()
    }
    function rotateRight(){
        actualImage.rotation += 90
    }
    function rotateLeft(){
        actualImage.rotation -= 90
    }

    //Code
    color: "#3B3B3B"
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
        visible: false
        DropArea{
            anchors.fill: parent
        }
        MouseArea{
            property real newPointX: 0 // for more clear Code, new Point is relative to image and
            property real newPointY: 0 // shows where the zooming point will be after the zoom
            property real imageCenterX: parent.width /2
            property real imageCenterY: parent.height / 2
            property real minSize: 50
            anchors.fill: parent
            hoverEnabled: true
            id: imageMouse
            onWheel: {
                var delta = wheel.angleDelta.y / 120.0
                if(delta === 1) // +ZOOM
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
                    if(parent.width < minSize && parent.height < minSize)
                    {
                        console.log("too small");
                    }
                    else
                    {
                        parent.myWidth = parent.width * parent.zoomRatio
                        parent.myHeight = parent.height * parent.zoomRatio
                        newPointX = (mouseX)*parent.zoomRatio
                        newPointY = (mouseY)*parent.zoomRatio
                        parent.x = parent.x +(mouseX- newPointX)
                        parent.y = parent.y +(mouseY - newPointY)
                    }
                }
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
    Rectangle{
        anchors.bottom: parent.bottom
        height: 15
        width: parent.width
        color: "#333333"
        visible: actualImage.visible ? true : false
        Text{
            anchors.left: parent.left
            height: parent.height
            color: "white"
            text: sourceList.metaData
        }
    }

    GroupBox {
            id: button
            anchors.centerIn: parent
            height: buttonHeight* buttonCount * marigin
            width: buttonWidth * marigin
            background: Rectangle{
                border.width: 1
                border.color: "#3B3B3B"
                color: "#3B3B3B"
            }

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
                    border.color: "#F54124"
                    radius: 20
                    }
                    y: index* (buttonHeight + smallSpace)
                    anchors.left: parent.left
                    height: buttonHeight
                    width: buttonWidth
                    text: modelData
                    onClicked: {
                        _selectFolder = (index == 0) ? false : true
                        openFileDialog()
                    }
                }
            }
            MouseArea{
                hoverEnabled: true
            }
    }
}
