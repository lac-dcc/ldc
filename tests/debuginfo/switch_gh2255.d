// RUN: %ldc -g -output-ll -of=%t.ll %s && FileCheck %s < %t.ll

int ggg();

// CHECK: define {{.*}}D13switch_gh22553foo
int foo(int i)
{
    switch (
        ggg()
        )
    {
    case 10:
        return 42;
    default:
        i = 66;
    }

    return 1234;
// CHECK: call {{.*}}D13switch_gh22553ggg{{.*}} !dbg ![[FOO_GGG:[0-9]+]]
// CHECK: ret i32 42, !dbg ![[FOO_42:[0-9]+]]
// CHECK: store i32 66, i32* %i, !dbg ![[FOO_66:[0-9]+]]
// CHECK: ret i32 1234
}

// CHECK: define {{.*}}D13switch_gh225511calculation
int calculation(int i)
{
    switch (
        (i
        +
        ggg())
        )
    {
    case 10:
        return 42;
    default:
        i = 66;
    }

    return 4321;

// CHECK: %[[CALC_TMP0:[0-9]+]] = load i32, i32* %i, !dbg ![[CALC_LOADI:[0-9]+]]
// CHECK: %[[CALC_TMP1:[0-9]+]] = call {{.*}}D13switch_gh22553gggFZi() {{.*}}!dbg ![[CALC_CALLGGG:[0-9]+]]
// CHECK: add i32 %[[CALC_TMP0]], %[[CALC_TMP1]]
// CHECK: ret i32 4321
}



// CHECK-DAG: ![[FOO_GGG]] = !DILocation(line: 9
// CHECK-DAG: ![[FOO_42]] = !DILocation(line: 13
// CHECK-DAG: ![[FOO_66]] = !DILocation(line: 15
// CHECK-DAG: ![[CALC_LOADI]] = !DILocation(line: 29
// CHECK-DAG: ![[CALC_CALLGGG]] = !DILocation(line: 31
