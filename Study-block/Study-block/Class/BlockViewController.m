//
//  BlockViewController.m
//  Study-block
//
//  Created by syong on 2020/7/17.
//  Copyright © 2020 com.eios. All rights reserved.
//

#import "BlockViewController.h"
#import "TestObject.h"

@interface BlockViewController ()

@end

static NSInteger testA = 100;
NSInteger testB = 1000;

@implementation BlockViewController

//什么叫block
/*
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
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //预览
    TestObject *object1 = [[TestObject alloc] init];
    __block TestObject *object2 = [[TestObject alloc] init];
    object1.name = @"Mike";
    object2.name = @"Sean";
    __block int vi = 1;
    //当定义block的时候，block会把外部变量的值以count的形式复制一份存放到block的所在内存中，如果引入的是全局变量，则不是以count方式复制
    //所以如果去掉int vi前面 __block 那么block里面就无法修改vi的值了
    //这是一个mallocblock
    void (^handler)(NSString *) = ^(NSString *name) {
        object1.name = name;
        object2.name = name;
        vi = 2;
    };
    handler(@"Lucy");
    //打印结果为 Lucy Lucy 2
    NSLog(@"%@", object1.name);
    NSLog(@"%@", object2.name);
    NSLog(@"%i", vi);
    
    //局部变量
   // [self localBlock];
    //全局变量，静态全局变量截获
    [self gloablBlcok];
 
}

- (void)localBlock{
    //---block变量截获----
     
     NSInteger num = 3;
     NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n){
         
         return  n * num;
     };
     num = 1;
     //打印结果是6 而不是2
     //block对局部变量是值截获,而不是指针，在外部对值的修改不会影响里面,除非加__block
     NSLog(@"%zd",block(2));
     
     
     
     NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
     
     void(^block2)(void) = ^{
         NSLog(@"%@",arr);
         [arr addObject:@"4"];
     };
     //使用对象调用方法是会影响到的
     [arr addObject:@"3"];
     arr = nil;
     block2();
     
     
     
     //局部静态变量截获是指针获取，修改后会影响到里面的值
     static NSInteger sum = 3;
     
     NSInteger(^block3)(NSInteger) = ^NSInteger(NSInteger n){
         return n * sum;
     };
     
     sum = 1;
     
     NSLog(@"%zd",block3(100));
}

- (void)gloablBlcok{
    //全局变量，静态全局变量截获:不截获,直接取值。
    NSInteger num = 30;
    
    static NSInteger num2 = 3;
    
    __block NSInteger num3 = 3000;
    //这是一个
    void(^block)(void) = ^{
        
        NSLog(@"%zd",num);//局部变量
        
        NSLog(@"%zd",num2);//静态变量
        
        NSLog(@"%zd",num3);//__block修饰变量
        
        NSLog(@"%zd",testA);//全局静态变量
        
        NSLog(@"%zd",testB);//全局变量
    };
    
    block();
}


@end

