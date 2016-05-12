//
//  ZJSDraggableAndGroupableGroupCollectionViewFlowLayout.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/9.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import "ZJSDraggableAndGroupableGroupCollectionViewFlowLayout.h"
#import "ZJSDraggableCollectionViewCell.h"

@interface ZJSDraggableAndGroupableGroupCollectionViewFlowLayout()

@property (nonatomic,readonly) id<ZJSDraggableAndGroupableGroupCollectionViewDataSource> dataSource;
@property (nonatomic,readonly) id<ZJSDraggableAndGroupableGroupCollectionViewFlowLayoutDelegate> delegate;

@property (nonatomic) CGFloat span;
@property (nonatomic,strong)    CADisplayLink* gameTimer;


@end

@implementation ZJSDraggableAndGroupableGroupCollectionViewFlowLayout
{
    CGFloat targetScale;
    CGSize oldItemSize;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _scale = 1.f;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scale = 1.f;
    }
    return self;
}


//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];;
//    
//    NSMutableArray *attributes =[[NSMutableArray alloc] initWithArray:layoutAttributesForElementsInRect];
//    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
//
//    }
//    
//    return attributes;
//}
//
//-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//
//    layoutAttributes.size = CGSizeMake(self.itemSize.width*self.scale, self.itemSize.height*self .scale);
//    NSLog(@"indexPath:%@",indexPath);
//    return layoutAttributes;
//}


#pragma mark - gesture
-(void)panGestureRecognizerTriggerd:(UIPanGestureRecognizer*)sender{
    
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
            
            if (!self.beingMovedPromptView) {
                return;
            }
            // 处理移动
            
            CGPoint currentPoint = [sender translationInView:sender.view];
            // NSLog(@"currentPoint:%@",NSStringFromCGPoint(currentPoint));
            CGPoint destinationPoint = CGPointMake( self.beingMovedPromptView.center.x + currentPoint.x, self.beingMovedPromptView.center.y + currentPoint.y);
            //destinationPoint = [self getbeingMovingViewCenterWithSourcePoint:destinationPoint toView:sender.view];
            self.beingMovedPromptView.center = destinationPoint;
            [sender setTranslation:CGPointZero inView:sender.view];
            
            [self scrollIfNeededAtPoint:destinationPoint];
            
            
            CGPoint velocity = [sender velocityInView:self.beingMovedPromptView];
            NSLog(@"velocity:%@",NSStringFromCGPoint(velocity));
            
            // 速度小于 才执行
            if (sqrt(velocity.x*velocity.x + velocity.y*velocity.y)<30) {
                NSLog(@"<30");
                if ([self.dataSource respondsToSelector:@selector(collecationViewCloseRect:)]) {
                    CGRect closeRect = [self.dataSource collecationViewCloseRect:self.collectionView];
                    if (CGRectContainsPoint(closeRect, self.beingMovedPromptView.center)) {
                        [self exchangeItemsIfNeeded];
                    }else{
                        if ([self.delegate respondsToSelector:@selector(collecationView:closeGroupWithItem:)]) {
                            [self.delegate collecationView:self.collectionView closeGroupWithItem:nil];
                        }
                    }
                }else{
                    
                }
                
                
                
                
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


-(CGPoint)getbeingMovingViewCenterWithSourcePoint:(CGPoint)sourcePoint toView:(UIView*)toView{
    CGPoint center;
    center = [self.collectionView convertPoint:sourcePoint toView:toView];
    return center;
}



-(void)addBeingMovedPromptViewCenter{

    
}

-(void)subtractBeingMovedPromptViewCenter{

    
}

-(CGPoint)getDestinationPoint:(CGPoint)destinationPoint{

    return  [self.beingMovedPromptView convertPoint:destinationPoint toView:self.collectionView];
    
}

-(id<ZJSDraggableAndGroupableGroupCollectionViewDataSource>)dataSource{
    return (id<ZJSDraggableAndGroupableGroupCollectionViewDataSource>)self.collectionView.dataSource;
}

-(id<ZJSDraggableAndGroupableGroupCollectionViewFlowLayoutDelegate>)delegate{
    return (id<ZJSDraggableAndGroupableGroupCollectionViewFlowLayoutDelegate>)self.collectionView.delegate;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(void)setScale:(CGFloat)scale{
    _scale = scale;
    NSLog(@"scale : %f",scale);
    __weak ZJSDraggableAndGroupableGroupCollectionViewFlowLayout *weakSelf = self;
    //dispatch_async(dispatch_get_main_queue(), ^{
//        [[weakSelf.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            CGRect frame = obj.frame;
//            frame.size = CGSizeMake(weakSelf.itemSize.width*weakSelf.scale, weakSelf.itemSize.height*weakSelf .scale);
//            obj.frame = frame;
//        }];
   // });
    
    self.itemSize = CGSizeMake(oldItemSize.width*self.scale, oldItemSize.height*self .scale);
    
    NSLog(@"itemSize:%@",NSStringFromCGSize(self.itemSize));
    [self invalidateLayout];
}

-(void)setScaleWithAnimation:(CGFloat)scale{
//    if (scale>self.scale) {
    targetScale = scale;
    oldItemSize = self.itemSize;
    self.span = (scale - self.scale)/(3*60);
//    }
    
//    self.scale = scale;
    

    self.gameTimer = [CADisplayLink displayLinkWithTarget:self
                                            selector:@selector(updateDisplay:)];
    
    [self.gameTimer addToRunLoop:[NSRunLoop currentRunLoop]
     
                    forMode:NSDefaultRunLoopMode];

}

-(void)updateDisplay:(id)sender{
    
    if (self.span>0) {
        if ((_scale + self.span)>targetScale) {
            self.scale = targetScale;
            [self.gameTimer invalidate];
            self.gameTimer = nil;
        }else{
            self.scale = _scale + self.span;
        }
    }else{
        if ((_scale + self.span)<targetScale) {
            self.scale = targetScale;
            [self.gameTimer invalidate];
            self.gameTimer = nil;
        }else{
            self.scale = _scale + self.span;
        }
    }
    
    
    
  
    

}

@end
