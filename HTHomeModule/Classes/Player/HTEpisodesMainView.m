//
//  HTEpisodesMainView.m
//  Hucolla
//
//  Created by mac on 2022/9/23.
//

#import "HTEpisodesMainView.h"
#import "HTEpisodesViewCell.h"
#import "HTEpisodesMainViewManager.h"

@interface HTEpisodesMainView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel        * episodesLab;

@property (nonatomic, strong) UIView         * var_line;
@property (nonatomic, strong) UICollectionView         * var_collectionView;
@property (nonatomic, strong) UIButton       * seasonBtn;
@property (nonatomic, strong) UIButton       * languageBtn;

@end

@implementation HTEpisodesMainView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.episodesLab = [HTEpisodesMainViewManager lgjeropj_episodesLabel];
    [self addSubview:self.episodesLab];
    
    self.seasonBtn = [HTEpisodesMainViewManager lgjeropj_seasonBtn];
    [self addSubview:self.seasonBtn];
    
    self.var_line = [HTEpisodesMainViewManager lgjeropj_line];
    [self addSubview:self.var_line];
    
    self.var_collectionView = [HTEpisodesMainViewManager lgjeropj_colletionView:self];
    [self addSubview:self.var_collectionView];
    
    [self.var_collectionView registerClass:[HTEpisodesViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HTEpisodesViewCell class])];
    
    [self.seasonBtn addTarget:self action:@selector(onSeasonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setContentArray:(NSArray *)contentArray {
    _contentArray = contentArray;
    [self.var_collectionView reloadData];
}

- (void)setCurrentSchedule:(HTTVDetailSeasonModel *)currentSeason {
    _currentSchedule = currentSeason;
    [self.seasonBtn setTitle:currentSeason.title forState:UIControlStateNormal];
    [self.seasonBtn setPosition:3 interval:2];
}

- (void)setCurrentIndex:(HTTVDetailEpsModel *)currentIndex {
    _currentIndex = currentIndex;
    NSInteger index = [currentIndex.eps_num integerValue] - 1;
    [self.var_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HTEpisodesViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTEpisodesViewCell class]) forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"%zd", indexPath.row + 1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HTTVDetailEpsModel *model = self.contentArray[indexPath.row];
    if ( self.exerciseBlock ) {
        self.exerciseBlock(model);
    }
}

- (void)onSeasonAction {
    if ( self.scheduleBlock ) {
        self.scheduleBlock(self.seasonBtn);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.episodesLab.frame = CGRectMake(50, 54, 80, 21);
    self.var_line.frame = CGRectMake(50, CGRectGetMaxY(self.episodesLab.frame) + 15, CGRectGetWidth(self.bounds) - 50, 1);
    
    self.seasonBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 100 - 15, CGRectGetMidY(self.episodesLab.frame) - 14, 100, 28);
    self.var_collectionView.frame = CGRectMake(50, CGRectGetMaxY(self.var_line.frame), CGRectGetWidth(self.bounds) - 50, CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.var_line.frame));
}

@end

