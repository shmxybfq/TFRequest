//
//  TFRequest.h
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFBaseRequest.h"

@interface TFRequest : TFBaseRequest

//请求的log
@property(nonatomic, copy) NSString *requestLog;
//请求的log - 
@property(nonatomic, copy) NSString *requestPrintJson;

@end




