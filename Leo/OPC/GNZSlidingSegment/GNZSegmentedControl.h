//
//  GNZSegmentControl.h
//  Pods
//
//  Created by Chris Gonzales on 11/17/15.
//
//

#import <UIKit/UIKit.h>
#import "GNZSegment.h"


NS_ASSUME_NONNULL_BEGIN
extern NSString * const GNZSegmentOptionControlBackgroundColor;
extern NSString * const GNZSegmentOptionSelectedSegmentTintColor;
extern NSString * const GNZSegmentOptionDefaultSegmentTintColor;
extern NSString * const GNZSegmentOptionIndicatorColor;
extern NSString * const GNZSegmentOptionDefaultSegmentFont;
extern NSString * const GNZSegmentOptionSelectedSegmentFont;

typedef NS_ENUM(NSUInteger, GNZIndicatorStyle) {
    GNZIndicatorStyleDefault,
    GNZIndicatorStyleElevator,
    GNZIndicatorStyleCustom
};

typedef void(^CustomIndicatorAnimatorBlock)(UIScrollView *scrollView);

@interface GNZSegmentedControl : UIControl <GNZSegment>

@property (nonatomic) UIFont *font;
@property (nonatomic) CGFloat controlHeight;
@property (nonatomic) CGFloat segmentDistance;
@property (strong, nonatomic) CustomIndicatorAnimatorBlock customIndicatorAnimatorBlock;

+ (instancetype)new __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)init __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("use initWithSegmentCount:options:")));
- (instancetype)initWithSegmentCount:(NSUInteger)count indicatorStyle:(GNZIndicatorStyle)style options:(NSDictionary<NSString *, UIColor *> *)segmentOptions;

- (void)setTitle:(NSString*)title forSegmentAtIndex:(NSUInteger)segment;
- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (void)setTitle:(nullable NSString *)title andImage:(nullable UIImage *)image withSpacing:(CGFloat)spacing forSegmentAtIndex:(NSUInteger)segment;
- (void)adjustIndicatorForScroll:(UIScrollView *)scrollView;

- (CGRect)selectedSegmentFrame;
- (CGRect)selectedSegmentFrameAdjustedForSpacing;

//- (void)segmentChanged:(UIButton *)sender;

@end
NS_ASSUME_NONNULL_END
