//
//  AJPageContentView.m
//  AJScrollContentView
//
//  Created by Guoxb on 2019/12/10.
//  Copyright © 2019 Guoxb. All rights reserved.
//

#import "AJPageContentView.h"

#define CellIdentifier @"collectionViewIdentifier"
#define iOS_Version ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface AJPageContentView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong) NSArray *childVCs;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AJPageContentView

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<AJPageContentViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentVC = parentVC;
        self.childVCs = childVCs;
        self.delegate = delegate;
        
        for (UIViewController *childVC in self.childVCs) {
            [self.parentVC addChildViewController:childVC];
        }
        
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (iOS_Version < 8.0) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIViewController *childVC = [self.childVCs objectAtIndex:indexPath.item];
        childVC.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:childVC.view];
    }
    return cell;
}

#ifdef __IPHONE_8_0

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVC = [self.childVCs objectAtIndex:indexPath.item];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];
}

#endif

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentIndex = floor(offsetX / CGRectGetWidth(scrollView.bounds));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ajContentViewScrollEndDecelerating:)]) {
        [self.delegate ajContentViewScrollEndDecelerating:currentIndex];
    }
}

#pragma mark - setter

- (void)setContentViewCurrentIndex:(NSInteger)contentViewCurrentIndex {
    if (contentViewCurrentIndex < 0 || contentViewCurrentIndex > self.childVCs.count - 1) {
        return;
    }
    _contentViewCurrentIndex = contentViewCurrentIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:contentViewCurrentIndex inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    self.collectionView.scrollEnabled = _canScroll;
}

#pragma mark - Lazyload

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

@end
