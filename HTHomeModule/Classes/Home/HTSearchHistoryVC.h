//
//  HTSearchHistoryVC.h
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTSearchHistoryVC : BaseViewController

@property (nonatomic, copy) BLOCK_SearchBlock   wordsBlock;
@property (nonatomic, copy) BLOCK_HTBlock       stretchBlock;

- (void)ht_reloadData;

@end

NS_ASSUME_NONNULL_END
