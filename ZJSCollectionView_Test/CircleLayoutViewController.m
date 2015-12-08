//
//  CircleLayoutViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/8/12.
//  Copyright (c) 2015年 周建顺. All rights reserved.
//

#import "CircleLayoutViewController.h"
#import "CircleLayout.h"
#import "CollectionViewCellBasic.h"
#import "LineLayout.h"

@interface CircleLayoutViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *array;


@end

static NSString *identify = @"basicIdentify";

@implementation CircleLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.title = @"circleLayout";
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCellBasic" bundle:nil] forCellWithReuseIdentifier:identify];
    
    self.array = [[NSMutableArray alloc] init];
    for (int i= 0; i<10; i++) {
        [self.array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    //self.cellCount = self.array.count;
    
    self.collectionView.collectionViewLayout = [[CircleLayout alloc] init];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.collectionView addGestureRecognizer:tapRecognizer];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint]; //获取点击处的cell的indexPath
        if (tappedCellPath!=nil) { //点击处没有cell
            [self.array removeObjectAtIndex:tappedCellPath.item];
            
            //self.cellCount = self.cellCount - 1;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:tappedCellPath]];
            } completion:nil];
        } else {
            //self.cellCount = self.cellCount + 1;
            NSString *lastStr = [self.array lastObject];
            NSInteger newObj = [lastStr integerValue]+1;
            [self.array insertObject:[NSString stringWithFormat:@"%d",newObj] atIndex:self.array.count];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:(self.array.count-1) inSection:0]]];
            } completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeTapped:(id)sender {
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[CircleLayout class]]) {
        
        [self.collectionView setCollectionViewLayout:[[LineLayout alloc] init] animated:YES];
    
    }else{
        
        
        [self.collectionView setCollectionViewLayout:[[CircleLayout alloc] init] animated:YES];

    }
    

}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCellBasic *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    
    cell.detailLabel.text = [self.array objectAtIndex:row];
    
    
    return cell;
    
}

@end
