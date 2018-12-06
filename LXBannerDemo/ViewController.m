//
//  ViewController.m
//  LXBannerDemo
//
//  Created by LX Zeng on 2018/12/6.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import "ViewController.h"

#import "LXBannerType_0ViewController.h"
#import "LXBannerType_1ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"banner轮播";
    
    // 初始化导航栏
    [self setupNavBar];
}

#pragma mark - 初始化导航栏
- (void)setupNavBar {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:AppFont(18), NSForegroundColorAttributeName:SYS_White_Color}];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage getImageWithColor:AppHTMLColor(@"4bccbc")] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - 普通轮播（定时）
- (IBAction)type_0BtnClick:(UIButton *)sender {
    LXBannerType_0ViewController *bannerType_0VC = [[LXBannerType_0ViewController alloc] init];
    bannerType_0VC.title = @"样式一";
    [self.navigationController pushViewController:bannerType_0VC animated:YES];
}

#pragma mark - 无限循环轮播（无定时）
- (IBAction)type_1BtnClick:(UIButton *)sender {
    LXBannerType_1ViewController *bannerType_1VC = [[LXBannerType_1ViewController alloc] init];
    bannerType_1VC.title = @"样式二";
    [self.navigationController pushViewController:bannerType_1VC animated:YES];
}

@end
