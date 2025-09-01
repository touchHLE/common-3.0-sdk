cmake_minimum_required(VERSION 3.20)
project(csu LANGUAGES C ASM)

set(ARCH_FLAGS -arch armv6 -arch armv7)
set(OFLAG -Os)

set(BASE_C_FLAGS
    ${OFLAG}
    --target=arm-apple-ios
    -B${SDK_PATH}/usr/bin
    -I${SDK_PATH}/usr/include
    -mlinker-version=253 
    -mfpu=vfpv2
    -Wall
    -Wno-expansion-to-defined
)

set(OS_MIN_V1 -miphoneos-version-min=2.0)
set(OS_MIN_V2 -miphoneos-version-min=2.0)
set(OS_MIN_V3 -miphoneos-version-min=2.0)
set(OS_MIN_V4 -miphoneos-version-min=3.1)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/crt1.v2.o
    COMMAND
        ${CMAKE_C_COMPILER} -r ${ARCH_FLAGS} ${BASE_C_FLAGS} ${OS_MIN_V3}
        -nostdlib -keep_private_externs csu/start.s csu/crt.c csu/dyld_glue.s -o
        ${CMAKE_BINARY_DIR}/crt1.v2.o -DCRT
    DEPENDS csu/start.s csu/crt.c csu/dyld_glue.s
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building crt1.v2.o"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/crt1.v4.o
    COMMAND
        ${CMAKE_C_COMPILER} -r ${ARCH_FLAGS} ${BASE_C_FLAGS} ${OS_MIN_V4}
        -nostdlib -keep_private_externs csu/start.s csu/crt.c -o
        ${CMAKE_BINARY_DIR}/crt1.v4.o -DADD_PROGRAM_VARS
    DEPENDS csu/start.s csu/crt.c
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building crt1.v4.o"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/gcrt1.o
    COMMAND
        ${CMAKE_C_COMPILER} -r ${ARCH_FLAGS} ${BASE_C_FLAGS} ${OS_MIN_V1}
        -nostdlib -keep_private_externs csu/start.s csu/crt.c csu/dyld_glue.s -o
        ${CMAKE_BINARY_DIR}/gcrt1.o -DGCRT -DOLD_LIBSYSTEM_SUPPORT
    DEPENDS csu/start.s csu/crt.c csu/dyld_glue.s
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building gcrt1.o"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/dylib1.v2.o
    COMMAND
        ${CMAKE_C_COMPILER} -r ${ARCH_FLAGS} ${BASE_C_FLAGS} ${OS_MIN_V2}
        -nostdlib -keep_private_externs csu/dyld_glue.s -o
        ${CMAKE_BINARY_DIR}/dylib1.v2.o -DCFM_GLUE
    DEPENDS csu/dyld_glue.s
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building dylib1.v2.o"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/bundle1.v1.o
    COMMAND
        ${CMAKE_C_COMPILER} -r ${ARCH_FLAGS} ${BASE_C_FLAGS} ${OS_MIN_V1}
        -nostdlib -keep_private_externs csu/dyld_glue.s -o
        ${CMAKE_BINARY_DIR}/bundle1.v1.o
    DEPENDS csu/dyld_glue.s
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building bundle1.v1.o"
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/lazydylib1.o
    COMMAND
        ${CMAKE_C_COMPILER} -r ${ARCH_FLAGS} ${BASE_C_FLAGS} ${OS_MIN_V3}
        -nostdlib -keep_private_externs csu/lazy_dylib_helper.s
        csu/lazy_dylib_loader.c -o ${CMAKE_BINARY_DIR}/lazydylib1.o
    DEPENDS csu/lazy_dylib_helper.s csu/lazy_dylib_loader.c
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Building lazydylib1.o"
)

add_custom_target(
    csu
    ALL
    DEPENDS
        ${CMAKE_BINARY_DIR}/crt1.v2.o
        ${CMAKE_BINARY_DIR}/crt1.v4.o
        ${CMAKE_BINARY_DIR}/gcrt1.o
        ${CMAKE_BINARY_DIR}/dylib1.v2.o
        ${CMAKE_BINARY_DIR}/bundle1.v1.o
        ${CMAKE_BINARY_DIR}/lazydylib1.o
)

install(FILES ${CMAKE_BINARY_DIR}/crt1.v2.o DESTINATION lib RENAME crt1.o)

install(
    FILES ${CMAKE_BINARY_DIR}/crt1.v4.o
    DESTINATION lib
    RENAME crt1.3.1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/dylib1.v2.o
    DESTINATION lib
    RENAME dylib1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/bundle1.v1.o
    DESTINATION lib
    RENAME bundle1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/lazydylib1.o
    DESTINATION lib
    RENAME lazydylib1.o
)

install(FILES ${CMAKE_BINARY_DIR}/gcrt1.o DESTINATION lib RENAME gcrt1.o)
