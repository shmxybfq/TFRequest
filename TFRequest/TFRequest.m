//
//  TFRequest.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFRequest.h"
#import "TFRequestParam.h"
#import "TFRequestManager.h"
@implementation TFRequest

-(BOOL)requestProgressWillFinishCallBack:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress
                          responseObject:(id)responseObject
                               withError:(NSError *)error{
    
    BOOL con = [super requestProgressWillFinishCallBack:request
                                                   task:task
                                               progress:progress
                                         responseObject:responseObject
                                              withError:error];
    if (con) {
        NSError *error = nil;
        id json = nil;
        @try {
            json = [NSJSONSerialization JSONObjectWithData:self.responseObject
                                                   options:NSJSONReadingMutableLeaves
                                                     error:&error];
        } @catch (NSException *exception) {
            con = NO;
            self.error = error;
        } @finally {
            RequestLog(@"服务器返回数据解析错误:parse error! : %@",self.responseObject);
        }
        if (error == nil) {
            self.responseJson = json;
        }
    }
    return con;
}


-(void)requestProgressDidFinishRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    [super requestProgressDidFinishRequest:request task:task responseObject:responseObject];
    [self doLogWithSuccess:YES];
}

-(void)requestProgressDidFailedRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task withError:(NSError *)error{
    [super requestProgressDidFailedRequest:request task:task withError:error];
    [self doLogWithSuccess:NO];
}


- (void)doLogWithSuccess:(BOOL)suc{
    if (self.params.closeLog) {
        return;
    }
#ifdef DEBUG
    NSData *data = nil;
    id json = nil;
    @try {
        json = [NSJSONSerialization JSONObjectWithData:self.responseObject
                                               options:NSJSONReadingMutableLeaves
                                                 error:nil];
    }@catch (NSException *exception) {} @finally {}
    
    @try {
        data = [NSJSONSerialization dataWithJSONObject:json
                                               options:NSJSONWritingPrettyPrinted
                                                 error:nil];
    } @catch (NSException *exception) {} @finally {}
    
    NSString * dataString;
    if (data) {
        dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSMutableString *log = [NSMutableString string];
    [log appendFormat:@"\n=========== request-begin =============="];
    [log appendFormat:@"\n time:(%@)",[NSDate date]];
    [log appendFormat:@"\n url:(%@)",self.totalUrl];
    [log appendFormat:@"\n header:(%@)",self.header];
    [log appendFormat:@"\n param:%@",self.params.param];
    [log appendFormat:@"\n defalutParams:%@",self.defalutParams];
    [log appendFormat:@"\n totalParams:%@",self.totalParams];
    if(suc){
        [log appendFormat:@"\nserver原数据 string:%@",[[NSString alloc]initWithData:self.responseObject encoding:NSUTF8StringEncoding]];
        [log appendFormat:@"\nserver原数据 json:%@",self.responseJson];
        [log appendFormat:@"\nserver原数据转中文 json:%@",dataString];
    }else{
        [log appendFormat:@"\n error:%@",self.error];
    }
    [log appendFormat:@"\n=========== request-end =============="];
    
    [[TFRequestManager shareInstance] addLog:[NSString stringWithString:log]];
    RequestLog(@"%@",log);
    
#endif
}

@end
