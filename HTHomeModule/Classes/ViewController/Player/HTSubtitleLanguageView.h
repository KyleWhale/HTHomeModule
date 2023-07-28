//
//  HTSubtitleLanguageView.h
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import <UIKit/UIKit.h>
#import "HTSubtitlesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTSubtitleLanguageView : UIView

@property (nonatomic, strong) NSString       * title;
@property (nonatomic, strong) NSArray        * textArray;
@property (nonatomic, copy) BLOCK_HTVoidBlock     cancelBlock;
@property (nonatomic, copy) BLOCK_dataBlock       selBlock;

- (void)setTextArray:(NSArray *)textArray;
@end

NS_ASSUME_NONNULL_END
