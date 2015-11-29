include( CMakeParseArguments )

function( pte_executable )
    cmake_parse_arguments( PTE_EXE "CONSOLE;INSTALL" "NAME" "SOURCES;HEADERS;RESOURCES;DEPENDS" ${ARGN} )

    set( generated_files )
    if ( PTE_EXE_RESOURCES )
        qt5_add_resources( generated_files ${PTE_EXE_RESOURCES} )
    endif ()

    if ( PTE_EXE_CONSOLE )
        set( win32_flag )
    else ()
        set( win32_flag WIN32 )
    endif ()

    add_executable( ${PTE_EXE_NAME}
        ${win32_flag}
        ${PTE_EXE_SOURCES}
        ${PTE_EXE_HEADERS}
        ${generated_files}
    )

    target_link_libraries( ${PTE_EXE_NAME} ${PTE_EXE_DEPENDS} )

    # Set output directory for executables.
    set_target_properties( ${PTE_EXE_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${PTE_DEV_BIN_DIR}
        RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PTE_DEV_BIN_DIR}
        RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PTE_DEV_BIN_DIR}
    )
    
    # Set folder name for Visual Studio projects.
    set_target_properties( ${PTE_EXE_NAME} PROPERTIES
        FOLDER executables
    )

    # Add to the install step.
    if ( PLATFORM_WIN )
        set( install_dir . )
    else ()
        set( install_dir bin )
    endif ()

    if ( PTE_EXE_INSTALL )
        install(
            TARGETS ${PTE_EXE_NAME}
            DESTINATION ${install_dir}
        )
    endif ()

    # Copy dlls to the bin directory.
    if ( PLATFORM_WIN )
        pte_find_dlls( ${PTE_EXE_NAME} shared_libs )

        foreach( lib ${shared_libs} )
            add_custom_command(
                TARGET ${PTE_EXE_NAME}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different ${lib} ${PTE_DEV_BIN_DIR}
            )
        endforeach ()

        if ( PTE_EXE_INSTALL )
            install(
                FILES ${shared_libs}
                DESTINATION ${install_dir}
            )
        endif ()
    endif ()
endfunction ()

# Recursively find shared libraries that a target depends on.
function ( pte_find_dlls target output_list )
    if ( NOT TARGET ${target} )
        return ()
    endif ()

    get_target_property( child_targets ${target} INTERFACE_LINK_LIBRARIES )
    set( all_libs )
    if ( child_targets )
        foreach ( child_target ${child_targets} )
            pte_find_dlls( ${child_target} child_libs )
            list( APPEND all_libs ${child_libs} )
        endforeach ()
    endif ()

    get_target_property( target_type ${target} TYPE )
    if ( ${target_type} MATCHES SHARED_LIBRARY )
        list( APPEND all_libs "$<TARGET_FILE:${target}>" )
    endif ()

    if ( all_libs )
        list( REMOVE_DUPLICATES all_libs )
    endif ()
    set( ${output_list} ${all_libs} PARENT_SCOPE )
endfunction ()
