//
//  ViewController.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "TestRequest.h"
#import "DownloadRequest.h"
#import "UploadRequest.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.postButton addTarget:self
                        action:@selector(postButtonClick)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.uploadButton addTarget:self
                          action:@selector(uploadButtonClick)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.downloadButton addTarget:self
                            action:@selector(downloadButtonClick)
                  forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

-(void)postButtonClick{
    self.textView.text = @"";
    __weak __typeof(self)weakSelf = self;
    
    
    [TestRequest requestWithDic/*requestWithParam*/:nil inView:self.view requestFinish:^(TestRequest *request) {
        
//        以下参数可以在请求完成后获得
//        request.paramDelegate;
//        request.requestDelegate;
//
//        request.task;
//        request.sessionManager;
//        request.downloadResponse;
//        request.downloadFilePath;
//
//        request.startBlock;
//        request.uploadBlock;
//        request.downloadcompletionBlock;
//        request.finishBlock;
//        request.canceledBlock;
//        request.failedBlock;
//        request.progressBlock;
//
//        request.url;//请求的url,最终会和baseUrl,拼成totalUrl
//        request.baseUrl;//baseUrl,最终会和url,拼成totalUrl
//        request.totalUrl;//baseUrl和url拼的
//        request.downLoadRequest;//下载的Request
//        request.requestType;//请求类型
//        request.requestMethod;//请求方法
//        request.securityPolicy;//隐私策略
//
//        request.header;//请求头
//        request.params;//请求参数
//        request.defalutParams;//请求默认参数
//        request.totalParams;//params.param和defalutParams的和
//        request.timeoutInterval;//请求超时的时间
//
//        request.inView;
//
//        request.error;
//
//        request.responseObject;
//        request.responseJson;
//
//        request.startTime;
//        request.endTime;
//        request.collectionLogIfRelease;
        
        weakSelf.textView.text = [NSString stringWithFormat:@"%@",request.responseJson];
        
    } requestFailed:^(TestRequest *request) {
        
        weakSelf.textView.text = [NSString stringWithFormat:@"%@",request.error];
        
    }];
}

-(void)downloadButtonClick{
    
    self.textView.text = @"";
    
    
    NSString *url = [NSString stringWithFormat:@"http://5b0988e595225.cdn.sohucs.com/images/20171218/042d939d112146a8ac48ba584daa36d0.jpeg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    TFRequestParam *param = [TFRequestParam new];//可自己创建此类的子类来协助实现更多需求
    [DownloadRequest requestWithDownloadRequest:request param:param inView:nil requestStart:^(DownloadRequest *request) {
        
        
    } requestProgress:^(DownloadRequest *request, NSProgress *progress) {
        
        NSLog(@"下载进度:%@",@(progress.fractionCompleted));
        
    } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            NSLog(@">>>>>>>下载失败:%@",error);
        }else{
            NSLog(@">>>>>>>下载成功:%@",filePath);
        }
    }];
    
}


-(void)uploadButtonClick{
    
    self.textView.text = @"";
    
    [UploadRequest requestWithParam:nil inView:self.view requestUpload:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"test_img"]);
        NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate];
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpeg",@(timeInterval)] mimeType:@"image/jpeg"];
        
    } requestProgress:^(UploadRequest *request, NSProgress *progress) {
        
        NSLog(@"上传进度:%@",@(progress.fractionCompleted));
        
    } requestFinish:^(UploadRequest *request) {
        
        NSLog(@">>>>>>>上传成功");
        
    } requestFailed:^(UploadRequest *request) {
        
        NSLog(@">>>>>>>上传失败:%@",request.error);
        
    }];
    
    
}


@end
