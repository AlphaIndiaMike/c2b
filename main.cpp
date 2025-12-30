#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
//#include "Markdownconverter.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Register MarkdownConverter app
    //MarkdownConverter converter;
    //engine.rootContext()->setContextProperty("MarkdownConverter", &converter);

    // Register resources
    engine.addImportPath("qrc:/");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("C2B", "Main");

    return app.exec();
}
