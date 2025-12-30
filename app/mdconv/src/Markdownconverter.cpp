#include "Markdownconverter.h"
#include "md4c-html.h"
#include <QByteArray>

MarkdownConverter::MarkdownConverter(QObject *parent)
    : QObject(parent)
{
}

static void processOutput(const MD_CHAR* text, MD_SIZE size, void* userdata)
{
    QByteArray* output = static_cast<QByteArray*>(userdata);
    output->append(text, size);
}

QString MarkdownConverter::toHtml(const QString &markdown)
{
    QByteArray input = markdown.toUtf8();
    QByteArray output;

    md_html(input.constData(), input.size(), processOutput, &output,
            MD_FLAG_TABLES | MD_FLAG_STRIKETHROUGH | MD_FLAG_TASKLISTS, 0);

    return QString::fromUtf8(output);
}
