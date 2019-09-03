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

-(void)requestProgressDidFinishRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    
    [super requestProgressDidFinishRequest:request task:task responseObject:responseObject];
    
    NSError *error = nil;
    id json = nil;
    @try {
        json = [NSJSONSerialization JSONObjectWithData:self.responseObject
                                               options:NSJSONReadingMutableLeaves
                                                 error:&error];
    } @catch (NSException *exception) {
        self.error = error;
        RequestLog(@"服务器返回数据解析错误:parse error! : %@",self.responseObject);
    } @finally {
        
    }
    if (error == nil) {
        self.responseJson = json;
    }
    
    [self doLogWithSuccess:YES];
}

-(void)requestProgressDidFailedRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task withError:(NSError *)error{
    
    [super requestProgressDidFailedRequest:request task:task withError:error];
    
    [self doLogWithSuccess:NO];
}


- (void)doLogWithSuccess:(BOOL)suc{
    
    BOOL doLog = NO;
#ifdef DEBUG
    if (self.params.closeLog == NO) {
        doLog = YES;
    }
#else
    if (self.configureCollectionLogIfRelease) {
        doLog = YES;
    }
#endif
    if (doLog) {
        NSData *data = nil;
        id json = nil;
        NSMutableString *log = [NSMutableString string];
        [log appendFormat:@"\n===================== request-begin ====================="];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【request-time】：%f",self.endTime - self.startTime];
        if (self.responseObject) {
            @try {
                json = [NSJSONSerialization JSONObjectWithData:self.responseObject
                                                       options:NSJSONReadingMutableLeaves
                                                         error:nil];
            }@catch (NSException *exception) {
                [log appendFormat:@"\n"];
                [log appendFormat:@"\n 【responseObject->json解析异常】"];
            } @finally {}
        }
        
        if (json) {
            @try {
                data = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
            } @catch (NSException *exception) {
                [log appendFormat:@"\n"];
                [log appendFormat:@"\n 【json->data解析异常】"];
            } @finally {}
        }
        
        
        NSString * dataString;
        if (data) {
            dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【time】:(%@)",[NSDate date]];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n [#placeholder#]"];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【url】:(%@)",self.totalUrl];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【custem-header】:(%@)",self.header];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【all-header】:(%@)",self.task.currentRequest.allHTTPHeaderFields];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【param】:%@",self.params.param];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【defalutParams】:%@",self.defalutParams];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n 【totalParams】:%@",self.totalParams];
        [log appendFormat:@"\n"];
        if(suc){
            [log appendFormat:@"\n【server origin data】:%@",[[NSString alloc]initWithData:self.responseObject encoding:NSUTF8StringEncoding]];
            [log appendFormat:@"\n"];
            [log appendFormat:@"\n【server origin json】:%@",self.responseJson];
            [log appendFormat:@"\n"];
            [log appendFormat:@"\n【server origin json to chinese】:%@",dataString];
        }else{
            [log appendFormat:@"\n【error】:%@",self.error];
        }
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n [#placeholder#]"];
        [log appendFormat:@"\n"];
        [log appendFormat:@"\n===================== request-end ====================="];
        
        [[TFRequestManager shareInstance] addLog:[NSString stringWithString:log]];
        RequestLog(@"%@",log);
    }
}

@end
