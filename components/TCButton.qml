import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: tcButton
    property string shortcutKey: ""

    // Size based on content + padding
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    // Set padding
    padding: 12
    leftPadding: 16
    rightPadding: 16
    topPadding: 2
    bottomPadding: 6

    contentItem: ColumnLayout {
        spacing: 2

        Label {
            text: tcButton.text
            font.pixelSize: Theme.fontSizeSmall
            color: tcButton.enabled ? Theme.textColor : Theme.textColorDisabled
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        Label {
            text: tcButton.shortcutKey
            font.pixelSize: Theme.fontSizeSmall
            color: tcButton.enabled ? Theme.textColorSecondary : Theme.textColorDisabled
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }
    }

    background: Rectangle {
        color: {
            if (!tcButton.enabled) return Theme.buttonBackground
            if (tcButton.pressed) return Theme.buttonBackgroundPressed
            if (tcButton.hovered) return Theme.buttonBackgroundHover
            return Theme.buttonBackground
        }
        border.color: Theme.borderColor
        border.width: 1
        radius: Theme.radiusSmall

        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }
}
