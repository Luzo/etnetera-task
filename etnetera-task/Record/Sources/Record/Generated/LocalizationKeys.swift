// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum LocalizationKeys {
  internal enum AddRecord {
    internal enum ActivityName {
      internal enum Textfield {
        /// Activity Name
        internal static let placeholder = LocalizationKeys.tr("Localizable", "addRecord.activityName.textfield.placeholder", fallback: "Activity Name")
      }
    }
    internal enum Duration {
      internal enum Hours {
        /// Hours
        internal static let label = LocalizationKeys.tr("Localizable", "addRecord.duration.hours.label", fallback: "Hours")
      }
      internal enum Minutes {
        /// Minutes
        internal static let label = LocalizationKeys.tr("Localizable", "addRecord.duration.minutes.label", fallback: "Minutes")
      }
      internal enum Seconds {
        /// Seconds
        internal static let label = LocalizationKeys.tr("Localizable", "addRecord.duration.seconds.label", fallback: "Seconds")
      }
      internal enum Section {
        /// Duration
        internal static let title = LocalizationKeys.tr("Localizable", "addRecord.duration.section.title", fallback: "Duration")
      }
    }
    internal enum Error {
      /// Error ocurred try to save again
      internal static let server = LocalizationKeys.tr("Localizable", "addRecord.error.server", fallback: "Error ocurred try to save again")
      /// Some fields are invalid or left unfilled
      internal static let validation = LocalizationKeys.tr("Localizable", "addRecord.error.validation", fallback: "Some fields are invalid or left unfilled")
    }
    internal enum Location {
      internal enum Textfield {
        /// Location
        internal static let placeholder = LocalizationKeys.tr("Localizable", "addRecord.location.textfield.placeholder", fallback: "Location")
      }
    }
    internal enum Navigation {
      /// Add Record
      internal static let title = LocalizationKeys.tr("Localizable", "addRecord.navigation.title", fallback: "Add Record")
    }
    internal enum RecordDetails {
      internal enum Section {
        /// Record Details
        internal static let title = LocalizationKeys.tr("Localizable", "addRecord.recordDetails.section.title", fallback: "Record Details")
      }
    }
    internal enum SaveRecord {
      internal enum Button {
        /// Save Record
        internal static let title = LocalizationKeys.tr("Localizable", "addRecord.saveRecord.button.title", fallback: "Save Record")
      }
    }
    internal enum Storage {
      internal enum Section {
        /// Storage
        internal static let title = LocalizationKeys.tr("Localizable", "addRecord.storage.section.title", fallback: "Storage")
      }
    }
    internal enum StorageType {
      internal enum Picker {
        /// Storage Type
        internal static let title = LocalizationKeys.tr("Localizable", "addRecord.storageType.picker.title", fallback: "Storage Type")
      }
    }
  }
  internal enum Record {
    internal enum FilterType {
      /// All
      internal static let all = LocalizationKeys.tr("Localizable", "record.filterType.all", fallback: "All")
      /// Local
      internal static let local = LocalizationKeys.tr("Localizable", "record.filterType.local", fallback: "Local")
      /// Remote
      internal static let remote = LocalizationKeys.tr("Localizable", "record.filterType.remote", fallback: "Remote")
    }
    internal enum StorageType {
      /// Localizable.strings
      ///   Record
      /// 
      ///   Created by Lubos Lehota on 29/07/2025.
      internal static let local = LocalizationKeys.tr("Localizable", "record.storageType.local", fallback: "Local Storage")
      /// Remote Storage
      internal static let remote = LocalizationKeys.tr("Localizable", "record.storageType.remote", fallback: "Remote Storage")
    }
  }
  internal enum RecordList {
    /// Error ocurred try to reload
    internal static let error = LocalizationKeys.tr("Localizable", "recordList.error", fallback: "Error ocurred try to reload")
    /// Loading records...
    internal static let loading = LocalizationKeys.tr("Localizable", "recordList.loading", fallback: "Loading records...")
    internal enum Filter {
      internal enum Picker {
        /// Filter
        internal static let title = LocalizationKeys.tr("Localizable", "recordList.filter.picker.title", fallback: "Filter")
      }
    }
    internal enum Navigation {
      /// Activity Records
      internal static let title = LocalizationKeys.tr("Localizable", "recordList.navigation.title", fallback: "Activity Records")
    }
    internal enum No {
      internal enum Network {
        /// It appears that you are disconnected.
        internal static let error = LocalizationKeys.tr("Localizable", "recordList.no.network.error", fallback: "It appears that you are disconnected.")
      }
      internal enum Records {
        /// No records found
        internal static let found = LocalizationKeys.tr("Localizable", "recordList.no.records.found", fallback: "No records found")
      }
    }
    internal enum Toolbar {
      internal enum Button {
        /// Add Record
        internal static let add = LocalizationKeys.tr("Localizable", "recordList.toolbar.button.add", fallback: "Add Record")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension LocalizationKeys {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
