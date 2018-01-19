import UIKit

enum MapOptionsType: Int {
  case mapOverlay
  case mapRoute
  
  func displayName() -> String {
    switch (self) {
    case .mapOverlay:
      return "Map Overlay"
    case .mapRoute:
      return "366-312"
    }
  }
}

class MapOptionsViewController: UIViewController {
  var selectedOptions = [MapOptionsType]()
}

//UITableViewDataSource
extension MapOptionsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell")!
    
    if let mapOptionsType = MapOptionsType(rawValue: indexPath.row) {
      cell.textLabel!.text = mapOptionsType.displayName()
      cell.accessoryType = selectedOptions.contains(mapOptionsType) ? .checkmark : .none
    }
    
    return cell
  }
}

//UITableViewDelegate
extension MapOptionsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    guard let mapOptionsType = MapOptionsType(rawValue: indexPath.row) else { return }
    
    if (cell.accessoryType == .checkmark) {
      // Remove option
      selectedOptions = selectedOptions.filter { $0 != mapOptionsType}
      cell.accessoryType = .none
    } else {
      // Add option
      selectedOptions += [mapOptionsType]
      cell.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
