#include "LiveImageProvider.h"
#include <QDebug>

// external variables
QImage __image;

LiveImageProvider::LiveImageProvider() : QQuickImageProvider(QQuickImageProvider::Image)
{
    this->no_image.load(":/no_image.jpg");
    this->blockSignals(false);
}

LiveImageProvider::~LiveImageProvider(){

}

QImage LiveImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage result  = __image;

    if(result.isNull()) {
        result = this->no_image;
    }

    if(size) {
        *size = result.size();
    }

    if(requestedSize.width() > 0 && requestedSize.height() > 0) {
        result = result.scaled(requestedSize.width(), requestedSize.height(), Qt::KeepAspectRatio);
    }

    return result;
}



