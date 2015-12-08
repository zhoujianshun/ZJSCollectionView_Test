//
//  ZJSGradientView.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/12/1.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZJSGradientViewType) {
    ZJSGradientViewTypeNone,
    ZJSGradientViewTypeLeftToRight,
    ZJSGradientViewTypeRightToLeft,
};

@interface ZJSGradientView : UIView

@property (nonatomic,assign) ZJSGradientViewType gradientViewType;

@end
