//
//  HTHistoryViewController.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTHistoryViewController.h"
#import "HTHistoryViewCell.h"
#import "HTDBHistoryModel.h"
#import "HTHistoryViewManager.h"
#import "HTHistoryBuriedManager.h"
#import "HTMoivePlayViewController.h"
#import "HTAdvertBannerView.h"

@interface HTHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UIButton * deleteBtn;

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * selArray;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL var_haveAds;
@property (nonatomic, strong) HTAdvertBannerView *var_bannerView;

@end

@implementation HTHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"Recently Played", nil);
    
    __weak typeof(self) weakSelf = self;;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_UpdateVIPStatusAndProductsInfo" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
            weakSelf.var_bannerView.hidden = !weakSelf.var_haveAds;
        });
    }];

    self.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();

    [self ht_addDefaultLeftItem];
    [self ht_addRightBtnWithTitle:LocalString(@"Edit", nil)];
    [self lgjeropj_addSubViews];
    
    //埋点
    [HTHistoryBuriedManager lgjeropj_reportShowMaidian];
}

- (void)ht_rightItemClicked:(UIButton *)sender {
    [sender setTitle:LocalString(@"Cancel", nil) forState:UIControlStateSelected];
    
    sender.selected = !sender.isSelected;
    self.isEdit = sender.isSelected;
    [self.tableView reloadData];
    
    if (self.isEdit) {
        if (self.selArray == nil) {
            self.selArray = [NSMutableArray array];
        } else {
            [self.selArray removeAllObjects];
        }
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    } else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(91);
        }];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self lgjeropj_bindViewModel];
}

- (void)lgjeropj_addSubViews {
    
    self.var_bannerView = [[HTAdvertBannerView alloc] init];
    self.var_bannerView.hidden = !self.var_haveAds;
    self.var_bannerView.backgroundColor = kMainColor;
    [self.view addSubview:self.var_bannerView];
    [self.var_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(320);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    self.bottomView = [HTHistoryViewManager lgjeropj_bottomView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(91);
        make.height.mas_equalTo(91);
    }];

    self.tableView = [HTHistoryViewManager lgjeropj_tableView:self];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    self.deleteBtn = [HTHistoryViewManager lgjeropj_deleteButton:self action:@selector(lgjeropj_onDeleteAction:)];
    [self.bottomView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];

    self.selectBtn = [HTHistoryViewManager lgjeropj_selectButton:self action:@selector(lgjeropj_onSelectAction:)];
    [self.bottomView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.deleteBtn.mas_left).offset(-10);
        make.width.equalTo(self.deleteBtn.mas_width);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + ((self.var_haveAds && self.dataArray.count > 0) ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.var_haveAds && (indexPath.row == 3 || (self.dataArray.count < 4 && indexPath.row == self.dataArray.count))) {
        return 280;
    }
    return 136;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.var_haveAds && (indexPath.row == 3 || (self.dataArray.count < 4 && indexPath.row == self.dataArray.count))) {
        HTHistoryAdCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTHistoryAdCell class])];
        __weak typeof(self) weakSelf = self;
        cell.cancelBlock = ^(id data) {
            weakSelf.var_haveAds = NO;
            [weakSelf.tableView reloadData];
        };
        cell.adStartBlock = ^(id data) {
            [HTCommonConfiguration lgjeropj_shared].BLOCK_toPremiumBlock(18);
        };
        return cell;
    }
    NSInteger index = 0;
    if (self.var_haveAds) {
        if (self.dataArray.count > 3) {
            if (indexPath.row > 3) {
                index = indexPath.row - 1;
            } else {
                index = indexPath.row;
            }
        } else {
            index = indexPath.row;
        }
    } else {
        index = indexPath.row;
    }
    HTDBHistoryModel *model = self.dataArray[index];
    HTHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTHistoryViewCell class])];
    [cell lgjeropj_selectEdit:self.isEdit];
    [cell ht_updateCellWithData:model];
    __weak typeof(self) weakSelf = self;
    cell.selectBlock = ^(BOOL isSelect) {
        [weakSelf lgjeropj_selectStatus:isSelect model:model];
    };
    return cell;
}

- (void)lgjeropj_selectStatus:(BOOL)isSelect model:(HTDBHistoryModel *)model {
    if (isSelect) {
        if (![self.selArray containsObject:model]) {
            [self.selArray addObject:model];
        }
    } else {
        if ([self.selArray containsObject:model]) {
            [self.selArray removeObject:model];
        }
    }
    
    if (self.selArray.count > 0) {
        self.deleteBtn.enabled = YES;
        if (self.selArray.count == self.dataArray.count) {
            self.selectBtn.selected = YES;
        } else {
            self.selectBtn.selected = NO;
        }
    } else {
        self.deleteBtn.enabled = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = 0;
    if (self.var_haveAds) {
        if (self.dataArray.count > 3) {
            if (indexPath.row > 3) {
                index = indexPath.row - 1;
            } else {
                index = indexPath.row;
            }
        } else {
            index = indexPath.row;
        }
    } else {
        index = indexPath.row;
    }
    if (self.var_haveAds && (indexPath.row == 3 || (self.dataArray.count < 4 && indexPath.row == self.dataArray.count))) {
        return;
    }
    HTDBHistoryModel *model = self.dataArray[index];
    HTMoivePlayViewController *vc = [[HTMoivePlayViewController alloc] init];
    vc.source = @"6";
    vc.var_mId = model.var_mId;
    vc.cover = model.var_cover;
    vc.var_isTType = model.var_isTV.intValue;
    [self.navigationController pushViewController:vc animated:YES];
    
    //埋点
    [HTHistoryBuriedManager lgjeropj_clickMTWithKid:@"1" andMID:model.var_mId andMname:model.var_title andType:(model.var_isTV.intValue?@"2":@"1")];
}

- (void)lgjeropj_onSelectAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.deleteBtn.enabled = sender.isSelected;
    for ( HTDBHistoryModel *model in self.dataArray) {
        model.var_isSelect = sender.isSelected;
    }
    
    if (sender.isSelected) {
        self.selArray = [NSMutableArray arrayWithArray:self.dataArray];
    } else {
        [self.selArray removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (void)lgjeropj_onDeleteAction:(UIButton *)sender {
    UIAlertController *alertVC = [HTKitCreate ht_alertControllerWithTitle:nil message:LocalString(@"You will delete from playback history", nil) andButtonTitles:@[LocalString(@"Cancel", nil),LocalString(@"Delete", nil)] handle:^(UIAlertAction * _Nonnull action) {
        if ([action.title isEqualToString:LocalString(@"Delete", nil)]) {
            NSMutableArray *result = [NSMutableArray arrayWithArray:self.dataArray];
            if (self.selArray.count > 0) {
                for ( HTDBHistoryModel *model in self.selArray) {
                    [result removeObject:model];
                    [model ht_deleteDataWithMID:model.var_mId];
                }
            }
            
            self.deleteBtn.enabled = NO;
            
            [self.selArray removeAllObjects];
            self.dataArray = result;
            [self.tableView reloadData];
        }
    }];
    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
    if (popover){
        popover.sourceView = self.view;
        popover.sourceRect = CGRectMake(self.view.frame.size.width/2 -75, self.view.frame.size.height, 150, 150);
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)lgjeropj_bindViewModel {
    NSArray *array = [[HTDBHistoryModel alloc] ht_getAllData];
    self.dataArray = [NSMutableArray array];
    for ( int i=0; i < array.count; i++) {
        HTDBHistoryModel *model = array[i];
        BOOL isHave = [self lgjeropj_isHaveModel:model];
        if (isHave == NO) {
            [self.dataArray addObject:model];
        }
    }
    [self.tableView reloadData];
}

- (BOOL)lgjeropj_isHaveModel:(HTDBHistoryModel *)model {
    if (self.dataArray.count > 0) {
        for ( HTDBHistoryModel *var_model in self.dataArray) {
            if ([model.var_mId isEqualToString:var_model.var_mId]) {
                return YES;
            }
        }
    }
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
