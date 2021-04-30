//
//  TFRequestManager.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFRequestManager.h"
#import "TFBaseRequest.h"
@interface TFRequestManager()

@property(nonatomic,assign)NSUInteger requestCount;
@property(nonatomic,strong)NSLock *lock;

@end

@implementation TFRequestManager

static TFRequestManager *_requestManager = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestManager = [[[self class] alloc]init];
    });
    return _requestManager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.lock = [[NSLock alloc]init];
    }
    return self;
}

-(NSMutableArray *)requests{
    if (_requests == nil) {
        _requests = [[NSMutableArray alloc]init];
    }
    return _requests;
}

static const int _xrequest_max_count = 128;
- (void)addRequest:(id)request{
    [self.lock lock];
    self.requestCount += 1;
    if(self.requests.count > _xrequest_max_count){
        [self.requests removeObjectAtIndex:0];
    }
    [self.requests addObject:request];
    [self.lock unlock];
}


- (void)removeRequest:(id)request{
    [self.lock lock];
    if ([request isKindOfClass:[TFBaseRequest class]]) {
        TFBaseRequest *req = request;
        if (req.canceledBlock) {
            req.canceledBlock(req);
        }
        [req.task cancel];
        [req.sessionManager invalidateSessionCancelingTasks:YES resetSession:YES];
        req.startBlock = nil;
        req.uploadBlock = nil;
        req.finishBlock = nil;
        req.canceledBlock = nil;
        req.failedBlock = nil;
        req.progressBlock = nil;
        [self.requests removeObject:request];
    }
    [self.lock unlock];
}

-(void)removeRequestWithClass:(Class)cls{
    [self removeRequestWithUrl:[[cls alloc]configureUrl]];
}

-(void)removeRequestWithUrl:(NSString *)url{
    NSMutableArray *reqs = [NSMutableArray arrayWithArray:self.requests];
    for (TFBaseRequest *req in reqs) {
        if ([[req configureUrl] isEqualToString:url]) {
            [self removeRequest:req];
        }
    }
    [reqs removeAllObjects];
}


-(void)removeAllRequest{
    NSMutableArray *reqs = [NSMutableArray arrayWithArray:self.requests];
    for (TFBaseRequest *req in reqs) {
        [self removeRequest:req];
    }
    [reqs removeAllObjects];
}


-(NSMutableArray *)logs{
    if (_logs == nil) {
        _logs = [[NSMutableArray alloc]init];
    }
    return _logs;
}

//添加请求 -- 框架用
- (void)addLog:(NSString *)log{
    [self.lock lock];
    if (log != nil && [log isKindOfClass:[NSString class]]) {
        if (self.logs.count > _xrequest_max_count) {
            [self.logs removeLastObject];
        }
        [self.logs addObject:log];
    }
    [self.lock unlock];
}


- (NSString *)allLog{
    [self.lock lock];
    NSInteger count = self.logs.count;
    NSMutableString *log = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i < count; i ++) {
        [log appendFormat:@"\n========= 请求坐标(%@) =========\n",@(i)];
        [log appendFormat:@"%@",[self.logs objectAtIndex:i]];
    }
    [self.lock unlock];
    return log;
}




@end


