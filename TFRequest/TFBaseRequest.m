//
//  TFBaseRequest.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFBaseRequest.h"
@interface TFBaseRequest()

@end;

@implementation TFBaseRequest

+(instancetype)requestWithDic:(NSDictionary *)dic
                requestFinish:(RequestFinishBlock)finish
                requestFailed:(RequestFailedBlock)failed{
    TFRequestParam *param = [TFRequestParam paramWithDictionary:dic];
    return [self requestWithParam:param requestFinish:finish requestFailed:failed];
}

+(instancetype)requestWithParam:(TFRequestParam *)param
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed{
    
    return [self requestWithParam:param
                     requestStart:nil
                    requestUpload:nil
                  requestProgress:nil
                    requestFinish:finish
                  requestCanceled:nil
                    requestFailed:failed];
}

+(instancetype)requestWithParam:(TFRequestParam *)param
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed{
    
    return [self requestWithParam:param
                     requestStart:nil
                    requestUpload:upload
                  requestProgress:progress
                    requestFinish:finish
                  requestCanceled:nil
                    requestFailed:failed];
}


+(instancetype)requestWithParam:(TFRequestParam *)param
                   requestStart:(RequestStartBlock)start
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                requestCanceled:(RequestCanceledBlock)canceled
                  requestFailed:(RequestFailedBlock)failed{
    
    id request =  [[[self class]alloc]initWithParam:param
                                       requestStart:start
                                      requestUpload:upload
                                    requestProgress:progress
                                      requestFinish:finish
                                    requestCanceled:canceled
                                      requestFailed:failed];
    [(TFBaseRequest *)request beginRequest];
    return request;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        
        _url = [aDecoder decodeObjectForKey:@"_url"];
        _baseUrl = [aDecoder decodeObjectForKey:@"_baseUrl"];
        _totalUrl = [aDecoder decodeObjectForKey:@"_totalUrl"];
        
        _requestType = [aDecoder decodeIntegerForKey:@"_requestType"];
        _requestMethod = [aDecoder decodeIntegerForKey:@"_requestMethod"];
        _securityPolicy = [aDecoder decodeObjectForKey:@"_securityPolicy"];
        
        _header = [aDecoder decodeObjectForKey:@"_header"];
        
        _params = [aDecoder decodeObjectForKey:@"_params"];
        _defalutParams = [aDecoder decodeObjectForKey:@"_defalutParams"];
        _totalParams = [aDecoder decodeObjectForKey:@"_totalParams"];
        
        _error = [aDecoder decodeObjectForKey:@"_error"];
        _responseObject = [aDecoder decodeObjectForKey:@"_responseObject"];
        _responseJson = [aDecoder decodeObjectForKey:@"_responseJson"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    if (_url)[aCoder encodeObject:_url forKey:@"_url"];
    if (_baseUrl)[aCoder encodeObject:_baseUrl forKey:@"_baseUrl"];
    if (_totalUrl)[aCoder encodeObject:_totalUrl forKey:@"_totalUrl"];
    
    [aCoder encodeInteger:_requestType forKey:@"_requestType"];
    [aCoder encodeInteger:_requestMethod forKey:@"_requestMethod"];
    if (_securityPolicy)[aCoder encodeObject:_securityPolicy forKey:@"_securityPolicy"];
    
    if (_header)[aCoder encodeObject:_header forKey:@"_header"];
    
    if (_params)[aCoder encodeObject:_params forKey:@"_params"];
    if (_defalutParams)[aCoder encodeObject:_defalutParams forKey:@"_defalutParams"];
    if (_totalParams)[aCoder encodeObject:_totalParams forKey:@"_totalParams"];
    
    if (_error)[aCoder encodeObject:_error forKey:@"_error"];
    if (_responseObject)[aCoder encodeObject:_responseObject forKey:@"_responseObject"];
    if (_responseJson)[aCoder encodeObject:_responseJson forKey:@"_responseJson"];
}



#pragma mark ----------------------  配置请求参数   ----------------------
- (NSString *)configureBaseUrl{
    return @"";
}
- (NSString *)configureUrl{
    return @"";
}
- (RequestType)configureRequestType {
    return RequestTypeForm;
}
- (RequestMethod)configureRequestMethod {
    return RequestMethodPost;
}
- (NSDictionary *)configureHeader{
    return @{};
}
- (NSDictionary *)configureDefalutParams{
    return @{};
}

- (AFSecurityPolicy *)configureSecurityPolicy{
    AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    return policy;
    /**
     *  导入证书
     */
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"你的证书文件" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    /**
     *  AFSSLPinningModeCertificate 使用证书验证模式
     */
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    
    /**
     * allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
     * 如果是需要验证自建证书，需要设置为YES
     */
    securityPolicy.allowInvalidCertificates = YES;
    
    
    /**
     *  validatesDomainName 是否需要验证域名，默认为YES；
     *  假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
     *  置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
     *  如置为NO，建议自己添加对应域名的校验逻辑。
     *
     */
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
    
    return securityPolicy;
}


-(instancetype)initWithParam:(TFRequestParam *)param
                requestStart:(RequestStartBlock)start
               requestUpload:(RequestUploadDataBlock)upload
             requestProgress:(RequestProgressBlock)progress
               requestFinish:(RequestFinishBlock)finish
             requestCanceled:(RequestCanceledBlock)canceled
               requestFailed:(RequestFailedBlock)failed{
    if (self = [super init]) {
        
        //保存 回调 block
        if (param && [param isKindOfClass:[TFRequestParam class]]) _params = param;
        if (start) _startBlock = [start copy];
        if (upload) _uploadBlock = [upload copy];
        if (progress) _progressBlock = [progress copy];
        if (finish) _finishBlock = [finish copy];
        if (canceled) _canceledBlock = [canceled copy];
        if (failed) _failedBlock = [failed copy];
        
    }
    return self;
}

-(void)cancelRequest{
    [[TFRequestManager shareInstance]removeRequest:self];
}

-(void)beginRequest{
    
    self.paramDelegate = self;
    self.requestDelegate = self;
    
    [[TFRequestManager shareInstance] addRequest:self];
    
    BOOL progressContinue = YES;
    //对象创建完毕
    if([self.requestDelegate respondsToSelector:@selector(requestProgressInit:)]){
        progressContinue = [self.requestDelegate requestProgressInit:self];
        if (progressContinue == NO) { return;}
    }
    //开始获取参数
    if([self.requestDelegate respondsToSelector:@selector(requestProgressWillGetParams:)]){
        progressContinue = [self.requestDelegate requestProgressWillGetParams:self];
        if (progressContinue == NO) { return;}
    }
    //代理获取baseUrl
    if ([self.paramDelegate respondsToSelector:@selector(configureBaseUrl)]) {
        _baseUrl = [[self.paramDelegate configureBaseUrl] copy];
    }else{
        _baseUrl = nil;
    }
    //代理获取url
    if ([self.paramDelegate respondsToSelector:@selector(configureUrl)]) {
        _url = [[self.paramDelegate configureUrl] copy];
    }else{
        _url = nil;
    }
    //代理获取请求类型
    if ([self.paramDelegate respondsToSelector:@selector(configureRequestType)]) {
        _requestType = [self.paramDelegate configureRequestType];
    }else{
        _requestType = RequestTypeForm;
    }
    //代理获取请求方法
    if ([self.paramDelegate respondsToSelector:@selector(configureRequestMethod)]) {
        _requestMethod = [self.paramDelegate configureRequestMethod];
    }else{
        _requestMethod = RequestMethodPost;
    }
    //代理获取请求头
    if ([self.paramDelegate respondsToSelector:@selector(configureHeader)]) {
        _header = [self.paramDelegate configureHeader];
    }else{
        _header = nil;
    }
    //代理获取默认参数
    if ([self.paramDelegate respondsToSelector:@selector(configureDefalutParams)]) {
        _defalutParams = [self.paramDelegate configureDefalutParams];
    }else{
        _defalutParams = nil;
    }
    //代理获取安全策略
    if([self.paramDelegate respondsToSelector:@selector(configureSecurityPolicy)]){
        _securityPolicy = [self.paramDelegate configureSecurityPolicy];
    }else{
        _securityPolicy = nil;
    }
    
    //拼接 baseUrl 和 Url
    if ([_baseUrl hasSuffix:@"/"]) {
        _baseUrl = [_baseUrl substringWithRange:NSMakeRange(0, _baseUrl.length - 1)];
    }
    if ([_url hasPrefix:@"/"]) {
        _url = [_url substringWithRange:NSMakeRange(1, _url.length - 1)];
    }
    _totalUrl = [NSString stringWithFormat:@"%@/%@",_baseUrl,_url];
    
    //拼接 默认参数 和 参数
    _totalParams = [[NSMutableDictionary alloc]init];
    if (_defalutParams && [_defalutParams isKindOfClass:[NSDictionary class]]) {
        [_totalParams addEntriesFromDictionary:_defalutParams];
    }
    if (_params.param && [_params.param isKindOfClass:[NSDictionary class]]) {
        [_totalParams addEntriesFromDictionary:_params.param];
    }
    
    //参数准备完毕
    if([self.requestDelegate respondsToSelector:@selector(requestProgressDidGetParams:)]){
        progressContinue = [self.requestDelegate requestProgressDidGetParams:self];
        if (progressContinue == NO) { return;}
    }
    
    self.task = [self sendRequest];
}

-(NSURLSessionDataTask *)sendRequest{
    
    kdeclare_weakself;
    BOOL progressContinue = YES;
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    self.sessionManager = sessionManager;
    switch (self.requestType) {
        case RequestTypeForm:{
            sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }break;
        case RequestTypeJson:{
            sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        }break;
        default:break;
    }
    sessionManager.requestSerializer.timeoutInterval = 30;
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (self.header && [self.header isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = self.header.allKeys;
        for (NSString *key in keys) {
            NSString *value = [self.header objectForKey:key];
            [sessionManager.requestSerializer setValue:value
                                    forHTTPHeaderField:key];
        }
    }
    [sessionManager setSecurityPolicy:self.securityPolicy];
    NSString *enUrl = @"";
    enUrl = [self.totalUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *enParam = [_totalParams isKindOfClass:[NSDictionary class]]?_totalParams:@{};
    __block NSURLSessionDataTask *dataTask = nil;
    //将要发送请求
    if([self.requestDelegate respondsToSelector:@selector(requestProgressWillSendRequest:task:)]){
        progressContinue = [self.requestDelegate requestProgressWillSendRequest:self
                                                                           task:dataTask];
        if (progressContinue == NO) { return dataTask;}
    }
    switch (self.requestMethod) {
        case RequestMethodPost:{
            dataTask = [sessionManager POST:enUrl parameters:enParam progress:^(NSProgress * _Nonnull downloadProgress) {
                //正在请求
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                    [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                       task:dataTask
                                                                   progress:downloadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求完成
                dataTask = task;
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFinishRequest:task:responseObject:)]){
                    [weakSelf.requestDelegate requestProgressDidFinishRequest:weakSelf
                                                                         task:task
                                                               responseObject:responseObject];
                }
                if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFinishCallBack:task:progress:responseObject:withError:)]) {
                    BOOL con = [weakSelf.requestDelegate requestProgressWillFinishCallBack:weakSelf
                                                                                      task:task
                                                                                  progress:nil
                                                                            responseObject:responseObject
                                                                                 withError:nil];
                    if(weakSelf.finishBlock && con){
                        weakSelf.finishBlock(weakSelf);
                        [weakSelf.requestDelegate requestProgressDidFinishCallBack:weakSelf
                                                                              task:task
                                                                          progress:nil
                                                                    responseObject:responseObject
                                                                         withError:nil];
                    }
                }
                
                [[TFRequestManager shareInstance]removeRequest:weakSelf];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求失败
                dataTask = task;
                weakSelf.error = error;
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFailedRequest:task:withError:)]){
                    [weakSelf.requestDelegate requestProgressDidFailedRequest:weakSelf
                                                                         task:task
                                                                    withError:error];
                }
                if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFailedCallBack:task:progress:responseObject:withError:)]) {
                    BOOL con = [weakSelf.requestDelegate requestProgressWillFailedCallBack:weakSelf
                                                                                      task:task
                                                                                  progress:nil
                                                                            responseObject:nil
                                                                                 withError:error];
                    if (weakSelf.failedBlock && con) {
                        weakSelf.failedBlock(weakSelf);
                        [weakSelf.requestDelegate requestProgressDidFailedCallBack:weakSelf
                                                                              task:task
                                                                          progress:nil
                                                                    responseObject:nil
                                                                         withError:error];
                    }
                }
                [[TFRequestManager shareInstance]removeRequest:weakSelf];
            }];
        }break;
        case RequestMethodGet:{
            dataTask = [sessionManager GET:enUrl parameters:enParam progress:^(NSProgress * _Nonnull downloadProgress) {
                //正在请求
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                    [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                       task:dataTask
                                                                   progress:downloadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求完成
                dataTask = task;
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFinishRequest:task:responseObject:)]){
                    [weakSelf.requestDelegate requestProgressDidFinishRequest:weakSelf
                                                                         task:task
                                                               responseObject:responseObject];
                }
                if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFinishCallBack:task:progress:responseObject:withError:)]) {
                    BOOL con = [weakSelf.requestDelegate requestProgressWillFinishCallBack:weakSelf
                                                                                      task:task
                                                                                  progress:nil
                                                                            responseObject:responseObject
                                                                                 withError:nil];
                    if(weakSelf.finishBlock && con){
                        weakSelf.finishBlock(weakSelf);
                        [weakSelf.requestDelegate requestProgressDidFinishCallBack:weakSelf
                                                                              task:task
                                                                          progress:nil
                                                                    responseObject:responseObject
                                                                         withError:nil];
                    }
                }
                [[TFRequestManager shareInstance]removeRequest:weakSelf];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求失败
                dataTask = task;
                weakSelf.error = error;
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFailedRequest:task:withError:)]){
                    [weakSelf.requestDelegate requestProgressDidFailedRequest:weakSelf
                                                                         task:task
                                                                    withError:error];
                }
                if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFailedCallBack:task:progress:responseObject:withError:)]) {
                    BOOL con = [weakSelf.requestDelegate requestProgressWillFailedCallBack:weakSelf
                                                                                      task:task
                                                                                  progress:nil
                                                                            responseObject:nil
                                                                                 withError:error];
                    if (weakSelf.failedBlock && con) {
                        weakSelf.failedBlock(weakSelf);
                        [weakSelf.requestDelegate requestProgressDidFailedCallBack:weakSelf
                                                                              task:task
                                                                          progress:nil
                                                                    responseObject:nil
                                                                         withError:error];
                    }
                }
                [[TFRequestManager shareInstance]removeRequest:weakSelf];
            }];
        }break;
        case RequestMethodUploadPost:{
            dataTask = [sessionManager POST:enUrl parameters:enParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (weakSelf.uploadBlock) {
                    weakSelf.uploadBlock(formData);
                    if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressUploadDidJointedFormdataRequest:task:formData:)]) {
                        [weakSelf.requestDelegate requestProgressUploadDidJointedFormdataRequest:weakSelf task:dataTask formData:formData];
                    }
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                //正在请求
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                    [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                       task:dataTask
                                                                   progress:uploadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求完成
                dataTask = task;
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFinishRequest:task:responseObject:)]){
                    [weakSelf.requestDelegate requestProgressDidFinishRequest:weakSelf
                                                                         task:task
                                                               responseObject:responseObject];
                }
                if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFinishCallBack:task:progress:responseObject:withError:)]) {
                    BOOL con = [weakSelf.requestDelegate requestProgressWillFinishCallBack:weakSelf
                                                                                      task:task
                                                                                  progress:nil
                                                                            responseObject:responseObject
                                                                                 withError:nil];
                    if(weakSelf.finishBlock && con){
                        weakSelf.finishBlock(weakSelf);
                        [weakSelf.requestDelegate requestProgressDidFinishCallBack:weakSelf
                                                                              task:task
                                                                          progress:nil
                                                                    responseObject:responseObject
                                                                         withError:nil];
                    }
                }
                [[TFRequestManager shareInstance]removeRequest:weakSelf];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //请求失败
                dataTask = task;
                weakSelf.error = error;
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFailedRequest:task:withError:)]){
                    [weakSelf.requestDelegate requestProgressDidFailedRequest:weakSelf
                                                                         task:task
                                                                    withError:error];
                }
                if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFailedCallBack:task:progress:responseObject:withError:)]) {
                    BOOL con = [weakSelf.requestDelegate requestProgressWillFailedCallBack:weakSelf
                                                                                      task:task
                                                                                  progress:nil
                                                                            responseObject:nil
                                                                                 withError:error];
                    if (weakSelf.failedBlock && con) {
                        weakSelf.failedBlock(weakSelf);
                        [weakSelf.requestDelegate requestProgressDidFailedCallBack:weakSelf
                                                                              task:task
                                                                          progress:nil
                                                                    responseObject:nil
                                                                         withError:error];
                    }
                }
                [[TFRequestManager shareInstance]removeRequest:weakSelf];
            }];
        }break;
        default:break;
    }
    //已经发送请求等待请求结果
    if([self requestDelegate]){
        if ([self.requestDelegate respondsToSelector:@selector(requestProgressDidSendRequest:task:)]) {
            [weakSelf.requestDelegate requestProgressDidSendRequest:self task:dataTask];
        }
    }
    return dataTask;
}




#pragma mark ----------------------  请求过程   ----------------------
-(BOOL)requestProgressInit:(TFBaseRequest *)request{
    return YES;
}
-(BOOL)requestProgressWillGetParams:(TFBaseRequest *)request{
    return YES;
}
-(BOOL)requestProgressDidGetParams:(TFBaseRequest *)request{
    return YES;
}
-(BOOL)requestProgressWillSendRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task{
    if (self.startBlock) {
        self.startBlock(self);
    }
    return YES;
}
-(void)requestProgressDidSendRequest:(TFBaseRequest *)request
                                task:(NSURLSessionDataTask *)task{
    
}
-(void)requestProgressUploadDidJointedFormdataRequest:(TFBaseRequest *)request
                                                 task:(NSURLSessionDataTask *)task
                                             formData:(id<AFMultipartFormData>)formData{
    
}
-(void)requestProgressProgressingRequest:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress{
    if (self.progressBlock) {
        self.progressBlock(self, progress);
    }
}
-(void)requestProgressDidFinishRequest:(TFBaseRequest *)request
                                  task:(NSURLSessionDataTask *)task
                        responseObject:(id)responseObject{
    self.responseObject = responseObject;
}
-(void)requestProgressDidCancelRequest{
    
}
-(void)requestProgressDidFailedRequest:(TFBaseRequest *)request
                                  task:(NSURLSessionDataTask *)task
                             withError:(NSError*)error{
    self.error = error;
}
-(BOOL)requestProgressWillFinishCallBack:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress
                          responseObject:(id)responseObject
                               withError:(NSError*)error{
    return YES;
}
-(void)requestProgressDidFinishCallBack:(TFBaseRequest *)request
                                   task:(NSURLSessionDataTask *)task
                               progress:(NSProgress *)progress
                         responseObject:(id)responseObject
                              withError:(NSError*)error{
    
}
-(BOOL)requestProgressWillFailedCallBack:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress
                          responseObject:(id)responseObject
                               withError:(NSError*)error{
    return YES;
}
-(void)requestProgressDidFailedCallBack:(TFBaseRequest *)request
                                   task:(NSURLSessionDataTask *)task
                               progress:(NSProgress *)progress
                         responseObject:(id)responseObject
                              withError:(NSError*)error{
    
}



@end
