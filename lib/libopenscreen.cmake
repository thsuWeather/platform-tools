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

file(GLOB LIBOPENSCREEN_SRCS
    ${SRC}/openscreen/discovery/dnssd/impl/*.cc
    ${SRC}/openscreen/discovery/dnssd/public/*.cc
    ${SRC}/openscreen/discovery/mdns/*.cc
    ${SRC}/openscreen/discovery/mdns/public/*.cc
    ${SRC}/openscreen/platform/base/*.cc
    ${SRC}/openscreen/platform/api/*.cc
    ${SRC}/openscreen/platform/impl/*.cc
    ${SRC}/openscreen/util/*.cc
    )
add_library(libopenscreen STATIC ${LIBOPENSCREEN_SRCS})

target_compile_options(libopenscreen PRIVATE 
    -fno-strict-aliasing
    -Wno-address-of-packed-member
    -Wno-array-bounds
    -Wno-pointer-sign
    -Wno-unused
    -Wno-unused-but-set-variable
    -Wno-unused-parameter
    -Wno-missing-field-initializers
    -Werror=implicit-function-declaration
    )

target_compile_options(libopenscreen PRIVATE 
    -std=c++17
    -fno-exceptions 
    -fno-unwind-tables 
    -fno-asynchronous-unwind-tables
    )

target_include_directories(libopenscreen PRIVATE
    ${SRC}/openscreen
    ${SRC}/abseil-cpp
    )
    