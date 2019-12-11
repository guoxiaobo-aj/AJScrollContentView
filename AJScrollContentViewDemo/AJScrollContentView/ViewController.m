//
//  ViewController.m
//  AJScrollContentView
//
//  Created by Guoxb on 2019/12/10.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import "ViewController.h"
#import "AJScrollContentView.h"

#define IS_IPHONE_X (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
#define IS_IPHONE_XR (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)
#define IS_IPHONE_XMAX (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)
#define IS_IPHONE_X_XR_MAX (IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XMAX)
#define STATUSBARHEIGHT (IS_IPHONE_X_XR_MAX ? 44 : 20)

#define SCREEN_WIDTH [[UIScreen mainScreen ] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen ] bounds].size.height

@interface ViewController () <AJSegmentTitleViewDelegate, AJPageContentViewDelegate>
{
    NSArray *_pageTitles;
}
@property (nonatomic, strong) AJSegmentTitleView *titleView;
@property (nonatomic, strong) AJPageContentView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _pageTitles = @[@"关注", @"推荐", @"热点", @"北京", @"新时代", @"视频", @"图片", @"问答", @"懂车帝", @"军事"];
    
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
    self.title = _pageTitles[0];
}

- (UIColor*)randomColor {
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
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

@end
