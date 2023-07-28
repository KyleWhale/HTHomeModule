//
//  HTTVSeasonView.m
//  Hucolla
//
//  Created by mac on 2022/9/22.
//

#import "HTTVSeasonView.h"
#import "HTTVDetailSeasonModel.h"

@interface HTTVSeasonView()

@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * var_buttonArray;

@end

@implementation HTTVSeasonView

- (void)ht_addViewSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(10, 8);
    self.layer.shadowRadius = 15;
    self.contentView = [[UIScrollView alloc] init];
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.cornerRadius = 6;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#2B2B3E"];
    [self addSubview:self.contentView];
}

- (void)ht_updateViewWithData:(id)data {
    if ( data ) {
        self.dataArray = (NSArray *)data;
        
        if ( self.var_buttonArray == nil ) {
            self.var_buttonArray = [NSMutableArray array];
        }
        
        while ( self.var_buttonArray.count > self.dataArray.count ) {
            UIButton *button = [self.var_buttonArray lastObject];
            [button removeFromSuperview];
            [self.var_buttonArray removeObject:button];
        }
        
        for ( int i=0; i < self.dataArray.count; i++ ) {
            HTTVDetailSeasonModel *model = self.dataArray[i];
            UIButton * button;
            if (self.var_buttonArray.count <= i) {
                button = [HTKitCreate ht_buttonWithImage:nil andTitle:model.title andFont:HTPingFangRegularFont(14) andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
                [self.contentView addSubview:button];
                [self.var_buttonArray addObject:button];
            } else {
                button = [self.var_buttonArray objectAtIndex:i];
            }
            [button addTarget:self action:@selector(onSeasonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:model.title forState:UIControlStateNormal];
        }
    }
}

- (void)onSeasonAction:(UIButton *)sender {
    NSInteger index = [self.var_buttonArray indexOfObject:sender];
    if ( self.seasonBlock ) {
        self.seasonBlock(self.dataArray[index]);
    }
    [self dismiss];
}

- (void)ht_showInView {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    self.frame = window.bounds;
    
    CGFloat height = 10;
    if ( self.var_buttonArray.count > 0 ) {
        for ( int i=0; i < self.var_buttonArray.count; i++ ) {
            UIButton *button = self.var_buttonArray[i];
            button.frame = CGRectMake(10, 12 + (24 + 8)*i, CGRectGetWidth(self.fromRect) - 20, 24);
            if ( i == self.var_buttonArray.count - 1) {
                height = CGRectGetMaxY(button.frame) + 12;
            }
        }
    }
    
    self.contentView.frame = CGRectMake(CGRectGetMinX(self.fromRect), CGRectGetMaxY(self.fromRect) + 10, CGRectGetWidth(self.fromRect), 10);
    self.contentView.contentSize = CGSizeMake(self.contentView.size.width, height);
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(CGRectGetMinX(self.fromRect), CGRectGetMaxY(self.fromRect) + 10, CGRectGetWidth(self.fromRect), MIN(height, 150));
    }];
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(CGRectGetMinX(self.fromRect), CGRectGetMaxY(self.fromRect) + 10, CGRectGetWidth(self.fromRect), 10);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ( touch ) {
        CGPoint point = [touch locationInView:self];
        if ( CGRectContainsPoint(self.contentView.frame, point) == NO ) {
            [self dismiss];
        }
    }
}

@end
