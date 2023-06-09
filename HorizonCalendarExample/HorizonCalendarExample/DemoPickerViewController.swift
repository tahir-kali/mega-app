// Created by Bryan Keller on 6/18/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import HorizonCalendar
import UIKit

// MARK: - DemoPickerViewController

final class DemoPickerViewController: UIViewController {

  // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Day Range"

        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        view.addSubview(monthsLayoutPicker)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        monthsLayoutPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthsLayoutPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monthsLayoutPicker.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: monthsLayoutPicker.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let selectedDemoDestination = verticalDemoDestinations.first(where: { $0.destinationType == DayRangeSelectionDemoViewController.self })!
        let demoViewController = selectedDemoDestination.destinationType.init(
            monthsLayout: .vertical(
                options: VerticalMonthsLayoutOptions(
                    pinDaysOfWeekToTop: false,
                    alwaysShowCompleteBoundaryMonths: false,
                    scrollsToFirstMonthOnStatusBarTap: false)))

        navigationController?.pushViewController(demoViewController, animated: false)
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
      
      ("Show Calendar", DayRangeSelectionDemoViewController.self)
     
    ]

  private let horizontalDemoDestinations: [(name: String, destinationType: DemoViewController.Type)] =
    [
     
      ("Show Calendar", DayRangeSelectionDemoViewController.self)
      
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
