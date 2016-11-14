//
//  MOAPayDataSourceBase.h
//  moa
//
//  Created by liangkai.zheng on 16/9/13.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYDataSourceBase.h"

@interface MOAPayDataSourceBase : DYDataSourceBase

/**
 *	@brief	获取对象实例
 *
 *	@return	返回对象实例
 */
+ (instancetype)shareInstance;

/**
 *	@brief	获取所有的饭店信息
 *
 *	@param 	resultBlock 	结果回调
 */
- (void)getAllHotelsWithResultBlock:(DYInterfaceResultBlock)resultBlock;


/**
 *	@brief	 获取饭店详情
 *
 *	@param 	hotelID 	饭店ID
 *	@param 	resultBlock 	结果回调
 */
- (void)getHotelsWithID:(NSString *)hotelID andResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	获取饭店二维码
 *
 *	@param 	pkId 	饭店id
 *	@param 	resultBlock 	结果回调
 */
- (void)getHotelQRCodeWithId:(NSString*)pkId andResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	交易
 *
 *	@param 	price 	价格
 *	@param 	pkId 	饭店id
 *	@param 	memoInfo 	备注信息
 *	@param 	resultBlock 	结果回调
 */
- (void)diningTradeWithPrice:(float)price inHotel:(NSString*)pkId andMemoInfo:(NSString*)memoInfo andResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	获取个人交易流水
 *
 *	@param 	resultBlock 	结果回调
 */
- (void)getTradeListInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock;

#pragma mark - 新街口
//获取交易流水
- (void)getTradeListInfoWithBeginDate:(NSString *)beginDate
                              endDate:(NSString *)endDate
                                admin:(NSString *)admin
                          ResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	获取最新的交易流水（只有10条）
 *
 *	@param 	beginDate 	起始日期
 *	@param 	endDate 	结束日期
 *	@param 	resultBlock 	结果回调
 */
- (void)getLatestTradeListInfoWithBeginDate:(NSString *)beginDate
                                    endDate:(NSString *)endDate
                                ResultBlock:(DYInterfaceResultBlock)resultBlock;

//执行交易
- (void)addTransWithRestaurant:(NSString *)restaurant
                      QRString:(NSString *)qrStr
                   ResultBlock:(DYInterfaceResultBlock)resultBlock;


//获取个人付款二维码
- (void)getUserPayQRWithResultBlock:(DYInterfaceResultBlock)resultBlock;

#pragma mark - weixin APIs

/**
 *	@brief	获取access_token
 *
 *	@param 	resultBlock 	返回access_token
 */
- (void)fetchAccessTokenWithGorpId:(NSString*)corpId andSecrect:(NSString*)secrect andResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	消耗二维码
 *
 *	@param 	coddString 	二维码
 *	@param 	resultBlock 	结果回调
 */
- (void)consumeQRCode:(NSString*)coddString andAccessToken:(NSString*)accessToken andResultBlock:(DYInterfaceResultBlock)resultBlock;
@end
