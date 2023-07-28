//
//  HTSearchHistoryKeywordCell.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSearchHistoryKeywordCell.h"

@interface HTSearchHistoryKeywordCell()

@property (nonatomic, strong) UIButton               * moreBtn;
@property (nonatomic, strong) NSMutableArray          * var_buttonArray;
@property (nonatomic, strong) UIButton               * lastBtn;

@end

@implementation HTSearchHistoryKeywordCell

- (void)ht_addCellSubViews {
    
    self.clipsToBounds = YES;
    
    self.moreBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:115] andSelectImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:116]];
    self.moreBtn.bounds = CGRectMake(0, 0, 57, 28);
    self.moreBtn.backgroundColor = [UIColor colorWithHexString:@"#3A3A51"];
    self.moreBtn.cornerRadius = 14;
    [self.moreBtn addTarget:self action:@selector(lgjeropj_onDownWords:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview: self.moreBtn];
}

- (void)setKeywordArray:(NSArray *)keywordArray {
    _keywordArray = keywordArray;
    
    if ( keywordArray.count > 0 ) {
        self.moreBtn.hidden = NO;
        
        if ( self.var_buttonArray == nil ) {
            self.var_buttonArray = [NSMutableArray array];
        }
        
        while ( self.var_buttonArray.count > keywordArray.count ) {
            UIButton *lastBtn = [self.var_buttonArray lastObject];
            [lastBtn removeFromSuperview];
            [self.var_buttonArray removeLastObject];
        }
        
        for ( int i=0; i < keywordArray.count; i++ ) {
            NSString * key = keywordArray[i];
            UIButton *button;
            if (self.var_buttonArray.count > i) {
                button = [self.var_buttonArray objectAtIndex:i];
            } else {
                button = [HTKitCreate ht_buttonWithImage:nil andTitle:key andFont:HTPingFangRegularFont(14) andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
                button.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16);
                button.backgroundColor = [UIColor colorWithHexString:@"#3A3A51"];
                button.cornerRadius = 14;
                [button addTarget:self action:@selector(lgjeropj_onKeywordAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:button];
                [self.var_buttonArray addObject:button];
            }
            [button setTitle:key forState:UIControlStateNormal];
            [button sizeToFit];
        }
    } else {
        self.moreBtn.hidden = YES;
    }
    [self layoutSubviews];
}

- (void)lgjeropj_potentateAwestruck:(BOOL)var_isStretch {
    _var_isStretch = var_isStretch;
    self.moreBtn.selected = var_isStretch;
    [self layoutSubviews];
}

- (void)lgjeropj_onKeywordAction:(UIButton *)sender {
    if ( self.wordsBlock ) {
        self.wordsBlock(sender.currentTitle, 1, [self.keywordArray indexOfObject:sender.currentTitle]+1);
    }
}

- (void)lgjeropj_onDownWords:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ( self.stretchBlock ) {
        self.stretchBlock(sender.isSelected);
    }
}

- (CGFloat)ht_cellHeight {
    if ( self.var_buttonArray.count > 0 ) {
        CGFloat height = CGRectGetMaxY(self.moreBtn.frame) + 10;
        if ( self.var_isStretch == NO ) {
            if ( height > 10*3 + 28*2 ) {
                height = 10*3 + 28*2;
            }
        } else {
            
        }
        return height;
    }
    return 1;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat left = 16;  CGFloat top = 10;
    CGFloat right = 0;
    for ( int i=0; i < self.var_buttonArray.count; i++ ) {
        UIButton *button = [self.var_buttonArray objectAtIndex:i];
        button.frame = CGRectMake(left, top, button.bounds.size.width, 28);
        right = CGRectGetMaxX(button.frame);
        if ( right > kScreenWidth - 16 ) {
            left = 16;
            top = top + 28 + 10;
            button.frame = CGRectMake(left, top, button.bounds.size.width, 28);
            right = CGRectGetMaxX(button.frame);
        }
        
        left = right + 12;
    }
    
    
    if ( self.var_isStretch ) {
        for ( UIButton *button in self.var_buttonArray ) {
            button.hidden = NO;
        }
        self.lastBtn = [self.var_buttonArray lastObject];
    } else {
        for ( NSInteger i = self.var_buttonArray.count - 1; i >= 0; i-- ) {
            UIButton *button = self.var_buttonArray[i];
            if ( button.top > 10*2 + 28 ) {
                button.hidden = YES;
            } else {
                if ( button.top == 10*2 + 28 ) {
                    if ( button.right + 12 + CGRectGetWidth(self.moreBtn.frame) > kScreenWidth - 16 ) {
                        button.hidden = YES;
                    } else {
                        self.lastBtn = button;
                        break;
                    }
                } else {
                    self.lastBtn = button;
                    break;
                }
                
            }
            
        }
    }
    
    if ( self.lastBtn ) {
        self.moreBtn.frame = CGRectMake(CGRectGetMaxX(self.lastBtn.frame) + 12, CGRectGetMinY(self.lastBtn.frame), CGRectGetWidth(self.moreBtn.frame), 28);
        if ( CGRectGetMaxX(self.moreBtn.frame) > kScreenWidth - 16) {
            self.moreBtn.frame = CGRectMake(16, CGRectGetMaxY(self.lastBtn.frame) + 10, CGRectGetWidth(self.moreBtn.frame), 28);
        }
    }
}

@end
