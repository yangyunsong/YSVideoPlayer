//
//  BaseNavigationController.m
//  videopleyer
//
//  Created by yangyunsong on 16/12/8.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "BaseNavigationController.h"
#import "videoPlayerHeader.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+(void)initialize{

    // 设置为不透明
    [[UINavigationBar appearance] setTranslucent:NO];
    // 设置导航栏背景颜色
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:101/255.0 green:169/255.0 blue:184/255.0 alpha:1];
    
    // 设置导航栏文字颜色
    NSMutableDictionary *color = [NSMutableDictionary dictionary];
    color[NSFontAttributeName] = kFont(17.0f);
    color[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [[UINavigationBar appearance]setTitleTextAttributes:color];
    
    // 拿到整个导航的外观
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    item.tintColor = [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f];
    
    // 设置字体大小
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = kFont(17.0);
    attr[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.visibleViewController.navigationItem.backBarButtonItem = backButtonItem;
    
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    if (![[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        return self.interfaceOrientationMask;
    }
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (![[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        return self.interfaceOrientation;
    }
    return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft;
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
