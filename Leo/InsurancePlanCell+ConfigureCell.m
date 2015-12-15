//
//  InsurerCell+ConfigureCell.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "InsurancePlanCell+ConfigureCell.h"
#import "InsurancePlan.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@implementation InsurancePlanCell (ConfigureCell)

- (void)configureForPlan:(InsurancePlan *)plan {
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;
    style.lineBreakMode = NSLineBreakByWordWrapping; //TODO: May want to do some sort of resizing of the text here such that we don't end up wrapping ever.
    
    UIFont *font1 = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    UIFont *font2 = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    
    UIColor *color1 = [UIColor leo_grayForTitlesAndHeadings];
    UIColor *color2 = [UIColor leo_grayStandard];
    
    NSDictionary *attributedDictionary1 = @{NSForegroundColorAttributeName:color1,
                                            NSFontAttributeName:font1,
                                            NSParagraphStyleAttributeName:style};
    
    NSDictionary *attributedDictionary2 = @{NSForegroundColorAttributeName:color2,
                                            NSFontAttributeName:font2,
                                            NSParagraphStyleAttributeName:style};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", plan.insurerName]
                                                                       attributes:attributedDictionary1]];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:plan.name
                                                                       attributes:attributedDictionary2]];
    
    self.insurancePlanLabel.attributedText = attrString;
}

@end
