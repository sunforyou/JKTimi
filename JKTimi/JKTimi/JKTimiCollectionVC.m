//
//  JKTimiCollectionVC.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/12.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKTimiCollectionVC.h"
#import "JKTimiCollectionViewCell.h"

@interface JKTimiCollectionVC ()

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JKTimiCollectionVC

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 50; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell
    [self.collectionView registerClass:[JKTimiCollectionViewCell class] forCellWithReuseIdentifier:JKDraggableCollectionViewCellIdentifier];
    
    // Setup item size
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.bounds) -20) / 4;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.lineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark UICollectionView Datasource/Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JKTimiCollectionViewCell *cell = (JKTimiCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:JKDraggableCollectionViewCellIdentifier forIndexPath:indexPath];
    
    // Set number on cell
    cell.categoryLabel.text = self.dataArray[indexPath.row];
    [cell.categoryButton setTitle:self.dataArray[indexPath.row] forState:UIControlStateNormal];
    
    // Set our delegate for dragging
    cell.draggingDelegate = self;
    
    return cell;
}

#pragma mark - HTKDraggableCollectionViewCellDelegate

- (BOOL)userCanDragCell:(UICollectionViewCell *)cell {
    // All cells can be dragged in this demo
    return YES;
}

- (void)userDidEndDraggingCell:(UICollectionViewCell *)cell {
    [super userDidEndDraggingCell:cell];
    
    JKDragAndDropCollectionViewLayout *flowLayout = (JKDragAndDropCollectionViewLayout *)self.collectionView.collectionViewLayout;
    
    // Save our dragging changes if needed
    if (flowLayout.finalIndexPath != nil) {
        // Update datasource
        NSObject *objectToMove = [self.dataArray objectAtIndex:flowLayout.draggedIndexPath.row];
        [self.dataArray removeObjectAtIndex:flowLayout.draggedIndexPath.row];
        [self.dataArray insertObject:objectToMove atIndex:flowLayout.finalIndexPath.row];
    }
}

@end
