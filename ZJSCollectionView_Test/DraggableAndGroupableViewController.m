  //
//  DraggableAndGroupableViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 16/5/6.
//  Copyright © 2016年 周建顺. All rights reserved.
//

#import "DraggableAndGroupableViewController.h"
#import "ZJSDraggableAndGroupableCollectionViewFlowLayout.h"
#import "CollectionViewCellBasic.h"
#import "ZJSGroupViewController.h"

static NSString *identify = @"basicIdentify2";

@interface DraggableAndGroupableViewController ()<ZJSDraggableAndGroupableCollectionViewFlowLayoutDelegate,ZJSDraggableAndGroupableCollectionViewDataSource,ZJSGroupViewControllerDelegate,UIGestureRecognizerDelegate,ZJSDraggableAndGroupableCollectionViewDataSource,ZJSDraggableAndGroupableCollectionViewFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,weak) ZJSGroupViewController *groupView;
@property (nonatomic,weak) ZJSDraggableAndGroupableCollectionViewFlowLayout *collectionLayout;

@property (nonatomic,getter=isGroupShow) BOOL groupShow;


@end

@implementation DraggableAndGroupableViewController{
    NSMutableArray *_array;
    UILongPressGestureRecognizer * _longPressGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCellBasic" bundle:nil] forCellWithReuseIdentifier:identify];
    [self addGestureRecognizers];
    
    _array = [[NSMutableArray alloc] init];
    for (int i= 50; i<100; i++) {
        if (i%5==0) {
            [_array addObject:[NSNumber numberWithInt:i]];
        }else{
            [_array addObject:[NSString stringWithFormat:@"%d",i]];
        }

    }
    
    
}

-(void)dealloc{
    [self removeGestureRecognizers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addGestureRecognizers{
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerTriggerd:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
    
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerTriggerd:)]
    ;
    _longPressGestureRecognizer.cancelsTouchesInView = NO; // 源码上是这么设置的，不知道为什么暂时不打开
    _longPressGestureRecognizer.delegate = self;
    
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
    
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)removeGestureRecognizers{
    if (_longPressGestureRecognizer) {
        if (_longPressGestureRecognizer.view) {
            [_longPressGestureRecognizer.view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer = nil;
    }
    
    if (_panGestureRecognizer) {
        if (_panGestureRecognizer.view) {
            [_panGestureRecognizer.view removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer = nil;
    }
    
}

-(void)longPressGestureRecognizerTriggerd:(UILongPressGestureRecognizer *)longPressGestureRecognizer{
    if (self.isGroupShow) {
        [self.groupView.groupLayout longPressGestureRecognizerTriggerd:longPressGestureRecognizer];
    }else{
        [self.collectionLayout longPressGestureRecognizerTriggerd:longPressGestureRecognizer];
    }


}

-(void)panGestureRecognizerTriggerd:(UIPanGestureRecognizer*)sender{
    if (self.isGroupShow) {
        [self.groupView.groupLayout panGestureRecognizerTriggerd:sender];
    }else{
        [self.collectionLayout  panGestureRecognizerTriggerd:sender];
    }
 
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.isGroupShow) {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]&&!self.groupView.groupLayout.panEnable) {
            return NO;
        }
    }else{
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]&&!self.collectionLayout.panEnable) {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return YES;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 50; // 最小行间距
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10; // 最小列间距
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(30, 10, 30, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath:%@",indexPath);
    
    
    id result= [_array objectAtIndex:indexPath.item];
    if (![result isKindOfClass:[NSString class]]){
        ZJSDraggableAndGroupableCollectionViewFlowLayout *layout =  self.collectionLayout;
        
        ZJSGroupViewController *groupView = [[ZJSGroupViewController alloc] init];
        groupView.delegate = self;
        groupView.sourceView = [collectionView cellForItemAtIndexPath:indexPath];
        groupView.view.frame =  [self.view convertRect:self.view.bounds toView:self.collectionView];
        groupView.array = [NSMutableArray arrayWithArray:@[@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"]];
        [self addChildViewController:groupView];
        [self.collectionView  addSubview:groupView.view];
        [groupView didMoveToParentViewController:self];
        self.groupShow = YES;
        self.groupView = groupView;
    }
    

}

-(void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)dourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath{
    
    

}

-(void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString * dataDict = _array[sourceIndexPath.item];
    [_array removeObjectAtIndex:sourceIndexPath.item];
    [_array insertObject:dataDict atIndex:destinationIndexPath.item];
}

-(BOOL)collecationView:(UICollectionView *)collectionView canMoveItemAtIndex:(NSIndexPath*)indexPath toGroupIndexPath:(NSIndexPath*)groupIndexPath{
    return YES;
}
-(void)collecationView:(UICollectionView *)collectionView willMoveItemAtIndex:(NSIndexPath*)indexPath toGroupIndexPath:(NSIndexPath*)groupIndexPath{
    if (self.groupView) {
        
    }else{
        id result = [_array objectAtIndex:groupIndexPath.item];
        if ([result isKindOfClass:[NSString class]]) {
            ZJSDraggableAndGroupableCollectionViewFlowLayout *layout =  self.collectionLayout;
            
            ZJSGroupViewController *groupView = [[ZJSGroupViewController alloc] init];
            groupView.delegate = self;
            groupView.sourceView = [collectionView cellForItemAtIndexPath:groupIndexPath];
            groupView.movingView = layout.beingMovedPromptView;

            NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[_array objectAtIndex:groupIndexPath.item], nil];
            id additem = [_array objectAtIndex:indexPath.item];
            groupView.addItem = additem;
            self.collectionLayout.movingItemIndexPath = nil;
            [_array removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            groupView.array = array;
            
            [self addChildViewController:groupView];
            [self.collectionView insertSubview:groupView.view belowSubview:layout.beingMovedPromptView];
            [groupView didMoveToParentViewController:self];
            groupView.view.frame =  [self.view convertRect:self.view.bounds toView:self.collectionView];
            self.groupShow = YES;
            self.groupView = groupView;
        }else{
            ZJSDraggableAndGroupableCollectionViewFlowLayout *layout =  self.collectionLayout;
            
            ZJSGroupViewController *groupView = [[ZJSGroupViewController alloc] init];
            groupView.delegate = self;
            groupView.sourceView = [collectionView cellForItemAtIndexPath:groupIndexPath];
            groupView.movingView = layout.beingMovedPromptView;
            NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"]];
            id additem = [_array objectAtIndex:indexPath.item];
            groupView.addItem = additem;
            self.collectionLayout.movingItemIndexPath = nil;
            [_array removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
            groupView.array = array;
            
            
            [self addChildViewController:groupView];
            [self.collectionView insertSubview:groupView.view belowSubview:layout.beingMovedPromptView];
            [groupView didMoveToParentViewController:self];
            groupView.view.frame =  [self.view convertRect:self.view.bounds toView:self.collectionView];
            self.groupShow = YES;
            self.groupView = groupView;
        }

    }
}

-(void)groupViewControllerWillHide:(ZJSGroupViewController *)groupView selectedItem:(id)selectedItem{
    NSLog(@"selectedItem:%@",selectedItem);


    if (selectedItem) {
        [_array addObject:selectedItem];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(_array.count -1) inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        self.collectionLayout.movingItemIndexPath = indexPath;
        [self.collectionView bringSubviewToFront:self.collectionLayout.beingMovedPromptView];
        self.collectionLayout.beingMovedPromptView = self.groupView.groupLayout.beingMovedPromptView;
    }
    
}

-(void)groupViewControllerDidHide:(ZJSGroupViewController *)groupView selectedItem:(id)selectedItem{
     NSLog(@"selectedItem:%@",selectedItem);

 self.groupShow = NO;
}


#pragma mark - getter and setter

-(ZJSDraggableAndGroupableCollectionViewFlowLayout *)collectionLayout{
    return  (ZJSDraggableAndGroupableCollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
}

-(void)setGroupShow:(BOOL)groupShow{
    _groupShow = groupShow;
    if (groupShow) {
        self.collectionView.scrollEnabled = NO;
    }else{
        self.collectionView.scrollEnabled = YES;
    }
}
@end
