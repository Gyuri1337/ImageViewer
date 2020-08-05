#include "myfilesource.h"
#include <QObject>
#include <QImage>
#include <exiv2/config.h>
#include <QUrl>
// Costructors
MyFileSource::MyFileSource(QObject* parent): QObject (parent){ }
MyFileSource::MyFileSource(QString _dir, QString _fileName, QImage _imageValue, QObject *parent): QObject(parent)
{
    fileName = _fileName;
    dir      = _dir;
    imageDir = _imageValue;
}


// Public methods
QString MyFileSource::getDir(){
    return dir;
}

QString MyFileSource::getFileName(){
    return fileName;
}
QImage* MyFileSource::getImage(){
    return (&imageDir);
}
