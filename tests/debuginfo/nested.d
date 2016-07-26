// Tests debug info generation for nested functions
// REQUIRES: atleast_llvm308
// RUN: %ldc -g -c -output-ll -of=%t.ll %s && FileCheck %s < %t.ll
// RUN: %ldc -g -c -O3 -output-ll -of=%t.O3.ll %s

// CHECK: define {{.*}} @{{.*}}encloser
// CHECK-SAME: !dbg
void encloser(int arg0, int arg1)
{
    // CHECK: @llvm.dbg.declare{{.*}}%.frame{{.*}}enc_n
    int enc_n;

    // CHECK-LABEL: define {{.*}}encloser{{.*}}nested
    void nested(int nes_i)
    {
        // CHECK: @llvm.dbg.declare{{.*}}%nestedFrame{{.*}}arg1
        arg0 = arg1 = enc_n = nes_i; // accessing arg0, arg1 and enc_n from a nested function turns them into closure variables

        // nes_i and arg1 have the same parameter index in the generated IR, if both get declared as
        // function parameters this triggers off an assert in LLVM >=3.8 (see Github PR #1598)
    }
}

// See Github PR #1598. This code used to result in an ICE with `-g -O3`.
void pr1598(string fmt)
{
    size_t fmtIdx;
    void nested()
    {
        auto a = fmt[fmtIdx .. $];
    }
}


// CHECK-LABEL: !DISubprogram(name:{{.*}}"{{.*}}encloser.nested"
// CHECK: !DILocalVariable{{.*}}nes_i
// CHECK-SAME: arg: 2
// CHECK: !DILocalVariable{{.*}}arg1
// CHECK-NOT: arg:
// CHECK-SAME: ){{$}}
