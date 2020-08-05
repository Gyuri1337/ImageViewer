#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QString>
#include <QImage>
#include <QQmlListProperty>
#include <QQmlContext>

#include "myfilesourcelist.h"
#include "liveimageprovider.h"
#include "timer.h"
int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setOrganizationName("somename");
    app.setOrganizationDomain("somename");
    QQmlApplicationEngine engine;


    //Type register
    qmlRegisterType<MyFileSource>("com.ImageList",1,0,"MyFileSource");


    //Context properties
    ////FileSource
    MyFileSourceList sourceList;
    engine.rootContext()->setContextProperty("sourceList", &sourceList);
    ////LiveImageProvider

    QScopedPointer<LiveImageProvider> liveImageProvider(new LiveImageProvider());
    engine.rootContext()->setContextProperty("liveImageProvider", liveImageProvider.data());
    engine.addImageProvider("live", liveImageProvider.data());


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
