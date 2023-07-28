//
//  HTGuideView.m
//  newNotes
//
//  Created by 李雪健 on 2022/11/2.
//

#import "HTGuideView.h"
#import "HTGuideViewManager.h"

@interface HTGuideView ()

@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *source;

@end

@implementation HTGuideView

- (instancetype)initWithData:(NSDictionary *)data andType:(NSInteger)type andSource:(NSString *)source {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.type = type;
        self.source = source;
        self.dataDict = [NSDictionary dictionaryWithDictionary:data];
        [self lgjeropj_addAlertSubviews];
    }
    return self;
}

- (void)lgjeropj_addAlertSubviews {
    NSString *var_title = (self.type == 1 ? [self.dataDict objectForKey:AsciiString(@"title")] : @"");
    NSString *var_detail = (self.type == 1 ? @"" : [self.dataDict objectForKey:AsciiString(@"t1")]);
    NSString *var_detail1 = (self.type == 1 ? [self.dataDict objectForKey:AsciiString(@"t4")] : [self.dataDict objectForKey:AsciiString(@"t2")]);
    NSString *var_detail2 = [self.dataDict objectForKey:AsciiString(@"t3")];
    NSString *var_detail3 = (self.type == 1 ? [self.dataDict objectForKey:AsciiString(@"text")] : @"");
    NSString *var_btnTitle = @"";
    if (self.type == 1) {
        var_btnTitle = [self.dataDict objectForKey:AsciiString(@"update")];
    } else if (self.type == 2) {
        var_btnTitle = [self.dataDict objectForKey:AsciiString(@"b1")];
        if([UIApplication.sharedApplication canOpenURL:[[NSURL alloc] initWithString:[self.dataDict objectForKey:AsciiString(@"l2")]]]){
            var_btnTitle = [self.dataDict objectForKey:AsciiString(@"b2")];
        }
    }
    UIView *var_centerView = [[UIView alloc] init];
    var_centerView.layer.backgroundColor = [UIColor colorWithHexString:@"#2C2B31"].CGColor;
    var_centerView.layer.cornerRadius = 12;
    [self addSubview:var_centerView];
    [var_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(320);
    }];
    
    UIImageView *var_icon1 = [[UIImageView alloc] init];
    [var_icon1 sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:247]];
    [var_centerView addSubview:var_icon1];
    [var_icon1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(100);
    }];
    
    UILabel *var_label = [[UILabel alloc] init];
    var_label.numberOfLines = 0;
    var_label.text = var_title;
    var_label.textColor = [UIColor whiteColor];
    var_label.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    var_label.hidden = var_title.length == 0;
    [var_centerView addSubview:var_label];
    [var_label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.equalTo(var_icon1.mas_left).offset(-10);
        if (var_detail.length == 0) {
            make.height.mas_equalTo(100);
        } else {
            make.height.mas_equalTo(50);
        }
    }];
    
    UILabel *var_detailLabel = [[UILabel alloc] init];
    var_detailLabel.text = var_detail;
    var_detailLabel.numberOfLines = 0;
    var_detailLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    var_detailLabel.font = [UIFont systemFontOfSize:14];
    var_detailLabel.hidden = var_detail.length == 0;
    [var_centerView addSubview:var_detailLabel];
    [var_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (var_title.length == 0) {
            make.bottom.equalTo(var_icon1.mas_bottom).offset(0);
        } else {
            make.top.equalTo(var_label.mas_bottom).offset(10);
        }
        make.left.mas_equalTo(15);
        make.right.equalTo(var_icon1.mas_left).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *var_detailLabel2 = [[UILabel alloc] init];
    var_detailLabel2.numberOfLines = 0;
    var_detailLabel2.text = var_detail1.length > 0 ? var_detail1 : (var_detail2.length > 0 ? var_detail2 : (var_detail3.length > 0 ? var_detail3 : @""));
    var_detailLabel2.textColor = [UIColor whiteColor];
    var_detailLabel2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [var_centerView addSubview:var_detailLabel2];
    [var_detailLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        if (var_detailLabel.isHidden) {
            make.top.equalTo(var_label.mas_bottom).offset(10);
        } else {
            make.top.equalTo(var_detailLabel.mas_bottom).offset(10);
        }
    }];
    
    UILabel *var_detailLabel3 = [[UILabel alloc] init];
    var_detailLabel3.numberOfLines = 0;
    var_detailLabel3.text = var_detail2;
    var_detailLabel3.textColor = [UIColor colorWithHexString:@"#888888"];
    var_detailLabel3.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    var_detailLabel3.hidden = (self.type == 2 && [[self.dataDict objectForKey:@"status"] integerValue] == 1) ? (var_detail1.length > 0 ? YES : NO) : (var_detail1.length == 0 ? YES : NO);
    [var_centerView addSubview:var_detailLabel3];
    [var_detailLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(var_detailLabel2.mas_bottom).offset(20);
    }];
    
    UIButton *var_updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [var_updateBtn setTitle:var_btnTitle forState:UIControlStateNormal];
    [var_updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [var_updateBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [var_updateBtn sd_setBackgroundImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:264] forState:UIControlStateNormal];
    [var_updateBtn addTarget:self action:@selector(lgjeropj_updateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [var_centerView addSubview:var_updateBtn];
    [var_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (var_detailLabel3.isHidden == YES) {
            make.top.equalTo(var_detailLabel2.mas_bottom).offset(20);
        } else {
            make.top.equalTo(var_detailLabel3.mas_bottom).offset(20);
        }
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-20);
    }];
    
    if ([[self.dataDict objectForKey:@"status"] integerValue] == 2) {
        UIButton *var_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [var_cancelButton sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:263] forState:UIControlStateNormal];
        [var_cancelButton addTarget:self action:@selector(lgjeropj_cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:var_cancelButton];
        [var_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(var_centerView.mas_bottom).offset(30);
            make.size.mas_equalTo(50);
            make.centerX.mas_equalTo(0);
        }];
    }
}
#pragma mark-
- (void)lgjeropj_updateButtonAction {
    NSString *var_yumingStr = self.dataDict[AsciiString(@"l1")];
    NSURL *var_linkURL = [NSURL URLWithString:self.dataDict[AsciiString(@"link")]];
    if (var_yumingStr && var_yumingStr.length > 0) {
        var_linkURL = [HTGuideViewManager lgjeropj_createDynamiclink:self.dataDict];
    }
    [[UIApplication sharedApplication] openURL:var_linkURL options:@{} completionHandler:^(BOOL success) {}];
    //埋点
    [HTGuideViewManager lgjeropj_daoLiangClick:@"1" andStatus:[self.dataDict[@"status"] integerValue] andSource:self.source andTag:[self.dataDict objectForKey:AsciiString(@"a1")]];
}

- (void)lgjeropj_cancelButtonAction {
    [HTCommonConfiguration lgjeropj_shared].BLOCK_stopAdBlock(NO);
    [self lgjeropj_hideAlertView];
    //埋点
    [HTGuideViewManager lgjeropj_daoLiangClick:@"2" andStatus:[self.dataDict[@"status"] integerValue] andSource:self.source andTag:[self.dataDict objectForKey:AsciiString(@"a1")]];
}

- (void)lgjeropj_showAlertView {
    UIWindow *rootWindow = [[[UIApplication sharedApplication] delegate] window];
    [rootWindow addSubview:self];
    //埋点
    [HTGuideViewManager lgjeropj_daoLiangShow:[self.dataDict[@"status"] integerValue] andSource:self.source andTag:[self.dataDict objectForKey:AsciiString(@"a1")]];
}

- (void)lgjeropj_hideAlertView{
    [self removeFromSuperview];
}

@end
