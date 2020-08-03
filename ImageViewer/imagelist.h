#ifndef IMAGELIST_H
#define IMAGELIST_H

#include <QObject>
#include <QQuickItem>
#include <QQmlListProperty>
#include <QImage>
#include "image.h"
class ImageList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<MyImage> images READ images NOTIFY imagesUpdated)

signals:
    void imagesUpdated();

public slots:
    void addImagesFromURL(QString itemDir);
    void addImagesFromFolder(QString foldDir);
    QQmlListProperty<MyImage> images();

public:
    ~ImageList();
    ImageList();


private:
    QList<MyImage *> m_images;

};

#endif // IMAGELIST_H
