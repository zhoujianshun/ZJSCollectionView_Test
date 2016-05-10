//
//  ZJSDraggableCollectionViewFlowLayout.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/20.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSDraggableCollectionViewFlowLayout.h"


@protocol ZJSDraggableAndGroupableCollectionViewDataSource <ZJSDraggableCollectionViewDataSource>

@optional

-(BOOL)collecationView:(UICollectionView *)collectionView canMoveItemAtIndex:(NSIndexPath*)indexPath toGroupIndexPath:(NSIndexPath*)groupIndexPath;
-(void)collecationView:(UICollectionView *)collectionView willMoveItemAtIndex:(NSIndexPath*)indexPath toGroupIndexPath:(NSIndexPath*)groupIndexPath;

@end

@protocol ZJSDraggableAndGroupableCollectionViewFlowLayoutDelegate <ZJSDraggableCollectionViewFlowLayoutDelegate>


@end



@interface ZJSDraggableAndGroupableCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) BOOL panEnable;
@property (nonatomic,getter=isEdit) BOOL edit;

//@property (nonatomic,assign) BOOL panGestureRecognizerEnable;
//@property (nonatomic,getter=isGroupShow) BOOL groupShow;

@property (nonatomic,strong) NSIndexPath * movingItemIndexPath;
@property (nonatomic,strong) UIView *beingMovedPromptView;
@property (nonatomic) BOOL isGroup;


-(void)longPressGestureRecognizerTriggerd:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
-(void)panGestureRecognizerTriggerd:(UIPanGestureRecognizer*)sender;

-(void)scrollIfNeededAtPoint:(CGPoint)destinationPoint;
-(void)exchangeItemsIfNeeded;

@end



