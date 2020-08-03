#ifndef STRINGFILEPROPERTYTESTER_H
#define STRINGFILEPROPERTYTESTER_H

#include <QQmlListProperty>
#include <QObject>
#include <QImage>
#include <QUrl>

#include "myfilesource.h"
#include "liveimageprovider.h"

class MyFileSourceList: public QObject // Class for a list of MyFileSource objects
{
    Q_OBJECT

    Q_PROPERTY(QQmlListProperty<MyFileSource> actualFiles   READ getActualFiles     NOTIFY actualFilesChanged   )

public slots:
    void addFileSource(QString _dir);           // Add images source to the list
    void addFileSourceFromFolder(QString _dir); // Add images source from a folder to the list
    void changeImage(int index);
    void deleteImage(int index);
    void rotate(int);
    void next();
    void stop();
    void deleteAll();
    void setCheckStateTo(bool);
public:
    // Contructors
    MyFileSourceList(QObject *parent= nullptr);
    //MyFileSourceList(LiveImageProvider * imageProvider, QObject *parent= nullptr);
    ~MyFileSourceList();

    // Public methods
    QQmlListProperty<MyFileSource> getActualFiles();


signals:
    void actualFilesChanged();
    void imageAdded();
    void imageDeleted();
    void animationEnded();

private:
    //Private variables
    QList<MyFileSource*> _myList;
    bool isImage =false;
    int actualImage = -1;
    bool replay = false;
};

#endif // STRINGFILEPROPERTYTESTER_H
