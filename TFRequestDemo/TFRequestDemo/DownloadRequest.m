//
//  DownloadRequest.m
//  TFRequestDemo
//
//  Created by zhutaofeng on 2019/11/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "DownloadRequest.h"

@implementation DownloadRequest

-(RequestMethod)configureRequestMethod {
    return RequestMethodDownload;
}

-(NSURL *)configureDownloadDestinationPath:(NSURL *)targetPath response:(NSURLResponse *)response{
    NSAssert(NO, @"");
    return nil;
    
    NSString *string = self.downLoadRequest.URL.absoluteString;
    NSString *filePath = [NSString stringWithFormat:@"%@%@",@"/Users/xxx/Desktop/trueResult/xxx.jpg",string];
    return [NSURL fileURLWithPath:filePath];
}



@end
