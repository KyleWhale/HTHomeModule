//
//  HTSearchAssociationVC.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSearchAssociationVC.h"
#import "HTSearchHistoryManager.h"
#import "HTAssociationViewManager.h"
#import "HTSearchResultModel.h"
#import "HTHttpRequest.h"

@interface HTSearchAssociationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView         * tableView;
@property (nonatomic, strong) UILabel             * searchLab;
@property (nonatomic, strong) HTSearchResultModel * dataModel;
@property (nonatomic, strong) NSMutableArray      * wordsArray;

@end

@implementation HTSearchAssociationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self lgjeropj_addSubViews];
}

- (void)lgjeropj_addSubViews {
    
    self.searchLab = [HTAssociationViewManager lgjeropj_searchLabel];
    [self.view addSubview:self.searchLab];
    [self.searchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(16);
        make.top.equalTo(self.view).offset(20);
        make.height.equalTo(@20);
    }];
    
    self.tableView = [HTAssociationViewManager lgjeropj_tableView:self];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.searchLab.mas_bottom).offset(9);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTSearchAssociationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTSearchAssociationCell class])];
    [cell ht_updateCellWithData:self.wordsArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.showResult = YES;
    self.searchString = self.wordsArray[indexPath.row];
    if (self.searchClickBlock) {
        self.searchClickBlock(self.searchString, 0, indexPath.row);
    }
}

- (void)setSearchString:(NSString *)searchString {
    _searchString = searchString;
    self.searchLab.text = [NSString stringWithFormat:@"%@ “%@”", AsciiString(@"Search"), searchString];
    
    if ( self.showResult ) {
        NSDictionary *params = @{AsciiString(@"page"):@(1),
                                AsciiString(@"v_type"):@"0",
                                AsciiString(@"keyword"):searchString};
        [self ht_searchRequest:params];
    } else {
        [HTAssociationViewManager lgjeropj_getAssociationWordsWithRequest:searchString completion:^(NSArray *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data.count > 0) {
                    [self.wordsArray removeAllObjects];
                    [self.wordsArray addObjectsFromArray:data];
                    [self.tableView reloadData];
                }
            });
        }];
    }
}

- (void)ht_searchRequest:(NSDictionary *)params {
 
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 148] andParameters:params andCompletion:^(HTResponseModel *model, NSError * _Nullable error) {
        if ( error == nil ) {
            if ( model.status == 200 ) {
                self.dataModel = [HTSearchResultModel yy_modelWithJSON:model.data];
                if ( self.showResult ) {
                    if ([self.searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
                        // 空串
                        NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
                        NSMutableArray *multArray = [NSMutableArray arrayWithArray:keywords];
                        if ( [multArray containsObject:self.searchString] ) {
                            [multArray removeObject:self.searchString];
                        }
                        [multArray insertObject:self.searchString atIndex:0];
                        if( multArray.count > 10 ) {
                            [multArray removeLastObject];
                        }
                        [HTSearchHistoryManager lgjeropj_saveHistory:multArray];
                    }
                    if ( self.searchResultBlock ) {
                        self.searchResultBlock(self.dataModel);
                    }
                }
            } else {
                [SVProgressHUD showInfoWithStatus:model.msg];
            }
        }
    }];
}

@end
