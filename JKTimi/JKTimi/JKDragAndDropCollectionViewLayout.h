//
//  JKDragAndDropCollectionViewLayout.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/12.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKDragAndDropCollectionViewLayout : UICollectionViewLayout

#pragma mark - Layout Properties

/**
 * Cell的尺寸
 */
@property (nonatomic) CGSize itemSize;

/**
 * 行间线宽
 */
@property (nonatomic) CGFloat lineSpacing;

/**
 * 同一行Cell的最小边距
 */
@property (nonatomic) CGFloat minimumInteritemSpacing;

/**
 * 段落的内边距
 */
@property (nonatomic) UIEdgeInsets sectionInset;

#pragma mark - Dragging Properties

/**
 * 当前正在被拖动的Cell的位置
 */
@property (nonatomic, strong) NSIndexPath *draggedIndexPath;

/**
 * 被拖动的Cell的源位置
 */
@property (nonatomic) CGRect draggedCellFrame;

/**
 * 拖动结束后Cell的最终位置
 */
@property (nonatomic, strong) NSIndexPath *finalIndexPath;

/**
 * 被拖动的Cell的中心点
 */
@property (nonatomic) CGPoint draggedCellCenter;

/**
 * 标识Cell拖动状态
 */
@property (nonatomic, readonly) BOOL isDraggingCell;

/**
 * 当用户拖动Cell到另一个Cell上时，交换两个Cell的位置
 */
- (void)exchangeItemsIfNeeded;

/**
 * 当用户结束拖动Cell时重置拖动
 */
- (void)resetDragging;

@end
