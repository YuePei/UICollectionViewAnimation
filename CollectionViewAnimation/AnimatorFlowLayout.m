//
//  AnimatorFlowLayout.m
//  CollectionViewAnimation
//
//  Created by 乐培培 on 2018/9/13.
//  Copyright © 2018年 乐培培. All rights reserved.
//

#import "AnimatorFlowLayout.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface AnimatorFlowLayout ()
//dynamicAnimator
@property (nonatomic, strong)UIDynamicAnimator *dynamicAnimator;

@end
@implementation AnimatorFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        [self dynamicAnimator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellCount:) name:@"cellCount" object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeCellCount:(id)sender {
    NSDictionary *userInfoDic = [(NSDictionary *)sender valueForKey:@"userInfo"];
    self.cellCount = [[userInfoDic objectForKey:@"cellCount"] intValue];
}

- (void)prepareLayout {
    
    CGSize contentSize = self.collectionView.contentSize;
    NSLog(@"-----------:%f",contentSize.height);
    NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]initWithItem:obj attachedToAnchor:[obj center]];
        attachment.length = 0;
        attachment.damping = 0.4;
        [self.dynamicAnimator addBehavior:attachment];
    }];
    

}
#pragma mark 重写的方法
//布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(50, 50);
    float radius = 150;
    CGPoint center = CGPointMake(SWidth / 2.0, SHeight / 2.0);
    float x = center.x + radius * cosf(2 * M_PI / self.cellCount * indexPath.item);
    float y = center.y - radius * sinf(2 * M_PI / self.cellCount * indexPath.item);
    attributes.center = CGPointMake(x, y);
    
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

//动画
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0;
    attributes.transform = CGAffineTransformScale(attributes.transform, 0, 0);
    attributes.center = CGPointMake(SWidth / 2.0, SHeight / 2.0);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.transform = CGAffineTransformScale(attributes.transform, 0.01, 0.01);
    
    return attributes;
}

#pragma mark lazy
- (UIDynamicAnimator *)dynamicAnimator {
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.collectionView];
    }
    return _dynamicAnimator;
}
@end
