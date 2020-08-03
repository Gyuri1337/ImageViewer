#include <QQmlListProperty>
#include <QQuickItem>
#include <QObject>
#include <QImage>
#include <stdio.h>
#include <QUrl>
#include <QDir>

#include "myfilesource.h"
#include "myfilesourcelist.h"
#include "liveimageprovider.h"
//**************
// Constructors
//**************
MyFileSourceList::MyFileSourceList(QObject *parent) :QObject (parent){ }
MyFileSourceList::~MyFileSourceList(){
    for (MyFileSource* p: _myList) {
       delete p;
    }
}
//**************
//Slots
//**************
void MyFileSourceList::addFileSource(QString _dir){
    QUrl tmpUrl(_dir);
    QImage tmpImage(_dir);
    MyFileSource* fileSource = new MyFileSource(tmpUrl.fileName(),tmpImage);
    _myList.append(fileSource);

    emit actualFilesChanged();

}
void MyFileSourceList::addFileSourceFromFolder(QString _dir){
    QDir tmpDirectory(_dir);
    QStringList imageList = tmpDirectory.entryList(QStringList("*.jpg"));
    for (int i=0;i < imageList.count();i++) {
        QUrl tmpUrl(_dir +"/"+imageList[i]);
        QImage tmpImage(_dir +"/"+imageList[i]);
        MyFileSource* fileSource = new MyFileSource(tmpUrl.fileName(),tmpImage);
        _myList.append(fileSource);
    }
    emit actualFilesChanged();
}
void MyFileSourceList::changeImage(int index){
    if(index >= 0 && index < _myList.count())
    {
        QImage tmp = _myList[index]->getImage();
         if(tmp != __image || !isImage)
         {
             __image = tmp;
             isImage = true;
             emit imageAdded();
         }
    }

}
void MyFileSourceList::deleteImage(int index)
{
    if(index > -1)
    {
    QImage tmp =_myList[index]->getImage();
    if(tmp == __image)
    {
        if(_myList.count()==1)
        {
            delete _myList[index];
            _myList.clear();
            isImage=false;
            emit imageDeleted();
        }
        else if(index < (_myList.count() - 1))
        {
            delete _myList[index];
            __image = _myList[index + 1] -> getImage();
            _myList.removeAt(index);
            emit imageAdded();
        }
        else {
            delete _myList[index];
            __image = _myList[index - 1] -> getImage();
            _myList.removeAt(index);
            emit imageAdded();
        }
        emit actualFilesChanged();
    }
    else {
        delete _myList[index];
        _myList.removeAt(index);
        emit actualFilesChanged();
    }
    }
}

void MyFileSourceList::rotate(int degree){
    if(isImage){
    QImage srcImg = __image;
    QPoint center = srcImg.rect().center();
    QMatrix matrix;
    matrix.translate(center.x(), center.y());
    matrix.rotate(degree);
    __image = srcImg.transformed(matrix);
    emit imageAdded();
    }
}
void MyFileSourceList::next(){
    if(_myList.count()>0)
    {
        if(actualImage == _myList.count() - 1 ){
            if(!replay){
                emit animationEnded();
                actualImage = -1;
            }
            else {
                actualImage = 0;
                __image = _myList[actualImage] -> getImage();
            }

        }
        else {
            actualImage++;
            __image = _myList[actualImage] -> getImage();
        }

    }
}
void MyFileSourceList::stop(){
    actualImage= -1;
    if(_myList.count()> 0)
    {
        __image = _myList[0] -> getImage();
    }
}

void MyFileSourceList::deleteAll(){
    for (int i=0;i < _myList.count();i++) {
        delete _myList[i];
    }
    _myList.clear();
    actualImage = -1;
}

void MyFileSourceList::setCheckStateTo(bool value){
    replay = value;
}
//**************
//Public methods
//**************
QQmlListProperty<MyFileSource> MyFileSourceList::getActualFiles(){
    return QQmlListProperty<MyFileSource>(this, _myList);
}



