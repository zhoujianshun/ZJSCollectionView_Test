//
//  ZJSSelectableCategoryCell.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/28.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSSelectableCategoryCell : UICollectionViewCell

@property (nonatomic,copy) NSString *title;

@property (nonatomic) BOOL checked;

@property (nonatomic) CGFloat scale;


-(void)setChecked:(BOOL)checked withAnimation:(BOOL) animation;
+(CGSize)cellSizeWithTitle:(NSString *)title isSelected:(BOOL)selected;

@end
