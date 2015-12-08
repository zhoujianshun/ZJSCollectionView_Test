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
static CGFloat CategoryInteritemSpacing = 1.f;
#define CategoryCollectionInset  UIEdgeInsetsMake(0, 0 , 0, 0)
#define CategorySectionInset  UIEdgeInsetsMake(8, 0,8, 0)


@interface ZJSSelectabelCategoryView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) ZJSSelectableCategoryFlowLayout *flowLayout;

@property (nonatomic,strong) ZJSGradientView *leftGradientView;
@property (nonatomic,strong) ZJSGradientView *rightGradientView;


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
    
    
    _selectedIndex = 0;
    
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
    

    NSDictionary *gradientMetrics = @{@"_left":[NSNumber numberWithFloat:CategoryCollectionInset.left - 1],@"_right":[NSNumber numberWithFloat:CategoryCollectionInset.right - 1] };
    self.leftGradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.leftGradientView];
    NSDictionary *leftViews = @{@"_leftGradientView":self.leftGradientView};
    NSArray *leftViewsConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(_left)-[_leftGradientView(30)]" options:0 metrics:gradientMetrics views:leftViews];
    NSArray *leftViewsConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_leftGradientView]-0-|" options:0 metrics:gradientMetrics views:leftViews];
    [self addConstraints:leftViewsConstraint1];
    [self addConstraints:leftViewsConstraint2];
    
    self.rightGradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.rightGradientView];
    NSDictionary *rightViews = @{@"_rightGradientView":self.rightGradientView};
    NSArray *rightViewsConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"[_rightGradientView(30)]-(_right)-|" options:0 metrics:gradientMetrics views:rightViews];
    NSArray *rightViewsConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_rightGradientView]-0-|" options:0 metrics:gradientMetrics views:rightViews];
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
    NSString *tag = [self.categories objectAtIndex:indexPath.item];
    cell.title = tag;

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self setSelectedIndex:indexPath.item withAnimation:YES];

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //       ZJSSelectableCategoryCell *cell = (ZJSSelectableCategoryCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    NSString *tag = [self.categories objectAtIndex:indexPath.item];
    
    CGSize size = [ZJSSelectableCategoryCell cellSizeWithTitle:tag isSelected:indexPath.item ==self.selectedIndex];
    
    return CGSizeMake(size.width, self.collectionView.frame.size.height - CategorySectionInset.top - CategorySectionInset.bottom);
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.leftGradientView.hidden = !(scrollView.contentOffset.x>0);
    
    self.rightGradientView.hidden = !((scrollView.contentSize.width - scrollView.contentOffset.x  - 1)>(scrollView.bounds.size.width));
}


#pragma mark - getter and setter
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        self.flowLayout = [[ZJSSelectableCategoryFlowLayout alloc] init];
        self.flowLayout.minimumInteritemSpacing = CategoryInteritemSpacing;
        self.flowLayout.sectionInset = CategorySectionInset;
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



#pragma mark - observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.leftGradientView.hidden = !(self.collectionView.contentOffset.x>0);
        self.rightGradientView.hidden = !((self.collectionView.contentSize.width - self.collectionView.contentOffset.x - 1)>self.collectionView.bounds.size.width);
    }
}

@end
