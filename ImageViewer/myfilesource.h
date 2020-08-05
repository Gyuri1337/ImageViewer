#ifndef MYFILESOURCE_H
#define MYFILESOURCE_H

#include <QObject>
#include <QImage>
#include <QUrl>

class MyFileSource: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString fileName             READ getFileName            CONSTANT    )


public:
    // Contructors
    MyFileSource(QObject* parent = nullptr);
    MyFileSource(QString _dir, QString _fileName, QImage _imageValue, QObject *parent = nullptr);

    // Public methods
    QString getDir();
    QImage* getImage();
    QString getFileName();
    bool Equals(MyFileSource tmp);

private:
    //Private variables
    QString fileName;
    QString dir;
    QImage imageDir;
};

#endif // MYFILESOURCE_H
