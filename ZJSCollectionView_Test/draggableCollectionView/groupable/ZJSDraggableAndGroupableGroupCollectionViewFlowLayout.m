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

@end

@implementation ZJSDraggableAndGroupableGroupCollectionViewFlowLayout



#pragma mark - gesture
-(void)panGestureRecognizerTriggerd:(UIPanGestureRecognizer*)sender{
    
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
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


@end
