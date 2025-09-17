set(CCTOOLS_SOURCE_DIR "${SOURCES}/cctools-port")
set(CCTOOLS_BUILD_DIR "${CMAKE_BINARY_DIR}/cctools-build")
set(CCTOOLS_BUILD_PREFIX "${CMAKE_BINARY_DIR}/cctools")

include(ExternalProject)

# Need to smuggle semicolons through see:
# https://discourse.cmake.org/t/how-to-pass-cmake-osx-architectures-to-externalproject-add/2262/2
string(
    REPLACE
    ";"
    "$<SEMICOLON>"
    CMAKE_OSX_ARCHITECTURES_
    "${CMAKE_OSX_ARCHITECTURES}"
)

if(APPLE)
    # Need to use Apple clang in order to build universal cctools
    set(CCTOOLS_C_COMPILER /usr/bin/clang)
    set(CCTOOLS_CXX_COMPILER /usr/bin/clang++)
else()
    set(CCTOOLS_C_COMPILER ${CMAKE_C_COMPILER})
    set(CCTOOLS_CXX_COMPILER ${CMAKE_CXX_COMPILER})
endif()

ExternalProject_Add(
    cctools_port
    SOURCE_DIR ${CCTOOLS_SOURCE_DIR}
    BINARY_DIR ${CCTOOLS_BUILD_DIR}
    INSTALL_DIR ${CCTOOLS_BUILD_PREFIX}
    CMAKE_ARGS
        -DCMAKE_C_COMPILER=${CCTOOLS_C_COMPILER}
        -DCMAKE_CXX_COMPILER=${CCTOOLS_CXX_COMPILER}
        -DCMAKE_INSTALL_PREFIX=${CCTOOLS_BUILD_PREFIX}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES_}
)

install(
    DIRECTORY ${CMAKE_BINARY_DIR}/cctools/bin/
    DESTINATION usr/bin
    USE_SOURCE_PERMISSIONS
)
