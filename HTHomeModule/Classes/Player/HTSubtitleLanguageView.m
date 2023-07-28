//
//  HTSubtitleLanguageView.m
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import "HTSubtitleLanguageView.h"
#import "HTSubtitleLanguageViewManager.h"

@interface HTSubtitleLanguageView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView     * var_tableView;
@property (nonatomic, strong) UIButton        * var_cancelBtn;
@property (nonatomic, strong) UIView          * var_line;

@end

@implementation HTSubtitleLanguageView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.var_cancelBtn = [HTSubtitleLanguageViewManager lgjeropj_cancelBtn];
    [self addSubview:self.var_cancelBtn];
    
    self.var_line = [HTSubtitleLanguageViewManager lgjeropj_line];
    [self addSubview:self.var_line];
    
    self.var_tableView = [HTSubtitleLanguageViewManager lgjeropj_tableView:self];
    [self addSubview:self.var_tableView];
    
    [self.var_cancelBtn addTarget:self action:@selector(onCancelAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    [self.var_cancelBtn setTitle:title forState:UIControlStateNormal];
    [self.var_cancelBtn setPosition:1 interval:8];
}

- (void)setTextArray:(NSArray *)textArray {
    
    _textArray = textArray;
    [self.var_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HTSubtitlesModel *model = self.textArray[indexPath.row];
    HTLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTLanguageCell class])];
    [cell ht_updateCellWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (HTSubtitlesModel *mod in self.textArray) {
        mod.isSelect = NO;
    }
    HTSubtitlesModel *model = self.textArray[indexPath.row];
    model.isSelect = YES;
    if ( self.selBlock ) {
        self.selBlock(model);
    }
}

- (void)onCancelAction {
    
    if ( self.cancelBlock ) {
        self.cancelBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.var_cancelBtn.frame = CGRectMake(50, 49, 150, 30);
    self.var_line.frame = CGRectMake(50, CGRectGetMaxY(self.var_cancelBtn.frame), CGRectGetWidth(self.bounds) - 50, 1);
    self.var_tableView.frame = CGRectMake(50, CGRectGetMaxY(self.var_line.frame)+9, CGRectGetWidth(self.bounds) - 50 - 38, CGRectGetHeight(self.bounds) - 18 - CGRectGetMaxY(self.var_line.frame));
}

@end
