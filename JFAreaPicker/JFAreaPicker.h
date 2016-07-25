//
//  JFAreaPicker.h
//  JFAreaPicker
//
//  Created by 汪继峰 on 16/7/8.
//  Copyright © 2016年 汪继峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFAreaPicker;

typedef enum : NSUInteger {
    JFAreaPickerContentModeBottom,
    JFAreaPickerContentModeCenter,
} JFAreaPickerContentMode;

@protocol JFAreaPickerDelegate <NSObject>

/**
 *  获取选择地区的名称及编码
 *
 *  @param areaPicker   areaPicker对象
 *  @param provinceName 省份名称
 *  @param provinceCode 省份编码
 *  @param cityName     城市名称
 *  @param cityCode     城市编码
 *  @param countryName  乡镇名称
 *  @param countryCode  乡镇编码
 */
- (void)areaPicker:(JFAreaPicker *)areaPicker getProvinceName:(NSString *)provinceName provinceCode:(NSString *)provinceCode cityName:(NSString *)cityName cityCode:(NSString *)cityCode countryName:(NSString *)countryName countryCode:(NSString *)countryCode;

@end

@interface JFAreaPicker : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) JFAreaPickerContentMode contentMode;
@property (nonatomic, weak) id<JFAreaPickerDelegate> delegate;

- (void)show;

@end
