//
//  TFBaseRequest.h
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TFRequestParam.h"
#import "TFRequestManager.h"
#import <AFNetworking/AFNetworking.h>

#define kNoNetworkCode (1314)
#define kDataError @"数据格式错误."
#define kNotworkError @"网络连接失败,请检查您的网络连接."

#ifndef tf_weak_obj
#define tf_weak_obj(target,name)  __weak typeof(target) name = target;
#endif
#ifndef kdeclare_weakself
#define kdeclare_weakself tf_weak_obj(self,weakSelf)
#endif


#ifdef DEBUG
#   define RequestLog(fmt, ...) NSLog((@"\nfun:%s,line:%d\n" fmt @"\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define RequestLog(...)
#endif


//请求方法,default=RequestMethodPost
typedef NS_ENUM(NSInteger,RequestMethod) {
    RequestMethodGet = 0,
    RequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    RequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"
    //mimeType(video):application/octet-stream, mimeType(image):@"image/png",
    RequestMethodUploadPost = 3
};

//请求方式,default=RequestTypeForm
typedef NS_ENUM(NSInteger,RequestType) {
    RequestTypeForm = 0,
    RequestTypeJson = 1,
};

//请求回调block
typedef void (^RequestStartBlock)(id request);
typedef void (^RequestUploadDataBlock)(id<AFMultipartFormData>formData);
typedef void (^RequestProgressBlock)(id request,NSProgress *progress);
typedef void (^RequestFinishBlock)(id request);
typedef void (^RequestCanceledBlock)(id request);
typedef void (^RequestFailedBlock)(id request);


/* 请求配置的代理方法,本类已自己为代理,并实现所有方法做了默认配置.
 * 如果修改的话,可以在子类重写方法
 */
@protocol TFRequestParamDelegate <NSObject>

- (RequestType)configureRequestType;//配置请求方式
- (RequestMethod)configureRequestMethod;//配置请求方法
- (NSString *)configureBaseUrl;//配置baseUrl
- (NSString *)configureUrl;//配置url
- (NSDictionary *)configureHeader;//配置请求头
//配置默认请求参数,请求时会和传进来的参数合并,并且传的参数会覆盖默认参数的相同项
- (NSDictionary *)configureDefalutParams;
- (AFSecurityPolicy *)configureSecurityPolicy;//配置隐私策略

@end



/* 请求过程代理方法,下面方法会在请求过程中各个阶段调用,返回值为BOOL类型可以打断请求
 * 下面方法本类已自己为代理,并实现所有方法做了默认处理,集体请看各个方法的注释.
 * 如需在过程方法中添加其他操作,直接子类重写即可
 */
@class TFBaseRequest;
@protocol TFBaseRequestDelegate <NSObject>
@optional
//请求对象创建完成
-(BOOL)requestProgressInit:(TFBaseRequest *)request;
//请求开始获取参数和请求配置
-(BOOL)requestProgressWillGetParams:(TFBaseRequest *)request;
//请求已经获取参数和请求配置
-(BOOL)requestProgressDidGetParams:(TFBaseRequest *)request;
//请求将要开始发送请求,如需在请求前修改请求配置或者参数,重写此方法即可
-(BOOL)requestProgressWillSendRequest:(TFBaseRequest *)request task:(NSURLSessionDataTask *)task;
//请求-上传请求已经拼接完上传的数据,如需修改上传数据重写此方法即可
-(void)requestProgressUploadDidJointedFormdataRequest:(TFBaseRequest *)request
                                                 task:(NSURLSessionDataTask *)task
                                             formData:(id)formData;
//请求已经发送请求,正在等待服务器返回结果
-(void)requestProgressDidSendRequest:(TFBaseRequest *)request
                                task:(NSURLSessionDataTask *)task;
//请求已经发送,回调请求(上传、下载)进度
-(void)requestProgressProgressingRequest:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress;
//请求完成
-(void)requestProgressDidFinishRequest:(TFBaseRequest *)request
                                  task:(NSURLSessionDataTask *)task
                        responseObject:(id)responseObject;
//请求取消
-(void)requestProgressDidCancelRequest;
//请求失败
-(void)requestProgressDidFailedRequest:(TFBaseRequest *)request
                                  task:(NSURLSessionDataTask *)task
                             withError:(NSError*)error;
//请求完成,将要回调到请求完成block
-(BOOL)requestProgressWillFinishCallBack:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress
                          responseObject:(id)responseObject
                               withError:(NSError*)error;
//请求完成,已经回调到请求完成block
-(void)requestProgressDidFinishCallBack:(TFBaseRequest *)request
                                   task:(NSURLSessionDataTask *)task
                               progress:(NSProgress *)progress
                         responseObject:(id)responseObject
                              withError:(NSError*)error;
//请求完成,将要回调到请求失败block
-(BOOL)requestProgressWillFailedCallBack:(TFBaseRequest *)request
                                    task:(NSURLSessionDataTask *)task
                                progress:(NSProgress *)progress
                          responseObject:(id)responseObject
                               withError:(NSError*)error;
//请求完成,已经回调到请求失败block
-(void)requestProgressDidFailedCallBack:(TFBaseRequest *)request
                                   task:(NSURLSessionDataTask *)task
                               progress:(NSProgress *)progress
                         responseObject:(id)responseObject
                              withError:(NSError*)error;

@end


@class AFHTTPSessionManager;
@interface TFBaseRequest : NSObject<NSCoding,TFBaseRequestDelegate,TFRequestParamDelegate>

@property (nonatomic,   weak) id<TFRequestParamDelegate> paramDelegate;
@property (nonatomic,   weak) id<TFBaseRequestDelegate> requestDelegate;

@property (nonatomic, strong) NSURLSessionDataTask  *task;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic,   copy,readonly) RequestStartBlock startBlock;
@property (nonatomic,   copy,readonly) RequestUploadDataBlock uploadBlock;
@property (nonatomic,   copy,readonly) RequestFinishBlock finishBlock;
@property (nonatomic,   copy,readonly) RequestCanceledBlock canceledBlock;
@property (nonatomic,   copy,readonly) RequestFailedBlock failedBlock;
@property (nonatomic,   copy,readonly) RequestProgressBlock progressBlock;


//以下参数可在代理方法requestProgressDidGetParams时(后)取到
@property (nonatomic,   copy) NSString *url;//请求的url,最终会和baseUrl,拼成totalUrl
@property (nonatomic,   copy) NSString *baseUrl;//baseUrl,最终会和url,拼成totalUrl
@property (nonatomic,   copy) NSString *totalUrl;//baseUrl和url拼的
@property (nonatomic, assign) RequestType requestType;//请求类型
@property (nonatomic, assign) RequestMethod requestMethod;//请求方法
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;//隐私策略

@property (nonatomic, strong) NSDictionary *header;//请求头
@property (nonatomic, strong) TFRequestParam *params;//请求参数
@property (nonatomic, strong) NSDictionary *defalutParams;//请求默认参数
@property (nonatomic, strong) NSMutableDictionary *totalParams;//params.param和defalutParams的和

//以下参数可在代理方法requestProgressDidFailedRequest时(后)取到
@property (nonatomic, strong) NSError  *error;

//以下参数可在代理方法requestProgressDidFinishRequest时(后)取到
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) id responseJson;

+(instancetype)requestWithDic:(NSDictionary *)dic
                requestFinish:(RequestFinishBlock)finish
                requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(TFRequestParam *)param
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(TFRequestParam *)param
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                  requestFailed:(RequestFailedBlock)failed;

+(instancetype)requestWithParam:(TFRequestParam *)param
                   requestStart:(RequestStartBlock)start
                  requestUpload:(RequestUploadDataBlock)upload
                requestProgress:(RequestProgressBlock)progress
                  requestFinish:(RequestFinishBlock)finish
                requestCanceled:(RequestCanceledBlock)canceled
                  requestFailed:(RequestFailedBlock)failed;

-(instancetype)initWithParam:(TFRequestParam *)param
                requestStart:(RequestStartBlock)start
               requestUpload:(RequestUploadDataBlock)upload
             requestProgress:(RequestProgressBlock)progress
               requestFinish:(RequestFinishBlock)finish
             requestCanceled:(RequestCanceledBlock)canceled
               requestFailed:(RequestFailedBlock)failed;


@end


