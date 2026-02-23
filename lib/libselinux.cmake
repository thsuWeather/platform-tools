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

file(GLOB LIBSELINUX_SRCS
    ${SRC}/selinux/libselinux/src/*.c
    ${SRC}/selinux/libselinux/src/android/*.c
    )
list(REMOVE_ITEM LIBSELINUX_SRCS ${SRC}/selinux/libselinux/src/selinux_restorecon.c)
add_library(libselinux STATIC ${LIBSELINUX_SRCS})

target_compile_definitions(libselinux PRIVATE
    -DAUDITD_LOG_TAG=1003 
    -D_GNU_SOURCE 
    -DHOST 
    -DUSE_PCRE2
    -DNO_PERSISTENTLY_STORED_PATTERNS 
    -DDISABLE_SETRANS
    -DDISABLE_BOOL 
    -DNO_MEDIA_BACKEND 
    -DNO_X_BACKEND 
    -DNO_DB_BACKEND
    -DPCRE2_CODE_UNIT_WIDTH=8
    )
    
target_include_directories(libselinux PRIVATE
    ${SRC}/selinux/libselinux/include 
    ${SRC}/selinux/libsepol/include
    ${SRC}/core/libcutils/include
    ${SRC}/logging/liblog/include 
    ${SRC}/core/libpackagelistparser/include
    ${SRC}/pcre/include
    )
target_include_directories(libselinux PRIVATE
    ${SRC}/selinux/libselinux/src
    )
