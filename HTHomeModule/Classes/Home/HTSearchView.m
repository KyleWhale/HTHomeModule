//
//  HTSearchView.m
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "HTSearchView.h"

@interface HTSearchView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;

@end

@implementation HTSearchView

- (void)ht_addViewSubViews {
    
    self.textField = [HTKitCreate ht_textFieldWithDelegate:self andFont:HTPingFangFont(14) andTextColor:[UIColor colorWithHexString:@"#222222"] andPlaceholder:LocalString(@"Search for movies, TV", nil) andHolderColor:[UIColor colorWithHexString:@"#666666"]];
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.cornerRadius = 18;
    [self.textField addTarget:self action:@selector(lgjeropj_textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 36)];
    UIImageView *iconImgV = [[UIImageView alloc] init];
    [iconImgV sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:131]];
    iconImgV.frame = CGRectMake(11, 10, 16, 16);
    [leftView addSubview:iconImgV];
    
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 36)];
    UIButton *clearBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:64] andSelectImage:nil];
    [clearBtn addTarget:self action:@selector(onClearAction) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.frame = CGRectMake(0, 3, 30, 30);
    [rightView addSubview:clearBtn];
    
    self.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.textField.rightView = rightView;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    self.textField.placeholder = placeHolder;
}

- (NSString *)placeHolder {
    return self.textField.placeholder;
}

- (void)setSearchString:(NSString *)searchString {
    self.textField.text = searchString;
}

- (NSString *)searchString {
    return self.textField.text;
}

- (void)ht_endEditing {
    [self.textField resignFirstResponder];
}

- (void)onClearAction {
    self.textField.text = @"";
    [self lgjeropj_textDidChange:self.textField];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_searchViewShouldBeginEditing:)] ) {
        return [self.delegate ht_searchViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_searchViewShouldEndEditing:)] ) {
        return [self.delegate ht_searchViewShouldEndEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_searchViewShouldShouldReturn:)] ) {
        return [self.delegate ht_searchViewShouldShouldReturn:self];
    }
    return YES;
}

- (void)lgjeropj_textDidChange:(UITextField *)textField {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_searchViewTextDidChanged:)] ) {
        [self.delegate ht_searchViewTextDidChanged:self];
    }
}

@end
