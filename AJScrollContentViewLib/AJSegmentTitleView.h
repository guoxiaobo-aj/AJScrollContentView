//
//  AJSegmentTitleView.h
//  AJScrollContentView
//
//  Created by Guoxb on 2019/12/10.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AJSegmentTitleViewTypeDefault,
    AJSegmentTitleViewTypeUnderLine
} AJSegmentTitleViewType;

@protocol AJSegmentTitleViewDelegate <NSObject>

@optional
- (void)ajTitleViewClickedIndex:(NSInteger)currentIndex;

@end

@interface AJSegmentTitleView : UIView

/// 代理
@property (nonatomic, weak) id<AJSegmentTitleViewDelegate> delegate;

/// 标题数组
@property (nonatomic, strong) NSArray *titlesArray;
/// 按钮-未选中-颜色
@property (nonatomic, strong) UIColor *titleNormalColor;
/// 按钮-选中-颜色
@property (nonatomic, strong) UIColor *titleSelectColor;
/// 按钮-未选中-文字样式
@property (nonatomic, strong) UIFont *titleFont;
/// 按钮-选中-文字样式
@property (nonatomic, strong) UIFont *titleSelectFont;
/// 当前-选中-的按钮下标
@property (nonatomic, assign) NSInteger selectedIndex;
/// 按钮左右内边距
@property (nonatomic, assign) CGFloat btnPadding;
/// 按钮中间边距
@property (nonatomic, assign) CGFloat btnMargin;
/// 类型
@property (nonatomic, assign) AJSegmentTitleViewType type;

/// 实例化对象-初始化方法
/// @param frame frame
/// @param titles 标题数组
/// @param delegate 代理
/// @param type 样式类型
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<AJSegmentTitleViewDelegate>)delegate type:(AJSegmentTitleViewType)type;

@end

NS_ASSUME_NONNULL_END
