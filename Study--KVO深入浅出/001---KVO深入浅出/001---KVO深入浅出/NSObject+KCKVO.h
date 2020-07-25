//
//  NSObject+KCKVO.h
//  001--KVO进阶
//
//  Created by Cooci on 2018/5/2.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KCKVOBlock)(id observer,NSString *keyPath,id oldValue,id newValue);

@interface NSObject (KCKVO)

/**
 KCKVO 添加观察
 @param observer 观察者
 @param keyPath 观察的键
 */
- (void)kc_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end
