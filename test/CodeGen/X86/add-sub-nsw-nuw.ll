; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i386-apple-darwin < %s | FileCheck %s

; PR30841: https://llvm.org/bugs/show_bug.cgi?id=30841
; Demanded bits analysis must disable nsw/nuw when it makes a
; simplification to add/sub such as in this case.

define i8 @PR30841(i64 %argc) {
; CHECK-LABEL: PR30841:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    negb %al
; CHECK-NEXT:    ## kill: def $al killed $al killed $eax
; CHECK-NEXT:    retl
entry:
  %or = or i64 %argc, -4294967296
  br label %end

end:
  %neg = sub nuw nsw i64 -4294967296, %argc
  %trunc = trunc i64 %neg to i8
  ret i8 %trunc
}

