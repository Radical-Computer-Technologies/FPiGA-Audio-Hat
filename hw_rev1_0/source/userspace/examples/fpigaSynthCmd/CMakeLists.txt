cmake_minimum_required(VERSION 3.16)

project(fpigaSynthCmd LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(fpigaSynthCmd main.cpp
    )

include(GNUInstallDirs)

target_link_libraries(fpigaSynthCmd PRIVATE FPiGA_AudioLib rtmidi)

target_include_directories(fpigaSynthCmd PUBLIC
    include
    /usr/local/lib/FPiGA/include/
    /usr/include/rtmidi/
)

install(TARGETS fpigaSynthCmd
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
