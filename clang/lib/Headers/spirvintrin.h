//===-- spirvintrin.h - SPIRV intrinsic functions -------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef __SPIRVINTRIN_H
#define __SPIRVINTRIN_H

#ifndef __SPIRV__
#error "This file is intended for SPIRV targets or offloading to SPIRV"
#endif

_Pragma("omp begin declare target device_type(nohost)");
_Pragma("omp begin declare variant match(device = {arch(spirv64)})");

// Type aliases to the address spaces used by the NVPTX backend.
#define __gpu_private 
#define __gpu_constant
#define __gpu_local 
#define __gpu_global __attribute__((address_space(1)))
#define __gpu_generic __attribute__((address_space(4)))

// Attribute to declare a function as a kernel.
#define __gpu_kernel __attribute__((spirv_kernel, visibility("protected")))

// Returns the number of CUDA blocks in the 'x' dimension.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_num_blocks_x(void) {
  return 0;
}

// Returns the number of CUDA blocks in the 'y' dimension.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_num_blocks_y(void) {
  return 0;
}

// Returns the number of CUDA blocks in the 'z' dimension.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_num_blocks_z(void) {
  return 0;
}

// Returns the 'x' dimension of the current CUDA block's id.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_block_id_x(void) {
  return 0;
}

// Returns the 'y' dimension of the current CUDA block's id.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_block_id_y(void) {
  return 0;
}

// Returns the 'z' dimension of the current CUDA block's id.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_block_id_z(void) {
  return 0;
}

// Returns the number of CUDA threads in the 'x' dimension.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_num_threads_x(void) {
  return 0;
}

// Returns the number of CUDA threads in the 'y' dimension.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_num_threads_y(void) {
  return 0;
}

// Returns the number of CUDA threads in the 'z' dimension.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_num_threads_z(void) {
  return 0;
}

// Returns the 'x' dimension id of the thread in the current CUDA block.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_thread_id_x(void) {
  return 0;
}

// Returns the 'y' dimension id of the thread in the current CUDA block.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_thread_id_y(void) {
  return 0;
}

// Returns the 'z' dimension id of the thread in the current CUDA block.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_thread_id_z(void) {
  return 0;
}

// Returns the size of a CUDA warp, always 32 on NVIDIA hardware.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_num_lanes(void) {
  return 0;
}

// Returns the id of the thread inside of a CUDA warp executing together.
_DEFAULT_FN_ATTRS static __inline__ uint32_t __gpu_lane_id(void) {
  return 0;
}

// Returns the bit-mask of active threads in the current warp.
_DEFAULT_FN_ATTRS static __inline__ uint64_t __gpu_lane_mask(void) {
  return 0;
}

// Copies the value from the first active thread in the warp to the rest.
_DEFAULT_FN_ATTRS static __inline__ uint32_t
__gpu_read_first_lane_u32(uint64_t __lane_mask, uint32_t __x) {
  return 0;
}

// Returns a bitmask of threads in the current lane for which \p x is true.
_DEFAULT_FN_ATTRS static __inline__ uint64_t __gpu_ballot(uint64_t __lane_mask,
                                                          bool __x) {
  return 0;
}

// Waits for all the threads in the block to converge and issues a fence.
_DEFAULT_FN_ATTRS static __inline__ void __gpu_sync_threads(void) {
  //  __syncthreads();
}

// Waits for all threads in the warp to reconverge for independent scheduling.
_DEFAULT_FN_ATTRS static __inline__ void __gpu_sync_lane(uint64_t __lane_mask) {
 
}

// Shuffles the the lanes inside the warp according to the given index.
_DEFAULT_FN_ATTRS static __inline__ uint32_t
__gpu_shuffle_idx_u32(uint64_t __lane_mask, uint32_t __idx, uint32_t __x,
                      uint32_t __width) {
  return 0;
}

// Returns a bitmask marking all lanes that have the same value of __x.
_DEFAULT_FN_ATTRS static __inline__ uint64_t
__gpu_match_any_u32(uint64_t __lane_mask, uint32_t __x) {
  return 0;
}

// Returns a bitmask marking all lanes that have the same value of __x.
_DEFAULT_FN_ATTRS static __inline__ uint64_t
__gpu_match_any_u64(uint64_t __lane_mask, uint64_t __x) {
  return 0;
}

// Returns the current lane mask if every lane contains __x.
_DEFAULT_FN_ATTRS static __inline__ uint64_t
__gpu_match_all_u32(uint64_t __lane_mask, uint32_t __x) {
  return 0;
}

// Returns the current lane mask if every lane contains __x.
_DEFAULT_FN_ATTRS static __inline__ uint64_t
__gpu_match_all_u64(uint64_t __lane_mask, uint64_t __x) {
  return 0;
}

// Returns true if the flat pointer points to CUDA 'shared' memory.
_DEFAULT_FN_ATTRS static __inline__ bool __gpu_is_ptr_local(void *ptr) {
  return false;
}

// Returns true if the flat pointer points to CUDA 'local' memory.
_DEFAULT_FN_ATTRS static __inline__ bool __gpu_is_ptr_private(void *ptr) {
  return false;
}

// Terminates execution of the calling thread.
_DEFAULT_FN_ATTRS [[noreturn]] static __inline__ void __gpu_exit(void) {

}

// Suspend the thread briefly to assist the scheduler during busy loops.
_DEFAULT_FN_ATTRS static __inline__ void __gpu_thread_suspend(void) {
 
}

_Pragma("omp end declare variant");
_Pragma("omp end declare target");


#endif
