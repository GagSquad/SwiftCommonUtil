//
//  DateUtils.swift
//  CommonUtil
//
//  Created by lijunjie on 15/11/9.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation

public class DateUtil {
    public let kNSDateHelperFormatFullDateWithTime    = "MMM d, yyyy h:mm a";
    public let kNSDateHelperFormatFullDate            = "MMM d, yyyy";
    public let kNSDateHelperFormatShortDateWithTime   = "MMM d h:mm a";
    public let kNSDateHelperFormatShortDate           = "MMM d";
    public let kNSDateHelperFormatWeekday             = "EEEE";
    public let kNSDateHelperFormatWeekdayWithTime     = "EEEE h:mm a";
    public let kNSDateHelperFormatTime                = "h:mm a";
    public let kNSDateHelperFormatTimeWithPrefix      = "'at' h:mm a";
    public let kNSDateHelperFormatSQLDate             = "yyyy-MM-dd";
    public let kNSDateHelperFormatSQLTime             = "HH:mm:ss";
    public let kNSDateHelperFormatSQLDateWithTime     = "yyyy-MM-dd HH:mm:ss";
    class func share() -> DateUtil {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DateUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DateUtil()
        }
        return Static.instance!
    }
    
    public func sharedCalendar() -> NSCalendar {
        let res = NSCalendar.currentCalendar();
        res.timeZone = NSTimeZone.systemTimeZone();
        res.firstWeekday = 2;
        return res;
    }
    
    public func sharedDateFormatter() -> NSDateFormatter {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NSDateFormatter? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NSDateFormatter()
        }
        return Static.instance!
    }
    
    public func detailTimeAgoString(date: NSDate) -> String {
        let timeNow = date.timeIntervalSince1970;
        let calendar = self.sharedCalendar();
        let unitFlags = NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue | NSCalendarUnit.Year.rawValue | NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Second.rawValue | NSCalendarUnit.WeekOfYear.rawValue | NSCalendarUnit.Weekday.rawValue;
        var component = calendar.components(NSCalendarUnit(rawValue: unitFlags), fromDate: date);
        let year = component.year;
        let month = component.month;
        let day = component.day;
        let today = NSDate();
        component = calendar.components(NSCalendarUnit(rawValue: unitFlags), fromDate: today);
        
        let t_year = component.year;
        
        var string: String;
        
        let now = today.timeIntervalSince1970;
        let distance = now - timeNow;
        if distance < 60 {
            string = "刚刚";
        } else if distance < 60*60 {
            string = String(format: "%lld分钟前", distance/60);
        } else if distance < 60*60*24 {
            string = String(format: "%lld小时前", distance/60/60);
        } else if distance < 60*60*24*7 {
            string = String(format: "%lld天前", distance/60/60/24);
        } else if year == t_year {
            string = String(format: "%ld月%ld日", month, day);
        } else {
            string = String(format: "%ld年%ld月%ld日", year, month, day);
        }
        return string
    }
    
    public func detailTimeAgoStringByInterval(timeInterval: NSTimeInterval) -> String {
        return self.detailTimeAgoString(self.dateFromTimeInterval(timeInterval));
    }
    
    public func daysAgoFromNow(date: NSDate) -> Int {
        let calendar = self.sharedCalendar();
        let components = calendar.components(NSCalendarUnit.Day, fromDate: date, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0));
        return components.day
    }
    
    public func daysAgoAgainstMidnight(date: NSDate) -> Int {
        let mdf = self.sharedDateFormatter();
        mdf.dateFormat = kNSDateHelperFormatSQLDate
        let midnight = mdf.dateFromString(mdf.stringFromDate(date));
        return Int((midnight?.timeIntervalSinceNow)! / (-60 * 60 * 24))
    }
    
    public func stringDaysAgoAgainstMidnight(flag: Bool, withDate date:NSDate ) -> String {
        let daysAgo: Int = flag ? self.daysAgoAgainstMidnight(date) : self.daysAgoFromNow(date);
        var text: String;
        switch daysAgo {
        case 0:
            text = "今天";
        case 1:
            text = "昨天"
        default:
            text = String(format: "%lu天前", daysAgo);
        }
        return text;
    }
  
    public func stringDaysAgo(date:NSDate) -> String {
        return self.stringDaysAgoAgainstMidnight(true, withDate: date);
    }
    
    /*
     * iOS中规定的就是周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7，
     * 无法通过某个设置改变这个事实的，只能在使用的时候注意一下这个规则了。
     */
    public func weekDay(date: NSDate) -> Int {
        let weekdayComponents = self.sharedCalendar().components(NSCalendarUnit.Weekday, fromDate: date);
        var wDay = weekdayComponents.weekday;
        if wDay == 1 {
            wDay = 7;
        } else {
            wDay -= 1
        }
        return wDay;
    }
    
    public func weekDayString(date: NSDate) -> String {
        let weekNameDict = [
            1 : "一",
            2 : "二",
            3 : "三",
            4 : "四",
            5 : "五",
            6 : "六",
            7 : "日"
        ];
        let weekName = weekNameDict[self.weekDay(date)];
        return String(format: "星期%@", weekName!);
    }

    
    public func weekNumberString(date: NSDate) -> String {
        return String(format: "第%lu周", self.weekNumber(date));
    }

    public func weekNumber(date: NSDate) -> Int {
        let calendar = self.sharedCalendar();
        let dateComponents = calendar.components(NSCalendarUnit.WeekOfYear, fromDate: date);
        return dateComponents.weekOfYear;
    }
    
    public func hour(date: NSDate) -> Int {
        let calendar = self.sharedCalendar();
        let dateComponents = calendar.components(NSCalendarUnit.Hour, fromDate: date);
        return dateComponents.hour;
    }
    
    public func minute(date: NSDate) -> Int {
        let calendar = self.sharedCalendar();
        let dateComponents = calendar.components(NSCalendarUnit.Minute, fromDate: date);
        return dateComponents.minute;
    }
    
    public func year(date: NSDate) -> Int {
        let calendar = self.sharedCalendar();
        let dateComponents = calendar.components(NSCalendarUnit.Year, fromDate: date);
        return dateComponents.year;
    }
    
    public func month(date: NSDate) -> Int {
        let calendar = self.sharedCalendar();
        let dateComponents = calendar.components(NSCalendarUnit.Month, fromDate: date);
        return dateComponents.month;
    }
    
    public func day(date: NSDate) -> Int {
        let calendar = self.sharedCalendar();
        let dateComponents = calendar.components(NSCalendarUnit.Day, fromDate: date);
        return dateComponents.day;
    }
    
    public func dateFromTimeInterval(timeInterval: NSTimeInterval) -> NSDate {
        return NSDate(timeIntervalSince1970: timeInterval);
    }
    
    public func dateFromString(string: String) -> NSDate {
        return self.dateFromString(string, withFormat: kNSDateHelperFormatSQLDate)
    }
    
    public func dateTimeFromString(string: String) -> NSDate {
        return self.dateFromString(string, withFormat:kNSDateHelperFormatSQLDateWithTime)
    }
    
    public func dateFromString(string: String, withFormat format: String) -> NSDate {
        let formatter = self.sharedDateFormatter();
        formatter.dateFormat = format;
        return formatter.dateFromString(string)!;
    }
    
    public func stringFromDate(date: NSDate, withFormat format: String) -> String {
        let formatter = self.sharedDateFormatter();
        formatter.dateFormat = format;
        return self.sharedDateFormatter().stringFromDate(date);
    }
    
    public func stringFromDate(date: NSDate) -> String {
        return self.stringFromDate(date, withFormat: kNSDateHelperFormatSQLDateWithTime);
    }
    
    public func stringWithDateStyle(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle, withDate date: NSDate) -> String {
        let formatter = self.sharedDateFormatter();
        formatter.dateStyle = dateStyle;
        formatter.timeStyle = timeStyle;
        return formatter.stringFromDate(date);
    }
    
    public func beginningOfWeek(date: NSDate) -> NSDate {
        let calendar = self.sharedCalendar();
        var beginningOfWeek: NSDate? = nil;
        let ok = calendar.rangeOfUnit(NSCalendarUnit.WeekOfYear, startDate: &beginningOfWeek, interval: nil, forDate: date);
        if ok {
            return beginningOfWeek!;
        }
        let weekdayComponents = calendar.components(NSCalendarUnit.Weekday, fromDate: date)
        let componentsToSubtract = NSDateComponents();
        componentsToSubtract.day = -(weekdayComponents.weekday - 1);
        beginningOfWeek = nil;
        beginningOfWeek = calendar.dateByAddingComponents(componentsToSubtract, toDate: date, options: NSCalendarOptions(rawValue: 0));
        let components = calendar.components(NSCalendarUnit(rawValue: NSCalendarUnit.Year.rawValue | NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue), fromDate: beginningOfWeek!);
        return calendar.dateFromComponents(components)!;
        
    }
    
    public func beginningOfDay(date: NSDate) -> NSDate {
        let calendar = self.sharedCalendar();
        let components = calendar.components(NSCalendarUnit(rawValue: NSCalendarUnit.Year.rawValue | NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue), fromDate: date)
        return calendar.dateFromComponents(components)!;
    }
    
    public func endOfWeek(date: NSDate) -> NSDate {
        let calendar = self.sharedCalendar();
        let weekdayComponents = calendar.components(NSCalendarUnit(rawValue: NSCalendarUnit.Weekday.rawValue), fromDate: date);
        let componentsToAdd = NSDateComponents();
        componentsToAdd.day = 7 - weekdayComponents.weekday;
        return calendar.dateByAddingComponents(componentsToAdd, toDate: date, options: NSCalendarOptions(rawValue: 0))!;
        
    }
    
    public func dateFormatString() -> String {
        return kNSDateHelperFormatSQLDate
    }
    
//
//    + (NSString *)dateFormatString
//    {
//    return kNSDateHelperFormatSQLDate;
//    }
//    
//    + (NSString *)timeFormatString
//    {
//    return kNSDateHelperFormatSQLTime;
//    }
//    
//    + (NSString *)timestampFormatString
//    {
//    return kNSDateHelperFormatSQLDateWithTime;
//    }
//    
//    + (NSString *)dbFormatString
//    {
//    return kNSDateHelperFormatSQLDateWithTime;
//    }
    
    public func birthdayToAge(date: NSDate) -> String {
        let calendar = self.sharedCalendar();
        let components = calendar.components(NSCalendarUnit(rawValue: NSCalendarUnit.Year.rawValue | NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue), fromDate: date, toDate: NSDate(), options:NSCalendarOptions(rawValue: 0));
        if components.year > 0 {
            return String(format:"%ld岁", components.year)
        } else if components.month > 0 {
            return String(format:"%ld个月%ld天" , components.month, components.day);
        } else {
            return String(format: "%ld天", components.day);
        }
        
    }
    
    public func birthdayToAgeByTimeInterval(date: NSTimeInterval) -> String {
        return self.birthdayToAge(self.dateFromTimeInterval(date));
    }
    
    public func dateToConstellation(date: NSDate) -> String? {
        let day = self.day(date);
        let month = self.month(date);
        if day == NSNotFound || month == NSNotFound {
            return nil;
        }
        
        let constellations = [
            "水瓶座", "双鱼座", "白羊座", "金牛座", "双子座", "巨蟹座",
            "狮子座", "处女座", "天秤座", "天蝎座", "射手座", "摩羯座"
        ];
        var res: String? = nil;
        
        if day <= 22 {
            if month != 1 {
                res = constellations[month - 2];
            } else {
                res = constellations[11];
            }
        } else {
            res = constellations[month - 1];
        }
        return res;
    }
    
    public func dateToConstellationByTimeInterval(date: NSTimeInterval) -> String {
        return self.dateToConstellation(self.dateFromTimeInterval(date))!;
    }
    
}

public let SharedDateUtil: DateUtil = DateUtil.share();
