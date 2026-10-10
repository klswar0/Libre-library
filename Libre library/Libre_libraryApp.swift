//
//  Libre_libraryApp.swift
//  Libre library
//
//  Created by Ksawery Lewandowski on 24/09/2026.
//

import SwiftUI
import SwiftData

func decodeUID(uid: String) -> String {
    var temp = uid.split(separator: ":")
    if temp[0] != "E0"{
        fatalError("Invalid prefix E0")
    }
    if temp[1] != "7A"{
        fatalError("Invalid prefix 7A")
    }
    if temp.count != 8{
        fatalError("Bad lenght")
    }
    let alphabet = Array("0123456789ACDEFGHJKLMNPQRTUVWXYZ")
    
    let bytes = temp[2...7].compactMap { UInt8($0, radix: 16) }
    
    var value: UInt64 = 0

    for byte in bytes {
        value = (value << 8) | UInt64(byte)
    }
    var result = ""

    for i in 0..<9 {
        let shift = 43 - (i * 5)
        let index = Int((value >> shift) & 0x1F)
        result.append(alphabet[index])
    }

    return result

}
    

@main
struct Libre_libraryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
