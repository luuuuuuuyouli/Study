//
//  NSObject+KCKVO.m
//  001--KVO进阶
//
//  Created by Cooci on 2018/5/2.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "NSObject+KCKVO.h"
#import <objc/message.h>

static NSString *const kKCKVOPrefix = @"KCKOV_";
static NSString *const kKCKVOAssiociateKey = @"kKCKVO_AssiociateKey";

@implementation NSObject (KCKVO)

/**
 KCKVO 添加观察
 @param observer 观察者
 @param keyPath 观察的键
 */
- (void)kc_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    //1判断是否存在于 keyPath是否存在 利用setter方法验证
    // setName
    SEL setterSeletor = NSSelectorFromString(setterForGetter(keyPath));
    Class superClass = object_getClass(self);
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@:not this setter method",self] userInfo:nil];
    }
    //2:动态创建类 CCKVO_A
    NSString * superClassName = NSStringFromClass(superClass);
    Class newClass;
    if (![superClassName hasPrefix:kKCKVOPrefix]) {
        //创建类 并替换父类
        newClass = [self creatClassFromSuperName:superClassName];
        object_setClass(self, newClass);
    }
    
    //3:添加setter方法  注意这个时候的self==>>>子类
    if (![self hasSeletor:setterSeletor]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(newClass, setterSeletor, (IMP)CCKV0_Setter, types);
    }

}

/**
  通过父类创建子类
 */
- (Class)creatClassFromSuperName:(NSString *)superName{
    
    //创建类
    /**
     动态创建类
     1:父类对象
     2:新类的名字
     3:为新类开辟的内存空间
     */
    Class superClass = NSClassFromString(superName);
    NSString *newClassName = [kKCKVOPrefix stringByAppendingString:superName];
    Class newClass = NSClassFromString(newClassName);
    if (newClass) { return newClass;}
    newClass = objc_allocateClassPair(superClass, newClassName.UTF8String, 0);
    
    //添加class方法
    //获取监听对象的class方法 取代class的实现方法---重写
    /**
     为一个类添加方法
     1:类
     2:响应的函数,方法名
     3:指针IMP 即 implementation ，表示由编译器生成的、指向实现方法的指针。也就是说，这个指针指向的方法就是我们要添加的方法
     4:类型:代表一个函数的返回值,参数
     */
    Method classMethod = class_getClassMethod(superClass, @selector(class));
    const char *types = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, @selector(class), (IMP)CCKVO_Class, types);
    //注册类
    objc_registerClassPair(newClass);
    return newClass;
}


/**
 判断是否存在该方法
 */
- (BOOL)hasSeletor:(SEL)selector{
    
    Class observedClass = object_getClass(self);
    unsigned int methodCount = 0;
    //得到一堆方法的名字列表  //class_copyIvarList 实例变量  //class_copyPropertyList 得到所有属性名字
    Method *methodList = class_copyMethodList(observedClass, &methodCount);
    
    for (int i = 0; i<methodCount; i++) {
        SEL sel = method_getName(methodList[i]);
        if (selector == sel) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

#pragma mark - 函数区域
//_cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例。
#pragma mark - 子类添加的setter方法
static void CCKV0_Setter(id self,SEL _cmd,id newValue){
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    if (!getterName) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ not instance getter",self] userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    [self willChangeValueForKey:getterName];
    //消息转发
    void (*KC_OBJCSendSuper)(void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super KCSuperSt = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    KC_OBJCSendSuper(&KCSuperSt,_cmd,newValue);
    [self didChangeValueForKey:getterName];
    
    NSLog(@"%@",newValue);
    
}


#pragma mark - CCKVO_Class 新类class所指向的函数实现
static Class CCKVO_Class(id self){
    return class_getSuperclass(object_getClass(self));
}

#pragma mark - 从get方法获取set方法的名称 name ===>>> setName:
static NSString  * setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil; }
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 setName:===> name
static NSString * getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    getter = [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
    
    return getter;
    
}



@end
