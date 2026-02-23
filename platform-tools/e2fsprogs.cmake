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
    ${SRC}/e2fsprogs/lib
    ${SRC}/core/libsparse/include
    ${SRC}/e2fsprogs/lib
    ${SRC}/e2fsprogs/misc
    ${SRC}/e2fsprogs/lib/ext2fs
    ${SRC}/selinux/libselinux/include
    ${SRC}/core/libcutils/include
    )

# libext2_blkid
file(GLOB LIBEXT2_BLKID_SRCS ${SRC}/e2fsprogs/lib/blkid/*.c)
add_library(libext2_blkid STATIC ${LIBEXT2_BLKID_SRCS})
target_include_directories(libext2_blkid PRIVATE ${INCLUDES})

# libext2_com_err
file(GLOB LIBEXT2_COM_ERR_SRCS ${SRC}/e2fsprogs/lib/et/*.c)
add_library(libext2_com_err STATIC ${LIBEXT2_COM_ERR_SRCS})
target_include_directories(libext2_com_err PRIVATE ${INCLUDES})

# libext2_e2p
file(GLOB LIBEXT2_E2P_SRCS ${SRC}/e2fsprogs/lib/e2p/*.c)
add_library(libext2_e2p STATIC ${LIBEXT2_E2P_SRCS})
target_include_directories(libext2_e2p PRIVATE ${INCLUDES})

# libext2_quota
file(GLOB LIBEXT2_QUOTA_SRCS ${SRC}/e2fsprogs/lib/support/*.c)
add_library(libext2_quota STATIC ${LIBEXT2_QUOTA_SRCS})
target_include_directories(libext2_quota PRIVATE ${INCLUDES})

# libext2_uuid
file(GLOB LIBEXT2_UUID_SRCS ${SRC}/e2fsprogs/lib/uuid/*.c)
add_library(libext2_uuid STATIC ${LIBEXT2_UUID_SRCS})
target_include_directories(libext2_uuid PRIVATE ${INCLUDES})

# libext2fs
file(GLOB LIBEXT2FS_SRCS ${SRC}/e2fsprogs/lib/ext2fs/*.c)
add_library(libext2fs STATIC ${LIBEXT2FS_SRCS})
target_include_directories(libext2fs PRIVATE ${INCLUDES})

# libext2_misc
add_library(libext2_misc STATIC
    ${SRC}/e2fsprogs/misc/create_inode.c
    )
target_include_directories(libext2_misc PRIVATE ${INCLUDES})

# mke2fs
add_executable(mke2fs
    ${SRC}/e2fsprogs/misc/mke2fs.c
    ${SRC}/e2fsprogs/misc/util.c
    ${SRC}/e2fsprogs/misc/mk_hugefiles.c
    ${SRC}/e2fsprogs/misc/default_profile.c
    )
target_include_directories(mke2fs PRIVATE ${INCLUDES})
target_link_libraries(mke2fs 
    libext2_misc 
    libext2_blkid 
    libext2fs 
    libext2_uuid  
    libext2_e2p 
    libext2_com_err 
    libext2_quota 
    libsparse 
    libbase 
    dl
    z
    )

# e2fsdroid
add_executable(e2fsdroid
    ${SRC}/e2fsprogs/contrib/android/e2fsdroid.c
    ${SRC}/e2fsprogs/contrib/android/block_range.c
    ${SRC}/e2fsprogs/contrib/android/fsmap.c
    ${SRC}/e2fsprogs/contrib/android/block_list.c
    ${SRC}/e2fsprogs/contrib/android/base_fs.c
    ${SRC}/e2fsprogs/contrib/android/perms.c
    ${SRC}/e2fsprogs/contrib/android/basefs_allocator.c
    )
target_include_directories(e2fsdroid PRIVATE ${INCLUDES})
target_link_libraries(e2fsdroid
    libext2_misc 
    libext2_com_err
    libext2fs 
    libselinux
    libsepol
    libpackagelistparser
    libsparse
    libcutils
    libbase
    liblog
    pcre2-8
    dl
    z
    )