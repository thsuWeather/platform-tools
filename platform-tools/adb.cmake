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

# ========================= adb proto ============================
set(ADB_PROTO_SRC)  # adb proto source files
set(ADB_PROTO_HDRS) # adb proto head files
set(ADB_PROTO_DIR ${SRC}/adb/proto)

file(GLOB_RECURSE PROTO_FILES ${ADB_PROTO_DIR}/*.proto)

foreach(proto ${PROTO_FILES})
    get_filename_component(FIL_WE ${proto} NAME_WE)
    if(DEFINED PROTOC_PATH)
        # execute the protoc command to generate the proto targets for host arch
        execute_process(
            COMMAND ${PROTOC_COMPILER} ${proto}
            --proto_path=${ADB_PROTO_DIR}
            --cpp_out=${ADB_PROTO_DIR}
            COMMAND_ECHO STDOUT
            RESULT_VARIABLE RESULT
            WORKING_DIRECTORY ${ADB_PROTO_DIR}
        )
        
        # check command result
        if(RESULT EQUAL 0)
            message(STATUS "generate cpp file ${TARGET_CPP_FILE}")
            message(STATUS "generate head file ${TARGET_HEAD_FILE}")
        endif()
    endif()
    
    set(TARGET_CPP_FILE "${ADB_PROTO_DIR}/${FIL_WE}.pb.cc")
    set(TARGET_HEAD_FILE "${ADB_PROTO_DIR}/${FIL_WE}.pb.h")
   
    if(EXISTS ${TARGET_CPP_FILE} AND EXISTS ${TARGET_HEAD_FILE})
        list(APPEND ADB_PROTO_SRC ${TARGET_CPP_FILE})
        list(APPEND ADB_PROTO_HDRS ${TARGET_HEAD_FILE})
    endif()
endforeach()

if(DEFINED PROTOC_PATH)
    set_source_files_properties(${ADB_PROTO_SRC} PROPERTIES GENERATED TRUE)
    set_source_files_properties(${ADB_PROTO_HDRS} PROPERTIES GENERATED TRUE)
endif()
# ========================= adb proto ============================


# ========================= fastdeploy proto ============================
# ApkEntry.proto
set(FASTDEPLOY_PROTO_SRC)  # adb proto source files
set(FASTDEPLOY_PROTO_HDRS) # adb proto head files
set(FASTDEPLOY_PROTO_DIR ${CMAKE_SOURCE_DIR}/src/adb/fastdeploy/proto)

if(DEFINED PROTOC_PATH)
    # execute the protoc command to generate the proto targets for host arch
    execute_process(
        COMMAND ${PROTOC_COMPILER} ${FASTDEPLOY_PROTO_DIR}/ApkEntry.proto
        --proto_path=${FASTDEPLOY_PROTO_DIR}
        --cpp_out=${FASTDEPLOY_PROTO_DIR}
        COMMAND_ECHO STDOUT
        RESULT_VARIABLE RESULT
        WORKING_DIRECTORY ${FASTDEPLOY_PROTO_DIR}
    )
    
    # check command result
    if(RESULT EQUAL 0)
        message(STATUS "generate cpp file ${TARGET_CPP_FILE}")
        message(STATUS "generate head file ${TARGET_HEAD_FILE}")
    endif()
endif()

set(TARGET_CPP_FILE "${FASTDEPLOY_PROTO_DIR}/ApkEntry.pb.cc")
set(TARGET_HEAD_FILE "${FASTDEPLOY_PROTO_DIR}/ApkEntry.pb.h")
    
if(EXISTS ${TARGET_CPP_FILE} AND EXISTS ${TARGET_HEAD_FILE})
    list(APPEND FASTDEPLOY_PROTO_SRC ${TARGET_CPP_FILE})
    list(APPEND FASTDEPLOY_PROTO_HDRS ${TARGET_HEAD_FILE})
endif()

if(DEFINED PROTOC_PATH)
    set_source_files_properties(${FASTDEPLOY_PROTO_SRC} PROPERTIES GENERATED TRUE)
    set_source_files_properties(${FASTDEPLOY_PROTO_HDRS} PROPERTIES GENERATED TRUE)
endif()
# ========================= fastdeploy proto ============================


file(GLOB LIBADB_SRCS
    ${SRC}/adb/*.cpp
    ${SRC}/adb/fdevent/*.cpp
    ${SRC}/adb/sysdeps/*.cpp
    ${SRC}/adb/sysdeps/posix/*.cpp
    ${SRC}/adb/client/openscreen/*.cpp
    ${SRC}/adb/client/openscreen/platform/*.cpp
    ${SRC}/adb/client/auth.cpp
    ${SRC}/adb/client/adb_wifi.cpp
    ${SRC}/adb/client/usb_libusb.cpp
    ${SRC}/adb/client/transport_local.cpp
    ${SRC}/adb/client/mdnsresponder_client.cpp
    ${SRC}/adb/client/mdns_utils.cpp
    ${SRC}/adb/client/transport_mdns.cpp
    ${SRC}/adb/client/transport_usb.cpp
    ${SRC}/adb/client/pairing/*.cpp
    ${SRC}/adb/client/usb_linux.cpp
    )
add_library(libadb STATIC ${LIBADB_SRCS} ${ADB_PROTO_SRC} ${ADB_PROTO_HDRS})
target_compile_definitions(libadb PRIVATE 
    -D_GNU_SOURCE
    -DADB_HOST=1
    )
target_include_directories(libadb PRIVATE
    ${SRC}/adb
    ${SRC}/adb/proto
    ${SRC}/adb/crypto/include
    ${SRC}/adb/pairing_auth/include
    ${SRC}/adb/pairing_connection/include
    ${SRC}/adb/tls/include
    ${SRC}/base/libs/androidfw/include
    ${SRC}/fmtlib/include
    ${SRC}/libbase/include
    ${SRC}/libziparchive/include
    ${SRC}/native/include
    ${SRC}/protobuf/src
    ${SRC}/zstd/lib
    ${SRC}/libusb/include
    ${SRC}/brotli/c/include
    ${SRC}/libbuildversion/include
    ${SRC}/mdnsresponder/mDNSShared
    ${SRC}/openscreen
    ${SRC}/abseil-cpp
    ${SRC}/core/libcrypto_utils/include
    ${SRC}/core/libcutils/include
    ${SRC}/core/include
    ${SRC}/core/diagnose_usb/include
    ${SRC}/boringssl/include
    ${SRC}/googletest/googletest/include
    ${SRC}/incremental_delivery/incfs/util/include 
    )

file(GLOB LIBADB_CRYPTO_SRCS ${SRC}/adb/crypto/*.cpp)
add_library(libadb_crypto STATIC ${LIBADB_CRYPTO_SRCS} ${ADB_PROTO_HDRS})
target_include_directories(libadb_crypto PRIVATE
    ${SRC}/adb
    ${SRC}/adb/crypto/include
    ${SRC}/adb/proto
    ${SRC}/boringssl/include
    ${SRC}/core/libcrypto_utils/include
    ${SRC}/libbase/include
    ${SRC}/protobuf/src
    )

file(GLOB LIBADB_TLS_SRCS ${SRC}/adb/tls/*.cpp)
add_library(libadb_tls_connection STATIC ${LIBADB_TLS_SRCS})
target_include_directories(libadb_tls_connection PRIVATE
    ${SRC}/adb
    ${SRC}/adb/tls/include
    ${SRC}/boringssl/include
    ${SRC}/libbase/include
    )
    
file(GLOB LIBADB_PAIRING_CONN_SRCS ${SRC}/adb/pairing_connection/*.cpp)
add_library(libadb_pairing_connection STATIC ${LIBADB_PAIRING_CONN_SRCS})
target_include_directories(libadb_pairing_connection PRIVATE
    ${SRC}/adb/proto
    ${SRC}/adb/pairing_connection/include
    ${SRC}/adb/pairing_auth/include
    ${SRC}/adb/tls/include
    ${SRC}/libbase/include
    ${SRC}/boringssl/include
    ${SRC}/protobuf/src
    )

file(GLOB LIBADB_PAIRING_AUTH_SRCS ${SRC}/adb/pairing_auth/*.cpp)
add_library(libadb_pairing_auth STATIC ${LIBADB_PAIRING_AUTH_SRCS})
target_include_directories(libadb_pairing_auth PRIVATE
    ${SRC}/adb/pairing_auth/include
    ${SRC}/libbase/include
    ${SRC}/boringssl/include
    ${SRC}/protobuf/src
    )

add_library(libadb_sysdeps STATIC
    ${SRC}/adb/sysdeps/env.cpp
    )
target_include_directories(libadb_sysdeps PRIVATE
    ${SRC}/libbase/include
    ${SRC}/adb
    )

file(GLOB LIBFASTDEPLOY_SRCS ${SRC}/adb/fastdeploy/deploypatchgenerator/*.cpp)
add_library(libfastdeploy STATIC
    ${LIBFASTDEPLOY_SRCS}
    ${SRC}/adb/fastdeploy/proto/ApkEntry.proto
    ${FASTDEPLOY_PROTO_SRC} ${FASTDEPLOY_PROTO_HDRS}
    )
target_include_directories(libfastdeploy PRIVATE
    ${SRC}/adb
    ${SRC}/core/libcutils/include
    ${SRC}/libbase/include
    ${SRC}/protobuf/src
    ${SRC}/boringssl/include
    )

file(GLOB LIBCRYPTO_SRCS ${SRC}/core/libcrypto_utils/*.cpp)
add_library(libcrypto STATIC ${LIBCRYPTO_SRCS})
target_include_directories(libcrypto PRIVATE
    ${SRC}/core/libcrypto_utils/include 
    ${SRC}/boringssl/include
    )

add_executable(adb
    ${SRC}/adb/client/adb_client.cpp
    ${SRC}/adb/client/bugreport.cpp
    ${SRC}/adb/client/commandline.cpp
    ${SRC}/adb/client/file_sync_client.cpp
    ${SRC}/adb/client/main.cpp
    ${SRC}/adb/client/console.cpp
    ${SRC}/adb/client/adb_install.cpp
    ${SRC}/adb/client/line_printer.cpp
    ${SRC}/adb/client/fastdeploy.cpp
    ${SRC}/adb/client/fastdeploycallbacks.cpp
    ${SRC}/adb/client/incremental.cpp
    ${SRC}/adb/client/incremental_server.cpp
    ${SRC}/adb/client/incremental_utils.cpp
    ${SRC}/adb/shell_service_protocol.cpp
    ${ADB_PROTO_HDRS}
    )
target_include_directories(adb PRIVATE
    ${SRC}/adb
    ${SRC}/adb/proto
    ${SRC}/adb/fastdeploy/deployagent
    ${SRC}/lz4/lib
    ${SRC}/zstd/lib
    ${SRC}/libbase/include 
    ${SRC}/core/include 
    ${SRC}/core/libcutils/include
    ${SRC}/core/libcrypto_utils/include 
    ${SRC}/boringssl/include
    ${SRC}/googletest/googletest/include
    )
target_compile_definitions(adb PRIVATE 
    -D_GNU_SOURCE
    -DADB_HOST=1
    )
target_link_libraries(adb
    libadb
    libadb_crypto
    libadb_tls_connection
    libadb_pairing_connection
    libadb_pairing_auth
    libcrypto
    libadb_sysdeps
    libfastdeploy
    libselinux
    libsepol
    libincfs
    libpackagelistparser
    libbase
    libutils
    libcutils
    libdiagnoseusb
    libandroidfw
    libbuildversion
    libziparchive
    libmdnssd
    libopenscreen
    libusb
    liblog
    pcre2-8
    crypto
    ssl
    protobuf::libprotoc
    protobuf::libprotobuf
    absl::base
    absl::strings
    brotlicommon-static
    brotlidec-static
    brotlienc-static
    libzstd_static
    lz4_static
    c++_static
    dl
    z
    )
