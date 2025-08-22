//
//  TitlesEnvironment.swift
//  MustWatch
//
//  Created by Karl Eknefelt on 2025-08-22.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var searchTitlesRepository: any SearchTitlesRepository = SearchTitlesRepositoryLive()
    @Entry var titleDetailsRepository: any TitleDetailsRepository = TitleDetailsRepositoryLive()
}
