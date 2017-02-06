//
//  YSVideoPlayerControlView.m
//  videopleyer
//
//  Created by yangyunsong on 16/12/22.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "YSVideoPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>

static const CGFloat kVideoControlBarHeight = 20.0 + 30.0;
static const CGFloat kVideoControlAnimationTimeInterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeInterval = 5.0;


typedef NS_ENUM(NSInteger,YSPanDirection){
    YSPanDirectionHorizontal, // 横向移动
    YSPanDirectionVertical   // 纵向移动
};


@interface YSVideoPlayerControlView()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL isVolumeAdjust;
@property (nonatomic, assign) YSPanDirection panDirection;
@property (nonatomic, strong) UISlider *volumeViewSlider;
@end

@implementation YSVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self configVolume];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    
    self.playButton.frame = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    
    self.pauseButton.frame = self.playButton.frame;
    
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame), 0, CGRectGetMinX(self.fullScreenButton.frame) - CGRectGetMaxX(self.playButton.frame), kVideoControlBarHeight);
    
    self.timeLabel.frame = CGRectMake(CGRectGetMidX(self.progressSlider.frame), CGRectGetHeight(self.bottomBar.bounds) - CGRectGetHeight(self.timeLabel.bounds) - 2.0, CGRectGetWidth(self.progressSlider.bounds)/2, CGRectGetHeight(self.timeLabel.bounds));
    
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 返回按钮
    self.backButton.frame = CGRectMake(CGRectGetMinX(self.topBar.bounds), CGRectGetHeight(self.topBar.bounds) - 40, 40, 40);
    // 锁定按钮
    self.lockButton.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.topBar.bounds) - 40, 40, 40);
    self.lockButton.center = CGPointMake(CGRectGetMinX(self.bounds) + CGRectGetWidth(self.lockButton.bounds), self.center.y);
    // 缓冲进度条
    self.bufferProgressView.bounds = CGRectMake(0, 0, self.progressSlider.bounds.size.width - 7, self.progressSlider.bounds.size.height);
    self.bufferProgressView.center = CGPointMake(self.progressSlider.center.x + 2, self.progressSlider.center.y);
    // 快进、快退指示器
    self.timeIndicatorView.center = self.indicatorView.center;
    // 亮度指示器
    self.brightnessIndicatorView.center = self.indicatorView.center;
    // 音量指示器
    self.volumeIndicatorView.center = self.indicatorView.center;

    // 标题
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.backButton.bounds), 20, CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.backButton.bounds) - CGRectGetWidth(self.lockButton.bounds), kVideoControlBarHeight - 20);
}
- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.isLockScreen = YES;
    [self addSubview:self.topBar];
    [self addSubview:self.bottomBar];
    [self.bottomBar addSubview:self.playButton];
    [self.bottomBar addSubview:self.pauseButton];
    self.pauseButton.hidden = YES;
    [self.bottomBar addSubview:self.fullScreenButton];
    [self.bottomBar addSubview:self.shrinkScreenButton];
    self.shrinkScreenButton.hidden = YES;
    [self.bottomBar addSubview:self.progressSlider];
    [self.bottomBar addSubview:self.timeLabel];
    [self addSubview:self.indicatorView];
    
    // 返回按钮
    [self.topBar addSubview:self.backButton];
    // 锁定按钮
    [self addSubview:self.lockButton];
    // 缓冲进度条
    [self.bottomBar insertSubview:self.bufferProgressView belowSubview:self.progressSlider];
    // 快进、快退指示器
    [self addSubview:self.timeIndicatorView];
    // 亮度指示器
    [self addSubview:self.brightnessIndicatorView];
    // 音量指示器
    [self addSubview:self.volumeIndicatorView];
    // 电池条
    //        [self.topBar addSubview:self.batteryView];
    // 标题
    [self.topBar addSubview:self.titleLabel];
    
    [self addGestureRecognizer:self.pan];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

#pragma mark - Public Method



- (void)animateHide
{
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
        self.lockButton.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
        self.lockButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

#pragma mark - Tap Detection

- (void)responseTapImmediately {
    self.bottomBar.alpha == 0 ? [self animateShow] : [self animateHide];
}


- (void)onTap:(UITapGestureRecognizer *)gesture
{
  
}

- (void)panAction:(UIPanGestureRecognizer *)pan{

    CGPoint localPoint = [pan locationInView:self];
    
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    if (self.isLockScreen) {
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            
            if (x > y) { // 水平移动
                self.panDirection = YSPanDirectionHorizontal;
                
            } else if (x < y) { // 垂直移动
                self.panDirection = YSPanDirectionVertical;
                if (localPoint.x > self.bounds.size.width / 2) { // 音量调节
                    self.isVolumeAdjust = YES;
                } else { // 亮度调节
                    self.isVolumeAdjust = NO;
                }
            }
        }
            break;
            
            
        case UIGestureRecognizerStateChanged: {
            
            switch (self.panDirection) {
                case YSPanDirectionHorizontal:
                {
                    self.timeIndicatorView.labelText = self.timeLabel.text;
                    
                    YSTimeIndicatorPlaystate playState = YSTimeIndicatorPlayStateRewind;
                    
                    if (veloctyPoint.x > 0) {
                        playState = YSTimeIndicatorPlayStateFastForward;
                    }else if (veloctyPoint.x < 0){
                        playState = YSTimeIndicatorPlayStateRewind;
                    }
                    
                    if (self.timeIndicatorView.playState != playState) {
                        if (veloctyPoint.x < 0) {
                            self.timeIndicatorView.playState = YSTimeIndicatorPlayStateRewind;
                            [self.timeIndicatorView setNeedsLayout];
                        }else if (veloctyPoint.x > 0){
                            self.timeIndicatorView.playState = YSTimeIndicatorPlayStateFastForward;
                            [self.timeIndicatorView setNeedsLayout];
                        }
                    }
                    
                    if (ABS(veloctyPoint.x) > ABS(veloctyPoint.y)) {
                        if ([pan translationInView:self].x > 0) {
                            if ([_delegate respondsToSelector:@selector(controlViewFingerMoveRight)]) {
                                [self.delegate controlViewFingerMoveRight];
                            }
                            [self configureWithTime:self.timeLabel.text];
                            [self.timeLabel setText:[NSString stringWithFormat:@"%@",self.timeLabel.text]];
                        }else{
                            if ([_delegate respondsToSelector:@selector(controlViewFingerMoveRight)]) {
                                [self.delegate controlViewFingerMoveLeft];
                            }
                            [self configureWithTime:self.timeLabel.text];
                        }
                }
                }
                    break;
                case YSPanDirectionVertical:{
                    [self verticalMoved:veloctyPoint.y];
                }
                    break;
                default:
                    break;
            }
        
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            switch (self.panDirection) {
                case YSPanDirectionHorizontal:{
                    [self autoFadeOutControlBar];
                }
                    break;
                case YSPanDirectionVertical:{
                    break;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    // UISlider & UIButton & topBar 不需要响应手势
    if([touch.view isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[UIButton class]] || [touch.view.accessibilityIdentifier isEqualToString:@"TopBar"]) {
        return NO;
    } else {
        return YES;
    }
}



#pragma mark -pan
/// pan垂直移动
- (void)verticalMoved:(CGFloat)value
{
    if (self.isVolumeAdjust) {
        // 调节系统音量
        self.volumeViewSlider.value -= value / 10000;
    }else {
        // 亮度
        [UIScreen mainScreen].brightness -= value / 10000;
    }
}

/// MARK: 系统音量控件

/// 获取系统音量控件
- (void)configVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.center = CGPointMake(-1000, 0);
    [self addSubview:volumeView];
    
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *error = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &error];
    
    if (!success) {/* error */}
    
}



#pragma mark - getters

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.accessibilityIdentifier = @"TopBar";
        _topBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomBar;
}
- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        _bgLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Video Bg"]].CGColor;
        _bgLayer.bounds = self.frame;
        _bgLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    }
    return _bgLayer;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"kr-video-player-fullscreen"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"kr-video-player-shrinkscreen"] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _shrinkScreenButton;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.4]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _timeLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kVideoControlBarHeight , kVideoControlBarHeight)];
        [_backButton setImage:[UIImage imageNamed:@"zx-video-banner-back"] forState:UIControlStateNormal];
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    }
    return _backButton;
}

- (UIButton *)lockButton
{
    if (!_lockButton) {
        _lockButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight)];
        [_lockButton setImage:[UIImage imageNamed:@"zx-video-player-unlock"] forState:UIControlStateNormal];
        [_lockButton setImage:[UIImage imageNamed:@"zx-video-player-lock"] forState:UIControlStateHighlighted];
        [_lockButton setImage:[UIImage imageNamed:@"zx-video-player-lock"] forState:UIControlStateSelected];
        _lockButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    return _lockButton;
}

- (UIProgressView *)bufferProgressView
{
    if (!_bufferProgressView) {
        _bufferProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bufferProgressView.progressTintColor = [UIColor colorWithWhite:1 alpha:0.3];
        _bufferProgressView.trackTintColor = [UIColor clearColor];
    }
    return _bufferProgressView;
}

- (YSVideoPlayerTimeIndicatorView *)timeIndicatorView
{
    if (!_timeIndicatorView) {
        _timeIndicatorView = [[YSVideoPlayerTimeIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kVideoTimeIndicatorViewSide, kVideoTimeIndicatorViewSide)];
    }
    return _timeIndicatorView;
}

- (YSVideoPlayerBrightnessView *)brightnessIndicatorView
{
    if (!_brightnessIndicatorView) {
        _brightnessIndicatorView = [[YSVideoPlayerBrightnessView alloc] initWithFrame:CGRectMake(0, 0, kVideoBrightnessIndicatorViewSide, kVideoBrightnessIndicatorViewSide)];
    }
    return _brightnessIndicatorView;
}

- (YSVideoPlayerVolumeView *)volumeIndicatorView
{
    if (!_volumeIndicatorView) {
        _volumeIndicatorView = [[YSVideoPlayerVolumeView alloc] initWithFrame:CGRectMake(0, 0, kVideoVolumeIndicatorViewSide, kVideoVolumeIndicatorViewSide)];
    }
    return _volumeIndicatorView;
}



- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIPanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        _pan.delegate = self;
    }
    return _pan;
}

#pragma mark - textchange
- (void)configureWithTime:(NSString *)time {
    [self.timeLabel setText:[NSString stringWithFormat:@"%@",time]];
}



@end
