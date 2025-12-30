#include "DocHTML.h"
#include "md4c-html.h"
#include <QRegularExpression>

HtmlGenerator::HtmlGenerator(QObject *parent)
    : QObject(parent)
{
}

static void processOutput(const MD_CHAR* text, MD_SIZE size, void* userdata)
{
    QByteArray* output = static_cast<QByteArray*>(userdata);
    output->append(text, size);
}

QString HtmlGenerator::generateTOC(const QString &markdown)
{
    QString toc = "<nav class=\"toc\">\n<h2>Table of Contents</h2>\n<ul>\n";

    // Extract headers (# Header, ## Header, etc.)
    QRegularExpression headerRegex("^(#{1,6})\\s+(.+)$",
                                   QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator it = headerRegex.globalMatch(markdown);

    int chapterNum = 0;
    while (it.hasNext()) {
        QRegularExpressionMatch match = it.next();
        int level = match.captured(1).length();
        QString title = match.captured(2);

        if (level == 1) {
            chapterNum++;
        }

        QString indent = QString("  ").repeated(level - 1);
        QString id = QString("chapter-%1").arg(chapterNum);

        toc += indent + QString("<li><a href=\"#%1\">%2</a></li>\n")
                            .arg(id, title);
    }

    toc += "</ul>\n</nav>\n";
    return toc;
}

QString HtmlGenerator::wrapWithTemplate(const QString &toc, const QString &htmlBody)
{
    return QString(R"(<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style>
        @media print {
            .toc { page-break-after: always; }
            h1 { page-break-before: always; }
        }

        body {
            font-family: 'Georgia', serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px;
            color: #333;
        }

        .toc {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 40px;
        }

        .toc h2 {
            margin-top: 0;
        }

        .toc ul {
            list-style: none;
            padding-left: 0;
        }

        .toc li {
            margin: 8px 0;
        }

        .toc a {
            color: #0066cc;
            text-decoration: none;
        }

        .toc a:hover {
            text-decoration: underline;
        }

        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }

        h2 {
            color: #34495e;
            margin-top: 30px;
        }

        code {
            background: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
        }

        pre {
            background: #f4f4f4;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
        }

        blockquote {
            border-left: 4px solid #3498db;
            margin-left: 0;
            padding-left: 20px;
            color: #555;
        }
    </style>
</head>
<body>
%1
%2
</body>
</html>)").arg(toc, htmlBody);
}

QString HtmlGenerator::generateFullDocument(const QString &markdown)
{
    // Generate TOC
    QString toc = generateTOC(markdown);

    // Convert markdown to HTML
    QByteArray input = markdown.toUtf8();
    QByteArray output;

    md_html(input.constData(), input.size(), processOutput, &output,
            MD_FLAG_TABLES | MD_FLAG_STRIKETHROUGH | MD_FLAG_TASKLISTS, 0);

    QString htmlBody = QString::fromUtf8(output);

    // Wrap with template
    return wrapWithTemplate(toc, htmlBody);
}
