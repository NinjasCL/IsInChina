// NJSIsInChina.m
// 
// Copyright (c) 2016 Ninjas.cl
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NJSIsInChina.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

// some code obtained
// from
// http://stackoverflow.com/questions/12205539/ios-is-a-user-in-the-united-states

@implementation NJSIsInChina

+ (NSString *) getCountryCode {
    
    CTTelephonyNetworkInfo * netInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier * carrier = [netInfo subscriberCellularProvider];
    
    NSString * code = [carrier isoCountryCode];
    
    return code;
}

+ (BOOL) phoneGotChineseCountryCode {
    
    NSString * code = [self getCountryCode];
    
    // China, Taiwan or Hong Kong will be under Chinese
    // Golden Shield
    
    if ([code isEqualToString:@"cn"] ||
        [code isEqualToString:@"tw"] ||
        [code isEqualToString:@"hk"]) {
    
        return YES;
    }
    
    return NO;
}

+ (BOOL) ipIsLocatedInChina {
    
    NSString * url = [NSString
                      stringWithFormat:@"http://www.geoplugin.net/json.gp"];
    
    
    NSData * locationData = [NSData
                             dataWithContentsOfURL:[NSURL
                                                    URLWithString:url]];
    
    NSError * error;
    
    NSDictionary * json = [NSJSONSerialization
                           JSONObjectWithData:locationData
                           options:NSJSONReadingMutableContainers
                           error:&error];
    
    NSString * code = [json[@"geoplugin_countryCode"] lowercaseString];
    
    if ([code isEqualToString:@"cn"] ||
        [code isEqualToString:@"tw"] ||
        [code isEqualToString:@"hk"]) {
        
        return YES;
    }
    
    return NO;
}

+ (BOOL) checkIfDeviceIsInChina {
    
    BOOL isInChina = [self phoneGotChineseCountryCode];
    
    if (!isInChina) {
        isInChina = [self ipIsLocatedInChina];
    }
    
    return isInChina;
}

+ (BOOL) deviceIsRunningInChina {
    
    static BOOL isInChina;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        isInChina = [self checkIfDeviceIsInChina];
    });
    
    return isInChina;
    
}

@end
