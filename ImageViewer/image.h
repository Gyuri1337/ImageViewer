#ifndef IMAGE_H
#define IMAGE_H

#include <QObject>
#include <QQuickItem>
#include <QImage>

class MyImage : QObject
{
  Q_OBJECT

public:
    QString getName();
    QImage m_value;
    MyImage();
    MyImage(QString myDir);
private:
    QString m_dir;

};

#endif // IMAGE_H
