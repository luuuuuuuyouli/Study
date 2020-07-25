//
//  ViewController.m
//  001---KVO深入浅出
//
//  Created by Cooci on 2018/7/7.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+KCKVO.h"

@interface ViewController ()
@property (nonatomic, strong) Person *p;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.p = [[Person alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
