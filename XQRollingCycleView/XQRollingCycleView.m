//
//  XQRollingCycleView.m
//  XQRollingCycleView
//
//  Created by 用户 on 16/9/1.
//  Copyright © 2016年 XinQianLiu. All rights reserved.
//

#import "XQRollingCycleView.h"

static NSString *const cellID = @"cellID";

@interface XQRollingCycleView ()

@property (nonatomic, strong) UICollectionView              *myCollectionView;  // 滚动视图
@property (nonatomic, strong) UICollectionViewFlowLayout    *layout;
@property (nonatomic, weak) NSTimer                         *timer;             // 循环滚动定时器
@property (nonatomic, assign) NSInteger                     totalItemsCount;

@end

@implementation XQRollingCycleView

#pragma mark - 初始化
+ (instancetype)rollingCycleViewWithImages:(NSArray *)images delegate:(id<XQRollingCycleViewDelegate>)delegate
{
    XQRollingCycleView *rollingCycleView = [[[self class] alloc] init];
    rollingCycleView.delegate = delegate;
    rollingCycleView.images = images;
    return rollingCycleView;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 150);
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[XQRollingCycleCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _myCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_myCollectionView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_myCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_myCollectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_myCollectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_myCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        _infiniteLoop = YES;
        self.autoScroll = YES;
        self.timerInterval = 2.0f;
    }
    
    return self;
}

#pragma mark - 私有方法
- (void)setupTimer
{
    [self invalidateTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
}

- (void)invalidateTimer
{
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (int)currentIndex
{
    int index = 0;
    
    if (_layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_myCollectionView.contentOffset.x + _layout.itemSize.width * 0.5) / _layout.itemSize.width;
    }
    else{
        index = (_myCollectionView.contentOffset.y + _layout.itemSize.height * 0.5) / _layout.itemSize.height;
    }
    
    return index;
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.images.count;
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
        return;
    }
    
    [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - Action
- (void)automaticScroll
{
    if (_totalItemsCount == 0) {
        return;
    }
    
    int currentIndex = [self currentIndex];
    int targentIndex = currentIndex + 1;
    [self scrollToIndex:targentIndex];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XQRollingCycleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.images[itemIndex]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(didSelectIndex:RollingCycleView:)]) {
        [_delegate didSelectIndex:indexPath.row RollingCycleView:self];
    }
}

#pragma mark - Setters
- (void)setTimerInterval:(CGFloat)timerInterval
{
    _timerInterval = timerInterval;
    [self setAutoScroll:_autoScroll];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    _totalItemsCount = self.infiniteLoop ? images.count * 100 : images.count;
    
    if (images.count != 1) {
        _myCollectionView.scrollEnabled = YES;
        [self setAutoScroll:_autoScroll];
    }
    else {
        _myCollectionView.scrollEnabled = NO;
    }
    
    [_myCollectionView reloadData];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        [self setupTimer];
    }
}
@end

#pragma mark - Cell
@implementation XQRollingCycleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imageView];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    
    return self;
}

@end
