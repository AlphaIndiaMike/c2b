import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine
import C2B

Rectangle {
    id: previewPanel
    color: Theme.surfaceColor

    property string baseUrl: ""
    
    function updatePreview(markdownText) {
        var fullHtml = HtmlGenerator.generatePreviewDocument(markdownText)
        webView.loadHtml(fullHtml, "file:///")
    }

    function scrollToTop() {
        webView.runJavaScript("window.scrollTo({ top: 0, behavior: 'smooth' });")
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
                        "; padding: 4px;'><p>Start typing to see preview...</p></body></html>")
            }
        }
    }
}
