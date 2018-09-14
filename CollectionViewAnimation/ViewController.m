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

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
//collectionView
@property (nonatomic , strong) UICollectionView *collectionView;
@end

@implementation ViewController

static const float lineSpace = 10;
static const float columnSpace = 15;
static const int cellPerLine = 5;
static int numberOfCell = 9;

#pragma mark lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self collectionView];
    
}

#pragma mark collectionViewCell增减
- (IBAction)addCell:(UIBarButtonItem *)sender {
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfCell inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        numberOfCell ++;
        NSNotification *notice = [NSNotification notificationWithName:@"cellCount" object:nil userInfo:@{@"cellCount":@(numberOfCell)}];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)deleteCell:(UIBarButtonItem *)sender {
    if (numberOfCell > 1) { //这里如果是大于0, 那下面的numberOfCell-1就是-1了, 会报错
        [self.collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(numberOfCell - 1) inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            numberOfCell --;
            NSNotification *notice = [NSNotification notificationWithName:@"cellCount" object:nil userInfo:@{@"cellCount":@(numberOfCell)}];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
        } completion:nil];
    }
}

#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView transitionWithView:cell duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        if (cell.backgroundColor == [UIColor redColor]) {
            cell.backgroundColor = [UIColor grayColor];
        }else {
            cell.backgroundColor = [UIColor redColor];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return numberOfCell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {

        AnimatorFlowLayout *layout = [[AnimatorFlowLayout alloc]init];
        layout.cellCount = numberOfCell;
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
