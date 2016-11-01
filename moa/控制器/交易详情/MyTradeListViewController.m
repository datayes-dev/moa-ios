//
//  MyTradeListViewController.m
//  moa
//
//  Created by 鄢彭超 on 2016/11/1.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "MyTradeListViewController.h"
#import "MOATradeInfoAdapter.h"
#import "MOATradeDetailTableViewCell.h"
#import "DYLoadingViewManager.h"
#import <JTCalendar/JTCalendar.h>

@interface MyTradeListViewController () <JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectDateButton;
@property (weak, nonatomic) IBOutlet UITableView *tradeListTableView;
@property (weak, nonatomic) IBOutlet UIView *calendarRootView;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong, nonatomic) NSDate *dateSelected;

@property (strong, nonatomic) MOATradeInfoAdapter *adapter;
@property (strong, nonatomic) NSArray *infoArray;

@end

@implementation MyTradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCalendarView];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupCalendarView
{
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    
    self.dateSelected = [NSDate date];
    
    _calendarMenuView.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView
}

- (void)loadData
{
    self.title = @"消费记录";
    [self addLeftButtonWithImage:[UIImage imageNamed:@"back"] hightLightImage:nil caption:nil];
    
    UINib *nib = [UINib nibWithNibName:@"MOATradeDetailTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tradeListTableView registerNib:nib forCellReuseIdentifier:@"MOATradeDetailTableViewCell"];
    
    WS(weakSelf);
    
    showLoadingAtWindow;
    
    NSString* dateString = [[self dateFormatter] stringFromDate:_dateSelected];
    NSString* beginDateTime = [NSString stringWithFormat:@"%@ 00:00:00", dateString];
    NSString* endDateTime = [NSString stringWithFormat:@"%@ 23:59:59", dateString];
    
    [self.adapter getTradeListInfoWithBeginDate:beginDateTime
                                        endDate:endDateTime
                                          admin:@"zsddft@datayes.com"
                                    ResultBlock:^(id data, NSError *error) {
                                        dismisLoadingFromWindow;
                                        
                                        if (error) {
                                            return ;
                                        }
                                        
                                        weakSelf.infoArray = (NSArray *)data;
                                        
                                        [weakSelf.tradeListTableView reloadData];
                                    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectDateTime:(id)sender {
    if ([self.calendarRootView isHidden]) {
        [self.calendarRootView setHidden:NO];
    }
    else {
        [self.calendarRootView setHidden:YES];
    }
}

- (IBAction)selectPreDateTime:(id)sender {
    if (![self.calendarRootView isHidden]) {
        [self.calendarRootView setHidden:YES];
    }
    
    self.dateSelected = [self preDate];
}

- (IBAction)selectNextDateTime:(id)sender {
    if (![self.calendarRootView isHidden]) {
        [self.calendarRootView setHidden:YES];
    }
    
    self.dateSelected = [self nextDate];
}

- (IBAction)dismissCalendarView:(id)sender {
    [self.calendarRootView setHidden:YES];
}


#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Hide if from another month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    dayView.dotView.hidden = YES;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    self.dateSelected = dayView.date;
    
    // Animation for the circleView
    WS(weakSelf);
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                        [weakSelf.calendarRootView setHidden:YES];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}

- (NSDate*)preDate
{
    NSDate* date = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:_dateSelected];
    return date;
}

- (NSDate*)nextDate
{
    NSDate* date = [NSDate dateWithTimeInterval:60*60*24 sinceDate:_dateSelected];
    return date;
}

- (void)showCurrentDate
{
    NSString* dateString = [[self dateFormatter] stringFromDate:_dateSelected];
    [self.selectDateButton setTitle:[NSString stringWithFormat:@"  %@", dateString] forState:UIControlStateNormal];
}

- (void)setDateSelected:(NSDate *)dateSelected
{
    _dateSelected = dateSelected;
    [_calendarManager setDate:dateSelected];
    [self showCurrentDate];
    [self loadData];
}

- (MOATradeInfoAdapter *)adapter
{
    
    if (_adapter == nil) {
        
        _adapter = [MOATradeInfoAdapter shareInstance];
    }
    return _adapter;
}

- (NSArray *)infoArray
{
    
    if (_infoArray == nil) {
        
        _infoArray = [NSArray array];
    }
    return _infoArray;
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.infoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MOATradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MOATradeDetailTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger count = [self.infoArray count];
    if (indexPath.row < count) {
        
//        DYCellDataItem *item = self.infoArray[count - indexPath.row - 1];
//        
//        cell.hotelName.text = item.hotelName;
//        cell.tradeDate.text = item.timeStamp;
//        cell.cash.text = item.price;
        DingTradeInfoItem *item = self.infoArray[count - indexPath.row - 1];
        
        cell.hotelName.text = item.restaurant_name;
        cell.tradeDate.text = item.time_stamp;
        cell.cash.text = [NSString stringWithFormat:@"%.2f",item.price];
    }
    
    return cell;
}

@end
