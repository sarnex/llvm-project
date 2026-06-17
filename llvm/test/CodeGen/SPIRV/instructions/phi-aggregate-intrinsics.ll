; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv64 %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64 %s -o - -filetype=obj | spirv-val %}

; An arithmetic-with-overflow intrinsic whose aggregate result is used as a
; whole value (here, an arm of an aggregate PHI) rather than being immediately
; destructured by extractvalue. SPIRVEmitIntrinsics rewrites the call into the
; spv_aggregate_with_overflow stand-in, which the selector lowers to a single composite
; {scalar, i1} value-id so it can take part in the PHI.

; CHECK-DAG: %[[#Int64:]] = OpTypeInt 64 0
; CHECK-DAG: %[[#Bool:]] = OpTypeBool
; CHECK-DAG: %[[#Struct:]] = OpTypeStruct %[[#Int64]] %[[#Bool]]

; CHECK: %[[#Carry:]] = OpIAddCarry
; CHECK: %[[#Lo:]] = OpCompositeExtract %[[#Int64]] %[[#Carry]] 0
; CHECK: %[[#Hi:]] = OpCompositeExtract %[[#Int64]] %[[#Carry]] 1
; CHECK: %[[#Ovf:]] = OpINotEqual %[[#Bool]] %[[#Hi]]
; CHECK: %[[#Val:]] = OpCompositeConstruct %[[#Struct]] %[[#Lo]] %[[#Ovf]]
; CHECK: %[[#Phi:]] = OpPhi %[[#Struct]] %[[#Val]] %[[#]] %[[#]] %[[#]]
; CHECK: OpReturnValue %[[#Phi]]

define spir_func { i64, i1 } @f(i32 %sel) {
entry:
  switch i32 %sel, label %sw.bb [
    i32 0, label %sw.bb
    i32 1, label %sw.epilog
  ]

sw.bb:                                            ; preds = %entry, %entry
  %0 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 0, i64 0)
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.bb, %entry
  %.pn = phi { i64, i1 } [ %0, %sw.bb ], [ zeroinitializer, %entry ]
  ret { i64, i1 } %.pn
}

; Signed add/sub overflow have no direct SPIR-V op; the overflow flag is
; computed from the sign bits of the operands and the wrapped result.

; CHECK: %[[#SAdd:]] = OpIAdd %[[#Int64]]
; CHECK: OpBitwiseXor %[[#Int64]]
; CHECK: OpBitwiseXor %[[#Int64]]
; CHECK: %[[#SAnd:]] = OpBitwiseAnd %[[#Int64]]
; CHECK: %[[#SOvf:]] = OpSLessThan %[[#Bool]] %[[#SAnd]]
; CHECK: OpCompositeConstruct %[[#Struct]] %[[#SAdd]] %[[#SOvf]]

define spir_func { i64, i1 } @g(i32 %sel, i64 %a, i64 %b) {
entry:
  switch i32 %sel, label %sw.bb [
    i32 0, label %sw.bb
    i32 1, label %sw.epilog
  ]

sw.bb:                                            ; preds = %entry, %entry
  %0 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %a, i64 %b)
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.bb, %entry
  %.pn = phi { i64, i1 } [ %0, %sw.bb ], [ zeroinitializer, %entry ]
  ret { i64, i1 } %.pn
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.uadd.with.overflow.i64(i64, i64) #0
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #0
