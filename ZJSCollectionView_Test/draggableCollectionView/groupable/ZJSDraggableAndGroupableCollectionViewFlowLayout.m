//
//  ZJSDraggableCollectionViewFlowLayout.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/20.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "ZJSDraggableAndGroupableCollectionViewFlowLayout.h"
#import "ZJSDraggableCollectionViewCell.h"
#import "ZJSShelfViewDecorationView.h"
#import "MXRCGUtil.h"


@interface ZJSDraggableAndGroupableCollectionViewFlowLayout()<UIGestureRecognizerDelegate>

@property (nonatomic,readonly) id<ZJSDraggableAndGroupableCollectionViewDataSource> dataSource;
@property (nonatomic,readonly) id<ZJSDraggableAndGroupableCollectionViewFlowLayoutDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *array;



@end


@implementation ZJSDraggableAndGroupableCollectionViewFlowLayout{

//    {
//        
//        CGPoint currentPoint = [sender locationInView:self.collectionView];
//        self.beingMovedPromptView.center = currentPoint;
//    }
    
}

#pragma mark - setup

-(void)dealloc{
//    [self removeGestureRecognizers];
    [self removeObserver:self forKeyPath:@"collectionView"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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



-(void)prepareLayout{
    [super prepareLayout];

}

#pragma mark - override UICollectionViewLayout methods
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];;
    
        NSMutableArray *attributes =[[NSMutableArray alloc] initWithArray:layoutAttributesForElementsInRect];
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            layoutAttributes.hidden = [layoutAttributes.indexPath isEqual: _movingItemIndexPath];
        }
        
    }

    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:_movingItemIndexPath];
        
    }
    NSLog(@"indexPath:%@",indexPath);
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
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_movingItemIndexPath];
            if (![cell isKindOfClass:[ZJSDraggableCollectionViewCell class]]) {
                _movingItemIndexPath = nil;
                return;
            }
            
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]&&([self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:_movingItemIndexPath] == NO)) {
                return ;
            }
            
            self.edit = YES;
            
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:_movingItemIndexPath];
            }
            
            self.panEnable = YES;
            self.collectionView.panGestureRecognizer.enabled = NO;
            
            ZJSDraggableCollectionViewCell * sourceCollectionViewCell = (ZJSDraggableCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:_movingItemIndexPath];
            UIView *snapshot =  [sourceCollectionViewCell snapshotView];
            snapshot.center = [self getbeingMovingViewCenterWithSourcePoint:sourceCollectionViewCell.center toView:longPressGestureRecognizer.view];
            self.beingMovedPromptView = snapshot;
            

            [longPressGestureRecognizer.view addSubview:self.beingMovedPromptView];
        
            
             __weak ZJSDraggableAndGroupableCollectionViewFlowLayout *weakSelf = self;
            [UIView animateWithDuration:0
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 
                                ZJSDraggableAndGroupableCollectionViewFlowLayout * __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     if (self.isGroup) {
                                         self.beingMovedPromptView.transform = CGAffineTransformMakeScale(1.1f*100.f/75.f, 1.1f*100.f/75.f);
                                     }else{
                                         self.beingMovedPromptView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                                     }
                                     
                                     self.beingMovedPromptView.alpha = 0.8f;
                                 }
                             }
                             completion:^(BOOL finished) {
                                 
                                 ZJSDraggableAndGroupableCollectionViewFlowLayout * __strong strongSelf = weakSelf;
                                 if (strongSelf) {
                                     
                                     
                                     if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                                         [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didBeginDraggingItemAtIndexPath:_movingItemIndexPath];
                                     }
                                 }
                             }];
            [self invalidateLayout];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
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
            
            self.panEnable = NO;
            self.collectionView.panGestureRecognizer.enabled = YES;
            _movingItemIndexPath = nil;
            
           // _longPressGestureRecognizer.enabled = NO;
            
            UICollectionViewLayoutAttributes *layoutAttributs = [self.collectionView layoutAttributesForItemAtIndexPath:movingItemIndexPath];
            
            ZJSDraggableAndGroupableCollectionViewFlowLayout * __weak weakSelf = self;
            [UIView animateWithDuration:0.f
                                  delay:0.f
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 ZJSDraggableAndGroupableCollectionViewFlowLayout * __strong strongSelf = weakSelf;
                                 if (strongSelf) {
        
                                     
                                     self.beingMovedPromptView.center = [self getbeingMovingViewCenterWithSourcePoint:layoutAttributs.center toView:longPressGestureRecognizer.view];
                                     self.beingMovedPromptView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                     self.beingMovedPromptView.alpha = 1.0f;
                                 }
                                 
                             } completion:^(BOOL finished) {
                                 
                                // _longPressGestureRecognizer.enabled = YES;
                                 ZJSDraggableAndGroupableCollectionViewFlowLayout * __strong strongSelf = weakSelf;
                                 if (strongSelf) {

                                     [self invalidateLayout];
                                     [self.beingMovedPromptView removeFromSuperview];
                                     self.beingMovedPromptView = nil;
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

-(void)panGestureRecognizerTriggerd:(UIPanGestureRecognizer*)sender{

    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
            
            // 处理移动
            
            CGPoint currentPoint = [sender translationInView:sender.view];
           // NSLog(@"currentPoint:%@",NSStringFromCGPoint(currentPoint));
            CGPoint destinationPoint = CGPointMake( self.beingMovedPromptView.center.x + currentPoint.x, self.beingMovedPromptView.center.y + currentPoint.y);
            self.beingMovedPromptView.center = destinationPoint;
            [sender setTranslation:CGPointZero inView:sender.view];
            [self scrollIfNeededAtPoint:destinationPoint];

            CGPoint velocity = [sender velocityInView:self.beingMovedPromptView];
            NSLog(@"velocity:%@",NSStringFromCGPoint(velocity));
            
            // 速度小于 才执行
            if (sqrt(velocity.x*velocity.x + velocity.y*velocity.y)<30) {
                NSLog(@"<30");
               [self exchangeItemsIfNeeded];
                
             
            }else{
                NSLog(@">30");
             }
          
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)scrollIfNeededAtPoint:(CGPoint)destinationPoint{

    destinationPoint = [self getDestinationPoint:destinationPoint];
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

        [self addBeingMovedPromptViewCenter];
        
        [self exchangeItemsIfNeeded];
        __weak ZJSDraggableAndGroupableCollectionViewFlowLayout *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [weakSelf scrollIfNeededAtPoint:weakSelf.beingMovedPromptView.center];
        });
    }
    
    if (destinationPoint.y - 40 < self.collectionView.contentOffset.y) {
        CGPoint newContentOffset = self.collectionView.contentOffset;
        newContentOffset.y = newContentOffset.y -1;
        
        if (0  >= newContentOffset.y) {
            return;
        }
        
        self.collectionView.contentOffset = newContentOffset;
        [self subtractBeingMovedPromptViewCenter];
        
        [self exchangeItemsIfNeeded];
        __weak ZJSDraggableAndGroupableCollectionViewFlowLayout *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf scrollIfNeededAtPoint:weakSelf.beingMovedPromptView.center];
        });
    }
    
}

-(void)exchangeItemsIfNeeded{
    if (!_movingItemIndexPath) {
        return;
    }
    
    CGRect beingMovedPromptViewFrame = [self.beingMovedPromptView convertRect:self.beingMovedPromptView.bounds toView:self.collectionView];
    CGPoint newPoint = [self.beingMovedPromptView.superview convertPoint:self.beingMovedPromptView.center toView:self.collectionView];
    NSArray *layoutAtts = [self layoutAttributesForElementsInRect:beingMovedPromptViewFrame];
    UICollectionViewLayoutAttributes *firstAtt = [layoutAtts firstObject];
    __block NSIndexPath *destinationIndexPath = [firstAtt indexPath];
    __block CGFloat minDistance = [MXRCGUtil distanceFromPointX:newPoint distanceToPointY:firstAtt.center];
    [layoutAtts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *atts = obj;
        CGFloat distance = [MXRCGUtil distanceFromPointX:newPoint distanceToPointY:atts.center];
        if (distance < minDistance) {
            minDistance = distance;
            destinationIndexPath = atts.indexPath;
        }
    }];
    
    ZJSDraggableCollectionViewCell * destinationCollectionViewCell = (ZJSDraggableCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:destinationIndexPath];
    
    CGRect showGroupRect = CGRectInset(destinationCollectionViewCell.frame, CGRectGetWidth(destinationCollectionViewCell.frame)/4,  CGRectGetHeight(destinationCollectionViewCell.frame)/4);
    BOOL canMoveToGroup = NO;
    if ([self.dataSource respondsToSelector:@selector(collecationView:canMoveItemAtIndex:toGroupIndexPath:)]) {
        canMoveToGroup = [self.dataSource collecationView:self.collectionView canMoveItemAtIndex:_movingItemIndexPath toGroupIndexPath:destinationIndexPath];
    }
    if (canMoveToGroup) {
        if (CGRectContainsPoint(showGroupRect, self.beingMovedPromptView.center)) {
            // 弹出文件夹
            if ([self.dataSource respondsToSelector:@selector(collecationView:willMoveItemAtIndex:toGroupIndexPath:)]) {
                [self.dataSource collecationView:self.collectionView willMoveItemAtIndex:_movingItemIndexPath toGroupIndexPath:destinationIndexPath];
            }
            
        }else{
            [self exchangeItemsAtIndexPath:destinationIndexPath];
        }
    }else{
        [self exchangeItemsAtIndexPath:destinationIndexPath];
    }
    
    
}

-(void)exchangeItemsAtIndexPath:(NSIndexPath*)destinationIndexPath{
    NSIndexPath *sourceIndexPath = _movingItemIndexPath;
    //    NSIndexPath *destinationIndexPath = [self.collectionView indexPathForItemAtPoint:self.beingMovedPromptView.center];
    
    UICollectionViewCell *destinationCell = [self.collectionView cellForItemAtIndexPath:destinationIndexPath];
    
    if (destinationIndexPath == nil || [sourceIndexPath isEqual:destinationIndexPath]||![destinationCell isKindOfClass:[ZJSDraggableCollectionViewCell class]]) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.dataSource collectionView:self.collectionView itemAtIndexPath:sourceIndexPath willMoveToIndexPath:destinationIndexPath];
    }
    
    _movingItemIndexPath = destinationIndexPath;
    
    ZJSDraggableAndGroupableCollectionViewFlowLayout * __weak weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        ZJSDraggableAndGroupableCollectionViewFlowLayout * __strong strongSelf = weakSelf;
        if (strongSelf) {
            //           if (sourceIndexPath&&destinationIndexPath) {
            [strongSelf.collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
            [strongSelf.collectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
            //            }else{
            //                [strongSelf invalidateLayout];
            //            }
            
        }
        
    } completion:^(BOOL finished) {
       // ZJSDraggableAndGroupableCollectionViewFlowLayout * __strong strongSelf = weakSelf;
        if (weakSelf) {
            if ([weakSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
                [weakSelf.dataSource collectionView:weakSelf.collectionView itemAtIndexPath:sourceIndexPath didMoveToIndexPath:destinationIndexPath];
            }
        }
    }];
}

#pragma  mark  文件夹中的collectionView和书架的collectionView，坐标需要转换
-(CGPoint)getbeingMovingViewCenterWithSourcePoint:(CGPoint)sourcePoint toView:(UIView*)toView{
    CGPoint center;
    if (self.collectionView == toView) {
        center = sourcePoint;
    }else{
        center = [self.collectionView convertPoint:sourcePoint toView:toView];
    }
    return center;
}



-(void)addBeingMovedPromptViewCenter{
    if (self.collectionView == self.beingMovedPromptView.superview) {
        self.beingMovedPromptView.center = CGPointMake(self.beingMovedPromptView.center.x, self.beingMovedPromptView.center.y + 1);
    }
    
}

-(void)subtractBeingMovedPromptViewCenter{
    if (self.collectionView == self.beingMovedPromptView.superview) {
        self.beingMovedPromptView.center = CGPointMake(self.beingMovedPromptView.center.x, self.beingMovedPromptView.center.y - 1);
    }
    
}

-(CGPoint)getDestinationPoint:(CGPoint)destinationPoint{
    if (self.collectionView == self.beingMovedPromptView.superview) {
        return destinationPoint;
    }else{
        return  [self.beingMovedPromptView convertPoint:destinationPoint toView:self.collectionView];
    }
}




#pragma mark - getter and setter
-(id<ZJSDraggableAndGroupableCollectionViewDataSource>)dataSource{
    return (id<ZJSDraggableAndGroupableCollectionViewDataSource>)self.collectionView.dataSource;
}

-(id<ZJSDraggableAndGroupableCollectionViewFlowLayoutDelegate>)delegate{
    return (id<ZJSDraggableAndGroupableCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
}

-(void)setEdit:(BOOL)edit{
    _edit = edit;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:didChangeEditState:)]) {
        [self.delegate collectionView:self.collectionView didChangeEditState:edit];
    }
}

-(void)setBeingMovedPromptView:(UIView *)beingMovedPromptView{
    _beingMovedPromptView = beingMovedPromptView;
}

-(BOOL)isGroup{
    return _beingMovedPromptView.superview != self.collectionView;
}

#pragma mark - kVO and notification
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"collectionView"]) {
//        if (self.collectionView) {
//            [self addGestureRecognizers];
//        }else{
//            [self removeGestureRecognizers];
//        }
//    }
}

//-(void)applicationWillResignActive:(NSNotification *)notification{
//    
//    // 取消当前状态
//    _longPressGestureRecognizer.enabled = NO;
//    _longPressGestureRecognizer.enabled = YES;
//}


#pragma mark －



@end
