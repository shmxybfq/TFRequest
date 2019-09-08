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
    return [self requestWithParam:param inView:nil requestFinish:finish requestFailed:failed];
}

+(instancetype)requestWithDic:(NSDictionary *)dic
                       inView:(UIView *)inView
                requestFinish:(RequestFinishBlock)finish
                requestFailed:(RequestFailedBlock)failed{
    TFRequestParam *param = [TFRequestParam paramWithDictionary:dic];
    return [self requestWithParam:param inView:inView requestFinish:finish requestFailed:failed];
}

+(instancetype)requestWithParam:(TFRequestParam *)param
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed{
    return [self requestWithParam:param inView:nil requestFinish:finish requestFailed:failed];
}

+(instancetype)requestWithParam:(TFRequestParam *)param
                         inView:(UIView *)inView
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed{
    
    return [self requestWithParam:param
                           inView:inView
                     requestStart:nil
                    requestUpload:nil
                  requestProgress:nil
                    requestFinish:finish
                  requestCanceled:nil
                    requestFailed:failed];
}

+(instancetype)requestWithParam:(TFRequestParam *)param
                         inView:(UIView *)inView
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed{
    
    return [self requestWithParam:param
                           inView:inView
                     requestStart:nil
                    requestUpload:upload
                  requestProgress:progress
                    requestFinish:finish
                  requestCanceled:nil
                    requestFailed:failed];
}


+(instancetype)requestWithParam:(TFRequestParam *)param
                         inView:(UIView *)inView
                   requestStart:(RequestStartBlock)start
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                requestCanceled:(RequestCanceledBlock)canceled
                  requestFailed:(RequestFailedBlock)failed{
    
    id request =  [[[self class]alloc]initWithParam:param
                                             inView:inView
                                       requestStart:start
                                      requestUpload:upload
                                    requestProgress:progress
                                         completion:nil
                                      requestFinish:finish
                                    requestCanceled:canceled
                                      requestFailed:failed];
    [(TFBaseRequest *)request beginRequest];
    return request;
}


+(instancetype)requestWithDownloadRequest:(NSURLRequest *)downRequest
                                   inView:(UIView *)inView
                             requestStart:(RequestStartBlock)start
                          requestProgress:(RequestProgressBlock)progress
                               completion:(RequestDownloadcompletionBlock)completion{
    TFRequestParam *param = [TFRequestParam new];
    id request =  [[[self class]alloc]initWithParam:param
                                             inView:inView
                                       requestStart:start
                                      requestUpload:nil
                                    requestProgress:progress
                                         completion:completion
                                      requestFinish:nil
                                    requestCanceled:nil
                                      requestFailed:nil];
    ((TFBaseRequest *)request).downLoadRequest = downRequest;
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

- (NSData   *)configureDownloadResumeData{
    return nil;
}
- (NSURL    *)configureDownloadDestinationPath:(NSURL *)targetPath response:(NSURLResponse *)response{
    NSString *date = [NSDate date].description;
    date = [date stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *filePath = [NSString stringWithFormat:@"%@%@.file",NSTemporaryDirectory(),date];
    return [NSURL fileURLWithPath:filePath];
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
-(BOOL)configureCollectionLogIfRelease{
    return NO;
}

- (AFSecurityPolicy *)configureSecurityPolicy{
    AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    return policy;
}


-(instancetype)initWithParam:(TFRequestParam *)param
                      inView:(UIView *)inView
                requestStart:(RequestStartBlock)start
               requestUpload:(RequestUploadDataBlock)upload
             requestProgress:(RequestProgressBlock)progress
                  completion:(RequestDownloadcompletionBlock)completion
               requestFinish:(RequestFinishBlock)finish
             requestCanceled:(RequestCanceledBlock)canceled
               requestFailed:(RequestFailedBlock)failed{
    if (self = [super init]) {
        
        //保存 回调 block
        if (param && [param isKindOfClass:[TFRequestParam class]]) _params = param;
        if (inView) _inView = inView;
        if (start) _startBlock = [start copy];
        if (upload) _uploadBlock = [upload copy];
        if (progress) _progressBlock = [progress copy];
        if (completion) _downloadcompletionBlock = [completion copy];
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
    //获取baseUrl
    if ([self.paramDelegate respondsToSelector:@selector(configureBaseUrl)]) {
        _baseUrl = [[self.paramDelegate configureBaseUrl] copy];
    }else{
        _baseUrl = nil;
    }
    //获取url
    if ([self.paramDelegate respondsToSelector:@selector(configureUrl)]) {
        _url = [[self.paramDelegate configureUrl] copy];
    }else{
        _url = nil;
    }
    //获取请求类型
    if ([self.paramDelegate respondsToSelector:@selector(configureRequestType)]) {
        _requestType = [self.paramDelegate configureRequestType];
    }else{
        _requestType = RequestTypeForm;
    }
    //获取请求方法
    if ([self.paramDelegate respondsToSelector:@selector(configureRequestMethod)]) {
        _requestMethod = [self.paramDelegate configureRequestMethod];
    }else{
        _requestMethod = RequestMethodPost;
    }
    //获取请求头
    if ([self.paramDelegate respondsToSelector:@selector(configureHeader)]) {
        NSDictionary *dic = [self.paramDelegate configureHeader];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            _header = [NSMutableDictionary dictionaryWithDictionary:dic];
        }else{
            _header = nil;
        }
    }else{
        _header = nil;
    }
    //获取默认参数
    if ([self.paramDelegate respondsToSelector:@selector(configureDefalutParams)]) {
        NSDictionary *dic = [self.paramDelegate configureDefalutParams];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            _defalutParams = [NSMutableDictionary dictionaryWithDictionary:dic];
        }else{
            _defalutParams = nil;
        }
    }else{
        _defalutParams = nil;
    }
    //获取安全策略
    if([self.paramDelegate respondsToSelector:@selector(configureSecurityPolicy)]){
        _securityPolicy = [self.paramDelegate configureSecurityPolicy];
    }else{
        _securityPolicy = nil;
    }
    //获取release状态下是否收集bug
    if([self.paramDelegate respondsToSelector:@selector(configureCollectionLogIfRelease)]){
        _collectionLogIfRelease = [self.paramDelegate configureCollectionLogIfRelease];
    }else{
        _collectionLogIfRelease = NO;
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
    [self.task resume];
}

-(NSURLSessionTask *)sendRequest{
    
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
    __block NSURLSessionTask *sessionTask = nil;
    
    //将要发送请求
    if([self.requestDelegate respondsToSelector:@selector(requestProgressWillSendRequest:task:)]){
        progressContinue = [self.requestDelegate requestProgressWillSendRequest:self
                                                                           task:sessionTask];
        if (progressContinue == NO) { return sessionTask;}
    }
    switch (self.requestMethod) {
        case RequestMethodPost:{
            self.startTime = CFAbsoluteTimeGetCurrent();
            sessionTask = [sessionManager POST:enUrl parameters:enParam progress:^(NSProgress * _Nonnull downloadProgress) {
                //正在请求
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                    [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                           task:sessionTask
                                                                       progress:downloadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求完成
                weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                sessionTask = task;
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
                weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                sessionTask = task;
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
            self.startTime = CFAbsoluteTimeGetCurrent();
            sessionTask = [sessionManager GET:enUrl parameters:enParam progress:^(NSProgress * _Nonnull downloadProgress) {
                //正在请求
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                    [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                           task:sessionTask
                                                                       progress:downloadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求完成
                weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                sessionTask = task;
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
                weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                sessionTask = task;
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
            self.startTime = CFAbsoluteTimeGetCurrent();
            sessionTask = [sessionManager POST:enUrl parameters:enParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (weakSelf.uploadBlock) {
                    weakSelf.uploadBlock(formData);
                    if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressUploadDidJointedFormdataRequest:task:formData:)]) {
                        [weakSelf.requestDelegate requestProgressUploadDidJointedFormdataRequest:weakSelf task:sessionTask formData:formData];
                    }
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                //正在请求
                if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                    [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                           task:sessionTask
                                                                       progress:uploadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求完成
                weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                sessionTask = task;
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
                weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                sessionTask = task;
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
        case RequestMethodDownload:{
            NSData *data = [self configureDownloadResumeData];
            if (data && [data isKindOfClass:[NSData class]]) {
                self.startTime = CFAbsoluteTimeGetCurrent();
                sessionTask = [sessionManager downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
                    //正在下载
                    if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                        [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                               task:sessionTask
                                                                           progress:downloadProgress];
                    }
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    return [weakSelf configureDownloadDestinationPath:targetPath response:response];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    //下载完成
                    NSLog(@"下载完成2");
                    weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                    weakSelf.downloadResponse = response;
                    weakSelf.downloadFilePath = filePath;
                    weakSelf.error = error;
                    if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFinishRequest:task:responseObject:)]){
                        [weakSelf.requestDelegate requestProgressDidFinishRequest:weakSelf
                                                                             task:sessionTask
                                                                   responseObject:nil];
                    }
                    if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFinishCallBack:task:progress:responseObject:withError:)]) {
                        BOOL con = [weakSelf.requestDelegate requestProgressWillFinishCallBack:weakSelf
                                                                                          task:sessionTask
                                                                                      progress:nil
                                                                                responseObject:nil
                                                                                     withError:error];
                        if(weakSelf.finishBlock && con){
                            weakSelf.finishBlock(weakSelf);
                            [weakSelf.requestDelegate requestProgressDidFinishCallBack:weakSelf
                                                                                  task:sessionTask
                                                                              progress:nil
                                                                        responseObject:nil
                                                                             withError:error];
                        }
                    }
                    [[TFRequestManager shareInstance]removeRequest:weakSelf];
                }];
            }else{
                self.startTime = CFAbsoluteTimeGetCurrent();
                sessionTask = [sessionManager downloadTaskWithRequest:self.downLoadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
                    //正在下载
                    NSLog(@"222");
                    if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressProgressingRequest:task:progress:)]){
                        [weakSelf.requestDelegate requestProgressProgressingRequest:weakSelf
                                                                               task:sessionTask
                                                                           progress:downloadProgress];
                    }
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSLog(@"111");
                    return [weakSelf configureDownloadDestinationPath:targetPath response:response];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    //下载完成
                    NSLog(@"下载完成1");
                    weakSelf.endTime = CFAbsoluteTimeGetCurrent();
                    weakSelf.downloadResponse = response;
                    weakSelf.downloadFilePath = filePath;
                    weakSelf.error = error;
                    if([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressDidFinishRequest:task:responseObject:)]){
                        [weakSelf.requestDelegate requestProgressDidFinishRequest:weakSelf
                                                                             task:sessionTask
                                                                   responseObject:nil];
                    }
                    if ([weakSelf.requestDelegate respondsToSelector:@selector(requestProgressWillFinishCallBack:task:progress:responseObject:withError:)]) {
                        BOOL con = [weakSelf.requestDelegate requestProgressWillFinishCallBack:weakSelf
                                                                                          task:sessionTask
                                                                                      progress:nil
                                                                                responseObject:nil
                                                                                     withError:error];
                        if(weakSelf.finishBlock && con){
                            weakSelf.finishBlock(weakSelf);
                            [weakSelf.requestDelegate requestProgressDidFinishCallBack:weakSelf
                                                                                  task:sessionTask
                                                                              progress:nil
                                                                        responseObject:nil
                                                                             withError:error];
                        }
                    }
                    [[TFRequestManager shareInstance]removeRequest:weakSelf];
                }];
            }
        }
        default:break;
    }
    //已经发送请求等待请求结果
    if([self requestDelegate]){
        if ([self.requestDelegate respondsToSelector:@selector(requestProgressDidSendRequest:task:)]) {
            [weakSelf.requestDelegate requestProgressDidSendRequest:self task:sessionTask];
        }
    }
    return sessionTask;
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


