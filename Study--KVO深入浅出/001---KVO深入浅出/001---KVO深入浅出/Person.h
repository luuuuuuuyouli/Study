//
//  Person.h
//  001--KVO进阶
//
//  Created by Cooci on 2018/5/2.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) Dog *dog;
@property (nonatomic, strong) NSMutableArray *mArray;

+ (instancetype)shared;

@end
