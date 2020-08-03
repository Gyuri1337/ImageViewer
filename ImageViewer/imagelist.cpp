#include "imagelist.h"
#include <QObject>
#include <QQuickItem>
#include <QQmlListProperty>
#include <QImage>
#include "image.h"

ImageList::ImageList()
{
    m_images = QList<MyImage*>();
}
ImageList::~ImageList(){
    for (MyImage* p : m_images) {
        delete p;
    }
}
QQmlListProperty<MyImage> ImageList::images(){
    return QQmlListProperty<MyImage>(this, m_images);
}

void ImageList::addImagesFromURL(const QString itemDir){
    MyImage* a = new MyImage(itemDir);
    a -> m_value.load(itemDir);
    m_images.append(a);

    imagesUpdated();
}

void ImageList::addImagesFromFolder(const QString itemDir){

    imagesUpdated();
}
