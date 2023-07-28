//
//  HTSearchViewController.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSearchViewController.h"
#import "HTSearchView.h"
#import "HTSearchHistoryVC.h"
#import "HTSearchAssociationVC.h"
#import "HTSearchResultVC.h"
#import "HTSearchViewBuriedManager.h"
#import "HTHomePointManager.h"

@interface HTSearchViewController ()<HTSearchViewDelegate>

@property (nonatomic, assign) BOOL var_haveAds;
@property (nonatomic, strong) UIView *navgationBar;
@property (nonatomic, strong) HTSearchView *searchView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger var_type;

@end

@implementation HTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.var_haveAds = YES;
    [self lgjeropj_addSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [HTSearchViewBuriedManager lgjeropj_maidianShow:self.var_source];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)lgjeropj_addSubViews {
    
    self.navgationBar = [[UIView alloc] init];
    self.navgationBar.backgroundColor = kNavBGColor;
    [self.view addSubview:self.navgationBar];
    [self.navgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kStatusHeight + 56);
    }];
    
    UIButton *backBtn = [HTKitCreate ht_buttonWithImage:[UIImage imageNamed:@"icon_wdback"] andSelectImage:nil];
    [backBtn addTarget:self action:@selector(lgjeropj_onBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationBar addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(self.navgationBar).offset(8);
        make.bottom.equalTo(self.navgationBar).offset(-8);
    }];
    
    self.searchView = [[HTSearchView alloc] init];
    self.searchView.delegate = self;
    [self.navgationBar addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backBtn.mas_right).offset(8);
        make.right.equalTo(self.navgationBar).offset(-16);
        make.bottom.equalTo(self.navgationBar).offset(-10);
        make.height.equalTo(@36);
    }];
    
    self.scrollView = [HTKitCreate ht_scrollViewWithDelegate:nil];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*3, kScreenHeight - kStatusHeight - 56);
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navgationBar.mas_bottom);
    }];
    
    HTSearchHistoryVC *hisVC = [[HTSearchHistoryVC alloc] init];
    [self addChildViewController:hisVC];
    [self.scrollView addSubview:hisVC.view];
    @weakify(self);
    hisVC.wordsBlock = ^(NSString *word, NSInteger type, NSInteger index) {
        @strongify(self);
        HTSearchAssociationVC *assVC = self.childViewControllers[1];
        assVC.showResult = YES;
        assVC.searchString = word;
        self.searchView.searchString = word;
        if (type == 1) {
            self.var_type = 5;
            [self lgjeropj_maidianClickWith:@"6" andIndex:index];
        } else {
            self.var_type = 3;
            [self lgjeropj_maidianClickWith:@"5" andIndex:index];
        }
    };
    hisVC.stretchBlock = ^(BOOL isSelect) {
        @strongify(self);
        if (isSelect) {
            self.var_type = 0;
            [self lgjeropj_maidianClickWith:@"14" andIndex:0];
        }
    };
    
    HTSearchAssociationVC *assVC = [[HTSearchAssociationVC alloc] init];
    [self addChildViewController:assVC];
    [self.scrollView addSubview:assVC.view];
    assVC.searchResultBlock = ^(HTSearchResultModel *result) {
        @strongify(self);
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:NO];
        [self.searchView ht_endEditing];
        HTSearchResultVC *rVC = self.childViewControllers[2];
        result.var_word = self.searchView.searchString;
        result.var_type = self.var_type;
        rVC.resultModel = result;
        
        // 埋点
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"search_result_sh_new" forKey:@"pointname"];
        [params setValue:@(self.var_source) forKey:@"source"];
        [params setValue:self.searchView.searchString forKey:AsciiString(@"word")];
        [params setValue:self.searchView.searchString forKey:@"keyword"];
        [params setValue:@(self.var_type) forKey:AsciiString(@"type")];
        [params setValue:(result ? @"1" : @"2") forKey:AsciiString(@"result")];
        [params setValue:(result ? @"success" : @"") forKey:@"errorinf"];
        [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
    };
    assVC.searchClickBlock = ^(NSString *word, NSInteger type, NSInteger index) {
        @strongify(self);
        self.searchView.searchString = word;
        self.var_type = 1;
        [self lgjeropj_maidianClickWith:@"9" andIndex:index];
    };
    
    HTSearchResultVC *resVC = [[HTSearchResultVC alloc] init];
    [self addChildViewController:resVC];
    [self.scrollView addSubview:resVC.view];
    
    hisVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusHeight - 56);
    assVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kStatusHeight - 56);
    resVC.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight - kStatusHeight - 56);
}

- (BOOL)ht_searchViewShouldBeginEditing:(HTSearchView *)searchView {
    
    if (self.scrollView.contentOffset.x == kScreenWidth*2) {
        // 埋点
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"search_result_cl_movies" forKey:@"pointname"];
        [params setValue:@(0) forKey:AsciiString(@"order")];
        [params setValue:self.searchView.searchString forKey:AsciiString(@"word")];
        [params setValue:@"1" forKey:AsciiString(@"kid")];
        [params setValue:@(self.var_type) forKey:AsciiString(@"type")];
        [params setValue:@"0" forKey:@"movie_id"];
        [params setValue:@"0" forKey:@"movie_type"];
        [params setValue:@"0" forKey:@"movie_name"];
        [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
    }
    if ( searchView.searchString.length > 0 ) {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
    }
    return YES;
}

- (void)ht_searchViewTextDidChanged:(HTSearchView *)searchView {
    if ( searchView.searchString.length > 0 ) {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
        HTSearchAssociationVC *assVC = self.childViewControllers[1];
        assVC.showResult = NO;
        assVC.searchString = searchView.searchString;
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        // 埋点
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"search_result_cl_movies" forKey:@"pointname"];
        [params setValue:@(0) forKey:AsciiString(@"order")];
        [params setValue:@"" forKey:AsciiString(@"word")];
        [params setValue:@"2" forKey:AsciiString(@"kid")];
        [params setValue:@(self.var_type) forKey:AsciiString(@"type")];
        [params setValue:@"0" forKey:@"movie_id"];
        [params setValue:@"0" forKey:@"movie_type"];
        [params setValue:@"0" forKey:@"movie_name"];
        [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
    }
}

- (BOOL)ht_searchViewShouldShouldReturn:(HTSearchView *)searchView {
    HTSearchAssociationVC *assVC = self.childViewControllers[1];
    assVC.showResult = YES;
    assVC.searchString = searchView.searchString;
    self.var_type = 1;
    [self lgjeropj_maidianClickWith:@"1" andIndex:0];
    return YES;
}

- (void)lgjeropj_onBackAction {
    if(self.scrollView.contentOffset.x == kScreenWidth*2) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        HTSearchHistoryVC *hisVC = (HTSearchHistoryVC *)self.childViewControllers.firstObject;
        [hisVC ht_reloadData];
        // 埋点
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"search_result_cl_movies" forKey:@"pointname"];
        [params setValue:@(0) forKey:AsciiString(@"order")];
        [params setValue:self.searchView.searchString forKey:AsciiString(@"word")];
        [params setValue:@"3" forKey:AsciiString(@"kid")];
        [params setValue:@(self.var_type) forKey:AsciiString(@"type")];
        [params setValue:@"0" forKey:@"movie_id"];
        [params setValue:@"0" forKey:@"movie_type"];
        [params setValue:@"0" forKey:@"movie_name"];
        [HTHomePointManager lgjeropj_maidianRequestWithParams:params];

        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lgjeropj_maidianClickWith:(NSString *)kid andIndex:(NSInteger)index {
    
    [HTSearchViewBuriedManager lgjeropj_maidianClickWith:kid andIndex:index andSource:self.var_source andType:self.var_type andKey:self.searchView.searchString];
}

@end
