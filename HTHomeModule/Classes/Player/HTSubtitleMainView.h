//
//  HTSubtitleMainView.h
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSubtitleMainView : UIView

@property (nonatomic, copy) BLOCK_HTVoidBlock     settingBlock;
@property (nonatomic, copy) BLOCK_HTVoidBlock     languageBlock;
@property (nonatomic, copy) BLOCK_HTBlock         switchBlock;

@end

NS_ASSUME_NONNULL_END
