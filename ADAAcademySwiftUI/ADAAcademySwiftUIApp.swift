//
//  ADAAcademySwiftUIApp.swift
//  ADAAcademySwiftUI
//
//  Created by Local Administrator on 31/07/21.
//

import SwiftUI

@available(iOS 15.0, *)
@main
struct ADAAcademySwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
