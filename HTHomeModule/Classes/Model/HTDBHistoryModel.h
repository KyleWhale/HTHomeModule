//
//  HTDBHistoryModel.h
//  Hucolla
//
//  Created by mac on 2022/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTDBHistoryModel : NSObject<YYModel>
@property (nonatomic, assign) BOOL var_isSelect;// 是否选中，不参与数据库存储
@property (nonatomic, strong) NSString *var_textPath;// 当前字幕地址，拼接而成，不参与数据库存储
@property (nonatomic, strong) NSString *var_isTV;
@property (nonatomic, strong) NSString *var_mId; // 电影时为电影id，电视时为剧tt_id
@property (nonatomic, strong) NSString *var_cover; // 封面
@property (nonatomic, strong) NSString *var_title; // 电影名/剧名
@property (nonatomic, strong) NSString *var_rate; // 评分
@property (nonatomic, strong) NSString *var_country; // 国家
@property (nonatomic, strong) NSString *var_tags; // 标签
@property (nonatomic, strong) NSString *var_stars; // 演员
@property (nonatomic, strong) NSString *var_desc; // 简介
@property (nonatomic, strong) NSString *var_playLink; // 播放地址
@property (nonatomic, strong) NSString *var_size; // 视频大小
@property (nonatomic, strong) NSString *var_jId; // 电视剧季id,电影时为nil
@property (nonatomic, strong) NSString *var_vId; // 电视剧集id,电影时为nil
@property (nonatomic, strong) NSString *var_seeTime; // 已播放时长
@property (nonatomic, strong) NSString *var_totalTime; // 总时长
@property (nonatomic, strong) NSString *var_lastTime; // 最后一次观看时间
@property (nonatomic, strong) NSString *var_srt; // srt字幕文件名

// 获取所有数据
- (NSArray *)ht_getAllData;
// 插入/更新数据
- (void)ht_insertOrUpDate;
// 更新字幕名
- (void)ht_updateSrt:(NSString *)var_srt;
// 删除某一条数据
- (void)ht_deleteDataWithMID:(NSString *)var_mId;
// 根据 mId获取数据
- (HTDBHistoryModel *)ht_getDataWithMID:(NSString *)var_mId;
// 根据 vId获取数据
- (HTDBHistoryModel *)ht_getDataWithVID:(NSString *)var_vId;



@end

NS_ASSUME_NONNULL_END
