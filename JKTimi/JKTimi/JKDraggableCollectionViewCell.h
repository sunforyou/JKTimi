//
//  JKDraggableCollectionViewCell.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/12.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Cell identifier for the cell.
 */
static NSString *JKDraggableCollectionViewCellIdentifier = @"JKDraggableCollectionViewCellIdentifier";

/**
 * Delegate for dragging the cell.
 */
@protocol JKDraggableCollectionViewCellDelegate <NSObject>

/**
 * Called when user starts to drag
 */
- (void)userDidBeginDraggingCell:(UICollectionViewCell *)cell;

/**
 * Called when user ends dragging.
 */
- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell;

/**
 * Called while user is dragging the cell
 */
- (void)userDidDragCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIPanGestureRecognizer *)recognizer;

@optional

/**
 * Determines if dragging can begin for cell. Defaults to YES.
 */
- (BOOL)userCanDragCell:(UICollectionViewCell *)cell;

@end

@interface JKDraggableCollectionViewCell : UICollectionViewCell

/**
 * Delegate for dragging the cell.
 */
@property (nonatomic, weak) id<JKDraggableCollectionViewCellDelegate> draggingDelegate;

@end
