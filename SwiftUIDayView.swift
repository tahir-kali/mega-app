//  Tahir Rahimi 28/4/2023

import HorizonCalendar
import SwiftUI

struct SwiftUIDayView: View {

  let dayNumber: Int
  let isSelected: Bool

  var body: some View {
    ZStack(alignment: .center) {
      Circle()
        .strokeBorder(isSelected ? Color.accentColor : .clear, lineWidth: 2)
        .background {
          Circle()
            .foregroundColor(isSelected ? Color(UIColor.systemBackground) : .clear)
        }
        .aspectRatio(1, contentMode: .fill)
      Text("\(dayNumber)").foregroundColor(Color(UIColor.label))
    }
  }

}

struct SwiftUIDayView_Previews: PreviewProvider {

  // MARK: Internal

  static var previews: some View {
    Group {
      SwiftUIDayView(dayNumber: 1, isSelected: false)
      SwiftUIDayView(dayNumber: 19, isSelected: false)
      SwiftUIDayView(dayNumber: 27, isSelected: true)
    }
    .frame(width: 50, height: 50)
  }

  // MARK: Private

  private static let calendar = Calendar.current
}
