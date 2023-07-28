//
//  HTSearchAssociationVC.h
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTSearchAssociationVC : BaseViewController

@property (nonatomic, strong) NSString     * searchString;
@property (nonatomic, assign) BOOL           showResult;

@property (nonatomic, copy) BLOCK_dataBlock     searchResultBlock;
@property (nonatomic, copy) BLOCK_SearchBlock   searchClickBlock;

@end

NS_ASSUME_NONNULL_END
