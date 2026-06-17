; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv64 %s -o - | FileCheck %s
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64 %s -o - -filetype=obj | spirv-val %}

; Several arithmetic-with-overflow results (a mix of intrinsics) flow as whole
; aggregate values into a single aggregate PHI, whose result is then
; destructured by extractvalue. Each arm is lowered to a {i64, i1} composite
; value-id, all feeding one OpPhi, and the PHI is destructured with
; OpCompositeExtract for both fields.

; CHECK-DAG: %[[#Int64:]] = OpTypeInt 64 0
; CHECK-DAG: %[[#Bool:]] = OpTypeBool
; CHECK-DAG: %[[#Struct:]] = OpTypeStruct %[[#Int64]] %[[#Bool]]

; CHECK: %[[#Sub:]] = OpISubBorrow
; CHECK: %[[#SubArm:]] = OpCompositeConstruct %[[#Struct]]
; CHECK: %[[#Add1:]] = OpIAddCarry
; CHECK: %[[#Add1Arm:]] = OpCompositeConstruct %[[#Struct]]
; CHECK: %[[#Add2:]] = OpIAddCarry
; CHECK: %[[#Add2Arm:]] = OpCompositeConstruct %[[#Struct]]
; CHECK: %[[#Phi:]] = OpPhi %[[#Struct]] %[[#Add2Arm]] %[[#]] %[[#Add1Arm]] %[[#]] %[[#SubArm]] %[[#]]
; CHECK: OpCompositeExtract %[[#Bool]] %[[#Phi]] 1
; CHECK: OpCompositeExtract %[[#Int64]] %[[#Phi]] 0

define spir_func i64 @phi_multi(i64 noundef %a, i64 noundef %b, i32 noundef %sel) {
entry:
  switch i32 %sel, label %sw.default [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
  ]

sw.bb1:                                           ; preds = %entry
  %0 = tail call { i64, i1 } @llvm.usub.with.overflow.i64(i64 %a, i64 %b)
  br label %sw.epilog

sw.bb:                                            ; preds = %entry
  %1 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %a, i64 %b)
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  %2 = tail call { i64, i1 } @llvm.uadd.with.overflow.i64(i64 %a, i64 %a)
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %sw.bb1, %sw.bb
  %.pn = phi { i64, i1 } [ %2, %sw.default ], [ %1, %sw.bb ], [ %0, %sw.bb1 ]
  %of.0.in = extractvalue { i64, i1 } %.pn, 1
  %v.0 = extractvalue { i64, i1 } %.pn, 0
  %not.of.0.in = xor i1 %of.0.in, true
  %add = zext i1 %not.of.0.in to i64
  %cond = add i64 %v.0, %add
  ret i64 %cond
}

declare { i64, i1 } @llvm.uadd.with.overflow.i64(i64, i64)
declare { i64, i1 } @llvm.usub.with.overflow.i64(i64, i64)
