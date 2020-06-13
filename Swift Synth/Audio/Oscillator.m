//
//  Oscillator.m
//  Swift Synth
//
//  Created by Gene Backlin on 6/12/20.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import "Oscillator.h"

@interface Oscillator()

@end

@implementation Oscillator

static float _amplitude = 1;
static float _frequency = 440;

static Signal _sine;
static Signal _triangle;
static Signal _sawtooth;
static Signal _square;
static Signal _whiteNoise;

// MARK: - Accessors and modifiers

+ (float)amplitude {
    return _amplitude;
}
+ (void)setAmplitude:(float)newValue {
    _amplitude = newValue;
}

+ (float)frequency {
    return _frequency;
}
+ (void)setFrequency:(float)newValue {
    _frequency = newValue;
}

+ (Signal)sine {
    return sineVal;
}
+ (void)setSine:(Signal)sine {
    _sine = sine;
}

+ (Signal)triangle {
    return triangleVal;
}
+ (void)setTriangle:(Signal)triangle {
    _triangle = triangle;
}

+ (Signal)sawtooth {
    return sawtoothVal;
}
+ (void)setSawtooth:(Signal)sawtooth {
    _sawtooth = sawtooth;
}

+ (Signal)square {
    return squareVal;
}
+ (void)setSquare:(Signal)square {
    _square = square;
}

+ (Signal)whiteNoise {
    return whiteNoiseVal;
}
+ (void)setWhiteNoise:(Signal)whiteNoise {
    _whiteNoise = whiteNoise;
}

// MARK: - Block definition

Signal sineVal = ^(float time) {
    return Oscillator.amplitude * (float)sin(2.0 * M_PI * Oscillator.frequency * time);
};

Signal triangleVal = ^(float time) {
    double period = 1.0 / (double)Oscillator.frequency;
    double currentTime = fmod((double)time, period);
    
    double value = currentTime / period;
    
    double result = 0.0;
    
    if (value < 0.25) {
        result = value * 4;
    }
    else if (value < 0.75) {
        result = 2.0 - (value * 4.0);
    }
    else {
        result = value * 4 - 4.0;
    }
    
    return Oscillator.amplitude * (float)result;
};

Signal sawtoothVal = ^(float time) {
    double period = 1.0 / (double)Oscillator.frequency;
    double currentTime = fmod((double)time, period);

    return Oscillator.amplitude * (float)(((float)currentTime / period) * 2 - 1.0);
};

Signal squareVal = ^(float time) {
    double period = 1.0 / (double)Oscillator.frequency;
    double currentTime = fmod((double)time, period);
    
    return ((currentTime / period) < 0.5) ? Oscillator.amplitude : (float)(-1.0 * Oscillator.amplitude);
};

Signal whiteNoiseVal = ^(float time) {
    int lowerBound = -1;
    int upperBound = 1;

    return Oscillator.amplitude * lowerBound + arc4random() % (upperBound - lowerBound);
};

@end
