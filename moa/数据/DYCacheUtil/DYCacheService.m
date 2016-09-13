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
//  DYCacheService.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/8/9.
//

#import "DYCacheService.h"

#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0]//根目录

#define CacheFolder @"cache"   //可清除的缓存路径
#define CacheCommonFolder @"cache/common"
#define CacheUserFolder @"cache/user"

#define FileFolder @"file"   //不可清除的缓存路径

@implementation DYCacheService

+ (DYCacheService *)shareInstance
{
    static DYCacheService *instance;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        instance = [[DYCacheService alloc]init];
    });
    return instance;
}


//返回文件夹路径
-(NSString *)getFolder:(DYCacheFolder)cacheFolder AndUserId:(NSString *)userId{
    
    NSString *folderName;
    switch (cacheFolder) {
        case dyCacheNet:{
            folderName = [NSString stringWithFormat:@"%@/%@",CacheCommonFolder,@"net"];
        }
            break;
        case dyCacheDevice:{
            folderName = [NSString stringWithFormat:@"%@/%@",CacheCommonFolder,@"device"];
        }
            break;
        case dyCacheUser:{
            if(!userId||userId.length<=0){
                userId = @"defult";
            }
            folderName = [NSString stringWithFormat:@"%@/%@",CacheUserFolder,userId];
        }
            break;
        case dyFile:{
            folderName = FileFolder;
        }
            break;
        default:{
            folderName = [NSString stringWithFormat:@"%@/%@",CacheCommonFolder,@"device"];
        }
            break;
    }
    
    NSString *folderDirectory = [DocumentsDirectory stringByAppendingPathComponent:folderName];
    return folderDirectory;
}

-(NSString *)getFilePath:(DYCacheFolder)cacheFolder AndUserId:(NSString *)userId FileName:(NSString *)fileName IsNational:(BOOL)national{
    
    NSString *filePath;
    NSString *folderPath=[self getFolder:cacheFolder AndUserId:userId];
    if(national){//国际化
        filePath=[folderPath stringByAppendingPathComponent:fileName];
    }
    else{
        filePath=[folderPath stringByAppendingPathComponent:fileName];
    }
    return filePath;
}


// 将基本对象存入path路径下
-(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType AtPath:(NSString *)path{
    return [DYCacheBaseUtil saveData:object DataType:dataType AtPath:path];
}

// 将基本对象存从path路径下取出
-(id)loadDataAtPath:(NSString *)path DataType:(JMDataTypeEnum)dataType{
    return [DYCacheBaseUtil loadDataAtPath:path DataType:dataType];
}

// 移除path路径
-(BOOL)removeDataAtPath:(NSString *)path{
    return [DYCacheBaseUtil removeDataAtPath:path];
}

// 获取filePath所在文件大小
-(long long)getFileSizeAtPath:(NSString *)filePath{
    return [DYCacheBaseUtil getFileSizeAtPath:filePath];
}

// 获取folderPath所在文件夹大小
-(long long)getFolderSizeAtPath:(NSString *)folderPath{
    return [DYCacheBaseUtil getFolderSizeAtPath:folderPath];
}

// 获取path所在文件的属性（创建日期，大小等）
-(NSDictionary *)getAttributesOfItemAtPath:(NSString *)path{
    return [DYCacheBaseUtil getAttributesOfItemAtPath:path];
}



// 存缓存
-(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType FolderPath:(DYCacheFolder)cacheFolder UserId:(NSString *)userId FileName:(NSString *)fileName IsNational:(BOOL)national{

    NSString *filePath = [self getFilePath:cacheFolder AndUserId:userId FileName:fileName IsNational:national];
    return [DYCacheBaseUtil saveData:object DataType:dataType AtPath:filePath];
}

// 读缓存
-(id)loadDataWithDataType:(JMDataTypeEnum)dataType FolderPath:(DYCacheFolder)cacheFolder UserId:(NSString *)userId FileName:(NSString *)fileName IsNational:(BOOL)national{
    
    NSString *filePath = [self getFilePath:cacheFolder AndUserId:userId FileName:fileName IsNational:national];
    return [DYCacheBaseUtil loadDataAtPath:filePath DataType:dataType];
}

@end
