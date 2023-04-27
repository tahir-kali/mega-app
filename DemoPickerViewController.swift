//  Tahir Rahimi 28/4/2023

import HorizonCalendar
import UIKit

// MARK: - DemoPickerViewController

final class DemoPickerViewController: UIViewController {

  // MARK: Internal

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "HorizonCalendar Example App"

    view.backgroundColor = .systemBackground

    view.addSubview(tableView)
    view.addSubview(monthsLayoutPicker)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    monthsLayoutPicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      monthsLayoutPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      monthsLayoutPicker.topAnchor.constraint(
        equalTo: view.layoutMarginsGuide.topAnchor,
        constant: 8),

      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: monthsLayoutPicker.bottomAnchor, constant: 8),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: animated)
    }
  }

  // MARK: Private

  private let verticalDemoDestinations: [(name: String, destinationType: DemoViewController.Type)] =
    [
      ("Day Range Selection", DayRangeSelectionDemoViewController.self)
    ]

  private let horizontalDemoDestinations: [(name: String, destinationType: DemoViewController.Type)] =
    [
      ("Day Range Selection", DayRangeSelectionDemoViewController.self)
    ]

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    return tableView
  }()

  private lazy var monthsLayoutPicker: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["Vertical", "Horizontal"])
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(
      self,
      action: #selector(monthsLayoutPickerValueChanged),
      for: .valueChanged)
    return segmentedControl
  }()

  @objc
  private func monthsLayoutPickerValueChanged() {
    tableView.reloadData()
  }

}

// MARK: - UITableViewDataSource

extension DemoPickerViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    monthsLayoutPicker.selectedSegmentIndex == 0
      ? verticalDemoDestinations.count
      : horizontalDemoDestinations.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    let demoDestination = monthsLayoutPicker.selectedSegmentIndex == 0
      ? verticalDemoDestinations[indexPath.item]
      : horizontalDemoDestinations[indexPath.item]
    cell.textLabel?.text = demoDestination.name

    return cell
  }

}

// MARK: - UITableViewDelegate

extension DemoPickerViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let demoDestination = monthsLayoutPicker.selectedSegmentIndex == 0
      ? verticalDemoDestinations[indexPath.item]
      : horizontalDemoDestinations[indexPath.item]

    let demoViewController = demoDestination.destinationType.init(
      monthsLayout: monthsLayoutPicker.selectedSegmentIndex == 0
        ? .vertical(
          options: VerticalMonthsLayoutOptions(
            pinDaysOfWeekToTop: false,
            alwaysShowCompleteBoundaryMonths: false,
            scrollsToFirstMonthOnStatusBarTap: false))
        : .horizontal(
          options: HorizontalMonthsLayoutOptions(
            maximumFullyVisibleMonths: 1.5,
            scrollingBehavior: .paginatedScrolling(
              .init(
                restingPosition: .atLeadingEdgeOfEachMonth,
                restingAffinity: .atPositionsClosestToTargetOffset)))))

    navigationController?.pushViewController(demoViewController, animated: true)
  }

}
