//
//  ZJProxy.m
//  Push
//
//  Created by 张建 on 2017/12/8.
//  Copyright © 2017年 zhangjian. All rights reserved.
//

#import "ZJProxy.h"

@implementation ZJProxy

+ (instancetype)zjProxyWithTarget:(id)target{
    
    ZJProxy *item = [ZJProxy alloc];
    item->_targetObject = target;
    return item;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    return [_targetObject methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    if ([_targetObject respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_targetObject];
    }
}

@end
