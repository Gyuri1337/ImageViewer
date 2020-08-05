#ifndef STRINGFILEPROPERTYTESTER_H
#define STRINGFILEPROPERTYTESTER_H

#include <QQmlListProperty>
#include <QObject>
#include <QImage>
#include <QUrl>
#include <unordered_map>

#include "myfilesource.h"
#include "liveimageprovider.h"
#include "exiv2/exiv2.hpp"

class MyFileSourceList: public QObject // Class for a list of MyFileSource objects
{
    Q_OBJECT

    Q_PROPERTY(QQmlListProperty<MyFileSource> actualFiles   READ getActualFiles     NOTIFY actualFilesChanged   )
    Q_PROPERTY(QString metaData                             READ getMetaData        NOTIFY metaDataChanged      )

public slots:
    void addFileSource(QString _dir);           // Add images source to the list
    void addFileSourceFromFolder(QString _dir); // Add images source from a folder to the list
    void changeImage(int index);
    void deleteImage(int index);
    void next();
    void stop();
    void deleteAll();
    void setCheckStateTo(bool);
    Exiv2::ExifData readExifMetadataFrom(QString _dir);
public:
    // Contructors
    MyFileSourceList(QObject *parent= nullptr);
    //MyFileSourceList(LiveImageProvider * imageProvider, QObject *parent= nullptr);
    ~MyFileSourceList();

    // Public methods
    QString getMetaData();
    QQmlListProperty<MyFileSource> getActualFiles();
    bool MyFileSourceList::get_tag_value(const std::string& tag);

signals:
    void actualFilesChanged();
    void imageAdded();
    void imageDeleted();
    void animationEnded();
    void metaDataChanged();

private:
    //Private variables
    std::unordered_map<std::string, MyFileSource*> myMap;
    QList<MyFileSource*> _myList;
    bool isImage =false;
    int actualImage = -1;
    bool replay = false;
};

#endif // STRINGFILEPROPERTYTESTER_H
