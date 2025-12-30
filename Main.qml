import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import C2B

ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 800
    minimumWidth: 800
    minimumHeight: 600
    title: "C2B Markdown Editor"

    // Theme
    color: Theme.backgroundColor

    property string currentFilePath: ""

    // Open File Dialog
    FileDialog {
        id: openDialog
        title: "Open Markdown File"
        nameFilters: ["Markdown files (*.md *.markdown)", "All files (*)"]
        fileMode: FileDialog.OpenFile
        onAccepted: {
            var filePath = selectedFile.toString().replace("file://", "")
            var content = DocumentManager.loadDocument(filePath)
            editor.text = content
            root.currentFilePath = filePath
            preview.baseUrl = DocumentManager.getBaseUrl(filePath)
        }
    }

    // Save File Dialog
    FileDialog {
        id: saveDialog
        title: "Save Document"
        nameFilters: ["Markdown files (*.md)"]
        fileMode: FileDialog.SaveFile
        onAccepted: {
            var filePath = selectedFile.toString().replace("file://", "")
            root.currentFilePath = filePath

            // Generate and save
            var fullHtml = HtmlGenerator.generateFullDocument(editor.text)
            DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
            preview.baseUrl = DocumentManager.getBaseUrl(root.currentFilePath)
        }
    }

    // Menu Bar
    menuBar: MenuBar {
        background: Rectangle {
            color: Theme.menuBarColor
        }

        Menu {
            title: "File"
            MenuItem {
                text: "New"
                onTriggered: editor.clear()
            }
            MenuItem {
                text: "Open..."
                onTriggered: openDialog.open()
            }
            MenuItem {
                text: "Save"
                onTriggered: {
                    if (root.currentFilePath) {
                        var fullHtml = HtmlGenerator.generateFullDocument(editor.text)
                        DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
                    } else {
                        saveDialog.open()
                    }
                }
            }
            MenuItem {
                text: "Save As..."
                onTriggered: saveDialog.open()
            }
            MenuSeparator {}
            MenuItem {
                text: "Exit"
                onTriggered: Qt.quit()
            }
        }
    }

    // Main Content
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Split View - Editor and Preview
        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            // Markdown Editor
            EditorPanel {
                id: editor
                SplitView.fillHeight: true
                SplitView.preferredWidth: parent.width * 0.5
                SplitView.minimumWidth: 300

                onTextChanged: {
                    // Update preview when text changes
                    preview.updatePreview(editor.text)
                }
            }

            // HTML Preview
            PreviewPanel {
                id: preview
                SplitView.fillHeight: true
                SplitView.fillWidth: true
                SplitView.minimumWidth: 300
            }
        }

        // Bottom Toolbar
        BottomToolbar {
            Layout.fillWidth: true
            Layout.preferredHeight: 48

            onNewChapterClicked: {
                editor.insertText("\n\n# New Chapter\n\n")
            }

            onNewSubChapterClicked: {
                editor.insertText("\n\n## New Section\n\n")
            }

            onNewSubSubClicked: {
                editor.insertText("\n\n### New Sub Section\n\n")
            }

            onSaveClicked: {

            }

            onTopClicked: {

            }


        }
    }
}
