//
//  ViewController.m
//  videopleyer
//
//  Created by yangyunsong on 16/12/7.
//  Copyright © 2016年 yangyunsong. All rights reserved.
//

#import "MainViewController.h"
#import "videoPlayerHeader.h"
#import "YSVideo.h"
#import "PlayerViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "ReadFile.h"
#import <SystemServices.h>
#import "NSString+Tools.h"
#import "MovieTableViewCell.h"
#define SystemSharedServices [SystemServices sharedServices]
#define kYSDevice  [UIDevice currentDevice].model

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *img;
}
@property (weak, nonatomic) IBOutlet UIView *pressView;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrM;
@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![kYSDevice isEqualToString:@"iPad"]) {
        [self forceOrientationPortrait];
        BaseNavigationController *navi = (BaseNavigationController *)self.navigationController;
        navi.interfaceOrientation =   UIInterfaceOrientationPortrait;
        navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        
        //强制翻转屏幕，Home键在右边。
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
        //刷新
        [UIViewController attemptRotationToDeviceOrientation];

    }

    self.navigationController.navigationBar.hidden = NO;
}

-(NSMutableArray *)arrM{
    if (!_arrM) {
        _arrM = [[ReadFile sharedManager]getLocalData];
        if (_arrM.count == 0) {
            [self createprompt];
        }
    }
    return _arrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"万能播放器";
 
    self.numLbl.text = [NSString stringWithFormat:@"主存储:%@ / 可用:%@", [SystemSharedServices diskSpace], [SystemSharedServices freeDiskSpaceinRaw]];
    UIView* pregssView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * (1 - [[[SystemSharedServices freeDiskSpaceinRaw] deleStringLastChar] floatValue] / [[[SystemSharedServices diskSpace] deleStringLastChar] floatValue]), self.pressView.bounds.size.height)];
    
    pregssView.backgroundColor = [UIColor colorWithRed:101/255.0 green:169/255.0 blue:184/255.0 alpha:1];
    
    [self.pressView addSubview:pregssView];
    
    [self.pressView sendSubviewToBack:pregssView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = 0;
    self.tableView.estimatedRowHeight = 90.f;
    self.tableView.rowHeight = 90.f;
    
    
}

- (void)createprompt{
    img = [[UIImageView alloc]initWithFrame:ScreenBounds];
    img.image = [UIImage imageNamed:@"prompt_01"];
    img.accessibilityIdentifier = @"promet";
    img.contentMode = UIViewContentModeScaleToFill;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(CGRectGetWidth(img.bounds) - 40, 20, 40, 40);
    [closeBtn addTarget:self action:@selector(closeprompt) forControlEvents:UIControlEventTouchUpInside];
    [img addSubview:closeBtn];
    img.userInteractionEnabled = YES;
    [self.view addSubview:img];
}
- (void)closeprompt{
    [img removeFromSuperview];
    img = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"localCell"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.arrM.count != 0) {
    YSVideo *video = self.arrM[indexPath.row];
    
    cell.video = video;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    YSVideo *video = self.arrM[indexPath.row];
    PlayerViewController *play = [[PlayerViewController alloc]init];
    play.video = video;
    [self.navigationController pushViewController:play animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    YSVideo *video = self.arrM[indexPath.row];
    NSLog(@"%@",video.filmName);

    [self.arrM removeObjectAtIndex:indexPath.row];
    [[ReadFile sharedManager]deleteLocalFile:video.filmPath];
  
    if (self.arrM.count == 0) {
        [self createprompt];
    }
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView reloadData];
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
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
