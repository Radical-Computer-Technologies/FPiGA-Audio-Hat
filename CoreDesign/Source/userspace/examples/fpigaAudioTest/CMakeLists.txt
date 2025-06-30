cmake_minimum_required(VERSION 3.16)

project(fpigaTest LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(fpigaTest main.cpp
    )

include(GNUInstallDirs)

target_link_libraries(fpigaTest FPiGA_AudioLib)

target_include_directories(fpigaTest PUBLIC
    include
    /usr/local/lib/FPiGA/include/
)

install(TARGETS fpigaTest
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
