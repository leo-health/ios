//
//  LEODateCell.m
//
//
//  Created by Zachary Drossman on 6/1/15.
//
//

#import "LEODateCell.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

@interface LEODateCell()

@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation LEODateCell

-(void)awakeFromNib {
    
    [self setUnselectedFormat];
}

-(void)setSelected:(BOOL)selected {
    
    super.selected = selected;
    
    if (!selected) {
        [self setUnselectedFormat];
    } else {
        [self setSelectedFormat];
    }
    
    [self layoutIfNeeded];
}

-(void)setSelectable:(BOOL)selectable {
    
    _selectable = selectable;
    
    if (!_selectable) {
        [self setUnselectableFormat];
    } else {
        [self setSelectableFormat];
    }
}

- (void)setUnselectableFormat {
    
    self.userInteractionEnabled = NO;
    self.dateLabel.font = [UIFont leo_appointmentSlotsAndDateFields];
    self.dateLabel.textColor = [UIColor leo_white];
    self.dayOfDateLabel.textColor = [UIColor leo_white];
    self.dayOfDateLabel.font = [UIFont leo_appointmentDayLabelAndTimePeriod];
    
    self.dateLabel.alpha = 0.5;
    self.dayOfDateLabel.alpha = 0.5;
}

- (void)setSelectableFormat {
    
    self.userInteractionEnabled = YES;
    self.dateLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
}

- (void)setUnselectedFormat {
    
    [self.bottomBorder removeFromSuperlayer];
    self.dateLabel.font = [UIFont leo_appointmentSlotsAndDateFields];
    self.dateLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    self.dayOfDateLabel.textColor = [UIColor leo_grayForTitlesAndHeadings];
    self.dayOfDateLabel.font = [UIFont leo_appointmentDayLabelAndTimePeriod];
    
    self.dateLabel.alpha = 1.0;
    self.dayOfDateLabel.alpha = 1.0;
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelectedFormat {

    // Add a bottomBorder.
    [self.layer addSublayer:self.bottomBorder];
    
    self.selectable = YES;
    [self setSelectableFormat];
        
    self.dateLabel.font = [UIFont leo_appointmentSlotsAndDateFields];
    self.dateLabel.textColor = [UIColor leo_white];
    self.dayOfDateLabel.font = [UIFont leo_appointmentDayLabelAndTimePeriod];
    self.dayOfDateLabel.textColor = [UIColor leo_white];
    
    self.dateLabel.alpha = 1.0;
    self.dayOfDateLabel.alpha = 1.0;
    
    self.backgroundColor = [UIColor clearColor];
}

-(CALayer *)bottomBorder {
    
    if (!_bottomBorder) {
        
        _bottomBorder = [CALayer layer];
        _bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - kSelectionLineHeight, self.frame.size.width, kSelectionLineHeight);
        _bottomBorder.backgroundColor = [UIColor leo_white].CGColor;
    }
    
    return _bottomBorder;
    
}

- (NSRange)timeRange {
    
    return NSMakeRange(0,self.dateLabel.text.length - 2);
}

- (NSRange)dayPeriodRange {
    
    return NSMakeRange(self.dateLabel.text.length - 2, 2);
}



@end