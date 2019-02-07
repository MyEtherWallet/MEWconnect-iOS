//
//  MnemonicsProviderLanguage.h
//
//  Created by Mikhail Nikanorov.
//

#ifndef MnemonicsProviderLanguage_h
#define MnemonicsProviderLanguage_h

static NSString *const kMnemonicsProviderEnglishFilename            = @"english";
static NSString *const kMnemonicsProviderJapaneseFilename           = @"japanese";
static NSString *const kMnemonicsProviderKoreanFilename             = @"korean";
static NSString *const kMnemonicsProviderSpanishFilename            = @"spanish";
static NSString *const kMnemonicsProviderChineseSimplifiedFilename  = @"chinese_simplified";
static NSString *const kMnemonicsProviderChineseTraditionalFilename = @"chinese_traditional";
static NSString *const kMnemonicsProviderFrenchFilename             = @"french";
static NSString *const kMnemonicsProviderItalianFilename            = @"italian";

typedef NS_ENUM(short, MnemonicsProviderLanguage) {
  MnemonicsProviderLanguageCustom             = -1,
  MnemonicsProviderLanguageEnglish            = 0,
  MnemonicsProviderLanguageJapanese           = 1,
  MnemonicsProviderLanguageKorean             = 2,
  MnemonicsProviderLanguageSpanish            = 3,
  MnemonicsProviderLanguageChineseSimplified  = 4,
  MnemonicsProviderLanguageChineseTraditional = 5,
  MnemonicsProviderLanguageFrench             = 6,
  MnemonicsProviderLanguageItalian            = 7,
};

NS_INLINE NSString *NSStringFilenameFromMnemonicsProviderLanguage(MnemonicsProviderLanguage language) {
  NSString *filename = nil;
  switch (language) {
    case MnemonicsProviderLanguageJapanese:           { filename = kMnemonicsProviderJapaneseFilename; break; }
    case MnemonicsProviderLanguageKorean:             { filename = kMnemonicsProviderKoreanFilename; break; }
    case MnemonicsProviderLanguageSpanish:            { filename = kMnemonicsProviderSpanishFilename; break; }
    case MnemonicsProviderLanguageChineseSimplified:  { filename = kMnemonicsProviderChineseSimplifiedFilename; break; }
    case MnemonicsProviderLanguageChineseTraditional: { filename = kMnemonicsProviderChineseTraditionalFilename; break; }
    case MnemonicsProviderLanguageFrench:             { filename = kMnemonicsProviderFrenchFilename; break; }
    case MnemonicsProviderLanguageItalian:            { filename = kMnemonicsProviderItalianFilename; break; }
    case MnemonicsProviderLanguageCustom:             { filename = nil; break; }
    case MnemonicsProviderLanguageEnglish:
    default:                                          { filename = kMnemonicsProviderEnglishFilename; break; }
  }
  return filename;
}

#endif /* MnemonicsProviderLanguage_h */
