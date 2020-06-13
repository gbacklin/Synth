//
//  Synth.h
//  Swift Synth
//
//  Created by Gene Backlin on 6/12/20.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Oscillator.h"

NS_ASSUME_NONNULL_BEGIN

@interface Synth : NSObject

+ (instancetype)shared;

- (float)volume;
- (void)setVolume:(float)newValue;
- (void)setWaveformTo:(Signal) newValue;

@end

NS_ASSUME_NONNULL_END
