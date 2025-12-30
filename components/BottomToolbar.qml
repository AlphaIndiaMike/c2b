import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: toolbar
    color: Theme.surfaceColorLight
    
    signal newChapterClicked()
    signal newSubChapterClicked()
    signal newSubSubClicked()
    signal saveClicked()
    signal topClicked()
    
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: Theme.borderColor
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingSmall
        spacing: Theme.spacingSmall
        
        // Total Commander style buttons
        TCButton {
            text: "New Chapter"
            shortcutKey: "F2"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: toolbar.newChapterClicked()
        }
        
        TCButton {
            text: "New Section"
            shortcutKey: "F3"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: toolbar.newSubChapterClicked()
        }
        
        TCButton {
            text: "New Sub-Section"
            shortcutKey: "F4"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: toolbar.newSubSubClicked()
        }

        TCButton {
            text: "Save"
            shortcutKey: "F5"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: toolbar.saveClicked()
        }

        TCButton {
            text: "Top"
            shortcutKey: "F6"
            Layout.fillWidth: true
            Layout.fillHeight: true
            onClicked: toolbar.topClicked()
        }
        
        // Spacer to push buttons to the left (Total Commander style)
        Item {
            Layout.fillWidth: true
        }
    }
}
