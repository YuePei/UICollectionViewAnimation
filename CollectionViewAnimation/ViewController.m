//
//  ViewController.m
//  CollectionViewAnimation
//
//  Created by 乐培培 on 2018/9/13.
//  Copyright © 2018年 乐培培. All rights reserved.
//

#import "ViewController.h"
#import "AnimatorFlowLayout.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//collectionView
@property (nonatomic , strong) UICollectionView *collectionView;
@end

@implementation ViewController

static const float lineSpace = 10;
static const float columnSpace = 15;
static const int cellPerLine = 8;
static int numberOfCell = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self collectionView];
    
}

- (IBAction)addCell:(UIBarButtonItem *)sender {
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        numberOfCell ++;
    } completion:^(BOOL finished) {
        
    }];
}



- (IBAction)deleteCell:(UIBarButtonItem *)sender {
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        numberOfCell --;
    } completion:nil];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return numberOfCell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {

        AnimatorFlowLayout *layout = [[AnimatorFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumLineSpacing = lineSpace;
        layout.minimumInteritemSpacing = columnSpace;
        float cellWidth = (SWidth - 20 - (cellPerLine - 1) * columnSpace) / cellPerLine;
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
@end
