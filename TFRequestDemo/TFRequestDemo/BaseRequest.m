//
//  BaseRequest.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/22.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest

-(void)dealloc{
    NSLog(@">>>>>>>>dealloc 请求释放:%@",[self class]);
}

#pragma mark ----------------------  配置请求参数   ----------------------

-(NSString *)configureBaseUrl{
    return @"http://180.76.121.105:8296";
}


-(NSDictionary *)configureHeader{
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:@"1" forKey:@"appBundleVersion"];
    [header setObject:@"1.0" forKey:@"appVersion"];
    [header setObject:@"US" forKey:@"countryCode"];
    [header setObject:@"en" forKey:@"lang"];
    [header setObject:@"375x812" forKey:@"screenSize"];
    [header setObject:@"ios" forKey:@"source"];
    [header setObject:@"12.1" forKey:@"systemVersion"];
    return header;
}

-(NSDictionary *)configureDefalutParams{
    
    NSString *json = @"[{\"eventTime\":\"2019-02-21 08:54:28 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"loginStatus_logging\",\"longitude\":\"\",\"pageName\":\"LoginViewController\"},{\"eventTime\":\"2019-02-21 08:54:29 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"loginStatus_welcomeBack\",\"longitude\":\"\",\"pageName\":\"QuickLoginView\"},{\"eventTime\":\"2019-02-21 08:54:31 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"time_enter\",\"longitude\":\"\",\"pageName\":\"FloatingIconsWindow\"},{\"eventTime\":\"2019-02-21 08:54:32 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"no_wallet\",\"longitude\":\"\",\"pageName\":\"WalletViewController\"},{\"eventTime\":\"2019-02-21 08:54:33 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"no_wallet\",\"longitude\":\"\",\"pageName\":\"WalletViewController\"},{\"eventTime\":\"2019-02-21 08:54:35 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"no_wallet\",\"longitude\":\"\",\"pageName\":\"WalletViewController\"},{\"eventTime\":\"2019-02-21 08:54:36 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"no_wallet\",\"longitude\":\"\",\"pageName\":\"WalletViewController\"},{\"eventTime\":\"2019-02-21 08:54:37 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"no_wallet\",\"longitude\":\"\",\"pageName\":\"WalletViewController\"},{\"eventTime\":\"2019-02-21 08:54:39 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"no_wallet\",\"longitude\":\"\",\"pageName\":\"WalletViewController\"},{\"eventTime\":\"2019-02-21 08:54:40 \",\"kEventIndexKey\":0,\"latitude\":\"\",\"eventType\":\"no_wallet\",\"longitude\":\"\",\"pageName\":\"WalletViewController\"}]";
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header setObject:@"1" forKey:@"gameId"];
    [header setObject:json forKey:@"json"];
    return header;
}

-(RequestType)configureRequestType{
    return RequestTypeJson;
}

-(RequestMethod)configureRequestMethod{
    return RequestMethodPost;
}



#pragma mark ----------------------  监听(阻断)请求过程   ----------------------

- (BOOL)requestProgressDidGetParams:(TFBaseRequest *)request{
    
    return YES;
}

-(void)requestProgressDidFinishRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    [super requestProgressDidFinishRequest:request task:task responseObject:responseObject];
}


@end
