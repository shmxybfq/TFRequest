//
//  TFRequestParam.h
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFRequestParam : NSObject

@property (nonatomic, strong)NSDictionary *param;
@property (nonatomic, assign)BOOL closeLog;

+(instancetype)paramWithDictionary:(NSDictionary *)ins;

@end

