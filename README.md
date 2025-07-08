# Table Calendar Widget Demo

This project is a demo of the [table_calendar](https://pub.dev/packages/table_calendar) Flutter widget. 
This widget displays full calendars with customizable day selection, styles, and event markers.

## Features

- **Multiple Calendar Formats:** Switch between month, two-week, and week views.
- **Event Management:**
  - Add events with a title, description, and time (using a time picker).
  - View events for a selected day or a date range.
  - Delete events interactively.
- **Custom Styling:**
  - Fully themed for both light and dark modes.
  - Custom decorations for selected, today, range, weekends, and outside days.
  - Custom event markers and day cell builders.
- **Range Selection:** Select a range of dates to see all events in that period.
- **Responsive UI:** Modern Material 3 design, works on all platforms supported by Flutter.

## How to Use

1. **Clone the repository and install dependencies:**
   ```sh
   flutter pub get
   ```
2. **Run the app:**
   ```sh
   flutter run
   ```
3. **Interact with the calendar:**
   - Tap a day to select it and view its events.
   - Tap the "+" button to add a new event (with time and description).
   - Switch calendar formats using the buttons at the top.
   - Select a range by tapping and dragging across days.
   - Delete events using the trash icon next to each event.

## Screenshot
![image](https://github.com/user-attachments/assets/2da18743-8728-4fcb-bf22-6219d27ed86f)



## Customization

- All styles (colors, fonts, decorations) can be easily customized in the code.
- The event model can be extended to include more fields (e.g., location, attendees).
- The calendar supports localization and can be themed to match your app.

## About table_calendar

[table_calendar](https://pub.dev/packages/table_calendar) is a powerful and flexible Flutter widget for displaying calendars. It supports:

- Multiple formats (month, week, two weeks)
- Event markers
- Range selection
- Custom builders for day cells, headers, and more
- Full theming and localization
