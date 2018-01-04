//
//  ZJLaunchImageAdView.m
//  Push
//
//  Created by zhangjian on 2017/12/29.
//  Copyright © 2017年 zhangjian. All rights reserved.
//

#import "ZJLaunchAdv.h"
#import "FLAnimatedImageView+WebCache.h"
#import "ZJProxy.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@implementation ZJAdConfiguration

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _adtype = ZJAdTypeNone;
        _adImageUrl = @"";
        _skipBtnType = ZJSkipButtonTypeNone;
        _duration = 3;
        _animationCircleColor = [UIColor redColor];
    }
    return self;
}
@end

@interface ZJLaunchAdv ()

/**倒计时*/
@property (nonatomic,strong) dispatch_source_t timer;
/**动画倒计时*/
@property (nonatomic,strong) CADisplayLink *displayLink;
/**倒计时按钮*/
@property (nonatomic,strong) UIButton *skipBtn;
/**动画环*/
@property (nonatomic,weak) CAShapeLayer *shapeLayer;
/**按钮点击事件*/
@property (nonatomic,copy) ActionBlock action;
/**结束block*/
@property (nonatomic,copy) CompletionBlock completion;

@end

@implementation ZJLaunchAdv
{
    NSTimeInterval _beginTime;
}
#pragma mark - 初始化
- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        //初始化默认配置
        [self initDefaultConfig];
        
    }
    return self;
}

+ (instancetype)zjLaunchImageView:(ConfigurationSetBlock)configurationBlock
                           action:(void (^)(void))action
                       completion:(void (^ _Nullable)(BOOL))completion{
    
    ZJLaunchAdv *launchAdView = [[ZJLaunchAdv alloc]init];
    ZJAdConfiguration *configuration = [[ZJAdConfiguration alloc]init];
    if (configurationBlock) {
        configurationBlock(configuration);
    }
    launchAdView.configuration = configuration;
    launchAdView.action = action;
    launchAdView.completion = completion;
    return launchAdView;
}

/**
 初始化默认配置
 */
- (void)initDefaultConfig{
    
    self.frame = [UIScreen mainScreen].bounds;
    NSString *launchImageName = [self getLaunchImage];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:launchImageName]];
}

- (void)setConfiguration:(ZJAdConfiguration *)configuration{
    
    if (configuration) {
        _configuration = configuration;
        //根据配置文件添加广告图
        [self addADImage];
    }
}

#pragma mark - 广告数据获取
/**
 获取启动图名称
 */
- (NSString *)getLaunchImage{
    
    //获取启动图片
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    //横屏请设置成 @"Landscape"|Portrait
    NSString *viewOrientation = @"Portrait";
    __block NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    [imagesDict enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *deviceOrientation = obj[@"UILaunchImageOrientation"];
        NSLog(@"%@",deviceOrientation);
        CGSize imageSize = CGSizeFromString(obj[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:obj[@"UILaunchImageOrientation"]])
        {
            launchImageName = obj[@"UILaunchImageName"];
        }
    }];
    return launchImageName;
}

/**
 添加广告图
 */
- (void)addADImage{
    
    CGRect imageViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    ZJAdType adtype = self.configuration.adtype;
    switch (adtype) {
        case ZJAdTypeLogo:
        {
            imageViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*4/5);
            [self addADImageWithFrame:imageViewFrame];
        }
            break;
        case ZJAdTypeFullScreen:
        {
            [self addADImageWithFrame:imageViewFrame];
        }
            break;
        case ZJAdTypeNone:
        {
            //不做处理
        }
            break;
    }
}

/**添加广告imageView*/
- (void)addADImageWithFrame:(CGRect)adFrame{
    
    FLAnimatedImageView *advImageView = [[FLAnimatedImageView alloc]initWithFrame:adFrame];
    [self addSubview:advImageView];
    if (_configuration.adImageUrl == nil || [_configuration.adImageUrl isEqualToString:@""]) {
        return;
    }
    //缓存网络图片
    __weak typeof(self) weakself = self;
    [advImageView sd_setImageWithURL:[NSURL URLWithString:_configuration.adImageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        //添加跳过按钮
        [weakself addSkipBtn];
        //倒计时
        [weakself addTimer];
        //动画倒计时
        [weakself addAnimationLink];
    }];
}

#pragma mark - 跳过按钮
/**跳过按钮设置*/
- (void)addSkipBtn{
    
    //创建按钮
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    skipBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _skipBtn = skipBtn;
    [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(clickSkipBtn) forControlEvents:UIControlEventTouchUpInside];
    
    ZJSkipButtonType skipBtnType = _configuration.skipBtnType;
    switch (skipBtnType) {
        case ZJSkipButtonTypeOvalTimeAndText:
        {
            [skipBtn setFrame:CGRectMake(SCREEN_WIDTH-70, 30, 55, 25)];
            skipBtn.layer.cornerRadius = 12.5;
            [skipBtn setTitle:@"跳过 0s" forState:UIControlStateNormal];
            
        }
            break;
        case ZJSkipButtonTypeOvalAnimationAndText:
        {
            [skipBtn setFrame:CGRectMake(SCREEN_WIDTH-65, 30, 50, 25)];
            skipBtn.layer.cornerRadius = 12.5;
            [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        
        }
            break;
        case ZJSkipButtonTypeCircleAnimationAndText:
        {
            [skipBtn setFrame:CGRectMake(SCREEN_WIDTH-45, 30, 30, 30)];
            skipBtn.layer.cornerRadius = 15;
            [skipBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
            
        }
            break;
        case ZJSkipButtonTypeNone:
        {
            //不做任何操作
        }
            break;
    }
    //动画环添加
    [self addAnimationView];
    if (_configuration.skipBtnType != ZJSkipButtonTypeNone) {
        [self addSubview:_skipBtn];
    }
}

- (void)clickSkipBtn{
    
    dispatch_source_cancel(_timer);
    [_displayLink invalidate];
    _displayLink = nil;
    [self dismiss];
    self.action();
}

#pragma mark - 动画环线
- (void)addAnimationView{
    
    if (_configuration.skipBtnType == ZJSkipButtonTypeOvalAnimationAndText
        || _configuration.skipBtnType == ZJSkipButtonTypeCircleAnimationAndText) {
     
        CAShapeLayer *layer = [CAShapeLayer layer];
        _shapeLayer = layer;
        layer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;    // 填充颜色
        layer.strokeColor = _configuration.animationCircleColor.CGColor;                                 // 绘制颜色
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.lineWidth = 2;
        layer.frame = self.bounds;
        layer.path = [self pathWithSkipType:_configuration.skipBtnType].CGPath;
        layer.strokeStart = 0;
        [self.layer addSublayer:layer];
        self.shapeLayer = layer;
    }
}

//绘制动画环
- (UIBezierPath *)pathWithSkipType:(ZJSkipButtonType)type{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_skipBtn.frame cornerRadius:CGRectGetHeight(_skipBtn.frame)/2];
    return path;
}

#pragma mark - 倒计时
- (void)addTimer{
    
    //倒计时
    __block NSInteger duration = _configuration.duration;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer= dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (duration <= 0) {
                
                dispatch_source_cancel(_timer);
                [self dismiss];
            }else{
                
                [self showTimeWithDuration:duration];
                duration--;
            }
        });
    });
    dispatch_resume(_timer);
    
}

//内容展示
- (void)showTimeWithDuration:(NSInteger)duration{
    
    switch (_configuration.skipBtnType) {
        case ZJSkipButtonTypeOvalTimeAndText:
        {
            [_skipBtn setTitle:[NSString stringWithFormat:@"跳过 %lds",(long)duration] forState:UIControlStateNormal];
        }
            break;
        case ZJSkipButtonTypeOvalAnimationAndText:
        {
            [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        }
            break;
        case ZJSkipButtonTypeCircleAnimationAndText:
        {
            [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        }
            break;
        case ZJSkipButtonTypeNone:
        {
            //nothing to do
        }
            break;
    }
    
}

- (void)addAnimationLink{
    
    _displayLink = [CADisplayLink displayLinkWithTarget:[ZJProxy zjProxyWithTarget:self] selector:@selector(animate)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _beginTime = CACurrentMediaTime();//获取当前时间
}

- (void)animate{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSTimeInterval currentTime = CACurrentMediaTime() - _beginTime;
        CGFloat percent = currentTime/_configuration.duration;
        if (percent > 1) {
            percent = 1;
            [_shapeLayer setStrokeStart:1];
            [_displayLink invalidate];
        }else{
            
            [_shapeLayer setStrokeStart:percent];
        }
    });
}

#pragma mark - 启动广告图消失
- (void)dismiss
{
    
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        if (self.completion) {
            self.completion(YES);
        }
        [self removeFromSuperview];
    }];
  
}

- (void)dealloc{
    
    [_displayLink invalidate];
    _displayLink = nil;
}
@end
