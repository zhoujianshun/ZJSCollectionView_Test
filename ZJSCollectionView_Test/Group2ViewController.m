//
//  Group2ViewController.m
//  ZJSCollectionView_Test
//
//  Created by 周建顺 on 15/10/29.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "Group2ViewController.h"
#import "MyGroup.h"
#import "MyObject.h"
#import "MyCollectionReusableView.h"
#import "Group2CollectionViewCell.h"
#import "Group2ObjectCollectionViewCell.h"

#define HEADER_IDENTIFY @"identifyHeader"

#define DOWN_IDENTIFY @"DOWN_IDENTIFY"
#define DOWN_INSET UIEdgeInsetsMake(30 - GROUP2_CELL_DELETE_PADDING, 20 - GROUP2_CELL_DELETE_PADDING, 30, 20 - GROUP2_CELL_DELETE_PADDING)



#define ITEM_IDENTIFY @"ITEM_IDENTIFY"
#define ITEM_INSET UIEdgeInsetsMake(30, 20, 30, 20 )

#define ITEM_

@interface Group2ViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *groups;
@property (nonatomic) BOOL isEdit;

@end

@implementation Group2ViewController

+(instancetype)group2ViewController{
    Group2ViewController *vc = [[Group2ViewController alloc] initWithNibName:@"Group2ViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"group2";
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItems = @[edit];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"Group2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DOWN_IDENTIFY];
    [self.collectionView registerNib:[UINib nibWithNibName:@"Group2ObjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ITEM_IDENTIFY];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFY];
    

    
    [self initData];
}

-(void)edit{
    self.isEdit = !self.isEdit;
}

-(void)initData{
    
    NSMutableArray *tempGroups = [[NSMutableArray alloc] init];
    
    MyGroup *group1 = [[MyGroup alloc] init];
    group1.name = @"已下载";
    
    MyGroup *group2 = [[MyGroup alloc] init];
    group2.name = @"全部";
    
    NSMutableArray *group2Array = [[NSMutableArray alloc] init];
    for (int i = 0; i <20; i++) {
        MyObject *obj1 = [[MyObject alloc] init];
        obj1.name = [NSString stringWithFormat:@"%i",i];
        [group2Array addObject:obj1];
    }
    group2.array = group2Array;

    [tempGroups addObject:group1];
    [tempGroups addObject:group2];
    
    self.groups = tempGroups;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.groups.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    MyGroup *group = [self.groups objectAtIndex:section];
    return group.array.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.collectionView.frame.size.width, 50);
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MyCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFY forIndexPath:indexPath];
        MyGroup *group = [self.groups objectAtIndex:indexPath.section];
         reusableView.titleLabel.text = [NSString stringWithFormat:@"%@(%li)",group.name,group.array.count];
        return reusableView;
    }

    return nil;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyGroup *group = [self.groups objectAtIndex:indexPath.section];
    MyObject *object = [group.array objectAtIndex:indexPath.row];
    
    NSLog(@"cellForItemAtIndexPath:%@",indexPath);
    
    if (indexPath.section == 0) {
        Group2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DOWN_IDENTIFY forIndexPath:indexPath];
        cell.myObject = object;
        cell.isEdit = self.isEdit;
        cell.deleteBlock = ^(Group2CollectionViewCell* cell){
            NSIndexPath *tempIndexPath =[self.collectionView indexPathForCell:cell];
             MyGroup *group1 = [self.groups objectAtIndex:0];
            [group1.array removeObject:cell.myObject];
            [self.collectionView reloadData];
        
        };
        return cell;
    }else{
        Group2ObjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ITEM_IDENTIFY forIndexPath:indexPath];
        cell.myObject = object;
        cell.downloadTapped = ^(Group2ObjectCollectionViewCell *cell){
            NSLog(@"downloadTapped:%@",[self.collectionView indexPathForCell:cell]);
            MyGroup *group1 = [self.groups objectAtIndex:0];
            if (!group1.array) {
                group1.array = [[NSMutableArray alloc] init];
            }
            [group1.array addObject:cell.myObject];
            [self.collectionView reloadData];
            
        };
        return cell;
    }
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    CGFloat width;
    CGFloat height;
    
    if (indexPath.section == 0) {
        width = (collectionViewWidth - DOWN_INSET.left - DOWN_INSET.right - 2*20)/3;
        height = width*1.3;
        
    }else{
        width = (collectionViewWidth - ITEM_INSET.left - ITEM_INSET.right - 2*20)/3;
        height = width*1.3;
    }
    
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    if (section == 0) {
        return DOWN_INSET;
    }
    return ITEM_INSET;
}

@end
