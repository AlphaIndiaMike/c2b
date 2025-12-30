#ifndef DOCHTML_H
#define DOCHTML_H

#include <QObject>
#include <QString>
#include <QQmlEngine>

class HtmlGenerator : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit HtmlGenerator(QObject *parent = nullptr);

    // Generate complete HTML with TOC from markdown
    Q_INVOKABLE QString generateFullDocument(const QString &markdown);

    static HtmlGenerator *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        return new HtmlGenerator();
    }

private:
    QString generateTOC(const QString &markdown);
    QString wrapWithTemplate(const QString &toc, const QString &htmlBody);
};

#endif // DOCHTML_H
