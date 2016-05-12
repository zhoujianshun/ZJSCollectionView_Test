//
//  ZJSGroupAnimationView.h
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/11.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJSGroupAnimationView;

typedef NS_ENUM(NSUInteger, ZJSGroupAnimationType) {
    ZJSGroupAnimationTypeUnKnow,
    ZJSGroupAnimationTypeShow,
    ZJSGroupAnimationTypeHide,
};

@protocol ZJSGroupAnimationViewDelegate <NSObject>

-(void)groupHideAnimationComplete:(ZJSGroupAnimationView*)animationView;
-(void)groupShowAnimationComplete:(ZJSGroupAnimationView*)animationView;

@end

@interface ZJSGroupAnimationView : UIView

@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,weak) id<ZJSGroupAnimationViewDelegate> delegate;

-(void)initHideView;
-(void)startHide;

-(void)initShowView;
-(void)startShow;

@end
