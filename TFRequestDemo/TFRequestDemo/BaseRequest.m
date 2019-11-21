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
    [header setObject:@"375x812" forKey:@"screenSize"];
    [header setObject:@"ios" forKey:@"source"];
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [header setObject:version forKey:@"version"];
    //设备系统版本号
    [header setObject:[UIDevice currentDevice].systemVersion forKey:@"systemVersion"];
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

//配置证书
//-(AFSecurityPolicy *)configureSecurityPolicy{
//    //导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"你的证书文件" ofType:@"cer"];//证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    //AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    //如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    /**
//     *  validatesDomainName 是否需要验证域名，默认为YES；
//     *  假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//     *  置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//     *  如置为NO，建议自己添加对应域名的校验逻辑。
//     *
//     */
//    securityPolicy.validatesDomainName = NO;
//    securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
//    return securityPolicy;
//}


#pragma mark
//----------------------  监听(阻断)请求过程   ----------------------
//----------------------  也可以监听(阻断)其他请求过程   ----------------------
- (BOOL)requestProgressDidGetParams:(TFBaseRequest *)request{
    
    return YES;
}

-(void)requestProgressDidFinishRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    [super requestProgressDidFinishRequest:request task:task responseObject:responseObject];
}


@end
