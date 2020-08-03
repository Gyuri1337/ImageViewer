#ifndef TIMER_H
#define TIMER_H

#include <QObject>
#include<Windows.h>
#include "myfilesourcelist.h"
class Timer: public QObject
{
    Q_OBJECT
public slots:
    void start(int interval);
    void stop();
public:
    Timer(MyFileSourceList*);
    ~Timer();
private:
    MyFileSourceList* myFileSource;
    bool on= false;
    void foo();
    long delay = 1000;
};

#endif // TIMER_H
