import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: editorPanel
    color: Theme.surfaceColor
    
    property alias text: textArea.text
    
    function clear() {
        textArea.clear()
    }
    
    function insertText(newText) {
        textArea.insert(textArea.cursorPosition, newText)
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
                    text: "Markdown Editor"
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    color: Theme.textColor
                    Layout.fillWidth: true
                }
                
                Label {
                    text: textArea.length + " chars | Line " + (textArea.lineCount)
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textColorSecondary
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.borderColor
        }
        
        // Editor Area
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            background: Rectangle {
                color: Theme.editorBackground
            }
            
            TextArea {
                id: textArea
                font.family: Theme.monospaceFontFamily
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.textColor
                selectionColor: Theme.primaryColor
                selectedTextColor: Theme.textColor
                wrapMode: TextArea.Wrap
                selectByMouse: true
                
                background: Rectangle {
                    color: Theme.editorBackground
                }
                
                placeholderText: "Enter your Markdown text here..."
                placeholderTextColor: Theme.textColorDisabled
                
                onTextChanged: editorPanel.textChanged()
                
                // Line numbers (simplified - real implementation would need more work)
                property int lineCount: text.split('\n').length
            }
        }
    }
}
