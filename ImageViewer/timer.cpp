#include "timer.h"
#include "liveimageprovider.h"
#include <Windows.h>
#include <thread>

Timer::Timer(MyFileSourceList* obj){
    myFileSource = obj;
}
Timer::~Timer()
{
    delete  myFileSource;
}

void Timer::start(int i){
    std::thread thread_object(&Timer::foo,this);
}
void Timer::stop(){
    on = false;
}

void Timer::foo()
{
    on = true;
    while(on)
    {
     myFileSource->next();
     Sleep(delay);
    }
}
