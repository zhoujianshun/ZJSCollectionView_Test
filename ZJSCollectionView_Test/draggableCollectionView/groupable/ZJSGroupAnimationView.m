//
//  ZJSGroupAnimationView.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/11.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import "ZJSGroupAnimationView.h"
#import "CollectionViewCellBasic.h"

@interface ZJSGroupAnimationView()

@property (nonatomic,strong) NSMutableArray *views;

@end

@implementation ZJSGroupAnimationView

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/*
 
 flowLayout.itemSize = CGSizeMake(75, 75);
 flowLayout.minimumInteritemSpacing = 10;
 flowLayout.minimumLineSpacing = 10;
 flowLayout.sectionInset =
 */

-(void)initHideView{

    NSInteger rowCount = 2;
    NSInteger colCount = 3;
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat width = 75;
    CGFloat height = 75;
    CGFloat interitemSpacing = (CGRectGetWidth(self.frame) - inset.left - inset.right - width*colCount)/colCount;
    CGFloat lineSpacing = 10;

    self.views = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    [self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        ZJSGroupAnimationChildView *cell = [[[NSBundle mainBundle] loadNibNamed:@"ZJSGroupAnimationChildView" owner:nil options:nil] firstObject];
        UIView *view = obj;
        NSInteger row = idx/colCount;
        NSInteger col = idx%colCount;
        view.frame = CGRectMake(inset.left + col*(width + interitemSpacing), inset.top + row*(height + lineSpacing), width, height);
        [self addSubview:view];
        [self.views addObject:view];
    }];
}

-(void)startHide{
    
    NSInteger rowCount = 2;
    NSInteger colCount = 2;
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat width = 30;
    CGFloat height = 30;
    CGFloat interitemSpacing = (CGRectGetWidth(self.frame) - inset.left - inset.right - width*colCount)/colCount;
    CGFloat lineSpacing = 10;
    [self.views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = obj;
        
        if (idx >= 4) {
            [view removeFromSuperview];
        }else{
            NSInteger row = idx/colCount;
            NSInteger col = idx%colCount;
            view.frame = CGRectMake(inset.left + col*(width + interitemSpacing), inset.top + row*(height + lineSpacing), width, height);
            
        }
    }];
    
//    [UIView animateWithDuration:3.f animations:^{
//       
//    } completion:^(BOOL finished) {
//        if ([self.delegate respondsToSelector:@selector(groupHideAnimationComplete:)]) {
//            [self.delegate groupHideAnimationComplete:self];
//        }
//    }];
    

}

-(void)initShowView{
    NSInteger rowCount = 2;
    NSInteger colCount = 2;
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat width = 30;
    CGFloat height = 30;
    CGFloat interitemSpacing = (CGRectGetWidth(self.frame) - inset.left - inset.right - width*colCount)/colCount;
    CGFloat lineSpacing = 10;
    self.views = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor clearColor];
    [self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIView *view = obj;
        NSInteger row = idx/colCount;
        NSInteger col = idx%colCount;
        view.frame = CGRectMake(inset.left + col*(width + interitemSpacing), inset.top + row*(height + lineSpacing), width, height);
        [self addSubview:view];
        [view layoutIfNeeded];
        [self.views addObject:view];
    }];
}

-(void)startShow{
    
    NSInteger rowCount = 2;
    NSInteger colCount = 3;
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat width = 75;
    CGFloat height = 75;
    CGFloat interitemSpacing = (CGRectGetWidth(self.frame) - inset.left - inset.right - width*colCount)/(colCount -1) ;
    CGFloat lineSpacing = 10;
    [self.views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CollectionViewCellBasic *cell = (CollectionViewCellBasic*)obj;
        
//        if (idx >= 4) {
//            [cell removeFromSuperview];
//        }else{
            NSInteger row = idx/colCount;
            NSInteger col = idx%colCount;
            cell.frame = CGRectMake(inset.left + col*(width + interitemSpacing), inset.top + row*(height + lineSpacing), width, height);
            
//        }
    }];
    
    //    [UIView animateWithDuration:3.f animations:^{
    //
    //    } completion:^(BOOL finished) {
    //        if ([self.delegate respondsToSelector:@selector(groupHideAnimationComplete:)]) {
    //            [self.delegate groupHideAnimationComplete:self];
    //        }
    //    }];
    
    
}

@end
