/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  DYInterfaceIdDef.h
//  IntelligenceResearchReport
//
//  Created by datayes on 15/10/21.
//

#ifndef DYInterfaceIdDef_h
#define DYInterfaceIdDef_h

typedef NS_ENUM(NSInteger, EInterfaceId) {
    // ------------------------------------------------资讯页
    eGetAnnouncementsList = 0,                      // 获取公告列表
    eGetAnnouncementsIndustryList,                  // 获取公告的行业列表
    eSetAnnouncementImportant,                      // 设置公告是否重要
    eGetAnnouncementsClassifies,                    // 获取公告类型分类2级列表
    eGetNewsListForChannel,                         // 获取新闻列表
    eGetInfoListForChannel,                         // 原获取新闻列表
    eGetInfoNewsInduList,                           // 获取新闻行业列表
    eGetInfoNewsByClusterId,                        // 获取聚合新闻
    eSetNotInterestingInfo,                         // 用户标记不感兴趣的新闻
    eGetThemeStocksListInfo,                        // 获取题材股票列表
    eGetThemeIndexInfo,                             // 获取题材走势图数据
    eShareAnnouncementComment,                      // 分享并评论公告
    eShareNewsComment,                              // 分享并评论新闻
    
    // ------------------------------------------------股票池
    eGetAllStocksProperty = 100,                    // 增量获取股票列表
    eGetPriceInfoForStock,                          // 股票详情
    eGetTickInfoFreshTime,                          // 股票资讯最近更新时间
    eGetSocialInfoForStock,                         // 股票新闻情绪、社交热点列表
    eGetInfomationAboutStock,                       // 获取与某只股票相关的资讯（新闻、公告、研报）列表
    eGetFinancingInfo,                              // 融资融券明细列表
    eGetTickerBaseInfo,                             // 股票的基本信息：PE(市盈率)，52周最高，52周最低，EPS(每股盈余=盈余/流通在外股数)，流通市值，总市值，是否支持融资融券
    eAppNotUseThis,                                 // 阅读资讯内容(App暂时不用这个接口)
    eGetEarningForecast,                            // 个股盈利预测
    eGetRelatedEarningForecast,                     // 行业相关股票盈利预测
    eGetstockHotSocialInfo,                         // 热度走势
    eGetstockPriceListInfo,                         // 股价走势
    eGetIntelligenceEarningCurveData,               // 智能财报--折线图
    eGetIntelligenceEarningPieData,                 // 智能财报--饼状图
    eUploadMyStocks,                                // 保存自选股
    eDownloadMyStocks,                              // 获取自选股列表
    eGetStocksExponentListInfo,                     // 获取上证综指、深证综指、深证创业板、行业指数
    eGetThemeList,                                  // 获取题材对应股票列表
    eGetCommendDataForTicker,                       // 获取个股推荐数据
    eGetFinancialDataForTicker,                     // 股票池，获取财务数据
    eGetFinancialSearch,                            // 获取财务摘要信息
    eGetStudyDetailChannels,                        // 获取公司研究详情标题顺序
    ePostStudyDetailChannels,                       // 保存公司研究详情标题顺序
    eGetStockGroupList,                             // 获取股票池分组列表
    eCreateStockGroup,                              // 创建股票池分组
    eModifyStockGroup,                              // 修改股票池分组
    eDeleteStockGroup,                              // 删除股票池分组
    eMoveStockGroup,                                // 移动股票池分组

    
    // ------------------------------------------------事件
    eGetAllEventConcernedList = 200,                // 获取事件列表
    eGetEventByID,                                  // 根据事件ID获取事件
    
    eCreateNote,                                    // 创建笔记(老，作废)
    eModifyNote,                                    // 修改笔记（老，作废）
    //笔记新接口
    eNewGetNoteList,                                 // 获取笔记列表
    eNewCreateNote,                                  // 创建笔记
    eNewModifyNote,                                  // 修改笔记
    eNewDeleteNote,                                  // 删除笔记
    
    // ------------------------------------------------搜索
    eGetHotSearchKeywords = 300,                    // 获取热搜关键字列表
    eGetSearchResultByKeyword,                      // 获取搜索结果(新)
    eGetSearchSuggestion,                           // 获取搜索智能提示
    
    eGetUserSearchHistory,                          // 获取用户搜索历史
    eDeleteUserSearchHistory,                          // 删除用户搜索历史(单条)
    eDeleteUserAllSearchHistory,                       // 删除用户搜索历史(全部)
    
    eGetBasicInfoForDataset,                        // 数据详情列表（包括折线图）
    eGetRelativeStock,                              // 相关个股
    eGetRelativeData,                               // 相关数据
    eGetTimeLine,                                   // 分时图
    eGetTradeDetail,                                // 分时图明细
    eGetKLine,                                      // 日K线
    eGetIndicVisual,                                // 获取用户查看数据可视化
    ePostIndicVisual,                               // 保存用户查看数据可视化
    eGetStockHighFrequencyInfo,                     // 获取股票的高频信息
    eGetIndexInfo,                                  // 获取指数的最新信息
    eGetStockBaseInfo,                              // 获取股票的基本信息
    eGetIndexTimeLine,                              // 获取指数的分钟线
    
    // ------------------------------------------------订阅管理
    eDownloadChannels = 400,                        // 我的订阅
    eUploadChannels,                                // 保存订阅
    eGetRecommendChannels,                          // 推荐频道
    eGetRecommendChannelKeywordsByKeyword,          // 自定义搜索
    
    // ------------------------------------------------新的订阅管理
    eGetAllNewsSubscribeRuleList,                   //得到全部订阅列表
    eGetNewsSubscribeRule,                          //根据ID读取新闻订阅规则
    ePostNewsSubscribeRule,                         //创建新闻订阅规则
    eDeleteNewsSubscribeRule,                       //根据ID删除新闻订阅规则
    ePutNewsSubscribeRule,                          //根据ID更新新闻订阅规则
    ePutNewsSubscribeRuleTop,                       //置顶一条新闻订阅规则
    ePostNewsSubscribeRuleMove,                     //订阅管理，移动订阅号
    
    
    
    // ------------------------------------------------我的
    eUploadFavoriteItems= 500,                      // 保存收藏
    eDownloadFavoriteItems,                         // 获取收藏
    eDownloadMyData,                                // 获取我的数据
    eUploadMyData,                                  // 保存我的数据
    eUploadMyEventData,                             // 保存我的事件
    edownloadMyEventData,                           // 获取我的事件
    eUploadDataRelativeStock,                       // 保存数据相关股票
    edownloadDataRelativeStock,                     // 获取数据相关股票
    eDownloadStockRelationData,                     // 获取数据相关股票
    eUploadStockRelationData,                       // 保存数据相关股票
    eGetSyncVersions,                               // 获取同步版本信息
    eUploadSyncData,                                // 保存同步数据
    eDownloadSyncData,                              // 获取同步数据
    
    
    // ------------------------------------------------认证相关
    eAuthLogin = 600,                               // 登录
    eAuthRegister,                                  // 注册
    eAuthRegisterSendValidCode,                     // 注册 发送手机验证码
    eAuthRegisterSendValidCodeWithImage,            // 注册 发送手机验证码（带图片验证码）
    eAuthRegisterValidateCode,                      // 注册 验证用户输入的验证码是否正确
    eAuthAddPicture,                                // 增加头像
    eAuthGetCapthaImage,                            // 获取图形验证码图
    eAuthGetIdentity,                               // 获取身份信息接口
    eAuthResetGetUserInfo,                          // 根据用户名获取该用户的手机或邮箱信息（找回密码）
    eAuthResetGetUserInfoNoImageCode,               // 根据用户名获取该用户的手机或邮箱信息（找回密码, 无图片验证码）
    eAuthResetPassport,                             // 发送手机验证短信或者发送修改密码邮件（找回密码）
    eAuthResetValidation,                           // 验证手机验证码，获取token（找回密码）
    eAuthResetNewPassword,                          // 设置新密码（找回密码）
    eAuthChangePassword,                            // 用户修改密码
    
    // ------------------------------------------------站内信
    eFetchNotifiesList = 700,                       // 查询站内信列表
    eSetReadFlagForNotifies,                        // 标记所有为已读
    eReadNotify,                                    // 阅读某条站内信
    eCleanEmptyNotify,                              // 清空站内信
    eReadFlagForNotify,                             // 标记某条为已读
    eFetchNotifiesLetterList,                       // 新查询站内信列表（个股公告）
    
    // ------------------------------------------------app推送长链
    eFetchAppPushURL = 800,                         // 获取长链
    
    // ------------------------------------------------个股研究
    eFetchTickerProductData = 900,                 // 获取产品数据列表
    eFetchTickerProductNews,                        // 获取产品对应的新闻列表
    
    // ------------------------------------------------CMS相关接口
    eAppHandshake = 1000,                           // app握手
    eAppBind,                                       // 绑定接口
    eAppUnbnind,                                    // 解绑接口
    eGetHelpInfoList,                               // 获取帮助列表
    eGetHelpInfoItem,                               // 获取帮助详情
    eGetAdsList,                                    // 获取广告列表
    eGetFeedBack,                                   // 获取用户反馈
    eAddImageForNote,                               // 为笔记增加图片
    
    // ------------------------------------------------数据中心-我的关注相关接口
    eDataGetGroupList = 1100,                       // 我的关注的分类列表
    eDataGetSlotListInGroup,                        // 某个分类下slot列表（包含indic详细信息）
    eDataCreateSlotWithIndic,                       // 创建slot卡片（单个）
    eDataDeleteSlots,                               // 删除slot卡片（单个or批量）
    eDataMoveSlot,                                  // 调整slot卡片顺序
    
    eDiningGetAllHotelsInfo = 1200,                 // 获取饭店详情
    eDiningGetQRCodeWithPK,                         // 获取二维码
    eDiningTradeRequest,                            // 执行交易
    eDiningGetTradeList,                            // 个人交易流水
};

#endif /* DYInterfaceIdDef_h */
