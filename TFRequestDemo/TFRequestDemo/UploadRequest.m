//
//  UploadRequest.m
//  TFRequestDemo
//
//  Created by zhutaofeng on 2019/11/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "UploadRequest.h"

@implementation UploadRequest

//-(NSString *)configureBaseUrl{
//    return @"http://180.76.121.105:8296";
//}

-(NSString *)configureUrl{
    return @"app/img/upload";
}

- (RequestMethod)configureRequestMethod {
    return RequestMethodUploadPost;
}

@end
