//
//  AJSegmentTitleView.m
//  AJScrollContentView
//
//  Created by Guoxb on 2019/12/10.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import "AJSegmentTitleView.h"

@interface AJSegmentTitleView () 

@property (nonatomic, strong) NSMutableArray *btnsArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *underLine;

@end

@implementation AJSegmentTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id<AJSegmentTitleViewDelegate>)delegate type:(AJSegmentTitleViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
        self.titlesArray = titles;
        self.delegate = delegate;
        self.type = type;
    }
    return self;
}

#pragma mark - private

/// 属性初始化
- (void)initProperty {
    self.selectedIndex = 0;
    self.titleNormalColor = UIColor.blackColor;
    self.titleSelectColor = UIColor.redColor;
    self.titleFont = [UIFont systemFontOfSize:15.0f];
    self.titleSelectFont = self.titleFont;
    self.btnPadding = 20.0f;
    self.btnMargin = 0;
}

/**
 重新绘制
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
    if (self.titlesArray.count == 0) {
        return;
    }
    
    CGFloat totalWidth = 0;
    UIFont *tleFont = self.titleFont;
    if (self.titleFont != self.titleSelectFont) {
        for (int i = 0; i < self.btnsArray.count; i ++) {
            UIButton *btn = self.btnsArray[i];
            tleFont = btn.selected ? self.titleSelectFont : self.titleFont;
            CGFloat width = [self widthWithString:self.titlesArray[i] font:tleFont];
            totalWidth += width + self.btnPadding * 2;
        }
    } else {
        for (NSString *title in self.titlesArray) {
            CGFloat width = [self widthWithString:title font:self.titleFont];
            totalWidth += width + self.btnPadding * 2;
        }
    }
    totalWidth += (self.btnsArray.count - 1) * self.btnMargin;
    
    CGFloat btnX = 0;
    CGFloat btnH = CGRectGetHeight(self.bounds);
    for (UIButton *btn in self.btnsArray) {
        tleFont = btn.selected ? self.titleSelectFont : self.titleFont;
        CGFloat width = [self widthWithString:btn.titleLabel.text font:tleFont];
        width += self.btnPadding * 2;
        btn.frame = CGRectMake(btnX, 0, width, btnH);
        if (btn.selected && self.type == AJSegmentTitleViewTypeUnderLine) {
            CGPoint center = self.underLine.center;
            center.x = btnX + width / 2;
            [UIView animateWithDuration:0.2 animations:^{
                self.underLine.center = center;
            }];
        }
        btnX += width;
    }
    self.scrollView.contentSize = CGSizeMake(totalWidth, btnH);
}

- (void)buttonClick:(UIButton *)button {
    NSInteger tag = button.tag - 1000;
    if (tag == self.selectedIndex) {
        return;
    }
    self.selectedIndex = tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ajTitleViewClickedIndex:)]) {
        [self.delegate ajTitleViewClickedIndex:self.selectedIndex];
    }
}

/// 计算文本宽度
/// @param string 文本内容
/// @param font 文本字体
- (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

/// 滚动选中按钮到屏幕中间位置
- (void)scrollSelectBtnToCenter {
    if (self.scrollView.contentSize.width <= CGRectGetWidth(self.bounds)) {
        return;
    }
    // 获取当前按钮center
    UIButton *button = self.btnsArray[self.selectedIndex];
    CGFloat center = button.frame.origin.x + button.frame.size.width / 2;
    CGPoint contentOffset;
    if (center < CGRectGetWidth(self.bounds) / 2) {
        // 滚动到头部
        contentOffset = CGPointMake(0, 0);
    } else if (self.scrollView.contentSize.width - center <= CGRectGetWidth(self.bounds) / 2) {
        // 滚动到尾部
        contentOffset = CGPointMake(self.scrollView.contentSize.width - CGRectGetWidth(self.bounds), 0);
    } else {
        // 滚动到中间
        contentOffset = CGPointMake(center - CGRectGetWidth(self.bounds) / 2, 0);
    }
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark - Setters

- (void)setTitlesArray:(NSArray *)titlesArray {
    _titlesArray = titlesArray;
    [self.btnsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.btnsArray removeAllObjects];
    if (titlesArray.count - 1 < self.selectedIndex) {
        _selectedIndex = 0;
    }
    int index = 0;
    for (NSString *title in titlesArray) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        button.titleLabel.font = self.titleFont;
        button.tag = 1000 + index;
        if (self.selectedIndex == index) {
            button.selected = YES;
            button.titleLabel.font = self.titleSelectFont;
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnsArray addObject:button];
        [self.scrollView addSubview:button];
        index ++;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex) {
        return;
    }
    
    UIButton *button = [self.scrollView viewWithTag:1000 + _selectedIndex];
    button.selected = NO;
    button.titleLabel.font = self.titleFont;
    _selectedIndex = selectedIndex;
    UIButton *currentBtn = [self.scrollView viewWithTag:1000 + _selectedIndex];
    currentBtn.selected = YES;
    currentBtn.titleLabel.font = self.titleSelectFont;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self scrollSelectBtnToCenter];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.btnsArray) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor {
    _titleSelectColor = titleSelectColor;
    for (UIButton *btn in self.btnsArray) {
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    for (UIButton *btn in self.btnsArray) {
        btn.titleLabel.font = btn.selected ? self.titleSelectFont : titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont {
    _titleSelectFont = titleSelectFont;
    for (UIButton *btn in self.btnsArray) {
        btn.titleLabel.font = btn.selected ? titleSelectFont : self.titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setBtnPadding:(CGFloat)btnPadding {
    _btnPadding = btnPadding;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setBtnMargin:(CGFloat)btnMargin {
    _btnMargin = btnMargin;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setType:(AJSegmentTitleViewType)type {
    _type = type;
    if (type == AJSegmentTitleViewTypeUnderLine) {
        [self.scrollView addSubview:self.underLine];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } else {
        [self.underLine removeFromSuperview];
    }
}

#pragma mark - Lazyload

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray *)btnsArray {
    if (!_btnsArray) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 2, 40, 2)];
        _underLine.backgroundColor = self.titleSelectColor;
    }
    return _underLine;
}

@end
