//
//  TFRequestManager.h
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFRequestManager : NSObject

@property(nonatomic,strong)NSMutableArray *requests;
@property(nonatomic,strong)NSMutableArray *logs;

+(instancetype)shareInstance;

//添加请求 -- 框架用
- (NSString *)allLog;
- (void)addLog:(NSString *)log;

//添加请求 -- 框架用
- (void)addRequest:(id)request;
//取消所有请求
- (void)removeAllRequest;
//取消某个请求
- (void)removeRequest:(id)request;
//取消某个请求-通过请求类名
- (void)removeRequestWithClass:(Class)cls;
//取消某个请求-通过请求url(configureUrl)
- (void)removeRequestWithUrl:(NSString *)url;

@end

