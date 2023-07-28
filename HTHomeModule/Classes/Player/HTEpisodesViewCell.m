//
//  HTEpisodesViewCell.m
//  Hucolla
//
//  Created by dn on 2022/10/25.
//

#import "HTEpisodesViewCell.h"

@interface HTEpisodesViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HTEpisodesViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.cornerRadius = 10;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.titleLabel.text = text;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.titleLabel.textColor = selected ? [UIColor colorWithHexString:@"#3CDEF4"]:[UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

@end




