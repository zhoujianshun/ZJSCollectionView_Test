//
//  ZJSDraggableCollectionViewFlowLayout.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/20.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "ZJSDraggableCollectionViewFlowLayout.h"

@interface ZJSDraggableCollectionViewFlowLayout()<UIGestureRecognizerDelegate>

@property (nonatomic,readonly) id<ZJSDraggableCollectionViewDataSource> dataSource;
@property (nonatomic,readonly) id<ZJSDraggableCollectionViewFlowLayoutDelegate> delegate;

@end


@implementation ZJSDraggableCollectionViewFlowLayout{
    UILongPressGestureRecognizer * _longPressGestureRecognizer;
    NSIndexPath * _movingItemIndexPath;
    UIView *_beingMovedPromptView;
    CGPoint _sourceItemCollectionViewCellCenter;
    CGPoint _beginPoint;
    
    
}

#pragma mark - setup

-(void)dealloc{
    [self removeGestureRecognizers];
    [self removeObserver:self forKeyPath:@"collectionView"];
}

-(void)setup{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueChangeNewKey||NSKeyValueChangeOldKey context:nil];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


-(void)addGestureRecognizers{
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerTriggerd:)]
    ;
    //_longPressGestureRecognizer.cancelsTouchesInView = NO; // 源码上是这么设置的，不知道为什么暂时不打开
    _longPressGestureRecognizer.delegate = self;
    
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)removeGestureRecognizers{
    if (_longPressGestureRecognizer) {
        if (_longPressGestureRecognizer.view) {
            [_longPressGestureRecognizer.view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer = nil;
    }
    
}

#pragma mark - override UICollectionViewLayout methods
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];;
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            layoutAttributes.hidden = [layoutAttributes.indexPath isEqual: _movingItemIndexPath];
        }
    }
    return layoutAttributesForElementsInRect;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:_movingItemIndexPath];
    }
    return layoutAttributes;
}

#pragma mark - gesture

-(void)longPressGestureRecognizerTriggerd:(UILongPressGestureRecognizer *)longPressGestureRecognizer{
   // NSLog(@"longPressGestureRecognizerTriggerd");
    
    switch (longPressGestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
        {
            // 开始
            _movingItemIndexPath = [self.collectionView indexPathForItemAtPoint:[longPressGestureRecognizer locationInView:self.collectionView]];
            
            if (!_movingItemIndexPath) {
                return;
            }
            
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]&&([self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:_movingItemIndexPath] == NO)) {
                return ;
            }
            
            self.edit = YES;
            
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self didBeginDraggingItemAtIndexPath:_movingItemIndexPath];
            }
            
            _beginPoint = [longPressGestureRecognizer locationInView:self.collectionView];
            
            UICollectionViewCell * sourceCollectionViewCell = [self.collectionView cellForItemAtIndexPath:_movingItemIndexPath];
            _beingMovedPromptView = [[UIView alloc] initWithFrame:sourceCollectionViewCell.frame];
            _beingMovedPromptView.backgroundColor = [UIColor redColor];
            UIView *snapshot =  [sourceCollectionViewCell snapshotViewAfterScreenUpdates:NO];
            [_beingMovedPromptView addSubview:snapshot];
            [self.collectionView addSubview:_beingMovedPromptView];
            
            static NSString * const kVibrateAnimation = @"kVibrateAnimation";
            static CGFloat const VIBRATE_DURATION = 0.1;
            static CGFloat const VIBRATE_RADIAN = M_PI / 96;
            
            
            CABasicAnimation * vibrateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            vibrateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            vibrateAnimation.fromValue = @(- VIBRATE_RADIAN);
            vibrateAnimation.toValue = @(VIBRATE_RADIAN);
            vibrateAnimation.autoreverses = YES;
            vibrateAnimation.duration = VIBRATE_DURATION;
            vibrateAnimation.repeatCount = CGFLOAT_MAX;
            [_beingMovedPromptView.layer addAnimation:vibrateAnimation forKey:kVibrateAnimation];
            
            _sourceItemCollectionViewCellCenter = sourceCollectionViewCell.center;

            typeof(self) __weak weakSelf = self;
            [UIView animateWithDuration:0
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 
                                 typeof(self) __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     
                                 }
                             }
                             completion:^(BOOL finished) {
                                 
                                 typeof(self) __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     
                                     
                                     if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                                         [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didEndDraggingItemAtIndexPath:_movingItemIndexPath];
                                     }
                                 }
                             }];
            [self invalidateLayout];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            // 处理移动
            
            CGPoint currentPoint = [longPressGestureRecognizer locationInView:self.collectionView];
            CGPoint destinationPoint = CGPointMake(_sourceItemCollectionViewCellCenter.x + (currentPoint.x - _beginPoint.x), _sourceItemCollectionViewCellCenter.y + (currentPoint.y - _beginPoint.y));
            NSLog(@"currentPoint:%@",NSStringFromCGPoint(currentPoint));
            _beingMovedPromptView.center = destinationPoint;
            
            [self scrollIfNeededAtPoint:destinationPoint];
        
            
            [self exchangeItemsIfNeeded];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            // 结束
            NSIndexPath * movingItemIndexPath = _movingItemIndexPath;
            if (movingItemIndexPath) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:movingItemIndexPath];
                }
            }
            
            _movingItemIndexPath = nil;
            _sourceItemCollectionViewCellCenter = CGPointZero;
            _beginPoint = CGPointZero;
            
            _longPressGestureRecognizer.enabled = NO;
            
            UICollectionViewLayoutAttributes *layoutAttributs = [self.collectionView layoutAttributesForItemAtIndexPath:movingItemIndexPath];
            
            typeof(self) __weak weakSelf = self;
            [UIView animateWithDuration:0.f
                                  delay:0.f
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 typeof(self) __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     _beingMovedPromptView.center = layoutAttributs.center;
                                 }
                                 
                             } completion:^(BOOL finished) {
                                 
                                 _longPressGestureRecognizer.enabled = YES;
                                 typeof(self) __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     [_beingMovedPromptView removeFromSuperview];
                                     _beingMovedPromptView = nil;
                                     
                                     [self invalidateLayout];
                                     
                                     if ([self.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                                         [self.delegate collectionView:self.collectionView layout:self didEndDraggingItemAtIndexPath:movingItemIndexPath];
                                     }
                                     
                                 }
                             }];

        }
            break;
        case UIGestureRecognizerStateFailed:
            break;
            
        default:
            break;
    }
}

-(void)scrollIfNeededAtPoint:(CGPoint)destinationPoint{
    
    if (!_movingItemIndexPath) {
        return;
    }
    if (destinationPoint.y + 40 > (self.collectionView.contentOffset.y + self.collectionView.frame.size.height)) {
        
        CGPoint newContentOffset = self.collectionView.contentOffset;
        newContentOffset.y = newContentOffset.y +1;
        
        if (newContentOffset.y + CGRectGetHeight(self.collectionView.bounds) > self.collectionView.contentSize.height) {
            return;
        }
        
        self.collectionView.contentOffset = newContentOffset;
        _beingMovedPromptView.center = CGPointMake(_beingMovedPromptView.center.x, _beingMovedPromptView.center.y + 1);
        
        [self exchangeItemsIfNeeded];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollIfNeededAtPoint:_beingMovedPromptView.center];
        });
    }
    
    if (destinationPoint.y - 40 < self.collectionView.contentOffset.y) {
        CGPoint newContentOffset = self.collectionView.contentOffset;
        newContentOffset.y = newContentOffset.y -1;
        
        if (0  >= newContentOffset.y) {
            return;
        }
        
        self.collectionView.contentOffset = newContentOffset;
        _beingMovedPromptView.center = CGPointMake(_beingMovedPromptView.center.x, _beingMovedPromptView.center.y - 1);
        
        [self exchangeItemsIfNeeded];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollIfNeededAtPoint:_beingMovedPromptView.center];
        });
    }
    
}

-(void)exchangeItemsIfNeeded{
    
    if (!_movingItemIndexPath) {
        return;
    }

    NSIndexPath *sourceIndexPath = _movingItemIndexPath;
    NSIndexPath *destinationIndexPath = [self.collectionView indexPathForItemAtPoint:_beingMovedPromptView.center];
    
    if (destinationIndexPath == nil || [sourceIndexPath isEqual:destinationIndexPath]) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.dataSource collectionView:self.collectionView itemAtIndexPath:sourceIndexPath willMoveToIndexPath:destinationIndexPath];
    }
    
    _movingItemIndexPath = destinationIndexPath;
    
    typeof(self) __weak weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        typeof(self) __strong strongSelf = weakSelf;
        if (strongSelf) {
 //           if (sourceIndexPath&&destinationIndexPath) {
                [strongSelf.collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
                [strongSelf.collectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
//            }else{
//                [strongSelf invalidateLayout];
//            }

        }
        
    } completion:^(BOOL finished) {
        typeof(self) __strong strongSelf = weakSelf;
        if (strongSelf) {
            if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
                [strongSelf.dataSource collectionView:self.collectionView itemAtIndexPath:sourceIndexPath didMoveToIndexPath:destinationIndexPath];
            }
        }
    }];
}


//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (self.edit) {
//        return _movingItemIndexPath != nil;
//    }
//    return YES;
//}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if ([_longPressGestureRecognizer isEqual:gestureRecognizer]) {
//        return [_panGestureRecognizer isEqual:otherGestureRecognizer];
//    }
//    
//    if ([_panGestureRecognizer isEqual:gestureRecognizer]) {
//        return [_longPressGestureRecognizer isEqual:otherGestureRecognizer];
//    }
//    
//    return NO;
//}



#pragma mark - getter
-(id<ZJSDraggableCollectionViewDataSource>)dataSource{
    return (id<ZJSDraggableCollectionViewDataSource>)self.collectionView.dataSource;
}

-(id<ZJSDraggableCollectionViewFlowLayoutDelegate>)delegate{
    return (id<ZJSDraggableCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
}


#pragma mark - kVO and notification
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"collectionView"]) {
        if (self.collectionView) {
            [self addGestureRecognizers];
        }else{
            [self removeGestureRecognizers];
        }
    }
}

-(void)applicationWillResignActive:(NSNotification *)notification{
    
    // 取消当前状态
    _longPressGestureRecognizer.enabled = NO;
    _longPressGestureRecognizer.enabled = YES;
}


@end
