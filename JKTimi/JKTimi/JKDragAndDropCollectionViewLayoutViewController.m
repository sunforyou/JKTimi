//
//  JKDragAndDropCollectionViewLayoutViewController.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/12.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKDragAndDropCollectionViewLayoutViewController.h"

@interface JKDragAndDropCollectionViewLayoutViewController ()

//拖动Cell时可同步滚动视图
- (void)scrollIfNeededWhileDraggingCell:(UICollectionViewCell *)cell;

@end

@implementation JKDragAndDropCollectionViewLayoutViewController

- (void)loadView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[JKDragAndDropCollectionViewLayout alloc] init]];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
}

#pragma mark - HTKDraggableCollectionViewCellDelegate

- (void)userDidBeginDraggingCell:(UICollectionViewCell *)cell {
    
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    // Set the indexPath that we're beginning to drag
    flowLayout.draggedIndexPath = [self.collectionView indexPathForCell:cell];
    // Set it's frame so if we have to reset it, we know where to put it.
    flowLayout.draggedCellFrame = cell.frame;
}

- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell {
    
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    
    // Reset
    [flowLayout resetDragging];
}

- (void)userDidDragCell:(UICollectionViewCell *)cell withGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    CGPoint translation = [recognizer translationInView:self.collectionView];
    // Determine our new center
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y + translation.y);
    // Set center
    flowLayout.draggedCellCenter = newCenter;
    [recognizer setTranslation:CGPointZero inView:self.collectionView];
    
    // swap items if needed
    [flowLayout exchangeItemsIfNeeded];
    
    // Scroll down if we're holding cell off screen vertically
    UICollectionViewCell *draggedCell = [self.collectionView cellForItemAtIndexPath:flowLayout.draggedIndexPath];
    [self scrollIfNeededWhileDraggingCell:draggedCell];
}

#pragma mark - Helper Methods

- (void)scrollIfNeededWhileDraggingCell:(UICollectionViewCell *)cell {
    
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    if (![flowLayout isDraggingCell]) {
        // If we've stopped dragging, exit
        return;
    }
    
    CGPoint cellCenter = flowLayout.draggedCellCenter;
    // Offset we will be adjusting
    CGPoint newOffset = self.collectionView.contentOffset;
    // How far past edge does it need to be before scrolling
    CGFloat buffer = 10;
    
    // Check for scrolling down
    CGFloat bottomY = self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.frame);
    if (bottomY < CGRectGetMaxY(cell.frame) - buffer) {
        // We're scrolling down
        newOffset.y += 1;
        
        if (newOffset.y + CGRectGetHeight(self.collectionView.bounds) > self.collectionView.contentSize.height) {
            return; // Stop moving, went too far
        }
        
        // adjust cell's center by 1
        cellCenter.y += 1;
    }
    
    // Check if moving upwards
    CGFloat offsetY = self.collectionView.contentOffset.y;
    if (CGRectGetMinY(cell.frame) + buffer < offsetY) {
        // We're scrolling up
        newOffset.y -= 1;
        
        if (newOffset.y <= 0) {
            return; // Stop moving, went too far
        }
        
        // adjust cell's center by 1
        cellCenter.y -= 1;
    }
    
    // Set new values
    self.collectionView.contentOffset = newOffset;
    flowLayout.draggedCellCenter = cellCenter;
    // Repeat until we went to far.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollIfNeededWhileDraggingCell:cell];
    });
}

@end
