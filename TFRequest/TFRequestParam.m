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


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _closeLog = [aDecoder decodeBoolForKey:@"_closeLog"];
        _param = [aDecoder decodeObjectForKey:@"_param"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:_closeLog forKey:@"_closeLog"];
    if (_param)[aCoder encodeObject:_param forKey:@"_param"];
}

@end
