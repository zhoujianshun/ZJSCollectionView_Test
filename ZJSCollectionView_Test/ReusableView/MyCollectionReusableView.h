//
//  MyCollectionReusableView.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/9/22.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapBlock)(NSInteger section);

@interface MyCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic) NSInteger section;
@property (nonatomic,copy) tapBlock tap;

@end
