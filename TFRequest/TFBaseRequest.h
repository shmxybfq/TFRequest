//
//  TFBaseRequest.h
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFNetworking;
@class TFRequestManager;
@class TFRequestParam;
@class TFBaseRequest;
@class AFSecurityPolicy;

#define kNotworkError @"网络连接失败,请检查您的网络连接."
#define kDataError @"数据格式错误."
#define kNoNetworkCode (1314)

#ifndef TF_WEAK_OBJ
#define TF_WEAK_OBJ(TARGET,NAME)  __weak typeof(TARGET) NAME = TARGET;
#endif
#ifndef kdeclare_weakself
#define kdeclare_weakself TF_WEAK_OBJ(self,weakSelf)
#endif


#ifdef DEBUG
#   define RequestLog(fmt, ...) NSLog((@"\nfunction:%s,line:%d\n" fmt @"\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define RequestLog(...)
#endif

typedef NS_ENUM(NSInteger,RequestMethod) {
    RequestMethodGet = 0,
    RequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    RequestMethodMultipartPost = 2   // content type = @"multipart/form-data"
};

typedef NS_ENUM(NSInteger,RequestType) {
    RequestTypeForm = 0,
    RequestTypeJson = 1,
};

typedef NS_ENUM(NSInteger,RequestProgress) {
    RequestProgressInit = 0,
    RequestProgressWillGetParams,
    RequestProgressDidGetParams,
    RequestProgressWillSendRequest,
    RequestProgressDidSendRequest,
    RequestProgressProgressingRequest,
    RequestProgressDidFinishRequest,
    RequestProgressDidCancelRequest,
    RequestProgressDidFailedRequest,
    RequestProgressWillFinishCallBack,
    RequestProgressDidFinishCallBack,
    RequestProgressWillFailedCallBack,
    RequestProgressDidFailedCallBack,
};

typedef void (^RequestStartBlock)(id request);
typedef void (^RequestFinishBlock)(id request);
typedef void (^RequestCanceledBlock)(id request);
typedef void (^RequestFailedBlock)(id request);
typedef void (^RequestProgressBlock)(id request,NSProgress *progress);

@protocol TFRequestParamDelegate <NSObject>

/* 请求配置.
 */
- (RequestType)configureRequestType;
- (RequestMethod)configureRequestMethod;
- (NSString *)configureBaseUrl;
- (NSString *)configureUrl;
- (NSDictionary *)configureHeader;
- (NSDictionary *)configureDefalutParams;
- (AFSecurityPolicy *)configureSecurityPolicy;



@end

@protocol TFBaseRequestDelegate <NSObject>
@optional


/* 请求过程.
 */
-(BOOL)requestProgressInit:(TFBaseRequest *)request;
-(BOOL)requestProgressWillGetParams:(TFBaseRequest *)request;
-(BOOL)requestProgressDidGetParams:(TFBaseRequest *)request;
-(BOOL)requestProgressWillSendRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task;
-(BOOL)requestProgressDidSendRequest:(TFBaseRequest *)request
                                task:(NSURLSessionDataTask *)task;
-(void)requestProgressProgressingRequest:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress;
-(void)requestProgressDidFinishRequest:(TFBaseRequest *)request
                                  task:(NSURLSessionDataTask *)task
                        responseObject:(id)responseObject;
-(void)requestProgressDidCancelRequest;
-(void)requestProgressDidFailedRequest:(TFBaseRequest *)request
                                  task:(NSURLSessionDataTask *)task
                             withError:(NSError*)error;
-(BOOL)requestProgressWillFinishCallBack:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress
                          responseObject:(id)responseObject
                               withError:(NSError*)error;
-(void)requestProgressDidFinishCallBack:(TFBaseRequest *)request
                                   task:(NSURLSessionDataTask *)task
                               progress:(NSProgress *)progress
                         responseObject:(id)responseObject
                              withError:(NSError*)error;
-(BOOL)requestProgressWillFailedCallBack:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress
                          responseObject:(id)responseObject
                               withError:(NSError*)error;
-(void)requestProgressDidFailedCallBack:(TFBaseRequest *)request
                                   task:(NSURLSessionDataTask *)task
                               progress:(NSProgress *)progress
                         responseObject:(id)responseObject
                              withError:(NSError*)error;

@end


@interface TFBaseRequest : NSObject<NSCoding,TFBaseRequestDelegate,TFRequestParamDelegate>

@property (nonatomic,   weak) id<TFBaseRequestDelegate> requestDelegate;
@property (nonatomic,   weak) id<TFRequestParamDelegate> paramDelegate;

@property (nonatomic, strong) NSURLSessionDataTask  *task;
@property (nonatomic,   copy,readonly) RequestStartBlock startBlock;
@property (nonatomic,   copy,readonly) RequestFinishBlock finishBlock;
@property (nonatomic,   copy,readonly) RequestCanceledBlock canceledBlock;
@property (nonatomic,   copy,readonly) RequestFailedBlock failedBlock;
@property (nonatomic,   copy,readonly) RequestProgressBlock progressBlock;

@property (nonatomic,   copy) NSString *url;
@property (nonatomic,   copy) NSString *baseUrl;
@property (nonatomic,   copy) NSString *totalUrl;
@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, assign) RequestMethod requestMethod;
@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, strong) TFRequestParam *params;
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
@property (nonatomic, strong) NSDictionary *defalutParams;
@property (nonatomic, strong) NSMutableDictionary *totalParams;


@property (nonatomic, strong) NSError  *error;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) id responseJson;

+(instancetype)requestWithDic:(NSDictionary *)dic
                requestFinish:(RequestFinishBlock)finish
                requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(TFRequestParam *)param
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(TFRequestParam *)param
                   requestStart:(RequestStartBlock)start
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                requestCanceled:(RequestCanceledBlock)canceled
                  requestFailed:(RequestFailedBlock)failed;

-(instancetype)initWithParam:(TFRequestParam *)param
                requestStart:(RequestStartBlock)start
             requestProgress:(RequestProgressBlock)progress
               requestFinish:(RequestFinishBlock)finish
             requestCanceled:(RequestCanceledBlock)canceled
               requestFailed:(RequestFailedBlock)failed;


@end


