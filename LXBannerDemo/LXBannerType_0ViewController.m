//
//  LXBannerType_0ViewController.m
//  LXBannerDemo
//
//  Created by LX Zeng on 2018/12/6.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import "LXBannerType_0ViewController.h"

#import "LXBannerView.h"

@interface LXBannerType_0ViewController ()

@property (nonatomic, strong) LXBannerView *bannerView;

@end

@implementation LXBannerType_0ViewController

#pragma mark - lazy load
- (LXBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [LXBannerView bannerViewWithFrame:CGRectMake(0, 0, kScreen_WIDTH, 200) style:LXBannerViewStyle_Normal imgArray:@[@"timg-1.jpeg", @"timg-2.jpeg", @"timg-3.jpeg", @"timg-4.jpeg", @"timg-5.jpeg"]];
#warning 自定义是否开启定时轮播（openTimer为YES开启，openTimer为No或者下面代码不写均为关闭）
        _bannerView.openTimer = YES;
        if (_bannerView.startTimerBlock) {
            _bannerView.startTimerBlock(2.0);
        }
    }
    return _bannerView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    [self setupNavBar];
    
    // 初始化bannerType_0View
    [self setupBannerType_0View];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.bannerView.openTimer) {
        if (self.bannerView.endTimerBlock) {
            self.bannerView.endTimerBlock();
        }
    }
}

- (void)dealloc {
    if (self.bannerView.openTimer) {
        if (self.bannerView.endTimerBlock) {
            self.bannerView.endTimerBlock();
        }
    }
}

#pragma mark - 初始化导航栏
- (void)setupNavBar {
    // leftBarButtonItem（返回）
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:ImageNamed(@"back") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = @[returnItem];
}

// 返回
- (void)returnBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化bannerType_0View
- (void)setupBannerType_0View {
    [self.view addSubview:self.bannerView];
}

@end
