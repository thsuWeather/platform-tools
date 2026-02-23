#
# Copyright © 2022 Github Lzhiyong
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# ========================= aapt2 proto ============================
set(AAPT2_PROTO_SRC)  # proto source files
set(AAPT2_PROTO_HDRS) # proto head files
set(AAPT2_PROTO_DIR ${SRC}/base/tools/aapt2)

file(GLOB_RECURSE PROTO_FILES ${AAPT2_PROTO_DIR}/*.proto)

foreach(proto ${PROTO_FILES})
    get_filename_component(FIL_WE ${proto} NAME_WE)
    
    if(DEFINED PROTOC_PATH)
        # execute the protoc command to generate the proto targets for host arch
        execute_process(
            COMMAND ${PROTOC_COMPILER} ${proto}
            --proto_path=${AAPT2_PROTO_DIR}
            --cpp_out=${AAPT2_PROTO_DIR}
            COMMAND_ECHO STDOUT
            RESULT_VARIABLE RESULT
            WORKING_DIRECTORY ${AAPT2_PROTO_DIR}
        )
    
        # check command result
        if(RESULT EQUAL 0)
            message(STATUS "generate cpp file ${TARGET_CPP_FILE}")
            message(STATUS "generate head file ${TARGET_HEAD_FILE}")
        endif()
    endif()
    
    set(TARGET_CPP_FILE "${AAPT2_PROTO_DIR}/${FIL_WE}.pb.cc")
    set(TARGET_HEAD_FILE "${AAPT2_PROTO_DIR}/${FIL_WE}.pb.h")
    
    if(EXISTS ${TARGET_CPP_FILE} AND EXISTS ${TARGET_HEAD_FILE})
        list(APPEND AAPT2_PROTO_SRC ${TARGET_CPP_FILE})
        list(APPEND AAPT2_PROTO_HDRS ${TARGET_HEAD_FILE})
    endif()
endforeach()

if(DEFINED PROTOC_PATH)
    set_source_files_properties(${AAPT2_PROTO_SRC} PROPERTIES GENERATED TRUE)
    set_source_files_properties(${AAPT2_PROTO_HDRS} PROPERTIES GENERATED TRUE)
endif()
# ========================= aapt2 proto ============================


set(INCLUDES
    ${SRC}/base/tools/aapt2
    ${SRC}/protobuf/src
    ${SRC}/logging/liblog/include
    ${SRC}/expat/lib
    ${SRC}/fmtlib/include
    ${SRC}/libpng
    ${SRC}/libbase/include
    ${SRC}/base/libs/androidfw/include
    ${SRC}/base/cmds/idmap2/libidmap2_policies/include
    ${SRC}/core/libsystem/include
    ${SRC}/core/libutils/include
    ${SRC}/googletest/googletest/include
    ${SRC}/libziparchive/include 
    ${SRC}/libbuildversion/include
    ${SRC}/incremental_delivery/incfs/util/include 
    ${SRC}/incremental_delivery/incfs/kernel-headers
    )

set(COMPILE_FLAGS
    -Wno-unused-parameter
    -Wno-missing-field-initializers
    -fno-exceptions 
    -fno-rtti
    )

file(GLOB TOOL_SOURCE ${SRC}/base/tools/aapt2/cmd/*.cpp)
    
# build the host static library: aapt2
file(GLOB LIBAAPT2_SRCS
    ${SRC}/base/tools/aapt2/*.cpp
    ${SRC}/base/tools/aapt2/compile/*.cpp
    ${SRC}/base/tools/aapt2/configuration/*.cpp
    ${SRC}/base/tools/aapt2/dump/*.cpp
    ${SRC}/base/tools/aapt2/filter/*.cpp
    ${SRC}/base/tools/aapt2/format/*.cpp
    ${SRC}/base/tools/aapt2/format/binary/*.cpp
    ${SRC}/base/tools/aapt2/format/proto/*.cpp
    ${SRC}/base/tools/aapt2/io/*.cpp
    ${SRC}/base/tools/aapt2/link/*.cpp
    ${SRC}/base/tools/aapt2/optimize/*.cpp
    ${SRC}/base/tools/aapt2/process/*.cpp
    ${SRC}/base/tools/aapt2/split/*.cpp
    ${SRC}/base/tools/aapt2/text/*.cpp
    ${SRC}/base/tools/aapt2/util/*.cpp
    ${SRC}/base/tools/aapt2/java/*.cpp
    ${SRC}/base/tools/aapt2/trace/*.cpp
    ${SRC}/base/tools/aapt2/xml/*.cpp
    )
list(REMOVE_ITEM LIBAAPT2_SRCS ${SRC}/base/tools/aapt2/Main.cpp)
file(GLOB LIBAAPT2_PROTO_FILES ${SRC}/base/tools/aapt2/*.proto)
add_library(libaapt2 STATIC
    ${LIBAAPT2_SRCS}
    ${LIBAAPT2_PROTO_FILES}
    ${AAPT2_PROTO_SRC} ${AAPT2_PROTO_HDRS}
    )
target_include_directories(libaapt2 PRIVATE ${INCLUDES})
target_compile_options(libaapt2 PRIVATE ${COMPILE_FLAGS})

# build the host shared library: aapt2_jni
#add_library(libaapt2_jni SHARED
#   ${SRC}/base/tools/aapt2/jni/aapt2_jni.cpp
#   ${TOOL_SOURCE}
#   )
#target_include_directories(libaapt2_jni PRIVATE ${INCLUDES})
#target_compile_options(libaapt2_jni PRIVATE ${COMPILE_FLAGS})
#target_link_libraries(libaapt2_jni libaapt2)

# build the executable file aapt2
add_executable(aapt2
    ${SRC}/base/tools/aapt2/Main.cpp
    ${TOOL_SOURCE}
    )
target_include_directories(aapt2 PRIVATE ${INCLUDES})
target_compile_options(aapt2 PRIVATE ${COMPILE_FLAGS})
target_link_libraries(aapt2 
    libaapt2
    libandroidfw 
    libincfs
    libselinux
    libsepol
    libpackagelistparser
    libutils 
    libcutils
    libziparchive
    libbase
    libbuildversion
    liblog
    protobuf::libprotoc
    protobuf::libprotobuf
    expat
    crypto
    ssl
    pcre2-8
    png_static
    c++_static
    dl
    )
