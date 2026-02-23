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

set(INCLUDES
    ${SRC}/art/libartbase
    ${SRC}/art/libdexfile
    ${SRC}/art/libartpalette/include
    ${SRC}/libbase/include
    ${SRC}/logging/liblog/include
    ${SRC}/libziparchive/include
    ${SRC}/fmtlib/include
    )

file(GLOB LIBARTBASE_SRCS
    ${SRC}/art/libartbase/base/*.cc
    ${SRC}/art/libartbase/base/unix_file/*.cc
    )
add_library(libartbase STATIC ${LIBARTBASE_SRCS})
target_include_directories(libartbase PRIVATE ${INCLUDES})

file(GLOB LIBARTPALETTE_SRCS
    ${SRC}/art/libartpalette/apex/*.cc
    ${SRC}/art/libartpalette/system/*.cc
    )
add_library(libartpalette STATIC ${LIBARTPALETTE_SRCS})
target_include_directories(libartpalette PRIVATE ${INCLUDES})

file(GLOB LIBDEXFILE_SRCS ${SRC}/art/libdexfile/dex/*.cc)
add_library(libdexfile STATIC ${LIBDEXFILE_SRCS})
target_compile_options(libdexfile PRIVATE -std=c++17)
target_include_directories(libdexfile PRIVATE ${INCLUDES})

add_executable(dexdump
    ${SRC}/art/dexdump/dexdump_cfg.cc
    ${SRC}/art/dexdump/dexdump_main.cc
    ${SRC}/art/dexdump/dexdump.cc
    )
target_include_directories(dexdump PRIVATE ${INCLUDES})
target_link_libraries(dexdump 
    libdexfile
    libartbase
    libartpalette
    libbase
    libziparchive
    liblog
    c++_static
    dl
    z
    )
    
