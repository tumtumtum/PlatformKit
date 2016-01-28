//
//  PKDictionarySerializable.h
//  PlatformKit
//
//  Created by Thong Nguyen on 09/07/2014.
//  Copyright (c) 2014 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PKDictionarySerializable<NSObject>
-(id) initWithPropertyDictionary:(NSDictionary*)dictionary;
-(NSDictionary*) allPropertiesAsDictionary;
@end
