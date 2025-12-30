import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine
import "../theme"

Rectangle {
    id: previewPanel
    color: Theme.surfaceColor
    
    function updatePreview(markdownText) {
        var fullHtml = HtmlGenerator.generateFullDocument(markdownText)
        webView.loadHtml(fullHtml, "file:///")
    }
    
    function convertMarkdownToHtml(markdown) {
        // md4c converter
        var htmlBody = MarkdownConverter.toHtml(markdown)
        var html = `
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: ${Theme.fontFamily};
            font-size: ${Theme.fontSizeMedium}px;
            line-height: 1.6;
            color: ${Theme.textColor};
            background-color: ${Theme.previewBackground};
            padding: 20px;
            margin: 0;
        }
        h1, h2, h3, h4, h5, h6 {
            color: ${Theme.primaryColor};
            margin-top: 24px;
            margin-bottom: 16px;
            font-weight: 600;
        }
        h1 { font-size: 2em; border-bottom: 1px solid ${Theme.borderColor}; padding-bottom: 0.3em; }
        h2 { font-size: 1.5em; border-bottom: 1px solid ${Theme.borderColor}; padding-bottom: 0.3em; }
        h3 { font-size: 1.25em; }
        p { margin-bottom: 16px; }
        code {
            background-color: ${Theme.surfaceColorLight};
            padding: 2px 6px;
            border-radius: 3px;
            font-family: ${Theme.monospaceFontFamily};
            font-size: 0.9em;
        }
        pre {
            background-color: ${Theme.surfaceColorLight};
            padding: 16px;
            border-radius: 6px;
            overflow-x: auto;
        }
        pre code {
            background-color: transparent;
            padding: 0;
        }
        blockquote {
            border-left: 4px solid ${Theme.primaryColor};
            padding-left: 16px;
            margin-left: 0;
            color: ${Theme.textColorSecondary};
        }
        ul, ol {
            padding-left: 2em;
        }
        a {
            color: ${Theme.primaryColor};
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        img {
            max-width: 100%;
            height: auto;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 16px 0;
        }
        th, td {
            border: 1px solid ${Theme.borderColor};
            padding: 8px 12px;
            text-align: left;
        }
        th {
            background-color: ${Theme.surfaceColorLight};
            font-weight: 600;
        }
    </style>
</head>
<body>
${htmlBody}
</body>
</html>
        `
        return html
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: Theme.surfaceColorLight
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingMedium
                anchors.rightMargin: Theme.spacingMedium
                spacing: Theme.spacingMedium
                
                Label {
                    text: "Preview"
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    color: Theme.textColor
                    Layout.fillWidth: true
                }
                
                // Zoom controls could go here
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.borderColor
        }
        
        // Preview Area
        WebEngineView {
            id: webView
            Layout.fillWidth: true
            Layout.fillHeight: true
            backgroundColor: Theme.previewBackground
            
            Component.onCompleted: {
                loadHtml("<html><body style='font-family: " + Theme.fontFamily + 
                        "; color: " + Theme.textColor + 
                        "; background-color: " + Theme.previewBackground + 
                        "; padding: 20px;'><p>Start typing to see preview...</p></body></html>")
            }
        }
    }
}
