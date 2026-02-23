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

file(GLOB LIBCUTILS_SRCS ${SRC}/core/libcutils/*.cpp ${SRC}/core/libcutils/*.c)
add_library(libcutils STATIC ${LIBCUTILS_SRCS})

target_compile_definitions(libcutils PRIVATE 
    -D_GNU_SOURCE
    )

target_include_directories(libcutils PRIVATE
    ${SRC}/core/libutils/include
    ${SRC}/core/libcutils/include
    ${SRC}/logging/liblog/include 
    ${SRC}/libbase/include
    )
    
