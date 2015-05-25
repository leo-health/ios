//
//  LEOCardView.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardView.h"
#import "Card.h"
#import "User+Methods.h"
#import <NSDate+DateTools.h>
#import "Role+Methods.h"
#import "UserRole+Methods.h"
#import "UIImage+Extensions.h"
#import "LEOConstants.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@interface LEOCardView ()

@end

@implementation LEOCardView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void)awakeFromNib {
    
    self.iconImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.bodyTextLabel = [[UILabel alloc] init];
    self.buttonView = [[LEOButtonView alloc] init];
    self.primaryUserLabel = [[UILabel alloc] init]; //FIXME: may not belong here given it is not used in every cell...
    
  }

-(void)setupSubviews{
    
    self.titleLabel.font = [UIFont leoTitleBoldFont];
    self.titleLabel.textColor = [UIColor leoWarmHeavyGray];
    self.titleLabel.text = self.card.title;

    self.bodyTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bodyTextLabel.numberOfLines = 0;
    self.bodyTextLabel.font = [UIFont leoBodyBasicFont];
    self.bodyTextLabel.textColor = [UIColor leoWarmHeavyGray];
    
    self.primaryUserLabel.font = [UIFont leoBodyBolderFont];
    self.primaryUserLabel.textColor = [UIColor leoWarmHeavyGray];
    
    
    UIImage *cardIcon = [UIImage imageNamed:@"SMS-32"]; //FIXME: Will need to vary by card activity
    self.titleLabel.text = self.card.title;
    self.bodyTextLabel.text = self.card.body;

    switch (self.card.format) {
            
        case CardFormatTwoButtonSecondaryOnly: {
            
            //self.iconImageView.image = cardIcon;
            self.secondaryUserView = [[LEOSecondaryUserView alloc] initWithCardFormat:self.card.format user:self.card.secondaryUser timestamp:self.card.timestamp];
            [self addSubview:self.secondaryUserView];
            
            break;
        }
            
        case CardFormatTwoButtonPrimaryOnly: {
            
            
            self.primaryUserLabel.text = [self.card.primaryUser.firstName uppercaseString]; //FIXME: Make this capitalized
            [self addSubview:self.primaryUserLabel];

            break;
            
        }
            
        case CardFormatTwoButtonSecondaryAndPrimary: {
            self.primaryUserLabel.text = [self.card.primaryUser.firstName uppercaseString]; //FIXME: Make this capitalized
            self.secondaryUserView = [[LEOSecondaryUserView alloc] initWithCardFormat:self.card.format user:self.card.secondaryUser timestamp:self.card.timestamp];

            [self addSubview:self.primaryUserLabel];
            [self addSubview:self.secondaryUserView];
            break;
            
        }

        default:
            break;
            
    }
    
    self.iconImageView.image = cardIcon;

    self.buttonView = [[LEOButtonView alloc] initWithActivity:self.card.activity state:self.card.state];

    [self addSubview:self.iconImageView];
    [self addSubview:self.bodyTextLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.buttonView];

    
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor leoWhite];
    
}

-(void)updateConstraints {
    

    if (!self.constraintsAlreadyUpdated) {
        
        [self setupSubviews];
        
        [self removeConstraints:self.constraints];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.primaryUserLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.bodyTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.secondaryUserView.translatesAutoresizingMaskIntoConstraints = NO;
        self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        switch (self.card.format) {
            case CardFormatTwoButtonSecondaryOnly: {
                
                NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_titleLabel, _bodyTextLabel, _secondaryUserView, _buttonView, _iconImageView);
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToSecondaryUserView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_secondaryUserView]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_secondaryUserView(==13)][_titleLabel][_bodyTextLabel]-[_buttonView(==25)]-(10)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
                [self.bodyTextLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.bodyTextLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.secondaryUserView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.buttonView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.buttonView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                
                //self.bodyTextLabel.preferredMaxLayoutWidth = self.frame.size.width;
                //self.titleLabel.preferredMaxLayoutWidth = self.frame.size.width;

                [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToSecondaryUserView];
                [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
                [self addConstraints:horizontalLayoutConstraintsForButtonView];
                [self addConstraints:verticalLayoutConstraintsForImage];
                [self addConstraints:verticalLayoutConstraintsForText];
                
                break;
            }
                
            case CardFormatTwoButtonPrimaryOnly: {
                NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _buttonView, _iconImageView);
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToPrimaryUserLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_primaryUserLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_primaryUserLabel][_titleLabel]-(20@1000)-[_bodyTextLabel]-(8@1000)-[_buttonView(==25)]-(10)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
                
                [self.bodyTextLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.bodyTextLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.primaryUserLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.buttonView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self.buttonView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

                
                [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToPrimaryUserLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
                [self addConstraints:horizontalLayoutConstraintsForButtonView];
                [self addConstraints:verticalLayoutConstraintsForImage];
                [self addConstraints:verticalLayoutConstraintsForText];
                
                break;
            }
                
            case CardFormatTwoButtonSecondaryAndPrimary: {
                NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _buttonView, _iconImageView, _secondaryUserView);
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToPrimaryUserLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_primaryUserLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToSecondaryUserView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_secondaryUserView]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                //NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                
                NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_primaryUserLabel][_titleLabel]-(20)-[_bodyTextLabel]-(10)-[_secondaryUserView]-(10)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
                
                [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToPrimaryUserLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToSecondaryUserView];
                [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
                //[self addConstraints:horizontalLayoutConstraintsForButtonView];
                [self addConstraints:verticalLayoutConstraintsForImage];
                [self addConstraints:verticalLayoutConstraintsForText];
                break;
            }
                
            default:
                break;
        }
        
        self.constraintsAlreadyUpdated = YES;
    }
    
    [super updateConstraints];

}

-(void)updateTypefaces {
    
}

-(void)updateColors {
    
}





















@end
