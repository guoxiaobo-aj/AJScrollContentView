//
//  AJPageContentView.h
//  AJScrollContentView
//
//  Created by Guoxb on 2019/12/10.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AJPageContentViewDelegate <NSObject>

@optional
- (void)ajContentViewScrollEndDecelerating:(NSInteger)currentIndex;

@end

@interface AJPageContentView : UIView

@property (nonatomic, weak) id<AJPageContentViewDelegate> delegate;

/// 当前显示的view索引
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;
/// 页面是否可手动滑动 - 默认可滑动
@property (nonatomic, assign) BOOL canScroll;


/// 初始化
/// @param frame frame
/// @param childVCs 子控制器数组
/// @param parentVC 父类vc
/// @param delegate 代理对象
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<AJPageContentViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
