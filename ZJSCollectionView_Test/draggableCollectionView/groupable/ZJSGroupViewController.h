//
//  ZJSGroupViewController.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/6.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJSGroupViewController;
@class ZJSDraggableAndGroupableGroupCollectionViewFlowLayout;


@protocol ZJSGroupViewControllerDelegate <NSObject>


-(void)groupViewControllerDidShow:(ZJSGroupViewController*)groupView;
-(void)groupViewControllerWillShow:(ZJSGroupViewController*)groupView;

-(void)groupViewControllerDidHide:(ZJSGroupViewController*)groupView selectedItem:(id)selectedItem;
-(void)groupViewControllerWillHide:(ZJSGroupViewController*)groupView selectedItem:(id)selectedItem;

@end

@interface ZJSGroupViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,weak) UIView *sourceView; // 进入文件夹动画开始的view
@property (nonatomic,weak) UIView *movingView; // 当前选中移动中的view
@property (nonatomic,strong) id addItem;
@property (nonatomic,weak,readonly) ZJSDraggableAndGroupableGroupCollectionViewFlowLayout *groupLayout;

@property (nonatomic,weak) id<ZJSGroupViewControllerDelegate> delegate;

-(void)hide;
-(void)show;

@end
