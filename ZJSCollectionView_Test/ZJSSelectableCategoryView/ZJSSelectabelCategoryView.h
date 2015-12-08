//
//  ZJSSelectabelCategoryView.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/28.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSSelectabelCategoryView : UIView

@property (nonatomic,strong) NSArray *categories;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) CGFloat scale;

-(void)setSelectedIndex:(NSInteger)selectedIndex withAnimation:(BOOL)animation;

@end
