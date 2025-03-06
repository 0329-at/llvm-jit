# llvm jit 实现基于llvm20

## v1.0.0

### 控制流
```
λ=> def fib(x)
  if (x < 3) then
    1
  else
    fib(λ=> x-1)+fib(x-2);
Read function definition:define double @fib(double %x) {
entry:
  %x1 = alloca double, align 8
  store double %x, ptr %x1, align 8
  %cmptmp = fcmp ult double %x, 3.000000e+00
  br i1 %cmptmp, label %ifcont, label %else

else:                                             ; preds = %entry
  %subtmp = fadd double %x, -1.000000e+00
  %calltmp = call double @fib(double %subtmp)
  %subtmp5 = fadd double %x, -2.000000e+00
  %calltmp6 = call double @fib(double %subtmp5)
  %addtmp = fadd double %calltmp, %calltmp6
  br label %ifcont

ifcont:                                           ; preds = %entry, %else
  %iftmp = phi double [ %addtmp, %else ], [ 1.000000e+00, %entry ]
  ret double %iftmp
}

λ=> Evaluated to 55.000000

λ=> def fibi(x)
  var a = 1, b = 1, c in
  (for i = 3,λ=>  i < x in
     c = a + b :
     a = b :
     b = c) :
  b;
Read function definition:define double @fibi(double %x) {
entry:
  %i = alloca double, align 8
  %b = alloca double, align 8
  %a = alloca double, align 8
  %x1 = alloca double, align 8
  store double %x, ptr %x1, align 8
  store double 1.000000e+00, ptr %a, align 8
  store double 1.000000e+00, ptr %b, align 8
  store double 3.000000e+00, ptr %i, align 8
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i7 = phi double [ %nextvar, %loop ], [ 3.000000e+00, %entry ]
  %b3 = phi double [ %addtmp, %loop ], [ 1.000000e+00, %entry ]
  %a2 = phi double [ %b3, %loop ], [ 1.000000e+00, %entry ]
  %addtmp = fadd double %a2, %b3
  store double %b3, ptr %a, align 8
  %binop = call double @"binary:"(double %addtmp, double %b3)
  store double %addtmp, ptr %b, align 8
  %binop6 = call double @"binary:"(double %binop, double %addtmp)
  %cmptmp = fcmp ult double %i7, %x
  %nextvar = fadd double %i7, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br i1 %cmptmp, label %loop, label %afterloop

afterloop:                                        ; preds = %loop
  %binop11 = call double @"binary:"(double 0.000000e+00, double %addtmp)
  ret double %binop11
}

λ=> fibi(10);
λ=> Evaluated to 55.000000
```

### for循环的llvm ir生成
```
def printstar(n)
  for i = 1, i < n, 1.0 in
    puλ=> tchard(42);  # ascii 42 = '*'
Read function definition:define double @printstar(double %n) {
entry:
  %i = alloca double, align 8
  %n1 = alloca double, align 8
  store double %n, ptr %n1, align 8
  store double 1.000000e+00, ptr %i, align 8
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i2 = phi double [ %nextvar, %loop ], [ 1.000000e+00, %entry ]
  %calltmp = call double @putchard(double 4.200000e+01)
  %cmptmp = fcmp ult double %i2, %n
  %nextvar = fadd double %i2, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br i1 %cmptmp, label %loop, label %afterloop

afterloop:                                        ; preds = %loop
  ret double 0.000000e+00
}
```

### 演示
常量折叠优化：
```
λ=> def test(x) (1+2+x)*(x+(1+2));
λ=> Read function definition:define double @test(double %x) {
entry:
  %addtmp = fadd double %x, 3.000000e+00
  %multmp = fmul double %addtmp, %addtmp
  ret double %multmp
}
```

### 一些内建数值计算
```
λ=> extern sin(x);
λ=> Read extern: declare double @sin(double)

λ=> extern cos(x);
λ=> Read extern: declare double @cos(double)

λ=> sin(1.0);
λ=> Evaluated to 0.841471
λ=> def foo(x) sin(x)*sin(x) + cos(x)*cos(x);
λ=> Read function definition:define double @foo(double %x) {
entry:
  %calltmp = call double @sin(double %x)
  %calltmp4 = call double @sin(double %x)
  %multmp = fmul double %calltmp, %calltmp4
  %calltmp6 = call double @cos(double %x)
  %calltmp8 = call double @cos(double %x)
  %multmp9 = fmul double %calltmp6, %calltmp8
  %addtmp = fadd double %multmp, %multmp9
  ret double %addtmp
}
 ```

### Removed

- Some packages/libraries from acknowledgements I no longer use
