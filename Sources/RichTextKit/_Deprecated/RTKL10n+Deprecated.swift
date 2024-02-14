import Foundation

@available(*, deprecated, message: "Use .module instead")
public extension RTKL10n {

    /**
     The bundle to use to retrieve localized strings.

     You should only override this value when the entire set
     of localized texts should be loaded from another bundle.
     */
    static var bundle: Bundle = .module
}
