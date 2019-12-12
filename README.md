# AJScrollContentView

![badge-languages](https://img.shields.io/badge/language-ObjC-orange.svg) ![badge-platforms](https://img.shields.io/badge/platforms-iOS8-lightgrey.svg) [![Build Status](https://travis-ci.org/shunFSKi/FSScrollContentView.svg?branch=master)](https://travis-ci.org/shunFSKi/FSScrollContentView) [![CocoaPods](https://img.shields.io/cocoapods/v/AJScrollContentView.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/dt/FSScrollContentView.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/l/FSScrollContentView.svg)]()

仿网易新闻，点击顶部标题，改变下面内容页面；以及，滑动内容页面，改变顶部标题的功能。

因为项目中多次用到这样的控件，很多主流App也有这样的需求，有必要简单封装一下，分享给更多的开发者。

功能点：

* 单个页面展示多个视图，并根据不同类型展示不同内容页面；
* 顶部视图类型通过点击切换下方内容视图页面；
* 分为顶部标题 和 下方内容展示页面，互相分离，高内聚，低耦合；
* Controller只需要遵循相应的代理协议即可。

## 效果图

![几种类型的效果图](https://raw.githubusercontent.com/guoxiaobo-aj/ImageResources/master/aj_scroll_contentview.gif)

## 要求

* iOS 8以上
* Xcode 8+

## 安装

AJScrollContentView可通过Cocoapods获得，只需要将以下代码添加到Podfile文件：

`'AJScrollContentView','〜> 0.0.1'`

或者cd到项目根目录，执行：

`pod AJScrollContentView`

## API介绍

### 1. 顶部 AJSegmentTitleView

初始化方式

```
/// 实例化对象-初始化方法
/// @param frame frame
/// @param titles 标题数组
/// @param delegate 代理
/// @param type 样式类型
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<AJSegmentTitleViewDelegate>)delegate type:(AJSegmentTitleViewType)type;
```

属性

```
typedef enum : NSUInteger {
    AJSegmentTitleViewTypeDefault, // 默认
    AJSegmentTitleViewTypeUnderLine // 带有下划线
} AJSegmentTitleViewType;

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
```

代理协议

```
@protocol AJSegmentTitleViewDelegate <NSObject>

@optional
// 定位当前选中的标题按钮索引
- (void)ajTitleViewClickedIndex:(NSInteger)currentIndex;

@end
```

### 2. 底部内容页 AJPageContentView

初始化

```
/// 初始化
/// @param frame frame
/// @param childVCs 子控制器数组
/// @param parentVC 父类vc
/// @param delegate 代理对象
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<AJPageContentViewDelegate>)delegate;
```

属性

```
@property (nonatomic, weak) id<AJPageContentViewDelegate> delegate;

/// 当前显示的view索引
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;
/// 页面是否可手动滑动 - 默认可滑动
@property (nonatomic, assign) BOOL canScroll;
```

代理协议

```
@protocol AJPageContentViewDelegate <NSObject>

@optional
// 定位当前滚动到的内容页索引
- (void)ajContentViewScrollEndDecelerating:(NSInteger)currentIndex;

@end
```

## 使用实例

```
- (void)viewDidLoad {
	NSArray *pageTitles = @[@"关注", @"推荐", @"热点", @"北京", @"新时代", @"视频", @"图片", @"问答", @"懂车帝", @"军事"];
	
	/*
	 * title view
	 */
	self.titleView = [[AJSegmentTitleView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT + 44, SCREEN_WIDTH, 50) titles:_pageTitles delegate:self type:(AJSegmentTitleViewTypeUnderLine)];
	self.titleView.backgroundColor = UIColor.lightGrayColor;
	[self.view addSubview:self.titleView];
	    
	/*
	 * content view
	 */
	NSMutableArray *childVCs = [NSMutableArray array];
	for (NSString *title in _pageTitles) {
	    UIViewController *vc = [UIViewController new];
	    vc.view.backgroundColor = [self randomColor];
	    [childVCs addObject:vc];
	}
	self.contentView = [[AJPageContentView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT + 44 + 50, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBARHEIGHT - 50 - 44) childVCs:childVCs parentVC:self delegate:self];
	[self.view addSubview:self.contentView];
	    
	self.titleView.selectedIndex = self.contentView.contentViewCurrentIndex = 0;
}

#pragma mark - AJSegmentTitleViewDelegate

- (void)ajTitleViewClickedIndex:(NSInteger)currentIndex {
    NSLog(@"title - %ld", currentIndex);
    self.contentView.contentViewCurrentIndex = currentIndex;
    self.title = _pageTitles[currentIndex];
}

#pragma mark - AJPageContentViewDelegate

- (void)ajContentViewScrollEndDecelerating:(NSInteger)currentIndex {
    NSLog(@"content - %ld", currentIndex);
    self.titleView.selectedIndex = currentIndex;
    self.title = _pageTitles[currentIndex];
}
```

## 作者

* 微博：[@夜雨寒I](https://weibo.com/p/1005055104640336)
* Email：gxbxemail@163.com
* 公众号：![](https://raw.githubusercontent.com/guoxiaobo-aj/ImageResources/master/wechat-qcode.png)
* 个人博客：[https://guoxb.com](https://guoxb.com)
