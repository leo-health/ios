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
    
  }

-(void)setupSubviews{
    
    self.iconImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.bodyTextLabel = [[UILabel alloc] init];
    self.buttonView = [[LEOButtonView alloc] init];
    self.primaryUserLabel = [[UILabel alloc] init];
    
    self.titleLabel.font = [UIFont leoTitleBoldFont];
    self.titleLabel.textColor = [UIColor leoWarmHeavyGray];
    
    self.bodyTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bodyTextLabel.numberOfLines = 0;
    self.bodyTextLabel.font = [UIFont leoBodyBasicFont];
    self.bodyTextLabel.textColor = [UIColor leoWarmHeavyGray];
    
    self.primaryUserLabel.font = [UIFont leoBodyBolderFont];
    self.primaryUserLabel.textColor = [UIColor leoWarmHeavyGray];
    
    [self addSubview:self.primaryUserLabel];
    [self addSubview:self.secondaryUserView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.bodyTextLabel];
    [self addSubview:self.titleLabel];
    //[self addSubview:self.buttonView];

    UIImage *cardIcon = [UIImage imageNamed:@"SMS-32"];

    self.titleLabel.text = self.card.title;
    self.bodyTextLabel.text = self.card.body;
    self.bodyTextLabel.text = self.card.body;

    self.primaryUserLabel.text = [self.card.primaryUser.firstName uppercaseString];

    switch (self.card.format) {
        case CardFormatTwoButtonSecondaryOnly: {
            
            self.secondaryUserView = [[UILabel alloc] init]; //[LEOSecondaryUserView alloc] initWithCardActivity:card.ac user:<#(nonnull User *)#> timestamp:<#(nonnull NSDate *)#>
            
        }
        case CardFormatTwoButtonPrimaryOnly: {
            self.iconImageView.image = cardIcon;
            self.titleLabel.text = self.card.title;
            break;
            
        }
            
        case CardActivityVisit: {
            self.iconImageView.image = cardIcon;
            self.primaryUserLabel.text = [self.card.primaryUser.firstName uppercaseString]; //FIXME: Make this capitalized
            self.titleLabel.text = self.card.title;
            self.bodyTextLabel.text = self.card.body;
            break;
            
        }

        default:
            break;
            
    }
    
    self.iconImageView.image = cardIcon;
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
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToSecondaryUserView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_secondaryUserView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                //NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_secondaryUserView][_titleLabel]-(20)-[_bodyTextLabel]-(10)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
                
                [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToSecondaryUserView];
                [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
                //[self addConstraints:horizontalLayoutConstraintsForButtonView];
                [self addConstraints:verticalLayoutConstraintsForImage];
                [self addConstraints:verticalLayoutConstraintsForText];
                
                break;
            }
                
            case CardFormatTwoButtonPrimaryOnly: {
                NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_primaryUserLabel, _titleLabel, _bodyTextLabel, _buttonView, _iconImageView);
                
                NSArray *horizontalLayoutConstraintsForIconToTitleLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView(==32)]-(15)-[_titleLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToPrimaryUserLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_primaryUserLabel]" options:0 metrics:nil views:viewsDictionary];
                NSArray *horizontalLayoutConstraintsForIconToBodyText = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_iconImageView]-(15)-[_bodyTextLabel]-(40)-|" options:0 metrics:nil views:viewsDictionary];
                //NSArray *horizontalLayoutConstraintsForButtonView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForText = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_primaryUserLabel][_titleLabel]-(20)-[_bodyTextLabel]-(10)-|" options:0 metrics:nil views:viewsDictionary];
                NSArray *verticalLayoutConstraintsForImage = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_iconImageView]" options:0 metrics:nil views:viewsDictionary];
                
                [self addConstraints:horizontalLayoutConstraintsForIconToTitleLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToPrimaryUserLabel];
                [self addConstraints:horizontalLayoutConstraintsForIconToBodyText];
                //[self addConstraints:horizontalLayoutConstraintsForButtonView];
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

- (void)resetConstraints {
    
    
    self.constraintsAlreadyUpdated = NO;
    [self setNeedsUpdateConstraints];
}























@end
