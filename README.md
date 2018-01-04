# ZJLaunchAdv
#### 说明
1. 可设置广告展示样式（无广告、全屏广告、带有log的广告）
````
typedef NS_ENUM(NSInteger,ZJAdType){
    
    ZJAdTypeLogo = 0,      //带有logo
    ZJAdTypeFullScreen,    //全屏，不带lodo
    ZJAdTypeNone           //无广告图
    
};
````
2. 跳过按钮以及倒计时多样式
````
typedef NS_ENUM(NSUInteger, ZJSkipButtonType) {
    
    ZJSkipButtonTypeOvalTimeAndText = 0,      //圆角矩形+文字+倒计时
    ZJSkipButtonTypeOvalAnimationAndText,     //圆角矩形+文字+动画
    ZJSkipButtonTypeCircleAnimationAndText,   //圆形+文字+动画
    ZJSkipButtonTypeNone                      //无跳过按钮
};
````

#### 代码引入方式事例:
````
ZJLaunchAdv *adview = [ZJLaunchAdv zjLaunchImageView:^(ZJAdConfiguration *configuration) {
        
        configuration.adImageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514888829314&di=4588cc130055455689d5312922f59704&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fexp%2Fw%3D500%2Fsign%3D347c8932f2246b607b0eb274dbf91a35%2Fac345982b2b7d0a28681d3fccfef76094b369a03.jpg";
        configuration.adtype = ZJAdTypeLogo;
        configuration.skipBtnType = ZJSkipButtonTypeOvalTimeAndText;
        configuration.duration = 4;
        configuration.animationCircleColor = [UIColor greenColor];
        
    } action:^{
        NSLog(@"点击了跳过按钮！");
    } completion:^(BOOL finished) {
        NSLog(@"启动广告消失!");
    }];
    [self.window addSubview:adview];
````

#### 集成方式
* 1.拷贝进工程
* 2.使用cocoaPods，终端cd进入项目文件夹，执行命令如下:
````
pod 'ZJLaunchAdv', '~> 1.0.1'
````
