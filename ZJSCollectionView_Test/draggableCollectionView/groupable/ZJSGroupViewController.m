//
//  ZJSGroupViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/6.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import "ZJSGroupViewController.h"
#import "ZJSDraggableAndGroupableCollectionViewFlowLayout.h"
#import "CollectionViewCellBasic.h"
#import "ZJSDraggableAndGroupableGroupCollectionViewFlowLayout.h"

static NSString *identify = @"basicIdentify1";

@interface ZJSGroupViewController ()<ZJSDraggableAndGroupableGroupCollectionViewDataSource,ZJSDraggableAndGroupableGroupCollectionViewFlowLayoutDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic) BOOL showComplete;
@property (nonatomic) BOOL startHide;
@end

@implementation ZJSGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addButton];
            self.button.backgroundColor = [UIColor colorWithRed:1.000 green:0.514 blue:1.000 alpha:0.480];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    CGRect startFrame = [self.sourceView convertRect:self.sourceView.bounds toView:nil];
    self.collectionView.frame = startFrame;
    [self.view addSubview:self.collectionView];
    
    self.showComplete = NO;
   // self.movingView.frame = [self.movingView convertRect:self.movingView.bounds toView:nil];
    [UIView animateWithDuration:0.3f animations:^{
        self.collectionView.frame = CGRectMake(50, 100, CGRectGetWidth(self.view.frame) - 50*2, CGRectGetHeight(self.view.frame)-150);
    //    [self.view addSubview:self.movingView];
        self.showComplete = YES;
    }];
    
    
    if (self.addItem) {
        [self.array addObject:self.addItem];
        self.groupLayout.beingMovedPromptView = self.movingView;
        self.groupLayout.movingItemIndexPath = [NSIndexPath indexPathForItem:(self.array.count - 1) inSection:0];
    }
}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated{


}

-(void)addButton{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"_button":self.button};
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_button]-0-|" options:0 metrics:nil views:views];
    NSArray *constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_button]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:constraintH];
    [self.view addConstraints:constraintV];

}

-(void)dealloc{
    self.collectionView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonTapped:(UIButton*)sender{
  //  [self.view removeFromSuperview];
    [self hide];
}

-(void)hide{
    if (self.startHide) {
        return;
    }
      self.startHide = YES;
    
    if ([self.delegate respondsToSelector:@selector(groupViewControllerWillHide:selectedItem:)]) {
         id selectedItem = [self.array objectAtIndex:self.groupLayout.movingItemIndexPath.item];
        [self.delegate groupViewControllerWillHide:self selectedItem:selectedItem];
    }
    
    [self willMoveToParentViewController:nil];
    self.button.alpha = 0;
    CGRect startFrame = [self.sourceView convertRect:self.sourceView.bounds toView:nil];
    
    
    ZJSDraggableAndGroupableGroupCollectionViewFlowLayout *flowLayout= [[ZJSDraggableAndGroupableGroupCollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(40, 40);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

  
   
    [UIView animateWithDuration:1.f animations:^{
        self.collectionView.frame = startFrame;
//            [self.collectionView reloadData];
        
        [self.collectionView setCollectionViewLayout:flowLayout animated:NO completion:^(BOOL finished) {
            
        }];
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if ([self.delegate respondsToSelector:@selector(groupViewControllerDidHide:selectedItem:)]) {
            id selectedItem = [self.array objectAtIndex:self.groupLayout.movingItemIndexPath.item];
            [self.delegate groupViewControllerDidHide:self selectedItem:selectedItem];
        }
    }];
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        ZJSDraggableAndGroupableGroupCollectionViewFlowLayout *flowLayout= [[ZJSDraggableAndGroupableGroupCollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(75, 75);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor redColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCellBasic" bundle:nil] forCellWithReuseIdentifier:identify];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}


#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCellBasic *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    
    id result= [_array objectAtIndex:row];
    if ([result isKindOfClass:[NSString class]]) {
        cell.detailLabel.text = result;
        cell.detailLabel.textColor = [UIColor blackColor];
    }else{
        cell.detailLabel.text = [NSString stringWithFormat:@"%@", result];
        cell.detailLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
    
}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.startHide) {
//        return CGSizeMake(30, 30);
//    }
//    return CGSizeMake(75, 75);
//}
//
//
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 10; // 最小行间距
//}
//
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 10; // 最小列间距
//}
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(10, 10, 30, 10);
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath:%@",indexPath);
}

-(void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)dourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath{
    
}

-(void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString * dataDict = _array[sourceIndexPath.item];
    [_array removeObjectAtIndex:sourceIndexPath.item];
    [_array insertObject:dataDict atIndex:destinationIndexPath.item];
}

-(CGRect)collecationViewCloseRect:(UICollectionView *)collectionView{
    if (self.showComplete) {
        CGRect rect = [self.view convertRect:self.collectionView.frame toView:self.view.superview];
        return rect;
    }
    return CGRectZero;

}


-(void)collecationView:(UICollectionView *)collectionView closeGroupWithItem:(id)item{
    [self hide];
}

#pragma  mark - getter and setter 

-(ZJSDraggableAndGroupableCollectionViewFlowLayout *)groupLayout{
    return (ZJSDraggableAndGroupableCollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
}

@end
