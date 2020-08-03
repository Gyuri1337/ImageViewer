#ifndef MYFILESOURCE_H
#define MYFILESOURCE_H

#include <QObject>
#include <QImage>

class MyFileSource: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString fileName             READ getFileName            CONSTANT    )


public:
    // Contructors
    MyFileSource(QObject* parent = nullptr);
    MyFileSource(QString _value, QImage _image, QObject* parent = nullptr);

    // Public methods
    QString getFileName();
    QImage getImage();


private:
    //Private variables
    QString _fileName;
    QImage _imageDir;
};

#endif // MYFILESOURCE_H
