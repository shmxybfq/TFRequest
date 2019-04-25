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
  
    //上传图片、视频、其他
//    [TFRequest requestWithParam:nil requestUpload:^(id<AFMultipartFormData> formData) {
//
//        NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@""], 0.7);
//        [formData appendPartWithFileData:data
//                                    name:@"file"
//                                fileName:[NSString stringWithFormat:@"image%d.jpg",0]
//                                mimeType:@"image/jpg"];
//
//    } requestProgress:^(id request, NSProgress *progress) {
//
//    } requestFinish:^(id request) {
//
//    } requestFailed:^(id request) {
//
//    }];
}




@end
