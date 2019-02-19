//
//  TFRequestParam.m
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFRequestParam.h"

@implementation TFRequestParam

+(instancetype)paramWithDictionary:(NSDictionary *)ins{
    TFRequestParam *param = [[TFRequestParam alloc]init];
    param.param = ins;
    return param;
}

@end
