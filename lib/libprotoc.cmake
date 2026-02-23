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

file(GLOB_RECURSE LIBPROTOC_SRCS ${SRC}/protobuf/src/google/protobuf/*.cc)
# Exclude main.cc to avoid conflict with protoc executable
list(REMOVE_ITEM LIBPROTOC_SRCS ${SRC}/protobuf/src/google/protobuf/compiler/main.cc)
add_library(libprotoc STATIC ${LIBPROTOC_SRCS})

target_compile_definitions(libprotoc PRIVATE -DHAVE_ZLIB=1)
target_include_directories(libprotoc PRIVATE 
    ${SRC}/protobuf/android
    ${SRC}/protobuf/src
    )
    
add_executable(protoc ${SRC}/protobuf/src/google/protobuf/compiler/main.cc)
target_include_directories(protoc PRIVATE 
    ${SRC}/protobuf/android
    ${SRC}/protobuf/src
    )
target_link_libraries(protoc libprotoc liblog dl z)
