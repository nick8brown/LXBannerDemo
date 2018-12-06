//
//  LXBannerView.h
//  LXBannerDemo
//
//  Created by LX Zeng on 2018/12/6.
//  Copyright © 2018   https://github.com/nick8brown   All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LXBannerViewStyle_Normal = 0, // 普通轮播
    LXBannerViewStyle_Loop // 无限循环轮播
} LXBannerViewStyle;

typedef void(^StartTimerBlock)(NSTimeInterval duration);
typedef void(^EndTimerBlock)(void);

@interface LXBannerView : UIView

@property (nonatomic, assign) LXBannerViewStyle style;

@property (nonatomic, assign) BOOL openTimer;
@property (nonatomic, copy) StartTimerBlock startTimerBlock;
@property (nonatomic, copy) EndTimerBlock endTimerBlock;

+ (instancetype)bannerViewWithFrame:(CGRect)frame style:(LXBannerViewStyle)style imgArray:(NSArray *)imgArray;
- (instancetype)initWithFrame:(CGRect)frame style:(LXBannerViewStyle)style imgArray:(NSArray *)imgArray;

@end

