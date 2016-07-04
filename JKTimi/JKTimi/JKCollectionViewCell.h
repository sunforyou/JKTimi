//
//  JKCollectionViewCell.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/16.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKDraggableCollectionViewCell.h"

static NSInteger const kImageDiameter = 35;

@interface JKCollectionViewCell : JKDraggableCollectionViewCell

/**
 *  账目图片
 */
@property (strong, nonatomic) UIImageView *imageView;

/**
 *  账目类型
 */
@property (strong, nonatomic) UILabel *descLabel;

@end
