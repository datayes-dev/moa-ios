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


@end
