//
//  TitlesEnvironment.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var titlesRepository: any SearchTitlesRepository = SearchTitlesRepositoryLive()
}
