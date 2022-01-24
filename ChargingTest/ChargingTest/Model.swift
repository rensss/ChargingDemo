//
//  Model.swift
//  ChargingTest
//
//  Created by Rzk on 2022/1/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let model = try? newJSONDecoder().decode(Model.self, from: jsonData)

import Foundation

// MARK: - Model
struct Model: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let name, originalName: String
    let appVersionID: Int
    let icon: Icon
    let batteries: [Battery]

    enum CodingKeys: String, CodingKey {
        case id, name
        case originalName = "original_name"
        case appVersionID = "app_version_id"
        case icon, batteries
    }
}

// MARK: - Battery
struct Battery: Codable {
    let id: Int
    let type: String
    let weight: Int
    let hidden: Bool
    let labels: [String]
    let previewVideo, previewImage, video: Icon?
    let gravity, resourceArchive: [String : String]?
    let batteryTagID: Int
    let lightningPosition: String?
    let lightning: Lightning?
    let color: Color?
    let sound: Sound?
    let batteryLightningID, batteryColorID, batterySoundID: Int?

    enum CodingKeys: String, CodingKey {
        case id, type, weight, hidden, labels
        case previewVideo = "preview_video"
        case previewImage = "preview_image"
        case video, gravity
        case resourceArchive = "resource_archive"
        case batteryTagID = "battery_tag_id"
        case lightningPosition = "lightning_position"
        case lightning, color, sound
        case batteryLightningID = "battery_lightning_id"
        case batteryColorID = "battery_color_id"
        case batterySoundID = "battery_sound_id"
    }
}

// MARK: - Color
struct Color: Codable {
    let id: Int
    let name, originalName, color: String
    let stroke: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case originalName = "original_name"
        case color, stroke
    }
}

// MARK: - Lightning
struct Lightning: Codable {
    let id, weight: Int
    let image: Icon
}

// MARK: - Icon
struct Icon: Codable {
    let url: String
}

// MARK: - Sound
struct Sound: Codable {
    let id: Int
    let name: String
    let weight: Int
    let hidden: Bool
    let audio: Icon
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

