// RUN: %ldc -g -output-ll -of=%t.ll %s && FileCheck %s < %t.ll

int ggg();

// CHECK: define {{.*}}D20subexpression_gh209014load_plus_call
int load_plus_call(int i)
{
    return
    i
    +
    ggg()
    ;
// CHECK: %[[LPC_TMP0:[0-9]+]] = load i32, i32* %i, !dbg ![[LPC_LOADI:[0-9]+]]
// CHECK: %[[LPC_TMP1:[0-9]+]] = call {{.*}}D20subexpression_gh20903ggg{{.*}} !dbg ![[LPC_CALLGGG:[0-9]+]]
// CHECK: add i32 %[[LPC_TMP0]], %[[LPC_TMP1]], !dbg ![[LPC_ADD:[0-9]+]]
// CHECK: ret i32{{.*}} !dbg ![[LPC_RET:[0-9]+]]
}


int* getptr();
// CHECK: define {{.*}}D20subexpression_gh209018dereference_retval
void dereference_retval() {
    auto
    i
    =
    *
    getptr()
    ;

    return;

// CHECK: %[[DR_TMP0:[0-9]+]] = call {{.*}}D20subexpression_gh20906getptr{{.*}} !dbg ![[DR_GETPTR:[0-9]+]]
// CHECK: %[[DR_TMP1:[0-9]+]] = load i32, i32* %[[DR_TMP0]], !dbg ![[DR_DEREF:[0-9]+]]
// CHECK: store i32 %[[DR_TMP1]], i32* %i, !dbg ![[DR_ASSIGN:[0-9]+]]
// CHECK: ret void, !dbg ![[DR_RET:[0-9]+]]
}


class A {
    int i;
}

// CHECK: define {{.*}}D20subexpression_gh20906FuzzMe
bool FuzzMe(ubyte* data, A a, size_t index)
{
    return
        a.i
        &&
        data[index]
            ==
            'Z'
    ;
}


// CHECK-DAG: ![[LPC_LOADI]] = !DILocation(line: 9
// CHECK-DAG: ![[LPC_CALLGGG]] = !DILocation(line: 11
// CHECK-DAG: ![[LPC_RET]] = !DILocation(line: 8

// CHECK-DAG: ![[DR_GETPTR]] = !DILocation(line: 27
// CHECK-DAG: ![[DR_DEREF]] = !DILocation(line: 26
// CHECK-DAG: ![[DR_ASSIGN]] = !DILocation(line: 24
// CHECK-DAG: ![[DR_RET]] = !DILocation(line: 30


// FIXMEs:
// The location of the binary operation itself (the + char) is not available from frontend's AST...
// C HECK-DAG: ![[LPC_ADD]] = !DILocation(line: 10
