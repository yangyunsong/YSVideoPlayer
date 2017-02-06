//
//  PlayerViewController.m
//  videopleyer
//
//  Created by yangyunsong on 16/12/14.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "YSVideoPlayerController.h"

#define kYSVideoPlayerOriginalWidth  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define kYSVideoPlayerOriginalHeight (kYSVideoPlayerOriginalWidth * (11.0 / 16.0))
#define kYScreenBounds [UIScreen mainScreen].bounds
#define kYSDevice  [UIDevice currentDevice].model
@interface PlayerViewController ()
{
    CGFloat beginTouchX;
}
@property (nonatomic, strong)YSVideoPlayerController *player;
@end

@implementation PlayerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    //强制旋转竖屏
    if ([kYSDevice isEqualToString:@"iPhone"]) {
    [self forceOrientationLandscape];
    BaseNavigationController *navi = (BaseNavigationController *)self.navigationController;
    navi.interfaceOrientation =   UIInterfaceOrientationLandscapeRight;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
        [UIViewController attemptRotationToDeviceOrientation];
    }
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      [self playVideo];

}

-(void)playVideo{
    if (!_player) {
        self.player = [[YSVideoPlayerController alloc]initWithFrame:CGRectMake(0, 0, kYSVideoPlayerOriginalWidth, kYSVideoPlayerOriginalHeight)];
        self.player.isLocal = YES;
        __weak typeof(self) weakSelf = self;
        
        __strong typeof(self) strongSelf = weakSelf;

        self.player.videoPlayerGoBackBlock = ^{
            [strongSelf.navigationController popViewControllerAnimated:NO];
        };
        
        [self.player showInView:self.view];
    }
    self.player.video = self.video;
}

/*
 * 屏幕旋转
 */
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
