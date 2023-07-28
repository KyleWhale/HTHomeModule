//
//  HTSearchHistoryKeywordCell.h
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

// type 1=历史 2=hot

@interface HTSearchHistoryKeywordCell : BaseCollectionViewCell

@property (nonatomic, strong) NSArray     * keywordArray;
@property (nonatomic, assign) BOOL          var_isStretch;

@property (nonatomic, copy) BLOCK_SearchBlock   wordsBlock;
@property (nonatomic, copy) BLOCK_HTBlock     stretchBlock;

- (void)lgjeropj_potentateAwestruck:(BOOL)var_isStretch;

@end

NS_ASSUME_NONNULL_END
