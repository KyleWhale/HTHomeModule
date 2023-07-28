//
//  HTSearchView.h
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class HTSearchView;
@protocol HTSearchViewDelegate <NSObject>
@optional;
- (BOOL)ht_searchViewShouldBeginEditing:(HTSearchView *)searchView;
- (BOOL)ht_searchViewShouldEndEditing:(HTSearchView *)searchView;
- (BOOL)ht_searchViewShouldShouldReturn:(HTSearchView *)searchView;
- (void)ht_searchViewTextDidChanged:(HTSearchView *)searchView;
@end

@interface HTSearchView : BaseView

@property (nonatomic, weak) id <HTSearchViewDelegate>  delegate;
@property (nonatomic, strong) NSString    * placeHolder;
@property (nonatomic, strong) NSString    * searchString;

- (void)ht_endEditing;

@end

NS_ASSUME_NONNULL_END
