cmake_minimum_required(VERSION 3.16)

project(FPiGA_AudioLib LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(FPiGA_AudioLib SHARED
    src/rct_fpiga.cpp
    include/rct_fpiga.h
    src/fpiga_audio.h
    src/fpiga_audio.cpp


)

target_include_directories(FPiGA_AudioLib PUBLIC
    include
)


