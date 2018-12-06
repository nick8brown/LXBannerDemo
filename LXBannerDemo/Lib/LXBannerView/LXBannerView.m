//
//  LXBannerView.m
//  LXBannerDemo
//
//  Created by LX Zeng on 2018/12/6.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import "LXBannerView.h"

#define bannerViewW CGRectGetWidth(self.frame)
#define bannerViewH CGRectGetHeight(self.frame)

#define PAGE self.imgData.count

@interface LXBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) NSArray *imgData;

@end

@implementation LXBannerView

#pragma mark - lazy load
- (StartTimerBlock)startTimerBlock {
    if (!_startTimerBlock) {
        self.openTimer = YES;
        
        __weak __typeof(self) weakSelf = self;
        _startTimerBlock = ^(NSTimeInterval duration){
            weakSelf.duration = duration;
            
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:weakSelf selector:@selector(repeatAnimation) userInfo:nil repeats:YES];
        };
    }
    return _startTimerBlock;
}

- (EndTimerBlock)endTimerBlock {
    if (!_endTimerBlock) {
        __weak __typeof(self) weakSelf = self;
        _endTimerBlock = ^(void){
            if ([weakSelf.timer isValid]) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
        };
    }
    return _endTimerBlock;
}

#pragma mark - private func
+ (instancetype)bannerViewWithFrame:(CGRect)frame style:(LXBannerViewStyle)style imgArray:(NSArray *)imgArray {
    return [[[self class] alloc] initWithFrame:frame style:style imgArray:imgArray];
}

- (instancetype)initWithFrame:(CGRect)frame style:(LXBannerViewStyle)style imgArray:(NSArray *)imgArray {
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = SYS_White_Color;
        
        self.style = style;
        
        // 初始化bannerView
        [self setupBannerView:imgArray];
    }
    return self;
}

#pragma mark - 初始化bannerView
- (void)setupBannerView:(NSArray *)imgArray {
    if (self.style == LXBannerViewStyle_Normal) {
        self.imgData = [NSMutableArray arrayWithArray:imgArray];
    } else if (self.style == LXBannerViewStyle_Loop) {
        // 前后+1
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObject:[imgArray lastObject]];
        [tempArray addObjectsFromArray:imgArray];
        [tempArray addObject:[imgArray firstObject]];
        
        self.imgData = [NSArray arrayWithArray:tempArray];
    }

    // scrollView
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = bannerViewW;
    CGFloat scrollViewH = bannerViewH;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
    self.scrollView.contentSize = CGSizeMake(PAGE*scrollViewW, 0);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    // imageView
    CGFloat imgViewY = 0;
    CGFloat imgViewW = bannerViewW;
    CGFloat imgViewH = bannerViewH;
    for (int i = 0; i < PAGE; i++) {
        CGFloat imgViewX = i * imgViewW;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH)];
//        imgView.backgroundColor = [UIColor randomColor];
        imgView.image = ImageNamed(self.imgData[i]);
        [self.scrollView addSubview:imgView];
    }
    
    // pageControl
    CGFloat pageControlX = 0;
    CGFloat pageControlW = bannerViewW;
    CGFloat pageControlH = 30;
    CGFloat pageControlY = bannerViewH - pageControlH;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    self.pageControl.numberOfPages = (self.style == LXBannerViewStyle_Normal) ? PAGE : PAGE-2;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = SYS_Orange_Color;
    [self addSubview:self.pageControl];
    
    // 显示第1页
    if (self.style == LXBannerViewStyle_Normal) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else if (self.style == LXBannerViewStyle_Loop) {
        [self.scrollView setContentOffset:CGPointMake(bannerViewW, 0) animated:NO];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    switch (self.style) {
        case LXBannerViewStyle_Normal:
        {
            NSInteger currentPage = self.scrollView.contentOffset.x / bannerViewW;
            self.pageControl.currentPage = currentPage;
        }
            break;
        case LXBannerViewStyle_Loop:
        {
            NSInteger currentPage = self.scrollView.contentOffset.x / bannerViewW;
            self.pageControl.currentPage = currentPage - 1;
        }
            break;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.openTimer) {
        // 释放定时器
        if (self.endTimerBlock) {
            self.endTimerBlock();
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    switch (self.style) {
        case LXBannerViewStyle_Normal:
        {
            NSInteger currentPage = self.scrollView.contentOffset.x / bannerViewW;
            [self.scrollView setContentOffset:CGPointMake(currentPage*bannerViewW, 0) animated:NO];
        }
            break;
        case LXBannerViewStyle_Loop:
        {
            NSInteger currentPage = self.scrollView.contentOffset.x / bannerViewW;
            if (currentPage == 0) {
                [self.scrollView setContentOffset:CGPointMake((PAGE-2)*bannerViewW, 0) animated:NO];
            } else if (currentPage == PAGE-1) {
                [self.scrollView setContentOffset:CGPointMake(bannerViewW, 0) animated:NO];
            }
        }
            break;
    }
    
    if (self.openTimer) {
        // 开启定时器
        if (self.startTimerBlock) {
            self.startTimerBlock(self.duration);
        }
    }
}

#pragma mark - 定时器
- (void)repeatAnimation {
    switch (self.style) {
        case LXBannerViewStyle_Normal:
        {
            NSInteger currentPage = (self.pageControl.currentPage+1) % PAGE;
            [UIView animateWithDuration:0.3 animations:^{
                [self.scrollView setContentOffset:CGPointMake(currentPage*bannerViewW, 0) animated:YES];
                
                self.pageControl.currentPage = currentPage;
            }];
        }
            break;
        case LXBannerViewStyle_Loop:
        {
            NSInteger currentPage = (self.pageControl.currentPage+1) % (PAGE-2);
            [UIView animateWithDuration:0.3 animations:^{
                if (currentPage == 0) {
                    [self.scrollView setContentOffset:CGPointMake(bannerViewW, 0) animated:NO];
                } else {
                    [self.scrollView setContentOffset:CGPointMake((currentPage+1)*bannerViewW, 0) animated:YES];
                }
                
                self.pageControl.currentPage = currentPage;
            }];
        }
            break;
    }
}

@end
