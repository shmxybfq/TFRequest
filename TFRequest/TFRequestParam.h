//
//  TFRequestParam.h
//  TFRequestDemo
//
//  Created by Time on 2019/2/19.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFRequestParam : NSObject

@property (nonatomic, strong)NSDictionary *param;

+(instancetype)paramWithDictionary:(NSDictionary *)ins;

@end

NS_ASSUME_NONNULL_END
