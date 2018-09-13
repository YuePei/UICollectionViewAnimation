//
//  AnimatorFlowLayout.m
//  CollectionViewAnimation
//
//  Created by 乐培培 on 2018/9/13.
//  Copyright © 2018年 乐培培. All rights reserved.
//

#import "AnimatorFlowLayout.h"

@implementation AnimatorFlowLayout

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0;
    attributes.transform = CGAffineTransformScale(attributes.transform, 0, 0);
    
    return attributes;
    
}
@end
