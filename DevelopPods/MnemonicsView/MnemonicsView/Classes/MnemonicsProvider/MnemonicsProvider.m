//
//  MnemonicsProvider.m
//
//  Created by Mikhail Nikanorov.
//

#import "MnemonicsProvider.h"

static NSString *const kMnemonicsProviderFileExtension    = @"txt";

@interface MnemonicsProvider ()
@property (nonatomic, strong) NSArray <NSString *> *words;
@end

@implementation MnemonicsProvider

#pragma mark - Lifecycle

- (instancetype)initWithLanguage:(MnemonicsProviderLanguage)language {
  self = [super init];
  if (self) {
    NSString *filename = NSStringFilenameFromMnemonicsProviderLanguage(language);
    if (filename) {
      [self _loadWordsWithFilename:filename];
    }
  }
  return self;
}

#pragma mark - MnemonicsProviderProtocol

- (NSArray <NSString *> *) allWords {
  return self.words;
}

- (NSArray <NSString *> *) wordsWithSearchTerm:(NSString *)term {
  term = [term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
  if ([term length] > 0) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", term];
    return [self.words filteredArrayUsingPredicate:predicate];
  } else {
    return [self allWords];
  }
}

- (BOOL) validateWords:(NSArray <NSString *> *)words {
  NSSet *uniqueWords = [NSSet setWithArray:words];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN[cd] %@", uniqueWords];
  NSArray *filtered = [self.words filteredArrayUsingPredicate:predicate];
  return [filtered count] == [uniqueWords count];
}

#pragma mark - Private

- (void) _loadWordsWithFilename:(NSString *)filename {
  NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:filename withExtension:kMnemonicsProviderFileExtension];
  NSParameterAssert(url);
  NSError *error = nil;
  NSString *wordsContent = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
  if (error) {
    [NSException raise:@"Loading error" format:@"Words loading error: %@", [error localizedDescription]];
    return;
  }
  _words = [wordsContent componentsSeparatedByString:@"\n"];
}

@end
