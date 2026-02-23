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

file(GLOB LIBSEPOL_SRCS
    ${SRC}/selinux/libsepol/src/*.c
    ${SRC}/selinux/libsepol/cil/src/*.c
    ${SRC}/selinux/libsepol/cil/src/*.l
    )
add_library(libsepol STATIC ${LIBSEPOL_SRCS})

target_compile_definitions(libsepol PRIVATE
    -DHAVE_REALLOCARRAY
    -D_GNU_SOURCE
    )
target_include_directories(libsepol PUBLIC
    ${SRC}/selinux/libselinux/include 
    ${SRC}/selinux/libsepol/include
    )
target_include_directories(libsepol PRIVATE
    ${SRC}/selinux/libsepol/src
    ${SRC}/selinux/libsepol/cil/include
    )