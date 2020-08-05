#include "LiveImageProvider.h"
#include <QDebug>
#include "myfilesource.h"
// external variables
MyFileSource* __image;

LiveImageProvider::LiveImageProvider() : QQuickImageProvider(QQuickImageProvider::Image)
{
    this->no_image.load(":/no_image.jpg");
    this->blockSignals(false);
}

LiveImageProvider::~LiveImageProvider(){

}

QImage LiveImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{

    QImage result;
    if(__image == nullptr) {
        if(no_image.isNull())
            return result;
        result = this->no_image;
    }
    else {
        result  = *__image->getImage();
    }

    if(size) {
        *size = result.size();
    }

    if(requestedSize.width() > 0 && requestedSize.height() > 0) {
        result = result.scaled(requestedSize.width(), requestedSize.height(), Qt::KeepAspectRatio);
    }

    return result;
}



