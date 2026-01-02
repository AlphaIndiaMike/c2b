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
    Q_INVOKABLE QString generateFullDocument(const QString &title, const QString &markdown);
    Q_INVOKABLE QString generatePreviewDocument(const QString &markdown);

    static HtmlGenerator *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        return new HtmlGenerator();
    }

private:
    static const QString header;
    QString generateTOC(const QString &markdown);
    QString wrapWithTemplate(const QString &title, const QString &toc, const QString &htmlBody);
    QString wrapWithTemplate(const QString &htmlBody);
    static QString createSlug(const QString &text);
    static QString addIdsToHeadings(const QString &html, const QString &markdown);
};

#endif // DOCHTML_H
