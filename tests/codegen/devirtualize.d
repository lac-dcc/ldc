// RUN: %ldc -O3 -output-ll -of=%t.ll %s

class A
{
    int foo()
    {
        return 0;
    }

    final void finalfunc()
    {
    }
}

final class B : A
{
    int foo()
    {
        return 1;
    }
}

void bar(B b)
{
    b.foo();
    b.finalfunc();
}
