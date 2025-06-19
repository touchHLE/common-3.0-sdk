set(CUSTOM_LD ${CCTOOLS_BUILD_PREFIX}/bin/ld)
set(CUSTOM_LIPO ${CCTOOLS_BUILD_PREFIX}/bin/lipo)

function(
    build_universal_component
    OUTPUT_NAME
    COMPILER_FLAGS
    LINKER_FLAGS
    SOURCES
)
    set(multiValueArgs DEPENDS)
    cmake_parse_arguments(ARGS "" "" "${multiValueArgs}" ${ARGN})

    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/universal_build_tmp)
    set(TEMP_DIR ${CMAKE_BINARY_DIR}/universal_build_tmp)

    set(OUTPUT_V6_TEMP ${TEMP_DIR}/${OUTPUT_NAME}.armv6.temp.o)
    set(OUTPUT_V7_TEMP ${TEMP_DIR}/${OUTPUT_NAME}.armv7.temp.o)
    set(FINAL_OUTPUT_PATH ${CMAKE_BINARY_DIR}/${OUTPUT_NAME})

    set(COMPILED_OBJS_V6 "")
    set(COMPILED_OBJS_V7 "")

    foreach(SRC_FILE ${SOURCES})
        get_filename_component(BASE_NAME ${SRC_FILE} NAME_WE)
        set(OBJ_V6_PATH ${TEMP_DIR}/${OUTPUT_NAME}_${BASE_NAME}_armv6.o)
        set(OBJ_V7_PATH ${TEMP_DIR}/${OUTPUT_NAME}_${BASE_NAME}_armv7.o)

        add_custom_command(
            OUTPUT ${OBJ_V6_PATH}
            COMMAND
                ${CMAKE_C_COMPILER} -c -arch armv6 ${COMPILER_FLAGS} ${SRC_FILE}
                -o ${OBJ_V6_PATH}
            DEPENDS ${ARGS_DEPENDS} ${SRC_FILE}
            COMMENT "Compiling ${BASE_NAME} for ${OUTPUT_NAME} (armv6)"
        )
        list(APPEND COMPILED_OBJS_V6 ${OBJ_V6_PATH})

        add_custom_command(
            OUTPUT ${OBJ_V7_PATH}
            COMMAND
                ${CMAKE_C_COMPILER} -c -arch armv7 ${COMPILER_FLAGS} ${SRC_FILE}
                -o ${OBJ_V7_PATH}
            DEPENDS ${ARGS_DEPENDS} ${SRC_FILE}
            COMMENT "Compiling ${BASE_NAME} for ${OUTPUT_NAME} (armv7)"
        )
        list(APPEND COMPILED_OBJS_V7 ${OBJ_V7_PATH})
    endforeach()

    add_custom_command(
        OUTPUT ${OUTPUT_V6_TEMP}
        COMMAND
            ${CUSTOM_LD} -r -arch armv6 ${LINKER_FLAGS} ${COMPILED_OBJS_V6} -o
            ${OUTPUT_V6_TEMP}
        DEPENDS ${COMPILED_OBJS_V6}
        COMMENT "Linking ${OUTPUT_NAME} for armv6 with custom ld"
    )

    add_custom_command(
        OUTPUT ${OUTPUT_V7_TEMP}
        COMMAND
            ${CUSTOM_LD} -r -arch armv7 ${LINKER_FLAGS} ${COMPILED_OBJS_V7} -o
            ${OUTPUT_V7_TEMP}
        DEPENDS ${COMPILED_OBJS_V7}
        COMMENT "Linking ${OUTPUT_NAME} for armv7 with custom ld"
    )

    add_custom_command(
        OUTPUT ${FINAL_OUTPUT_PATH}
        COMMAND
            ${CUSTOM_LIPO} -create ${OUTPUT_V6_TEMP} ${OUTPUT_V7_TEMP} -output
            ${FINAL_OUTPUT_PATH}
        DEPENDS ${OUTPUT_V6_TEMP} ${OUTPUT_V7_TEMP}
        COMMENT "Creating universal ${OUTPUT_NAME} with lipo"
    )
endfunction()
