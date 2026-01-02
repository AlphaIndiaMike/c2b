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

// Generate Table of Contents with proper nesting
QString HtmlGenerator::generateTOC(const QString &markdown)
{
    QString toc = "<nav class=\"toc\">\n<h2>Table of Contents</h2>\n<ul>\n";

    QRegularExpression headerRegex("^(#{1,6})\\s+(.+)$",
                                   QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator it = headerRegex.globalMatch(markdown);

    int currentLevel = 0;
    QMap<QString, int> slugCounts;

    while (it.hasNext()) {
        QRegularExpressionMatch match = it.next();
        int level = match.captured(1).length();
        QString title = match.captured(2).trimmed();

        // Create slug
        QString slug = createSlug(title);

        // Handle duplicates
        if (slugCounts.contains(slug)) {
            slugCounts[slug]++;
            slug = slug + "-" + QString::number(slugCounts[slug]);
        } else {
            slugCounts[slug] = 0;
        }

        // Close lists if going back up levels
        while (currentLevel > level) {
            toc += "</ul>\n</li>\n";
            currentLevel--;
        }

        // Open nested lists if going deeper
        while (currentLevel < level - 1) {
            toc += "<li><ul>\n";
            currentLevel++;
        }

        // Add the item
        if (currentLevel < level) {
            toc += "<li><ul>\n";
            currentLevel = level;
        } else if (currentLevel == level) {
            toc += "</li>\n";
        }

        toc += QString("<li><a href=\"#%1\">%2</a>")
                   .arg(slug, title);
    }

    // Close all remaining open lists
    while (currentLevel > 0) {
        toc += "</li>\n</ul>\n";
        currentLevel--;
    }

    toc += "</ul>\n</nav>\n";
    return toc;
}

const QString HtmlGenerator::header = R"(
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style>

        :root {
          --primary-color: #333;
          --secondary-color: #f4f4f4;
          --text-color: #333;

          --font-size-xlarge: 18pt;
          --font-size-large: 14pt;
          --font-size-medium: 12pt;
          --font-size-normal: 11pt;
          --font-size-small: 10pt;

          --spacing-xlarge: 30px;
          --spacing-large: 20px;
          --spacing-medium: 10px;
          --spacing-small: 5px;
          --spacing-tiny: 1px;

          --font-family: Arial, Helvetica, sans-serif;
        }

        body {
            font-family: 'Calibri', sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
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

        .toc ul ul {
            padding-left: 20px;  /* Indent nested levels */
            margin-top: 5px;
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
            word-wrap: break-word;
            white-space: pre-wrap;
            overflow-wrap: break-word;
        }

        pre {
            background: #f4f4f4;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            word-wrap: break-word;
            white-space: pre-wrap;
            overflow-wrap: break-word;
        }

        blockquote {
            border-left: 4px solid #3498db;
            margin-left: 0;
            padding-left: 20px;
            color: #555;
        }

        /* Print Styles */
        @media print {
          body {
            font-size: var(--font-size-small);
          }

          .container {
            width: 100%;
            height: auto;
            margin: 0;
            padding: 0;
          }

          /* Force page break before element */
          .page-break-before {
            page-break-before: always;
          }

          /* Force page break after element */
          .page-break-after {
            page-break-after: always;
          }

          /* Avoid breaking inside element */
          .avoid-break {
            page-break-inside: avoid;
          }

          /* Allow breaks inside element */
          .allow-break {
            page-break-inside: auto;
          }

          /* Force backgrounds to print */
          * {
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
            color-adjust: exact !important;
          }

          @page {
            width: 210mm;
            height: 297mm;
            page-break-after: always;
            padding: 2mm;
            box-sizing: border-box;
            /* margin: 1in 1in 1.5in 1in; extra bottom margin for footer */

            @bottom-center {
              content: "Page " counter(page) " / " counter(pages);
              font-family: var(--font-family);
              line-height: 1.6;
              color: var(--text-color);
              font-size: var(--font-size-small);
              margin: 0;
              padding: 0;
              box-sizing: border-box;
            }
          }
        }
    </style>
</head>
)";

QString HtmlGenerator::wrapWithTemplate(const QString &title, const QString &toc, const QString &htmlBody)
{
    return QString(R"(<!DOCTYPE html>
<html>
%1
<body>
<br/><br/><br/><br/><br/><br/><br/><br/><br/>
<h2 style="font-size:24pt;">
%2
</h2>
<br/><br/><br/><br/><br/><br/><br/><br/><br/>
<p class="page-break-after">&nbsp;</p>
%3
<p class="page-break-after">&nbsp;</p>
%4
</body>
</html>)").arg(header, title, toc, htmlBody);
}

QString HtmlGenerator::wrapWithTemplate(const QString &htmlBody)
{
    return QString(R"(<!DOCTYPE html>
<html>
%1
<body>
%2
</body>
</html>)").arg(header, htmlBody);
}

QString HtmlGenerator::generateFullDocument(const QString &title, const QString &markdown)
{
    // Generate TOC
    QString toc = generateTOC(markdown);

    // Convert markdown to HTML
    QByteArray input = markdown.toUtf8();
    QByteArray output;

    md_html(input.constData(), input.size(), processOutput, &output,
            MD_FLAG_TABLES | MD_FLAG_STRIKETHROUGH | MD_FLAG_TASKLISTS, 0);

    QString htmlBody = QString::fromUtf8(output);

    // Post-process: Add IDs to headings so TOC links work
    htmlBody = addIdsToHeadings(htmlBody, markdown);

    // Wrap with template
    return wrapWithTemplate(title, toc, htmlBody);
}

QString HtmlGenerator::generatePreviewDocument(const QString &markdown)
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
    return wrapWithTemplate(htmlBody);
}

// Helper: Create URL-friendly slug from text
QString HtmlGenerator::createSlug(const QString &text)
{
    QString slug = text.toLower();
    slug = slug.replace(QRegularExpression("[^a-z0-9\\s-]"), "");  // Remove special chars
    slug = slug.replace(QRegularExpression("\\s+"), "-");          // Spaces to hyphens
    slug = slug.replace(QRegularExpression("-+"), "-");            // Remove duplicate hyphens
    slug = slug.trimmed();
    if (slug.startsWith('-')) slug = slug.mid(1);
    if (slug.endsWith('-')) slug.chop(1);
    return slug;
}

// Add IDs to headings in generated HTML
QString HtmlGenerator::addIdsToHeadings(const QString &html, const QString &markdown)
{
    QString result = html;

    // Extract heading texts from original markdown
    QRegularExpression markdownHeaderRegex("^(#{1,6})\\s+(.+)$",
                                           QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator mdIt = markdownHeaderRegex.globalMatch(markdown);

    QStringList headingTexts;
    while (mdIt.hasNext()) {
        QRegularExpressionMatch match = mdIt.next();
        headingTexts.append(match.captured(2).trimmed());
    }

    // Replace headings in HTML with ID versions
    QMap<QString, int> slugCounts;
    int headingIndex = 0;

    QRegularExpression htmlHeaderRegex("<h([1-6])>(.*?)</h\\1>");

    int pos = 0;
    while ((pos = result.indexOf(htmlHeaderRegex, pos)) != -1) {
        QRegularExpressionMatch match = htmlHeaderRegex.match(result, pos);

        if (headingIndex < headingTexts.size()) {
            QString level = match.captured(1);
            QString content = match.captured(2);

            // Create slug from original markdown heading
            QString slug = createSlug(headingTexts[headingIndex]);

            // Handle duplicate slugs
            if (slugCounts.contains(slug)) {
                slugCounts[slug]++;
                slug = slug + "-" + QString::number(slugCounts[slug]);
            } else {
                slugCounts[slug] = 0;
            }

            // Replace with ID version
            QString replacement = QString("<h%1 id=\"%2\">%3</h%1>")
                                      .arg(level, slug, content);

            result.replace(pos, match.capturedLength(), replacement);
            pos += replacement.length();
            headingIndex++;
        } else {
            pos += match.capturedLength();
        }
    }

    return result;
}

