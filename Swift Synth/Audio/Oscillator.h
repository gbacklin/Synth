//
//  Oscillator.h
//  Swift Synth
//
//  Created by Gene Backlin on 6/12/20.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef float (^Signal)(float);

typedef NS_ENUM(NSInteger, Waveform) {
  sine,
  triangle,
  sawtooth,
  square,
  whiteNoise
};

@interface Oscillator : NSObject

@property (class, nonatomic, assign) float amplitude;
@property (class, nonatomic, assign) float frequency;

@property (class, nonatomic, assign) Signal sine;
@property (class, nonatomic, assign) Signal triangle;
@property (class, nonatomic, assign) Signal sawtooth;
@property (class, nonatomic, assign) Signal square;
@property (class, nonatomic, assign) Signal whiteNoise;


@end

NS_ASSUME_NONNULL_END
