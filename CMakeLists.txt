cmake_minimum_required(VERSION 3.16)

project(C2B VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 COMPONENTS WebEngineQuick)

add_subdirectory(extensions/md4c)

set_source_files_properties(theme/Theme.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_executable(appC2B
    app/mdconv/inc/Markdownconverter.h
    app/mdconv/src/Markdownconverter.cpp
    main.cpp
)

target_include_directories(appC2B PRIVATE
    app/mdconv/inc
    app/htmlman/inc
    app/docman/inc
)

qt_add_qml_module(appC2B
    URI C2B
    VERSION 1.0
    QML_FILES
        Main.qml
        theme/Theme.qml
        components/EditorPanel.qml
        components/PreviewPanel.qml
        components/BottomToolbar.qml
        components/TCButton.qml
        RESOURCES
    SOURCES
        app/mdconv/inc/Markdownconverter.h
        app/mdconv/src/Markdownconverter.cpp
        app/docman/inc/DocumentManager.h
        app/docman/src/DocumentManager.cpp
        app/htmlman/inc/DocHTML.h
        app/htmlman/src/DocHTML.cpp
        RESOURCES gitignore
        RESOURCES readme.md
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appC2B PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.alphaindiamike.appC2B
    MACOSX_BUNDLE_BUNDLE_NAME "C2B Markdown Editor"
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appC2B
    PRIVATE
        Qt6::Core
        Qt6::Quick
        md4c
)

include(GNUInstallDirs)
install(TARGETS appC2B
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET appC2B
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)

install(SCRIPT ${deploy_script})
