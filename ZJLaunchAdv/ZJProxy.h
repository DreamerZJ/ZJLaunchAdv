//
//  ZJProxy.h
//  Push
//
//  Created by 张建 on 2017/12/8.
//  Copyright © 2017年 zhangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface ZJProxy : NSProxy
@property (nonatomic,readonly,weak) id targetObject;
+ (instancetype)zjProxyWithTarget:(id)target;
@end
NS_ASSUME_NONNULL_END
