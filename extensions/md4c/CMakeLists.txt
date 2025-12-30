cmake_minimum_required(VERSION 3.16)

project(md4c VERSION 0.5.2 LANGUAGES C)

add_library(md4c STATIC
    git/src/md4c.c
    git/src/md4c.h
    git/src/md4c-html.c
    git/src/md4c-html.h
    git/src/entity.c
    git/src/entity.h
)

target_include_directories(md4c PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/git/src>
    $<INSTALL_INTERFACE:include>
)

set_target_properties(md4c PROPERTIES
    C_STANDARD 99
    C_STANDARD_REQUIRED ON
    POSITION_INDEPENDENT_CODE ON
)
