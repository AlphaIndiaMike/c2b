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
    property string documentTitle: "New Document"
    property bool hasUnsavedChanges: false

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
            root.documentTitle = DocumentManager.getFileName(filePath)
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
            root.documentTitle = DocumentManager.getFileName(filePath)

            // Generate and save
            var fullHtml = HtmlGenerator.generateFullDocument(root.documentTitle, editor.text)
            DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
            preview.baseUrl = DocumentManager.getBaseUrl(root.currentFilePath)
            root.hasUnsavedChanges = false;
        }
    }

    // Save Request upon Closing Dialog
    Dialog {
        id: confirmCloseDialog
        title: "Unsaved Changes"
        modal: true
        anchors.centerIn: parent

        standardButtons: Dialog.NoButton

        Label {
            text: "You have unsaved changes. Do you want to save before closing?"
            padding: 20
        }

        footer: DialogButtonBox {
            Button {
                text: "Save"
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
                onClicked: {
                    if (root.currentFilePath) {
                        var fullHtml = HtmlGenerator.generateFullDocument(root.documentTitle, editor.text)
                        DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
                        root.hasUnsavedChanges = false
                        Qt.quit()
                    } else {
                        saveDialog.open()
                        root.hasUnsavedChanges = false
                    }
                }
            }
            Button {
                text: "Don't Save"
                DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
                onClicked: {
                    root.hasUnsavedChanges = false
                    confirmCloseDialog.close()
                    Qt.quit()
                }
            }
            Button {
                text: "Cancel"
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
                onClicked: confirmCloseDialog.close()
            }
        }
    }

    // Save Request before new document
    Dialog {
        id: confirmOpenDialog
        title: "Unsaved Changes"
        modal: true
        anchors.centerIn: parent

        contentItem: Label {
            text: "You have unsaved changes. Do you want to save before creating a new document?"
            padding: 20
        }

        footer: DialogButtonBox {

            Button {
                text: "Cancel"
                onClicked: confirmOpenDialog.close()
            }

            Button {
                text: "Don't Save"
                onClicked: {
                    confirmOpenDialog.close()
                    root.hasUnsavedChanges = false
                    editor.clear()
                    root.currentFilePath = ""
                }
            }

            Button {
                text: "Save"
                highlighted: true
                onClicked: {
                    confirmOpenDialog.close()
                    if (root.currentFilePath) {
                        var fullHtml = HtmlGenerator.generateFullDocument(root.documentTitle, editor.text)
                        DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
                        root.hasUnsavedChanges = false
                        editor.clear()
                        root.currentFilePath = ""
                    } else {
                        // If no file path, show save dialog, then clear after saving
                        saveDialog.acceptedAfterAction = "newDocument"
                        saveDialog.open()
                    }
                }
            }
        }
    }

    // Confirm Open File Dialog
    Dialog {
        id: confirmOpenFileDialog
        title: "Unsaved Changes"
        modal: true
        anchors.centerIn: parent

        contentItem: Label {
            text: "You have unsaved changes. Do you want to save before opening another file?"
            padding: 20
        }

        footer: DialogButtonBox {

            Button {
                text: "Cancel"
                onClicked: confirmOpenFileDialog.close()
            }

            Button {
                text: "Don't Save"
                onClicked: {
                    confirmOpenFileDialog.close()
                    root.hasUnsavedChanges = false
                    openDialog.open()
                }
            }

            Button {
                text: "Save"
                highlighted: true
                onClicked: {
                    confirmOpenFileDialog.close()
                    if (root.currentFilePath) {
                        var fullHtml = HtmlGenerator.generateFullDocument(root.documentTitle, editor.text)
                        DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
                        root.hasUnsavedChanges = false
                        openDialog.open()
                    } else {
                        saveDialog.open()
                        // Need to open file picker after save dialog closes
                    }
                }
            }
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
                onTriggered: {
                    if (root.hasUnsavedChanges) {
                        confirmOpenDialog.open()
                    }
                    else
                    {
                        editor.clear()
                        root.currentFilePath = ""
                        root.lastSavedContent = ""
                        root.hasUnsavedChanges = false
                    }
                }
            }
            MenuItem {
                text: "Open..."
                onTriggered: {
                    if (root.hasUnsavedChanges) {
                        confirmOpenFileDialog.open()
                    }
                    else{
                        openDialog.open()
                    }
                }
            }
            MenuItem {
                text: "Save"
                onTriggered: {
                    if (root.currentFilePath) {
                        var fullHtml = HtmlGenerator.generateFullDocument(root.documentTitle, editor.text)
                        DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
                        root.hasUnsavedChanges = false;
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
                onTriggered: {
                    if (root.hasUnsavedChanges) {
                        confirmCloseDialog.open()
                    }
                    else
                    {
                        Qt.quit()
                    }
                }
            }
        }
    }

    // General events
    onClosing: function(close) {
        if (root.hasUnsavedChanges) {
            close.accepted = false
            confirmCloseDialog.open()
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
                    root.hasUnsavedChanges = true;
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
                root.hasUnsavedChanges = true;
            }

            onNewSubChapterClicked: {
                editor.insertText("\n\n## New Section\n\n")
                root.hasUnsavedChanges = true;
            }

            onNewSubSubClicked: {
                editor.insertText("\n\n### New Sub Section\n\n")
                root.hasUnsavedChanges = true;
            }

            onSaveClicked: {
                if (root.currentFilePath) {
                    var fullHtml = HtmlGenerator.generateFullDocument(root.documentTitle, editor.text)
                    DocumentManager.saveDocumentWithHtml(editor.text, fullHtml, root.currentFilePath)
                    root.hasUnsavedChanges = false;
                } else {
                    saveDialog.open()
                }
            }

            onTopClicked: {
                 preview.scrollToTop()
            }


        }
    }
}
