#include "image.h"
#include <QObject>
#include <QQuickItem>
#include <QImage>

MyImage::MyImage()
{

}
MyImage::MyImage(QString url){
    m_dir = url;
}

QString MyImage::getName(){
    QUrl url(m_dir);
    return url.fileName();
}
