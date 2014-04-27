//
//  PlatformKitTests.m
//  PlatformKitTests
//
//  Created by Thong Nguyen on 10/04/2013.
//  Copyright (c) 2013 Thong Nguyen. All rights reserved.
//

#import "PlatformKitTests.h"

@implementation PlatformKitTests

-(void) setUp
{
    [super setUp];
}

-(void) tearDown
{
    [super tearDown];
}

-(void) testMd5hexString
{
    XCTAssertTrue([[@"Hello World!" md5HexString] isEqualToString:@"ed076287532e86365e841e92bfc50d8c"], @"MD5 creation failed");
}

-(void) testSha1HexString
{
    XCTAssertTrue([[@"Hello World!" sha1HexString] isEqualToString:@"2ef7bde608ce5404e97d5f042f95f89f1c232871"], @"SHA1 creation failed");
}

-(void) testMd5Data
{
    [@"Hello World!" md5Data];
}

-(void) testSha1Data
{
    [@"Hello World!" sha1Data];
}

@end
