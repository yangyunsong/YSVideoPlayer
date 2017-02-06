//
//  YSVideoPlayerControlView.h
//  videopleyer
//
//  Created by yangyunsong on 16/12/22.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSVideoPlayerTimeIndicatorView.h"
#import "YSVideoPlayerVolumeView.h"
#import "YSVideoPlayerBrightnessView.h"
#import <AVFoundation/AVFoundation.h>

#define kYSPlayerControlViewHideNotification @"YSPlayerControlViewHideNotification"



@protocol YSVideoControlViewDelegate <NSObject>

@optional
- (void)contentViewFingerMoveUp;
- (void)controlViewFingerMoveDown;
- (void)controlViewFingerMoveLeft;
- (void)controlViewFingerMoveRight;

@end


@interface YSVideoPlayerControlView : UIView

@property (nonatomic, weak) id<YSVideoControlViewDelegate>delegate;

@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign, readonly) BOOL isBarShowing;
/// 返回按钮
@property (nonatomic, strong, readwrite) UIButton *backButton;
/// 屏幕锁定按钮
@property (nonatomic, strong, readwrite) UIButton *lockButton;
/// 锁定屏幕
@property (nonatomic, assign, readwrite) BOOL isLockScreen;
/// 缓冲进度条
@property (nonatomic, strong, readwrite) UIProgressView *bufferProgressView;
/// 快进、快退指示器
@property (nonatomic, strong, readwrite) YSVideoPlayerTimeIndicatorView *timeIndicatorView;
/// 亮度指示器
@property (nonatomic, strong, readwrite) YSVideoPlayerBrightnessView *brightnessIndicatorView;
/// 音量指示器
@property (nonatomic, strong, readwrite) YSVideoPlayerVolumeView *volumeIndicatorView;
/// 标题
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;
- (void)responseTapImmediately;
@end

