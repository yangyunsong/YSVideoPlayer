//
//  YSVideoControlView.m
//  videopleyer
//
//  Created by yangyunsong on 17/1/5.
//  Copyright © 2017年 yangyunsong. All rights reserved.
//

#import "YSVideoPlayerController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "YSVideoPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "YSVideoConst.h"
static const NSTimeInterval kVideoPlayerAnimationTimeinterval = 0.3f;

@interface YSVideoPlayerController()<VLCMediaPlayerDelegate,YSVideoControlViewDelegate>
{
    CGRect _originFrame;
}
@property (nonatomic, strong)   VLCMediaPlayer *player;
@property (nonatomic, strong)   YSVideoPlayerControlView *videoControl;
@property(nonatomic, assign)BOOL isFullscreenMode;

@end

@implementation YSVideoPlayerController
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.videoControl.frame = self.bounds;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showControl:)];
        
        UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
        doubleClick.numberOfTapsRequired = 2;
        [self.videoControl addGestureRecognizer:tap];
        [self addGestureRecognizer:doubleClick];
        [tap requireGestureRecognizerToFail:doubleClick];
        [self setupNotification];

    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setupView];
    [self configControlAction];
}

-(void)showInView:(UIView *)view{
    
    [view addSubview:self];

    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        self.Vframe = [UIScreen mainScreen].bounds;
    }
    if (self.isLocal) {
        self.videoControl.fullScreenButton.hidden = YES;
        self.videoControl.shrinkScreenButton.hidden = YES;
    }
    [self addSubview:self.videoControl];


    self.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerAnimationTimeinterval animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self play];
    }];
}

- (void)dismiss {
    self.player.delegate = nil;
    self.player.drawable = nil;
    self.isLocked = NO;
    // 注销通知
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeFromSuperview];
}
#pragma mark - Private Method
- (void)setupView {
    [self setBackgroundColor:[UIColor blackColor]];
}


// 添加事件
-(void)configControlAction{
    
    
    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.lockButton addTarget:self action:@selector(lockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchCancel];
}

- (void)setupNotification {
    
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];

}

/// 耳机插入、拔出事件
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSInteger routeChangeReason = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            [self play];
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            [self pause];
            // 拔掉耳机继续播放
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            break;
            
        default:
            break;
    }
}

/// 设备旋转方向改变
- (void)onDeviceOrientationDidChange
{
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    
    if (!self.isLocked)
    {
        switch (orientation) {
            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                NSLog(@"home键在 下");
                [self restoreOriginalScreen];
            }
                break;
            case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                NSLog(@"home键在 上");
            }
                break;
            case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                NSLog(@"home键在 右");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
            }
                break;
            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                NSLog(@"home键在 左");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
            }
                break;
                
            default:
                break;
        }
    }
}
/// 切换到全屏模式
- (void)changeToFullScreenForOrientation:(UIDeviceOrientation)orientation
{
        if (self.isFullscreenMode) {
        return;
    }
    
    
    if (self.videoPlayerWillChangeToFullScreenModeBlock) {
        self.videoPlayerWillChangeToFullScreenModeBlock();
    }
    
    self.Vframe = [UIScreen mainScreen].bounds;
    self.isFullscreenMode = YES;
    self.videoControl.fullScreenButton.hidden = YES;
    self.videoControl.shrinkScreenButton.hidden = NO;
}
/// 切换到竖屏模式
- (void)restoreOriginalScreen
{
    if (!self.isFullscreenMode) {
        return;
    }
    
    
    if (self.videoPlayerWillChangeToOriginalScreenModeBlock) {
        self.videoPlayerWillChangeToOriginalScreenModeBlock();
    }
    
    self.Vframe = CGRectMake(0, 0, kYSVideoPlayerOriginalWidth, kYSVideoPlayerOriginalHeight);
    
    self.isFullscreenMode = NO;
    self.videoControl.fullScreenButton.hidden = NO;
    self.videoControl.shrinkScreenButton.hidden = YES;
}


/**
 *    强制横屏
 *
 *    @param orientation 横屏方向
 */

- (void)changeToOrientation:(UIDeviceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


/**
 *    即将进入后台的处理
 */
- (void)applicationWillEnterForeground {
    [self play];
}

/**
 *    即将返回前台的处理
 */
- (void)applicationWillResignActive {
    [self play];
}


#pragma mark Player Logic
- (void)play {
    [self.player play];
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
    [self.videoControl autoFadeOutControlBar];
}

- (void)pause {
    [self.player pause];
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES;
    [self.videoControl autoFadeOutControlBar];
}

- (void)stop {
    [self.player stop];
    self.videoControl.progressSlider.value = 1;
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES;
}

- (void)showControl:(UITapGestureRecognizer *)tap{
    [self.videoControl responseTapImmediately];
}

- (void)doubleClick:(UITapGestureRecognizer *)tap{
    if (!self.isLocked) {
        if (self.player.isPlaying) {
            [self pause];
            [self.videoControl autoFadeOutControlBar];
        }else{
            [self play];
            [self.videoControl cancelAutoFadeOutControlBar];
        }
    }
}
/// 播放按钮点击
- (void)playButtonClick
{
    [self play];
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
}

/// 暂停按钮点击
- (void)pauseButtonClick
{
    [self pause];
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES;
}

/// 锁屏按钮点击
- (void)lockButtonClick:(UIButton *)lockBtn
{
    lockBtn.selected = !lockBtn.selected;
    if (lockBtn.selected) { // 锁定
        self.isLocked = YES;
        [self configureControl:NO];
    } else { // 解除锁定
        self.isLocked = NO;
        [self configureControl:YES];
    }
}

/// 全屏按钮点击
- (void)fullScreenButtonClick
{
    if (self.isFullscreenMode) {
        return;
    }
    
    // FIXME: ?
    [self changeToOrientation:UIDeviceOrientationPortrait];
}

/// 返回竖屏按钮点击
- (void)shrinkScreenButtonClick
{
    if (!self.isFullscreenMode) {
        return;
    }
    
    [self changeToOrientation:UIDeviceOrientationLandscapeRight];
}

/// slider 按下事件
- (void)progressSliderTouchBegan:(UISlider *)slider
{
    [self pause];
}

/// slider 松开事件
- (void)progressSliderTouchEnded:(UISlider *)slider
{
    [self.player setPosition:slider.value];
    [self play];
}

/// slider value changed
- (void)progressSliderValueChanged:(UISlider *)slider
{
    [self.player setPosition:slider.value];
}

#pragma mark - Action Code
- (void)backButtonClick{
    
    if (!self.isFullscreenMode) {
            if (self.videoPlayerGoBackBlock) {
                [self.videoControl cancelAutoFadeOutControlBar];
                [self stop];
                self.videoPlayerGoBackBlock();
        }
    }else if(self.isFullscreenMode){
        if (self.videoPlayerGoBackBlock) {
            [self.videoControl cancelAutoFadeOutControlBar];
            [self stop];
            self.videoPlayerGoBackBlock();
        }
    }else{
        [self stop];
        [self changeToOrientation:UIDeviceOrientationPortrait];
    }
}


#pragma mark - Delegate
#pragma mark VLC
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    [self bringSubviewToFront:self.videoControl];
    if (self.player.media.state == VLCMediaStateBuffering) {
        self.videoControl.indicatorView.hidden = NO;
        self.videoControl.bgLayer.hidden = NO;
    }else if (self.player.media.state == VLCMediaStatePlaying) {
        self.videoControl.indicatorView.hidden = YES;
        self.videoControl.bgLayer.hidden = YES;
    }else if (self.player.state == VLCMediaPlayerStateStopped) {
        [self stop];
    }else {
        self.videoControl.indicatorView.hidden = NO;
        self.videoControl.bgLayer.hidden = NO;
    }
    
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    
    [self bringSubviewToFront:self.videoControl];
    
    if (self.videoControl.progressSlider.state != UIControlStateNormal) {
        return;
    }
    
    float precentValue = ([self.player.time.numberValue floatValue]) / ([kMediaLength.numberValue floatValue]);
    
    [self.videoControl.progressSlider setValue:precentValue animated:YES];
    
    [self.videoControl.timeLabel setText:[NSString stringWithFormat:@"%@/%@",_player.time.stringValue,kMediaLength.stringValue]];
}

- (void)configureControl:(BOOL)interaction {
    interaction ? [self controlavailable] : [self controldisable];
}

- (void)controlavailable{
    self.videoControl.topBar.hidden = NO;
    self.videoControl.bottomBar.hidden = NO;
    self.videoControl.isLockScreen = YES;
}
- (void)controldisable{
    self.videoControl.topBar.hidden = YES;
    self.videoControl.bottomBar.hidden = YES;
    self.videoControl.isLockScreen = NO;
}


#pragma mark ControlView
- (void)controlViewFingerMoveLeft {
    [self.player shortJumpBackward];
}

- (void)controlViewFingerMoveRight {
    [self.player shortJumpForward];
}

-(void)setVideo:(YSVideo *)video{
    _video = video;
    self.videoControl.titleLabel.text = video.filmName;
    [self.player setDrawable:self];
    if (self.isLocal) {
        self.player.media = [VLCMedia mediaWithURL:[NSURL fileURLWithPath:video.filmPath]];
    }else{
        self.player.media = [VLCMedia mediaWithURL:[NSURL URLWithString:video.filmPath]];
    }
    
    [self play];
}


-(VLCMediaPlayer *)player{
    
    if (!_player) {
        _player = [[VLCMediaPlayer alloc]init];
        _player.delegate = self;
    }
    return _player;
}
-(YSVideoPlayerControlView *)videoControl{
    
    if (!_videoControl) {
        _videoControl = [[YSVideoPlayerControlView alloc]initWithFrame:self.bounds];
        _videoControl.delegate = self;
    }
    return _videoControl;
}

-(void)setVframe:(CGRect)Vframe{
    [self setFrame:Vframe];
    [self.videoControl setFrame:CGRectMake(0, 0, Vframe.size.width, Vframe.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}
- (UIDeviceOrientation)getDeviceOrientation
{
    return [UIDevice currentDevice].orientation;
}



@end
