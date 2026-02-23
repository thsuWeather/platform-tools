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

file(GLOB LIBANDROIDFW_SRCS ${SRC}/base/libs/androidfw/*.cpp)
add_library(libandroidfw STATIC ${LIBANDROIDFW_SRCS})

target_compile_definitions(libandroidfw PRIVATE 
    -DSTATIC_ANDROIDFW_FOR_TOOLS
    -D_GNU_SOURCE -DNDEBUG
    )

target_include_directories(libandroidfw PUBLIC
    ${SRC}/base/libs/androidfw/include
    ${SRC}/core/libcutils/include
    ${SRC}/logging/liblog/include
    ${SRC}/core/libsystem/include
    ${SRC}/core/libutils/include
    ${SRC}/libbase/include
    ${SRC}/native/include
    ${SRC}/native/libs/binder/include
    ${SRC}/libziparchive/include
    ${SRC}/incremental_delivery/incfs/util/include
    ${SRC}/incremental_delivery/incfs/kernel-headers
    )
    
target_link_libraries(libandroidfw PUBLIC fmt::fmt)
