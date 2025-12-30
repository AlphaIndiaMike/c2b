#ifndef MARKDOWNCONVERTER_H
#define MARKDOWNCONVERTER_H

#include <QObject>
#include <QString>
#include <QQmlEngine>

class MarkdownConverter : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit MarkdownConverter(QObject *parent = nullptr);

    Q_INVOKABLE QString toHtml(const QString &markdown);
};


#endif // MARKDOWNCONVERTER_H
