//
//  HTPlayerHistoryView.h
//  Hucolla
//
//  Created by mac on 2022/9/15.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTPlayerHistoryView : BaseView

@property (nonatomic, copy) BLOCK_HTVoidBlock playBlock;
@property (nonatomic, copy) BLOCK_HTBlock cancelBlock;

- (void)ht_startTimer;
- (void)ht_endTimer;

@end

NS_ASSUME_NONNULL_END
