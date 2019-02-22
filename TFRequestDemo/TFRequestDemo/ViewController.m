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
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.postButton addTarget:self
                        action:@selector(postButtonClick)
              forControlEvents:UIControlEventTouchUpInside];
    
   
    
}

-(void)postButtonClick{
    
    [TestRequest requestWithDic:nil requestFinish:^(TestRequest *request) {
        self.textView.text = [NSString stringWithFormat:@"%@",request.responseJson];
    } requestFailed:^(TestRequest *request) {
        self.textView.text = [NSString stringWithFormat:@"%@",request.error];
    }];
}


@end
