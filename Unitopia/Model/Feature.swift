//
//  Feature.swift
//  Unitopia
//
//  Created by Justin Hold on 2/28/25.
//

import Foundation

/// A model representing a feature in the application.
///
/// This struct stores information about a single feature, including its title,
/// description, and associated image. Each feature has a unique identifier that
/// is automatically generated upon creation.
///
/// Example usage:
/// ```
/// let newFeature = Feature(
///     title: "Dark Mode",
///     description: "Switch to a darker theme to reduce eye strain",
///     image: "moon.circle"
/// )
/// ```
struct Feature: Decodable, Identifiable {
   /// A unique identifier for the feature.
   ///
   /// This property is automatically initialized with a new UUID when a Feature instance is created.
   var id = UUID()
   
   /// The title of the feature.
   ///
   /// This should be a concise name that identifies the feature.
   let title: String
   
   /// A detailed description of what the feature does.
   ///
   /// This provides users with more information about the feature's functionality.
   let description: String
   
   /// The name of the image resource associated with this feature.
   ///
   /// This could be a system image name or a custom image in the asset catalog.
   let image: String
}
