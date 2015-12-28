//
//  GNZSegment.h
//  Pods
//
//  Created by Chris Gonzales on 11/19/15.
//
//

#import <Foundation/Foundation.h>

@protocol GNZSegment <NSObject>

- (NSUInteger)selectedSegmentIndex;
- (void)setSelectedSegmentIndex:(NSUInteger)index;
- (NSUInteger)numberOfSegments;

@optional
- (void)adjustIndicatorForScroll:(UIScrollView *)scrollView;

@end
