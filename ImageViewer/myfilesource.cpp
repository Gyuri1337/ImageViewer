#include "myfilesource.h"
#include <QObject>
#include <QImage>

// Costructors
MyFileSource::MyFileSource(QObject* parent): QObject (parent){ }
MyFileSource::MyFileSource(QString _fileNameValue, QImage _imageValue, QObject *parent): QObject(parent)
{
    _fileName   = _fileNameValue;
    _imageDir      = _imageValue;
}


// Public methods
QString MyFileSource::getFileName(){
    return _fileName;
}
QImage MyFileSource::getImage(){
    return _imageDir;
}

