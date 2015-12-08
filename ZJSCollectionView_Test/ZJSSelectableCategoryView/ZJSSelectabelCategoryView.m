//
//  ZJSSelectabelCategoryView.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/11/28.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "ZJSSelectabelCategoryView.h"
#import "ZJSSelectableCategoryFlowLayout.h"
#import "ZJSSelectableCategoryCell.h"
#import "ZJSGradientView.h"

#define CategoryIdentifier @"CategoryIdentifier"
static CGFloat CategoryInteritemSpacing = 20.f;
#define CategoryCollectionInset  UIEdgeInsetsMake(0, 20,0, 20)
#define CategorySectionInset  UIEdgeInsetsMake(8, 0,8, 0)


@interface ZJSSelectabelCategoryView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) ZJSSelectableCategoryFlowLayout *flowLayout;

@property (nonatomic,strong) ZJSGradientView *leftGradientView;
@property (nonatomic,strong) ZJSGradientView *rightGradientView;

//@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@end

@implementation ZJSSelectabelCategoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}


-(void)setup{
    
    
    //self.collectionView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"_collectionView":self.collectionView};
    NSDictionary *metrics = @{@"collcetionLeft":[NSNumber numberWithFloat:CategoryCollectionInset.left],@"collcetionRight":[NSNumber numberWithFloat:CategoryCollectionInset.right]};
    NSArray *constarint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(collcetionLeft)-[_collectionView]-(collcetionRight)-|" options:0 metrics:metrics views:views];
    NSArray *constarint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:views];
   // [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.collectionView.superview attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f];
    
    [self addConstraints:constarint1];
    [self addConstraints:constarint2];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.collectionView.superview attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    

//    self.shapeLayer = [[CAShapeLayer alloc] init];
//    self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
//    [self.layer addSublayer:self.shapeLayer];
    self.leftGradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.leftGradientView];
    NSDictionary *leftViews = @{@"_leftGradientView":self.leftGradientView};
    NSArray *leftViewsConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(collcetionLeft)-[_leftGradientView(30)]" options:0 metrics:metrics views:leftViews];
    NSArray *leftViewsConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_leftGradientView]-0-|" options:0 metrics:metrics views:leftViews];
    [self addConstraints:leftViewsConstraint1];
    [self addConstraints:leftViewsConstraint2];
    
    self.rightGradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.rightGradientView];
    NSDictionary *rightViews = @{@"_rightGradientView":self.rightGradientView};
    NSArray *rightViewsConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"[_rightGradientView(30)]-(collcetionRight)-|" options:0 metrics:metrics views:rightViews];
    NSArray *rightViewsConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_rightGradientView]-0-|" options:0 metrics:metrics views:rightViews];
    [self addConstraints:rightViewsConstraint1];
    [self addConstraints:rightViewsConstraint2];
    
    [self addObservers];

}

-(void)addObservers{
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark - collectionView delegate and dataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.categories.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJSSelectableCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryIdentifier forIndexPath:indexPath];
    cell.checked = self.selectedIndex == indexPath.item;
    cell.title = [self.categories objectAtIndex:indexPath.item];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self setSelectedIndex:indexPath.item withAnimation:YES];

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //       ZJSSelectableCategoryCell *cell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CGSize size = [ZJSSelectableCategoryCell cellSizeWithTitle:[self.categories objectAtIndex:indexPath.item] isSelected:indexPath.item ==self.selectedIndex];
    
    return CGSizeMake(size.width, self.collectionView.frame.size.height - CategorySectionInset.top - CategorySectionInset.bottom);
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.leftGradientView.hidden = !(scrollView.contentOffset.x>0);
    
    self.rightGradientView.hidden = !((scrollView.contentSize.width - scrollView.contentOffset.x)>scrollView.bounds.size.width);
}

//-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"shouldHighlightItemAtIndexPath");
//    return YES;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    NSLog(@"didHighlightItemAtIndexPath");
//    ZJSSelectableCategoryCell *cell = (ZJSSelectableCategoryCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
//    cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
//    cell.alpha = 0.5;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"didUnhighlightItemAtIndexPath");
//    ZJSSelectableCategoryCell *cell = (ZJSSelectableCategoryCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
//    cell.transform = CGAffineTransformIdentity;
//    cell.alpha = 1;
//}


#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        self.flowLayout = [[ZJSSelectableCategoryFlowLayout alloc] init];
       // self.flowLayout.minimumInteritemSpacing = CategoryInteritemSpacing;
        self.flowLayout.minimumLineSpacing = CategoryInteritemSpacing;
        self.flowLayout.sectionInset = CategorySectionInset;
//        self.flowLayout.itemSize = CGSizeMake(CategoryItemWidth, 30);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"ZJSSelectableCategoryCell" bundle:nil] forCellWithReuseIdentifier:CategoryIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

-(void)setCategories:(NSArray *)categories{
    if (_categories != categories) {
        _categories = categories;
        [self.collectionView reloadData];

    }
}

//-(void)setSelectedIndex:(NSInteger)selectedIndex{
//    
//    if (_selectedIndex != selectedIndex) {
//        _selectedIndex = selectedIndex;
//        NSArray *array = [self.collectionView visibleCells];
//        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            ZJSSelectableCategoryCell *cell = obj;
//            //cell.checked = NO;
//            [cell setChecked:NO withAnimation:YES];
//        }];
//        
//        ZJSSelectableCategoryCell *cell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0]];
//        if (cell) {
//            //cell.checked = YES;
//            [cell setChecked:YES withAnimation:YES];
//        }
//        
//         [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    }
//
////    NSIndexPath *indexpath =  [[self.collectionView indexPathsForSelectedItems] firstObject];
////    if (indexpath.item != selectedIndex ) {
////        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//// 
////    }
//   // [self setNeedsDisplay];
//  //  [self.flowLayout invalidateLayout];
//}


-(void)setSelectedIndex:(NSInteger)selectedIndex withAnimation:(BOOL)animation{
    
    if (_selectedIndex != selectedIndex) {
        self.selectedIndex = selectedIndex;
        NSArray *array = [self.collectionView visibleCells];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZJSSelectableCategoryCell *cell = obj;
            //cell.checked = NO;
            [cell setChecked:NO withAnimation:animation];
        }];
        
        ZJSSelectableCategoryCell *cell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0]];
        if (cell) {
            //cell.checked = YES;
            [cell setChecked:YES withAnimation:animation];
        }
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    //    NSIndexPath *indexpath =  [[self.collectionView indexPathsForSelectedItems] firstObject];
    //    if (indexpath.item != selectedIndex ) {
    //        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    //
    //    }
    // [self setNeedsDisplay];
    //  [self.flowLayout invalidateLayout];
}

-(void)setScale:(CGFloat)scale{
    _scale = scale;
    
    if (scale> 0 ) {
        if (self.selectedIndex < self.categories.count - 1) {
            ZJSSelectableCategoryCell *currentCell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
            ZJSSelectableCategoryCell *nextCell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex + 1 inSection:0]];
            currentCell.scale = scale;
            nextCell.scale = scale;
        }
    }else{
        if (self.selectedIndex > 0) {
            
            ZJSSelectableCategoryCell *currentCell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
            ZJSSelectableCategoryCell *preCell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex - 1 inSection:0]];
            currentCell.scale = ABS(scale);
            preCell.scale = ABS(scale);
        }
    }
}

//-(NSInteger)selectedIndex{
//    NSIndexPath *indexpath =  [[self.collectionView indexPathsForSelectedItems] firstObject];
//    
//    if (indexpath) {
//        return indexpath.item;
//    }else{
//        return 0;
//    }
//}


-(ZJSGradientView *)leftGradientView{
    if (!_leftGradientView) {
        _leftGradientView = [[ZJSGradientView alloc] init];
        _leftGradientView.gradientViewType = ZJSGradientViewTypeLeftToRight;
        _leftGradientView.hidden = YES;
    }
    return _leftGradientView;
}

-(ZJSGradientView *)rightGradientView{
    if (!_rightGradientView) {
        _rightGradientView = [[ZJSGradientView alloc] init];
        _rightGradientView.gradientViewType = ZJSGradientViewTypeRightToLeft;
        _rightGradientView.hidden = YES;
    }
    return _rightGradientView;
}

#pragma mark - draw

//-(void)drawRect:(CGRect)rect{
//    
//    CGFloat offset = CategoryItemWidth + CategoryInteritemSpacing;
//    if (self.selectedIndex == 0) {
//        offset = 0;
//    }else if(self.selectedIndex == self.categories.count - 1){
//        offset = (CategoryItemWidth + CategoryInteritemSpacing)*2;
//    }
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, CGRectGetMaxY(self.collectionView.frame))];
//    // 左边的横线
//    [path addLineToPoint:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left - radius, CGRectGetMaxY(self.collectionView.frame))];
//    // 左下圆角
//    [path addArcWithCenter:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left  - radius, CGRectGetMaxY(self.collectionView.frame) - radius) radius:radius startAngle:M_PI_2 endAngle:0 clockwise:NO];
//    // 左横线
//    [path addLineToPoint:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left , CGRectGetMinY(self.collectionView.frame) + CategorySectionInset.top + radius)];
//    // 左上圆角
//    [path addArcWithCenter:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left + radius, CGRectGetMinY(self.collectionView.frame) + CategorySectionInset.top + radius) radius:radius startAngle:M_PI endAngle:1.5*M_PI clockwise:YES];
//    // 上横线
//    [path addLineToPoint:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left + CategoryItemWidth - radius, CGRectGetMinY(self.collectionView.frame)+CategorySectionInset.top)];
//    // 右上圆角
//    [path addArcWithCenter:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left + CategoryItemWidth - radius, CGRectGetMinY(self.collectionView.frame)+CategorySectionInset.top+radius) radius:radius startAngle:1.5*M_PI endAngle:0 clockwise:YES];
//    // 右竖线
//    [path addLineToPoint:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left + CategoryItemWidth, CGRectGetMaxY(self.collectionView.frame)-radius)];
//    // 右下角远郊
//    [path addArcWithCenter:CGPointMake(offset + CategoryCollectionInset.left + CategorySectionInset.left + CategoryItemWidth + radius, CGRectGetMaxY(self.collectionView.frame)-radius) radius:radius startAngle:M_PI endAngle:0.5*M_PI clockwise:NO];
//    
//    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.frame),  CGRectGetMaxY(self.collectionView.frame))];
//    self.shapeLayer.path = path.CGPath;
//    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
//
//}


#pragma mark - observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.leftGradientView.hidden = !(self.collectionView.contentOffset.x>0);
        self.rightGradientView.hidden = !((self.collectionView.contentSize.width - self.collectionView.contentOffset.x)>self.collectionView.bounds.size.width);
    }
}

@end
