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

file(GLOB LIBABSL_BASE_SRCS ${SRC}/abseil-cpp/absl/base/internal/*.cc)
add_library(libabsl_base STATIC ${LIBABSL_BASE_SRCS})
target_include_directories(libabsl_base PUBLIC
    ${SRC}/abseil-cpp
    )

file(GLOB LIBABSL_STRINGS_SRCS
    ${SRC}/abseil-cpp/absl/strings/*.cc
    ${SRC}/abseil-cpp/absl/strings/internal/*.cc
    ${SRC}/abseil-cpp/absl/strings/internal/str_format/*.cc
    )
add_library(libabsl_strings STATIC ${LIBABSL_STRINGS_SRCS})
target_include_directories(libabsl_strings PUBLIC
    ${SRC}/abseil-cpp
    )
    