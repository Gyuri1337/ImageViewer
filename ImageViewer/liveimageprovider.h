#ifndef LIVEIMAGEPROVIDER_H
#define LIVEIMAGEPROVIDER_H

#include <QObject>
#include <QImage>
#include <QQuickImageProvider>

#include"myfilesource.h"

extern MyFileSource*__image;

class LiveImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
public:

    LiveImageProvider();
    ~LiveImageProvider();
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

public slots:

private:
    QImage no_image;
};

#endif // LIVEIMAGEPROVIDER_H
