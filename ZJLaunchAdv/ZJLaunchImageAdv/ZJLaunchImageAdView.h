//
//  ZJLaunchImageAdView.h
//  Push
//
//  Created by zhangjian on 2017/12/29.
//  Copyright © 2017年 zhangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ZJAdType){
    
    ZJAdTypeLogo = 0,      //带有logo
    ZJAdTypeFullScreen,    //全屏，不带lodo
    ZJAdTypeNone           //无广告图
    
};

typedef NS_ENUM(NSUInteger, ZJSkipButtonType) {
    
    ZJSkipButtonTypeOvalTimeAndText = 0,      //圆角矩形+文字+倒计时
    ZJSkipButtonTypeOvalAnimationAndText,     //圆角矩形+文字+动画
    ZJSkipButtonTypeCircleAnimationAndText,   //圆形+文字+动画
    ZJSkipButtonTypeNone                      //无跳过按钮
};

@interface ZJAdConfiguration : NSObject

/**广告图链接   默认为空*/
@property (nonatomic,copy) NSString *adImageUrl;
/**广告展示类型  默认为无广告*/
@property (nonatomic,assign) ZJAdType adtype;
/**按钮样式  默认为文字+倒计时*/
@property (nonatomic,assign) ZJSkipButtonType skipBtnType;
/**显示时长 默认为3s*/
@property (nonatomic,assign) NSTimeInterval duration;
/**动画环颜色*/
@property (nonatomic,strong) UIColor *animationCircleColor;

@end


/**配置block*/
typedef void(^ConfigurationSetBlock)(ZJAdConfiguration *configuration);
/**跳过按钮点击block*/
typedef void(^ActionBlock)(void);
/**结束block*/
typedef void(^CompletionBlock)(BOOL finished);

@interface ZJLaunchImageAdView : UIView

/**启动广告配置*/
@property (nonatomic,strong) ZJAdConfiguration *configuration;


/**
 创建带有configuration的广告图显示对象
 
 @param configurationBlock 设置configuration的block
 @return 返回带有configuration的广告图显示对象
 */
+ (instancetype)zjLaunchImageView:(ConfigurationSetBlock)configurationBlock
                           action:(void(^)(void))action
                       completion:(void (^ __nullable)(BOOL finished))completion;

NS_ASSUME_NONNULL_END
@end
