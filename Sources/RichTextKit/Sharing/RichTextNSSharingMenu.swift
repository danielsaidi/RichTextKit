//
//  RichTextNSSharingMenu.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-12-19.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This macOS-specific share menu can be used to trigger share
 actions for a list of ``RichTextDataFormat`` values.

 The menu will iterate over a set of `NSSharingService`s for
 every provided format. When the user then selects a service
 for a certain format, the `formatAction` function is called,
 in which you should then generate a share file, then return
 the url to the file so that the service can share it.

 If the url action returns `nil` instead of a valid url, the
 menu will abort the share operation.
 */
public struct RichTextNSSharingMenu: View {

    #if os(macOS)
    public init(
        title: String = RTKL10n.menuShareAs.text,
        icon: Image = .richTextActionShare,
        formats: [RichTextDataFormat] = RichTextDataFormat.libraryFormats,
        formatAction: @escaping (RichTextDataFormat) -> URL?,
        pdfAction: (() -> URL?)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.formats = formats
        self.formatAction = formatAction
        self.pdfAction = pdfAction
    }

    private let title: String
    private let icon: Image
    private let formats: [RichTextDataFormat]
    private let formatAction: (RichTextDataFormat) -> URL?
    private let pdfAction: (() -> URL?)?

    public var body: some View {
        Menu {
            ForEach(formats) { format in
                serviceMenu(
                    title: format.fileFormatText,
                    icon: icon,
                    serviceAction: { shareFormat(format, with: $0) }
                )
            }
            if pdfAction != nil {
                serviceMenu(
                    title: RTKL10n.fileFormatPdf.text,
                    icon: icon,
                    serviceAction: sharePdf
                )
            }
        } label: {
            Label(title, icon)
        }
    }
    #else
    public var body: some View {
        Text("RichTextNSSharingMenu is only available on macOS")
    }
    #endif
}

#if os(macOS)
private extension RichTextNSSharingMenu {

    var services: [NSSharingService] {
        NSSharingService.sharingServices(forItems: [""])
    }

    func serviceMenu(
        title: String,
        icon: Image,
        serviceAction: @escaping (NSSharingService) -> Void
    ) -> some View {
        Menu {
            ForEach(services, id: \.title) { service in
                Button {
                    serviceAction(service)
                } label: {
                    Image(nsImage: service.image)
                    Text(service.title)
                }
            }
        } label: {
            Label(title, icon)
        }
    }

    func sharePdf(
        with service: NSSharingService
    ) {
        guard let url = pdfAction?() else { return }
        service.perform(withItems: [url])
    }

    func shareFormat(
        _ format: RichTextDataFormat,
        with service: NSSharingService
    ) {
        guard let url = formatAction(format) else { return }
        service.perform(withItems: [url])
    }
}

struct RichTextNSSharingMenu_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            RichTextNSSharingMenu(
                formatAction: { _ in nil },
                pdfAction: { nil }
            )
        }
    }
}
#endif
