//
//  Person.m
//  001--KVO进阶
//
//  Created by Cooci on 2018/5/2.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)shared{
    static Person *p;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p = [[self alloc] init];
    });
    return p;
}


//嵌套层次
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"dogs"]) {
        NSArray *affectingKeys = @[@"_name", @"_age"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

//自动开关
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    
    if ([key isEqualToString:@"age"]) {
//        return NO;
    }
    return YES;
}

- (void)setAge:(int)age{
    //手动开关
//    [self willChangeValueForKey:@"age"];
    _age = age;
//    [self didChangeValueForKey:@"age"];
}


#pragma mark - lazy

- (NSMutableArray *)mArray{
    if (!_mArray) {
        _mArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _mArray;
}

@end
