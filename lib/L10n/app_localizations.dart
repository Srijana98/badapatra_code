import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ne')
  ];

  /// No description provided for @serviceTable.
  ///
  /// In en, this message translates to:
  /// **'Ward Service Table'**
  String get serviceTable;

  /// No description provided for @idNo.
  ///
  /// In en, this message translates to:
  /// **'ID No'**
  String get idNo;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @serviceRequirement.
  ///
  /// In en, this message translates to:
  /// **'Service Requirement'**
  String get serviceRequirement;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @serviceBranch.
  ///
  /// In en, this message translates to:
  /// **'Service Branch'**
  String get serviceBranch;

  /// No description provided for @commentSection.
  ///
  /// In en, this message translates to:
  /// **'Comment Section'**
  String get commentSection;

  /// No description provided for @municipalityName.
  ///
  /// In en, this message translates to:
  /// **'Bhanu Municipality'**
  String get municipalityName;

  /// No description provided for @municipalOffice.
  ///
  /// In en, this message translates to:
  /// **'Municipal Executive Office'**
  String get municipalOffice;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Tanahun'**
  String get location;

  /// No description provided for @citizenCharter.
  ///
  /// In en, this message translates to:
  /// **'Citizen Charter'**
  String get citizenCharter;

  /// Title for services search section
  ///
  /// In en, this message translates to:
  /// **'Search Services by ID'**
  String get searchServices;

  /// Instructions for printing and entering number
  ///
  /// In en, this message translates to:
  /// **'Print and enter number'**
  String get printInstructions;

  /// No description provided for @numberHint.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get numberHint;

  /// No description provided for @invalidId.
  ///
  /// In en, this message translates to:
  /// **'Invalid ID'**
  String get invalidId;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @newsLabel.
  ///
  /// In en, this message translates to:
  /// **'News24Nepal:'**
  String get newsLabel;

  /// No description provided for @newsTicker.
  ///
  /// In en, this message translates to:
  /// **'Latest Updates...'**
  String get newsTicker;

  /// No description provided for @homeLabel.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// No description provided for @teamLabel.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamLabel;

  /// No description provided for @contactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactLabel;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Message shown when no data is available
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ne': return AppLocalizationsNe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
