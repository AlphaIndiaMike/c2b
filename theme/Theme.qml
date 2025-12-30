pragma Singleton
import QtQuick

QtObject {
    // Color Palette
    readonly property color backgroundColor: "#1e1e1e"
    readonly property color surfaceColor: "#252526"
    readonly property color surfaceColorLight: "#2d2d30"
    readonly property color borderColor: "#3e3e42"
    readonly property color menuBarColor: "#2d2d30"
    
    readonly property color primaryColor: "#007acc"
    readonly property color primaryColorHover: "#1a8cd8"
    readonly property color primaryColorPressed: "#005a9e"
    
    readonly property color textColor: "#cccccc"
    readonly property color textColorSecondary: "#969696"
    readonly property color textColorDisabled: "#656565"
    
    readonly property color successColor: "#4ec9b0"
    readonly property color warningColor: "#dcdcaa"
    readonly property color errorColor: "#f48771"
    
    readonly property color buttonBackground: "#3e3e42"
    readonly property color buttonBackgroundHover: "#505050"
    readonly property color buttonBackgroundPressed: "#2a2a2a"
    
    readonly property color editorBackground: "#1e1e1e"
    readonly property color editorLineNumberBg: "#252526"
    readonly property color previewBackground: "#1e1e1e"
    
    // Typography
    readonly property string fontFamily: "Arial"
    readonly property string monospaceFontFamily: "Courier New"
    
    readonly property int fontSizeSmall: 11
    readonly property int fontSizeNormal: 13
    readonly property int fontSizeMedium: 14
    readonly property int fontSizeLarge: 16
    readonly property int fontSizeXLarge: 20
    
    // Spacing
    readonly property int spacingXSmall: 4
    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 12
    readonly property int spacingLarge: 16
    readonly property int spacingXLarge: 24
    
    // Border Radius
    readonly property int radiusSmall: 2
    readonly property int radiusMedium: 4
    readonly property int radiusLarge: 6
    
    // Dimensions
    readonly property int toolbarHeight: 48
    readonly property int menuItemHeight: 32
    readonly property int buttonMinWidth: 80
    readonly property int buttonHeight: 32
    readonly property int iconSize: 16
    readonly property int iconSizeMedium: 20
    readonly property int iconSizeLarge: 24
}
