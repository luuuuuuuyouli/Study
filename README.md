# Study

#### Block 预览

Block 是将函数及其执行上下文封装起来的对象。
Block内部有isa指针，所以其本质也是OC对象

Block的类型

A.GlobalBlock
   位于全局区
   在Block内部不适用外部变量，或者只使用静态变量和全局变量
B.MallocBlock
   位于堆区
   在Block内部使用局部变量或者OC属性，并且复制给强引用或者copy修饰的变量
C.StackBlock
   位于栈区
   与MallocBlock一样，可以在内部使用局部变量或者OC属性，但是不能赋值给强引用
   或者Copy修饰的变量
