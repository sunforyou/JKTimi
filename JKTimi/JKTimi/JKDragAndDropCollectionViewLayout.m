//
//  JKDragAndDropCollectionViewLayout.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/12.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKDragAndDropCollectionViewLayout.h"
#import "JKDragAndDropCollectionViewLayoutConstants.h"

@interface JKDragAndDropCollectionViewLayout ()

/**
 * 存放重新排序后的Cell
 */
@property (nonatomic, strong) NSMutableArray *itemArray;

/**
 * 存放Cell的属性，键是indexPath
 */
@property (nonatomic, strong) NSMutableDictionary *itemDictionary;

/**
 * 每行单元格数目
 */
@property (readonly, nonatomic) NSInteger numberOfItemsPerRow;

/**
 * 用于排序完成后重置所有Cell的位置
 */
- (void)resetLayoutFrames;

/**
 *  变更Cell的属性
 *
 *  @param layoutAttributes 正在被拖动的Cell的attributes
 */
- (void)applyDragAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;

/**
 * Inserts the dragged item into the indexPath passed. Will reorder
 * the items.
 */
/**
 *  插入Cell
 *
 *  @param intersectPath NSindexPath
 */
- (void)insertDraggedItemAtIndexPath:(NSIndexPath *)intersectPath;

/**
 *  确认被拖动Cell
 *
 *  @param point CGPoint
 *
 *  @return 返回被拖动的Cell原来的indexPath
 */
- (NSIndexPath *)indexPathBelowDraggedItemAtPoint:(CGPoint)point;

@end

@implementation JKDragAndDropCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemArray = [NSMutableArray array];
        _itemDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 确认已设置过Cell尺寸
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero)) {
        return;
    }
    
    // 防止重复创建数组
    if (self.itemArray.count > 0) {
        return;
    }
    
    self.draggedIndexPath = nil;
    self.finalIndexPath = nil;
    self.draggedCellFrame = CGRectZero;
    [self.itemArray removeAllObjects];
    [self.itemDictionary removeAllObjects];
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right;
    CGFloat xValue = self.sectionInset.left;
    CGFloat yValue = self.sectionInset.top;
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    // 创建存放Cell的数组和存放Cell属性的字典
    for (NSInteger section = 0; section < sectionCount; section ++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item ++) {
            
            if ((xValue + self.itemSize.width) > collectionViewWidth) {
            
                xValue = self.sectionInset.left;
                yValue += self.itemSize.height + self.lineSpacing;
            }

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
     
            attributes.frame = CGRectMake(xValue, yValue, self.itemSize.width, self.itemSize.height);
            
            self.itemDictionary[indexPath] = attributes;
            [self.itemArray addObject:attributes];
            
            xValue += self.itemSize.width + self.minimumInteritemSpacing;
        }
    }
}

- (CGSize)collectionViewContentSize {
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    // 设置段落数目
    NSInteger totalItems = 0;
    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        totalItems += [self.collectionView numberOfItemsInSection:i];
    }
    // 设置每段行数
    NSInteger rows = totalItems / self.numberOfItemsPerRow;
    // 设置collectionView高度
    CGFloat height = (rows * (self.itemSize.height + self.lineSpacing)) + self.sectionInset.top + self.sectionInset.bottom;
    
    return CGSizeMake(collectionViewWidth, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *elementArray = [NSMutableArray array];
    
    // Loop over our items and find elements that
    // intersect the rect passed.
    [[self.itemArray copy] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attribute = (UICollectionViewLayoutAttributes *)obj;
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [self applyDragAttributes:attribute];
            [elementArray addObject:attribute];
        }
    }];
    
    return elementArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    [self applyDragAttributes:layoutAttributes];
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [self.itemDictionary[itemIndexPath] copy];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    UICollectionViewLayoutAttributes *attributes = [self.itemDictionary[itemIndexPath] copy];
    return attributes;
}

#pragma mark - Getters

- (NSInteger)numberOfItemsPerRow {
    // Determine how many items we can fit per row
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right - self.sectionInset.left;
    NSInteger numberOfItems = collectionViewWidth / (self.itemSize.width + _minimumInteritemSpacing);
    
    return numberOfItems;
}

- (CGFloat)minimumInteritemSpacing {
    // return minimum item spacing
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right - self.sectionInset.left;
    CGFloat actualItemSpacing = MAX(_minimumInteritemSpacing, collectionViewWidth - (self.numberOfItemsPerRow * self.itemSize.width));
    return actualItemSpacing;
}

#pragma mark - Drag and Drop methods

- (void)resetDragging {
    
    // Set our dragged cell back to it's "home" frame
    UICollectionViewLayoutAttributes *attributes = self.itemDictionary[self.draggedIndexPath];
    attributes.frame = self.draggedCellFrame;
    
    self.finalIndexPath = nil;
    self.draggedIndexPath = nil;
    self.draggedCellFrame = CGRectZero;
    
    // Put the cell back animated.
    [UIView animateWithDuration:0.2 animations:^{
        [self invalidateLayout];
    }];
}

- (void)resetLayoutFrames {
    
    // Get width of collectionView and adjust by section insets
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right;
    
    CGFloat xValue = self.sectionInset.left;
    CGFloat yValue = self.sectionInset.top;
    for (NSInteger i = 0; i < self.itemArray.count; i++) {
        
        // Get attributes to work with
        UICollectionViewLayoutAttributes *attributes = self.itemArray[i];
        
        // Check our xvalue
        if ((xValue + self.itemSize.width) > collectionViewWidth) {
            // reset our x, increment our y.
            xValue = self.sectionInset.left;
            yValue += self.itemSize.height + self.lineSpacing;
        }
        
        // Set new frame
        attributes.frame = CGRectMake(xValue, yValue, self.itemSize.width, self.itemSize.height);
        
        // Increment our x value
        xValue += self.itemSize.width + self.minimumInteritemSpacing;
    }
}

- (void)applyDragAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if ([layoutAttributes.indexPath isEqual:self.draggedIndexPath]) {
        // Set dragged attributes
        layoutAttributes.center = self.draggedCellCenter;
        layoutAttributes.zIndex = 1024;
        layoutAttributes.alpha = JKDraggableCellInitialDragAlphaValue;
    } else {
        // Default attributes
        layoutAttributes.zIndex = 0;
        layoutAttributes.alpha = 1.0;
    }
}

- (void)setDraggedCellCenter:(CGPoint)draggedCellCenter {
    _draggedCellCenter = draggedCellCenter;
    [self invalidateLayout];
}

- (void)insertDraggedItemAtIndexPath:(NSIndexPath *)intersectPath {
    // Get attributes to work with
    UICollectionViewLayoutAttributes *draggedAttributes = self.itemDictionary[self.draggedIndexPath];
    UICollectionViewLayoutAttributes *intersectAttributes = self.itemDictionary[intersectPath];
    
    // get index of items
    NSUInteger draggedIndex = [self.itemArray indexOfObject:draggedAttributes];
    NSUInteger intersectIndex = [self.itemArray indexOfObject:intersectAttributes];
    
    // Move item in our array
    [self.itemArray removeObjectAtIndex:draggedIndex];
    [self.itemArray insertObject:draggedAttributes atIndex:intersectIndex];
    
    // Set our new final indexPath
    self.finalIndexPath = intersectPath;
    self.draggedCellFrame = intersectAttributes.frame;
    
    // relayout frames for items
    [self resetLayoutFrames];
    
    // Animate change
    [UIView animateWithDuration:0.10 animations:^{
        [self invalidateLayout];
    }];
}

- (void)exchangeItemsIfNeeded {
    // Exchange objects if we're touching.
    NSIndexPath *intersectPath = [self indexPathBelowDraggedItemAtPoint:self.draggedCellCenter];
    UICollectionViewLayoutAttributes *attributes = self.itemDictionary[intersectPath];
    
    // Create a "hit area" that's 20 pt over the center of the intersected cell center
    CGRect centerBox = CGRectMake(attributes.center.x - JKDragAndDropCenterTriggerOffset, attributes.center.y - JKDragAndDropCenterTriggerOffset, JKDragAndDropCenterTriggerOffset * 2, JKDragAndDropCenterTriggerOffset * 2);
    // Determine if we need to move items around
    if (intersectPath != nil && ![intersectPath isEqual:self.draggedIndexPath] && CGRectContainsPoint(centerBox, self.draggedCellCenter)) {
        [self insertDraggedItemAtIndexPath:intersectPath];
    }
}

- (BOOL)isDraggingCell {
    return self.draggedIndexPath != nil;
}

#pragma mark - Helper Methods

- (NSIndexPath *)indexPathBelowDraggedItemAtPoint:(CGPoint)point {
    
    __block NSIndexPath *indexPathBelow = nil;
    __weak JKDragAndDropCollectionViewLayout *weakSelf = self;
    
    [self.collectionView.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = (NSIndexPath *)obj;
        
        // Skip our dragged cell
        if ([self.draggedIndexPath isEqual:indexPath]) {
            return;
        }
        UICollectionViewLayoutAttributes *attribute = weakSelf.itemDictionary[indexPath];
        
        // Create a "hit area" that's 20 pt over the center of the testing cell
        CGRect centerBox = CGRectMake(attribute.center.x - JKDragAndDropCenterTriggerOffset, attribute.center.y - JKDragAndDropCenterTriggerOffset, JKDragAndDropCenterTriggerOffset * 2, JKDragAndDropCenterTriggerOffset * 2);
        if (CGRectContainsPoint(centerBox, weakSelf.draggedCellCenter)) {
            indexPathBelow = indexPath;
            *stop = YES;
        }
    }];
    
    return indexPathBelow;
}

@end
