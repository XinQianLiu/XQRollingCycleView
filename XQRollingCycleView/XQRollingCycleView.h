//
//  XQRollingCycleView.h
//  XQRollingCycleView
//
//  Created by 用户 on 16/9/1.
//  Copyright © 2016年 XinQianLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQRollingCycleView;
@protocol XQRollingCycleViewDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)selectIndex RollingCycleView:(XQRollingCycleView *)rollingCycleView;

@end

@interface XQRollingCycleView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

//初始化
+ (instancetype)rollingCycleViewWithImages:(NSArray *)images delegate:(id<XQRollingCycleViewDelegate>)delegate;

//----------------------------数据源接口
@property (nonatomic, strong) NSArray                           *images;        // 图片数组




//----------------------------滚动控制接口
@property (nonatomic, assign) id <XQRollingCycleViewDelegate>   delegate;       // 代理
@property (nonatomic, assign) CGFloat                           timerInterval;  // 自动滚动时间间隔， 默认 2.0f s
@property (nonatomic, assign) BOOL                              infiniteLoop;   // 是否无线循环， 默认 YES
@property (nonatomic, assign) BOOL                              autoScroll;     // 是否自动滚动， 默认 YES

@end

@interface XQRollingCycleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end