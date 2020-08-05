#include <QQmlListProperty>
#include <QQuickItem>
#include <QObject>
#include <QImage>
#include <stdio.h>
#include <QUrl>
#include <QDir>
#include <iostream>
#include <iomanip>
#include <cassert>
#include <unordered_map>
#include "myfilesource.h"
#include "myfilesourcelist.h"
#include "liveimageprovider.h"
#include "exiv2/exiv2.hpp"

//**************
// Constructors
//**************
MyFileSourceList::MyFileSourceList(QObject *parent) :QObject (parent){ }
MyFileSourceList::~MyFileSourceList(){
    for (MyFileSource* p: _myList) {
       delete p;
    }
    for(auto& it : myMap)
    {
        delete it.second;
    }
}
//**************
//Slots
//**************
void MyFileSourceList::addFileSource(QString _dir){
    QUrl tmpUrl(_dir);
    QImage tmpImage(_dir);
    readExifMetadataFrom(_dir);
    MyFileSource* fileSource = new MyFileSource(_dir,tmpUrl.fileName(),tmpImage);
    if(get_tag_value(_dir.toStdString())){
          //qDebug() << "already exists";
    }
    else {
        //qDebug() << "new image added" << _dir;
        myMap.insert(std::pair<std::string,MyFileSource*>(_dir.toStdString(),fileSource));
        _myList.append(fileSource);
    }
    emit actualFilesChanged();

}
void MyFileSourceList::addFileSourceFromFolder(QString _dir){
    QDir tmpDirectory(_dir);
    QStringList imageList = tmpDirectory.entryList(QStringList("*.jpg"));
    for (int i=0;i < imageList.count();i++) {
        if(get_tag_value((_dir +"/"+imageList[i]).toStdString())){
              //qDebug() << "already exists";
        }
        else {
            QUrl tmpUrl(_dir +"/"+imageList[i]);
            QImage tmpImage(_dir +"/"+imageList[i]);
            MyFileSource* fileSource = new MyFileSource((_dir +"/"+imageList[i]),tmpUrl.fileName(),tmpImage);
            myMap.insert(std::pair<std::string,MyFileSource*>((_dir +"/"+imageList[i]).toStdString(),fileSource));
            _myList.append(fileSource);
        }
    }
    emit actualFilesChanged();
}
bool MyFileSourceList::get_tag_value(const std::string& tag)
{
    auto t = myMap.find(tag);
    if (t == myMap.end()) return false;
    return true;
}
void MyFileSourceList::changeImage(int index){
    qDebug() << "changeImage";
    if(index >= 0 && index < _myList.count())
    {
        MyFileSource* tmp = _myList[index];
         if(tmp != __image || !isImage)
         {
             __image = tmp;
             isImage = true;
             emit imageAdded();
         }
    }
    emit metaDataChanged();
}
void MyFileSourceList::deleteImage(int index)
{
    if(index > -1)
    {
        MyFileSource* tmp =_myList[index];
        if(tmp == __image)
        {
            if(_myList.count()==1)
            {
                delete _myList[index];
                _myList.clear();
                myMap.clear();
                isImage=false;
                emit imageDeleted();
            }
            else if(index < (_myList.count() - 1))
            {
                myMap.erase(_myList[index]->getDir().toStdString());
                delete _myList[index];
                __image = _myList[index + 1];
                _myList.removeAt(index);
                emit imageAdded();
            }
            else {
                myMap.erase(_myList[index]->getDir().toStdString());
                delete _myList[index];
                __image = _myList[index - 1];
                _myList.removeAt(index);
                emit imageAdded();
            }
            emit actualFilesChanged();
        }
        else {
            myMap.erase(_myList[index]->getDir().toStdString());
            delete _myList[index];
            _myList.removeAt(index);
            emit actualFilesChanged();
        }
    }
    emit metaDataChanged();
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
                __image = _myList[actualImage];
            }

        }
        else {
            actualImage++;
            __image = _myList[actualImage];
        }
    }
    emit metaDataChanged();
}
QString MyFileSourceList::getMetaData(){
    if(__image == nullptr)
    {
        return "No Image";
    }
    return QString::fromStdString(readExifMetadataFrom(__image->getDir())["Exif.Image.DateTime"].toString());
}
Exiv2::ExifData MyFileSourceList::readExifMetadataFrom(QString _dir){
    Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open(_dir.toStdString());
    assert(image.get() != nullptr);
    image-> readMetadata();

    Exiv2::ExifData &exifData = image ->exifData();
    if(exifData.empty())
    {
        qDebug() << "No MetadataFOunded";
        return exifData;
    }
    else {
        qDebug() << "Metadata founded";
        return exifData;
    }


}
void MyFileSourceList::stop(){
    actualImage= -1;
    if(_myList.count()> 0)
    {
        __image = _myList[0];
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



