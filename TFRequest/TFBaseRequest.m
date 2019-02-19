//
//  TFBaseRequest.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFBaseRequest.h"
#import "AFNetworking.h"
#import "TFRequestParam.h"
#import "TFRequestManager.h"
@interface TFBaseRequest()

@property (nonatomic,strong)NSMutableString *requestLog;

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
                  requestProgress:nil
                    requestFinish:finish
                  requestCanceled:nil requestFailed:failed];
}

+(instancetype)requestWithParam:(TFRequestParam *)param
                   requestStart:(RequestStartBlock)start
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                requestCanceled:(RequestCanceledBlock)canceled
                  requestFailed:(RequestFailedBlock)failed{
    
    id request =  [[[self class]alloc]initWithParam:param
                                       requestStart:start
                                    requestProgress:progress
                                      requestFinish:finish
                                    requestCanceled:canceled
                                      requestFailed:failed];
    return request;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        
        _requestLog = [aDecoder decodeObjectForKey:@"_requestLog"];
        
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
    if (_requestLog)[aCoder encodeObject:_requestLog forKey:@"_requestLog"];
    
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



-(instancetype)initWithParam:(TFRequestParam *)param
                requestStart:(RequestStartBlock)start
             requestProgress:(RequestProgressBlock)progress
               requestFinish:(RequestFinishBlock)finish
             requestCanceled:(RequestCanceledBlock)canceled
               requestFailed:(RequestFailedBlock)failed{
    if (self = [super init]) {
        
        [[TFRequestManager shareInstance] addRequest:self];
        
        self.requestLog = [[NSMutableString alloc]init];
        
        self.paramDelegate = self;
        self.requestDelegate = self;
        
        BOOL progressContinue = YES;
        //对象创建完毕
        if([self requestDelegate]){
            progressContinue = [self.requestDelegate requestProgressInit:self];
            if (progressContinue == NO) { return self;}
        }
        //开始获取参数
        if([self requestDelegate]){
            progressContinue = [self.requestDelegate requestProgressWillGetParams:self];
            if (progressContinue == NO) { return self;}
        }
        //代理获取baseUrl
        if ([self.paramDelegate respondsToSelector:@selector(configureBaseUrl)]) {
            _baseUrl = [self.paramDelegate configureBaseUrl];
        }else{
            _baseUrl = nil;
        }
        //代理获取url
        if ([self.paramDelegate respondsToSelector:@selector(configureUrl)]) {
            _url = [self.paramDelegate configureUrl];
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
        
        //获取参数
        if (param && [param isKindOfClass:[TFRequestParam class]]) {
            _params = param;
        }else{
            _params = nil;
        }
        
        //拼接 baseUrl 和 Url
        if([_baseUrl hasSuffix:@"/"] || [_url hasPrefix:@"/"]){
            _totalUrl = [NSString stringWithFormat:@"%@%@",_baseUrl,_url];
        }else{
            _totalUrl = [NSString stringWithFormat:@"%@/%@",_baseUrl,_url];
        }
        
        //拼接 默认参数 和 参数
        _totalParams = [[NSMutableDictionary alloc]init];
        if (_defalutParams && [_defalutParams isKindOfClass:[NSDictionary class]]) {
            [_totalParams addEntriesFromDictionary:_defalutParams];
        }
        if (_params.param && [_params.param isKindOfClass:[NSDictionary class]]) {
            [_totalParams addEntriesFromDictionary:_params.param];
        }
        
        //保存 回调 block
        if (start) _startBlock = [start copy];
        if (progress) _progressBlock = [progress copy];
        if (finish) _finishBlock = [finish copy];
        if (canceled) _canceledBlock = [canceled copy];
        if (failed) _failedBlock = [failed copy];
        
        //参数准备完毕
        if([self requestDelegate]){
            progressContinue = [self.requestDelegate requestProgressDidGetParams:self];
            if (progressContinue == NO) { return self;}
        }
        
        self.task = [self sendRequest];
    }
    return self;
}

-(NSURLSessionDataTask *)sendRequest{
    
    kdeclare_weakself;
    BOOL progressContinue = YES;
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    switch (self.requestType) {
        case RequestTypeForm:{
            sessionManager.requestSerializer     = [AFHTTPRequestSerializer serializer];
        }break;
        case RequestTypeJson:{
            sessionManager.requestSerializer     = [AFJSONRequestSerializer serializer];
        }break;
        default:break;
    }
    sessionManager.requestSerializer.timeoutInterval = 30;
    sessionManager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    [self addRequestHeader:sessionManager];
    [sessionManager setSecurityPolicy:self.securityPolicy];
    NSString *enUrl = @"";
    enUrl = [self.totalUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *enParam = [_totalParams isKindOfClass:[NSDictionary class]]?_totalParams:@{};
    __block NSURLSessionDataTask *dataTask = nil;
    //将要发送请求
    if([self requestDelegate]){
        progressContinue = [self.requestDelegate requestProgressWillSendRequest:self
                                                                           task:dataTask];
        if (progressContinue == NO) { return dataTask;}
    }
    switch (self.requestMethod) {
        case RequestMethodPost:{
            dataTask = [sessionManager POST:enUrl parameters:enParam progress:^(NSProgress * _Nonnull downloadProgress) {
                //正在请求
                if([weakSelf requestDelegate]){
                    [self.requestDelegate requestProgressProgressingRequest:self
                                                                       task:dataTask
                                                                   progress:downloadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //正在完成
                dataTask = task;
                if([weakSelf requestDelegate]){
                    [weakSelf.requestDelegate requestProgressDidFinishRequest:self
                                                                         task:task
                                                               responseObject:responseObject];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //正在失败
                dataTask = task;
                weakSelf.error = error;
                if([weakSelf requestDelegate]){
                    [weakSelf.requestDelegate requestProgressDidFailedRequest:self
                                                                         task:task
                                                                    withError:error];
                }
            }];
        }break;
        case RequestMethodGet:{
            dataTask = [sessionManager GET:enUrl parameters:enParam progress:^(NSProgress * _Nonnull downloadProgress) {
                //正在请求
                if([weakSelf requestDelegate]){
                    [self.requestDelegate requestProgressProgressingRequest:self
                                                                       task:dataTask
                                                                   progress:downloadProgress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //正在完成
                dataTask = task;
                if([weakSelf requestDelegate]){
                    [weakSelf.requestDelegate requestProgressDidFinishRequest:self
                                                                         task:task
                                                               responseObject:responseObject];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //正在失败
                dataTask = task;
                weakSelf.error = error;
                if([weakSelf requestDelegate]){
                    [weakSelf.requestDelegate requestProgressDidFailedRequest:self
                                                                         task:task
                                                                    withError:error];
                }
            }];
        }break;
        default:break;
    }
    //已经发送请求等待请求结果
    if([self requestDelegate]){
        progressContinue = [weakSelf.requestDelegate requestProgressDidSendRequest:self task:dataTask];
        
        if (progressContinue == NO) { return dataTask;}
    }
    return dataTask;
}


-(BOOL)requestProgressWillSendRequest:(id)request task:(NSURLSessionDataTask *)task{
    if (self.startBlock) {
        self.startBlock(self);
    }
    return YES;
}

-(void)requestProgressProgressingRequest:(id)request task:(NSURLSessionDataTask *)task progress:(NSProgress *)progress{
    if (self.progressBlock) {
        self.progressBlock(self, progress);
    }
}

-(void)requestProgressDidFinishRequest:(id)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    
    self.responseObject = responseObject;
    BOOL con = [self.requestDelegate requestProgressWillFinishCallBack:self
                                                                  task:task
                                                              progress:nil
                                                        responseObject:responseObject
                                                             withError:nil];
    
    [self doWithLogWithSuccess:YES];
    if(self.finishBlock && con){
        self.finishBlock(self);
        [self.requestDelegate requestProgressDidFinishCallBack:self
                                                          task:task
                                                      progress:nil
                                                responseObject:responseObject
                                                     withError:nil];
    }
}

-(void)requestProgressDidFailedRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task withError:(NSError *)error{
    self.error = error;
    BOOL con = [self.requestDelegate requestProgressWillFailedCallBack:self
                                                                  task:task
                                                              progress:nil
                                                        responseObject:nil
                                                             withError:error];
    
    [self doWithLogWithSuccess:NO];
    if (self.failedBlock && con) {
        self.failedBlock(self);
        [self.requestDelegate requestProgressDidFailedCallBack:self
                                                          task:task
                                                      progress:nil
                                                responseObject:nil
                                                     withError:error];
        
    }
}

- (void)doWithLogWithSuccess:(BOOL)suc{
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
    
    [self.requestLog appendString:log];
    RequestLog(@"%@",self.requestLog);
    [[TFRequestManager shareInstance] addLog:[NSString stringWithString:log]];
    
#endif
    
}


/**
 *  post 给请求添加header
 */
-(void)addRequestHeader:(AFHTTPSessionManager *)manager{
    if (self.header && [self.header isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = self.header.allKeys;
        for (NSString *key in keys) {
            [manager.requestSerializer setValue:[self.header objectForKey:key]
                             forHTTPHeaderField:key];
        }
    }
}

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
@end
