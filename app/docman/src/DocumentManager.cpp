#include "DocumentManager.h"
#include <QFile>
#include <QTextStream>
#include <QFileInfo>
#include <QUrl>

DocumentManager::DocumentManager(QObject *parent)
    : QObject(parent)
{
}

QString DocumentManager::loadDocument(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return QString();
    }

    QTextStream in(&file);
    QString content = in.readAll();
    file.close();

    emit documentLoaded(content);
    return content;
}

bool DocumentManager::saveDocumentWithHtml(const QString &markdownContent,
                                           const QString &htmlContent,
                                           const QString &baseFilePath)
{
    QFileInfo fileInfo(baseFilePath);
    QString baseName = fileInfo.completeBaseName();
    QString dir = fileInfo.absolutePath();

    // Save markdown
    QString mdPath = baseFilePath;
    if (!mdPath.endsWith(".md")) {
        mdPath += ".md";
    }

    QFile mdFile(mdPath);
    if (!mdFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        emit documentSaved(false, "", "");
        return false;
    }

    QTextStream mdOut(&mdFile);
    mdOut << markdownContent;
    mdFile.close();

    // Save HTML with same base name
    QString htmlPath = dir + "/" + baseName + ".html";
    QFile htmlFile(htmlPath);
    if (!htmlFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        emit documentSaved(false, mdPath, "");
        return false;
    }

    QTextStream htmlOut(&htmlFile);
    htmlOut << htmlContent;
    htmlFile.close();

    emit documentSaved(true, mdPath, htmlPath);
    return true;
}

QString DocumentManager::getBaseUrl(const QString &filePath)
{
    QFileInfo fileInfo(filePath);
    QString dirPath = fileInfo.absolutePath();

    // Convert to proper file:// URL
    QUrl url = QUrl::fromLocalFile(dirPath + "/");
    return url.toString();
}
