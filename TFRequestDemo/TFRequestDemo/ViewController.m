//
//  ViewController.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "TestRequest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [TestRequest requestWithDic:nil requestFinish:^(id request) {
        
    } requestFailed:^(id request) {
        
    }];
    
}




@end
