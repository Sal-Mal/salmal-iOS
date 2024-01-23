import Foundation
import Combine

import Core

final class AppState: ObservableObject {
  private var cancelBag = Set<AnyCancellable>()
  
  @Published var showTab = true
  
  init() {
    NotificationService.publisher(.hideTabBar)
      .sink { [weak self] _  in
        self?.showTab = false
      }
      .store(in: &cancelBag)
    
    NotificationService.publisher(.showTabBar)
      .sink { [weak self] _  in
        self?.showTab = true
      }
      .store(in: &cancelBag)
  }
}
