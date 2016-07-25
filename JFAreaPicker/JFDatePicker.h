//
//  JFDatePicker.h
//  JFAreaPicker
//
//  Created by 汪继峰 on 16/7/11.
//  Copyright © 2016年 汪继峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFDatePicker;

typedef enum : NSUInteger {
    JFDatePickerContentModeBottom,
    JFDatePickerContentModeCenter,
} JFDatePickerContentMode;

typedef enum : NSUInteger {
    JFDatePickerModeTime,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    JFDatePickerModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    JFDatePickerModeDateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    JFDatePickerModeCountDownTimer, // Displays hour and minute (e.g. 1 | 53)
} JFDatePickerMode;

@protocol JFDatePickerDelegate <NSObject>

- (void)datePicker:(JFDatePicker *)datePicker getSelectedDateString:(NSString *)dateString;

@end

@interface JFDatePicker : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) JFDatePickerContentMode contentMode;
@property (nonatomic, assign) JFDatePickerMode pickerMode;
@property (nonatomic, weak) id<JFDatePickerDelegate> delegate;

- (void)show;

@end
