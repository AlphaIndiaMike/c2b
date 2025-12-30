#ifndef DOCUMENTMANAGER_H
#define DOCUMENTMANAGER_H

#include <QObject>
#include <QString>
#include <QQmlEngine>

class DocumentManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit DocumentManager(QObject *parent = nullptr);

    // Load markdown
    Q_INVOKABLE QString loadDocument(const QString &filePath);

    // Save both markdown and HTML
    Q_INVOKABLE bool saveDocumentWithHtml(const QString &markdownContent,
                                          const QString &htmlContent,
                                          const QString &baseFilePath);

    // Get base URL for images
    Q_INVOKABLE QString getBaseUrl(const QString &filePath);

    static DocumentManager *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        return new DocumentManager();
    }

signals:
    void documentSaved(bool success, const QString &mdPath, const QString &htmlPath);
    void documentLoaded(const QString &content);
};

#endif // DOCUMENTMANAGER_H
