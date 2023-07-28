//
//  HTCollectionWaterFlowLayout.m
//  Hucolla
//
//  Created by mac on 2022/9/23.
//

#import "HTCollectionWaterFlowLayout.h"

@interface HTCollectionWaterFlowLayout ()

@property (nonatomic, strong) NSMutableArray     * columnHeights;
@property (nonatomic, strong) NSMutableArray     * attributesArray;
@property (nonatomic, strong) NSMutableArray     * headerAttributesArray;
@property (nonatomic, strong) NSMutableArray     * footerAttributesArray;

@end

//NSString *const kSupplementaryViewKindHeader = @"Header";
//CGFloat const kSupplementaryViewKindHeaderPinnedHeight = 44.f;

@implementation HTCollectionWaterFlowLayout

- (void)prepareLayout {
    [super prepareLayout];

    //初始化数组
    self.columnHeights = [NSMutableArray array];
    for(NSInteger column=0; column<_var_columns; column++){
        self.columnHeights[column] = @(0);
    }

    self.attributesArray = [NSMutableArray array];
    self.headerAttributesArray = [NSMutableArray array];
    self.footerAttributesArray = [NSMutableArray array];
    NSInteger numSections = [self.collectionView numberOfSections];
    
    for ( int section = 0; section < numSections; section++ ) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if( headerAttributes != nil && CGSizeEqualToSize(headerAttributes.size, CGSizeZero) == NO) {
            [self.attributesArray addObject:headerAttributes];
        }
        
        for( NSInteger item = 0; item < numItems; item++ ) {
            //遍历每一项
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            //计算LayoutAttributes
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];

            [self.attributesArray addObject:attributes];
        }
        
        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        
        if ( footerAttributes != nil && CGSizeEqualToSize(footerAttributes.size, CGSizeZero) == NO) {
            [self.attributesArray addObject:footerAttributes];
        }
        
    }
    
    
}

- (CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    NSInteger columnIndex = [self columnOfMostHeight];
    CGFloat maxHeight = [self.columnHeights[columnIndex] floatValue];
    if ( size.height < maxHeight ) {
        return CGSizeMake(size.width, maxHeight);
    }
    return size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    NSInteger numSections = [self.collectionView numberOfSections];
    
    if ( indexPath.section == numSections - 1 ) {
        //外部返回Item高度
        
        CGFloat itemHeight = [self.delegate ht_collectionViewLayout:self heightForRowAtIndexPath:indexPath];

        //找出所有列中高度最小的
        NSInteger columnIndex = [self columnOfLessHeight];
        CGFloat lessHeight = [self.columnHeights[columnIndex] floatValue];

        //计算LayoutAttributes
        CGFloat width = attributes.frame.size.width;
        CGFloat height = itemHeight;
        CGFloat x = attributes.frame.origin.x;
        
        CGFloat y = attributes.frame.origin.y;
        if(lessHeight > 0 ) {
            y = lessHeight + _itemSpacing;
        }
        attributes.frame = CGRectMake(x, y, width, height);

        //更新列高度
        self.columnHeights[columnIndex] = @(y+height);
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes  * attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    
    return attributes;
}

#pragma mark - helpers
// 找到高度最小的那一列的下标
- (NSInteger)columnOfLessHeight
{
    if(self.columnHeights.count == 0 || self.columnHeights.count == 1){
        return 0;
    }

    __block NSInteger var_leastIndex = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        
        if([number floatValue] < [self.columnHeights[var_leastIndex] floatValue]){
            var_leastIndex = idx;
        }
    }];
    
    return var_leastIndex;
}

// 找到高度最大的那一列的下标
- (NSInteger)columnOfMostHeight
{
    if(self.columnHeights.count == 0 || self.columnHeights.count == 1){
        return 0;
    }
    
    __block NSInteger var_index = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        
        if([number floatValue] > [self.columnHeights[var_index] floatValue]){
            var_index = idx;
        }
    }];
    
    return var_index;
}

@end
