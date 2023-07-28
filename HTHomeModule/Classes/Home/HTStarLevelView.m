//
//  HTStarLevelView.m
//  Examination
//
//  Created by mac on 2020/12/21.
//

#import "HTStarLevelView.h"


@interface HTStarLevelView ()

@property (nonatomic, assign)   CGFloat               index;
@property (nonatomic, strong)   UIImage            * norStar;
@property (nonatomic, strong)   UIImage            * selStar;
@property (nonatomic, strong)   UIImage            * midStar;

@end

@implementation HTStarLevelView

+ (instancetype)ht_starLevelView
{
    HTStarLevelView *view = [[HTStarLevelView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.norStar = [UIImage imageNamed:@"icon_wdstar_nor"];
    view.selStar = [UIImage imageNamed:@"icon_wdstar_sel"];
    view.midStar = [UIImage imageNamed:@"icon_wdstar_bSel"];
    return view;
}

- (void)drawRect:(CGRect)rect {
    
    // 图片没间隙自己画
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat var_starWidth = CGRectGetHeight(self.frame);
    // 默认间隙为星星一半
    CGFloat var_spacing = var_starWidth * 0.5;
    if (self.var_spacing > 0 && self.var_spacing < 1.0) {
        var_spacing = var_starWidth * self.var_spacing;
    }
    CGFloat s = self.index/2.0;
    // 画图
    for (NSInteger i = 0; i < 5; i ++) {
        if (i < s - 1) {
            [self drawImage:context CGImageRef:self.selStar.CGImage CGRect:CGRectMake((var_starWidth + var_spacing) * i, 0, var_starWidth, var_starWidth)];
        } else if (i >= s - 1 && i < s) {
            [self drawImage:context CGImageRef:self.midStar.CGImage CGRect:CGRectMake((var_starWidth + var_spacing) * i, 0, var_starWidth, var_starWidth)];
        } else {
            [self drawImage:context CGImageRef:self.norStar.CGImage CGRect:CGRectMake((var_starWidth + var_spacing) * i, 0, var_starWidth, var_starWidth)];
        }
    }
}

- (void)drawImage:(CGContextRef)context CGImageRef:(CGImageRef)image CGRect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image);
    CGContextRestoreGState(context);
}

- (void)lgjeropj_spacing:(CGFloat)var_spacing {
    
    if (_var_spacing != var_spacing) {
        _var_spacing = var_spacing;
        [self setNeedsDisplay];
    }
}

- (void)lgjeropj_starCount:(CGFloat)var_starCount {
    
    if (var_starCount == 0) {
        return;
    }
    if (_var_starCount != var_starCount) {
        _var_starCount = var_starCount;
        if (var_starCount > 10.0) {
            var_starCount = 10.0;
        }
        if (var_starCount < 1.0) {
            var_starCount = 1.0;
        }
        self.index = var_starCount;
        [self setNeedsDisplay];
    }
}

@end
