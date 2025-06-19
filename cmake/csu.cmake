include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake)

set(OFLAG -Os)
set(CMAKE_C_COMPILER clang)
set(BASE_C_FLAGS
    ${OFLAG}
    -Wall
    --target=arm-apple-ios
    -I${CMAKE_BINARY_DIR}/include
    -Wno-expansion-to-defined
)

set(OS_MIN_V1 -miphoneos-version-min=2.0)
set(OS_MIN_V2 -miphoneos-version-min=2.0)
set(OS_MIN_V3 -miphoneos-version-min=2.0)
set(OS_MIN_V4 -miphoneos-version-min=3.1)

build_universal_component(crt1.v1.o
    "${BASE_C_FLAGS};-mdynamic-no-pic;-nostdlib;-DCRT;-DOLD_LIBSYSTEM_SUPPORT;${OS_MIN_V1}"
    "-keep_private_externs"
    "${CSU_SOURCE}/start.s;${CSU_SOURCE}/crt.c;${CSU_SOURCE}/dyld_glue.s"
    DEPENDS setup_headers cctools_port
)

build_universal_component(crt1.v2.o
    "${BASE_C_FLAGS};-nostdlib;-DCRT;${OS_MIN_V3}"
    "-keep_private_externs"
    "${CSU_SOURCE}/start.s;${CSU_SOURCE}/crt.c;${CSU_SOURCE}/dyld_glue.s"
    DEPENDS setup_headers cctools_port
)

build_universal_component(crt1.v3.o
    "${BASE_C_FLAGS};-nostdlib;-DADD_PROGRAM_VARS;${OS_MIN_V2}"
    "-keep_private_externs"
    "${CSU_SOURCE}/start.s;${CSU_SOURCE}/crt.c"
    DEPENDS setup_headers cctools_port
)

build_universal_component(crt1.v4.o
    "${BASE_C_FLAGS};-nostdlib;-DADD_PROGRAM_VARS;${OS_MIN_V4}"
    "-keep_private_externs"
    "${CSU_SOURCE}/start.s;${CSU_SOURCE}/crt.c"
    DEPENDS setup_headers cctools_port
)

build_universal_component(gcrt1.o
    "${BASE_C_FLAGS};-nostdlib;-DGCRT;-DOLD_LIBSYSTEM_SUPPORT;${OS_MIN_V1}"
    "-keep_private_externs"
    "${CSU_SOURCE}/start.s;${CSU_SOURCE}/crt.c;${CSU_SOURCE}/dyld_glue.s"
    DEPENDS setup_headers cctools_port
)

build_universal_component(crt0.o
    "${BASE_C_FLAGS};-static;-nostdlib"
    "-keep_private_externs;-new_linker"
    "${CSU_SOURCE}/start.s;${CSU_SOURCE}/crt.c"
    DEPENDS setup_headers cctools_port
)

build_universal_component(dylib1.v1.o
    "${BASE_C_FLAGS};-nostdlib;-DCFM_GLUE;${OS_MIN_V1}"
    "-keep_private_externs"
    "${CSU_SOURCE}/dyld_glue.s;${CSU_SOURCE}/icplusplus.c"
    DEPENDS setup_headers cctools_port
)

build_universal_component(dylib1.v2.o
    "${BASE_C_FLAGS};-nostdlib;-DCFM_GLUE;${OS_MIN_V2}"
    "-keep_private_externs"
    "${CSU_SOURCE}/dyld_glue.s"
    DEPENDS setup_headers cctools_port
)

build_universal_component(bundle1.v1.o
    "${BASE_C_FLAGS};-nostdlib;${OS_MIN_V1}"
    "-keep_private_externs"
    "${CSU_SOURCE}/dyld_glue.s"
    DEPENDS setup_headers cctools_port
)

build_universal_component(lazydylib1.o
    "${BASE_C_FLAGS};-nostdlib;${OS_MIN_V3}"
    "-keep_private_externs"
    "${CSU_SOURCE}/lazy_dylib_helper.s;${CSU_SOURCE}/lazy_dylib_loader.c"
    DEPENDS setup_headers cctools_port
)

add_custom_target(
    csu
    ALL
    DEPENDS
        ${CMAKE_BINARY_DIR}/crt1.v1.o
        ${CMAKE_BINARY_DIR}/crt1.v2.o
        ${CMAKE_BINARY_DIR}/crt1.v3.o
        ${CMAKE_BINARY_DIR}/crt1.v4.o
        ${CMAKE_BINARY_DIR}/gcrt1.o
        ${CMAKE_BINARY_DIR}/crt0.o
        ${CMAKE_BINARY_DIR}/dylib1.v1.o
        ${CMAKE_BINARY_DIR}/dylib1.v2.o
        ${CMAKE_BINARY_DIR}/bundle1.v1.o
        ${CMAKE_BINARY_DIR}/lazydylib1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/crt1.v2.o
    DESTINATION ${SDK_PATH}/usr/lib
    RENAME crt1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/crt1.v4.o
    DESTINATION ${SDK_PATH}/usr/lib
    RENAME crt1.3.1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/dylib1.v2.o
    DESTINATION ${SDK_PATH}/usr/lib
    RENAME dylib1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/bundle1.v1.o
    DESTINATION ${SDK_PATH}/usr/lib
    RENAME bundle1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/lazydylib1.o
    DESTINATION ${SDK_PATH}/usr/lib
    RENAME lazydylib1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/gcrt1.o
    DESTINATION ${SDK_PATH}/usr/lib
    RENAME gcrt1.o
)

install(
    FILES ${CMAKE_BINARY_DIR}/crt0.o
    DESTINATION ${SDK_PATH}/usr/local/lib
    RENAME crt0.o
)
