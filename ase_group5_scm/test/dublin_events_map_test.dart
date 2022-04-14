import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:ase_group5_scm/pages/DublinEvents/dublin_events_map.dart';

Future<void> main() async {
  final instance = FakeFirebaseFirestore();
  await instance.collection('users').doc("3Arena").set({
    "events": {
      "2022-04-13T17:00:00Z": "Little Mix",
      "22022-04-14T19:00:00Z": "The War On Drugs"
    },
    "latitude": "53.347512",
    "location_name": "3Arena",
    "longitude": "-6.228482",
    "nearest_bus_stops": {
      "Ringsend, stop 356": [53.3417336311692, -6.22741532105916],
      "Ringsend, stop 392": [53.3417336311692, -6.22741532105916]
    }
  });
  await instance.collection('users').doc("Aviva Stadium").set({
    "events": {
      "2022-04-15T16:30:00Z": "Heineken Champions Cup - Leinster V Connachtx",
      "22022-04-14T19:00:00Z": "The War On Drugs"
    },
    "latitude": "53.335237",
    "location_name": "Aviva Stadium",
    "longitude": "-6.228468",
    "nearest_bus_stops": {
      "Haddington Road": [53.3352555102392, -6.23727931905615],
      "Irishtown Road, stop 357": [53.3391710439696, -6.22312147489852]
    }
  });
  await instance.collection('users').doc("Bord Gais Energy Theatre").set({
    "events": {
      "2022-04-15T16:30:00Z": "Heineken Champions Cup - Leinster V Connachtx",
      "22022-04-14T19:00:00Z": "The War On Drugs"
    },
    "latitude": "53.335237",
    "location_name": "Bord Gais Energy Theatre",
    "longitude": "-6.228468",
    "nearest_bus_stops": {
      "Haddington Road": [53.3352555102392, -6.23727931905615],
      "Irishtown Road, stop 357": [53.3391710439696, -6.22312147489852]
    }
  });
  await instance.collection('users').doc("Gaiety Theatre").set({
    "events": {
      "2022-04-15T16:30:00Z": "Heineken Champions Cup - Leinster V Connachtx",
      "22022-04-14T19:00:00Z": "The War On Drugs"
    },
    "latitude": "53.335237",
    "location_name": "Gaiety Theatre",
    "longitude": "-6.228468",
    "nearest_bus_stops": {
      "Haddington Road": [53.3352555102392, -6.23727931905615],
      "Irishtown Road, stop 357": [53.3391710439696, -6.22312147489852]
    }
  });
  await instance.collection('users').doc("National Stadium").set({
    "events": {
      "2022-04-15T16:30:00Z": "Heineken Champions Cup - Leinster V Connachtx",
      "22022-04-14T19:00:00Z": "The War On Drugs"
    },
    "latitude": "53.33112",
    "location_name": "National Stadium",
    "longitude": "-6.280549",
    "nearest_bus_stops": {
      "Haddington Road": [53.3352555102392, -6.23727931905615],
      "Irishtown Road, stop 357": [53.3391710439696, -6.22312147489852]
    }
  });
  final firebaseSnapshot = await instance.collection('users').get();
  print(firebaseSnapshot.docs.length); // 1
  //print(snapshot.docs.first.get('latitude')); // 'Bob'
  var eventList = firebaseSnapshot.docs;
  for (int i = 0; i < eventList.length; i++) {
    var listOfEvents = "";
    var location_name = eventList[i].get("location_name");
    var event_near_by_stops = eventList[i].get("nearest_bus_stops");
    event_near_by_stops.forEach((key, value) {
      print(key);
      print(value[0]);
      print(value[1]);
    });
    print(location_name);
  }
  instance.dump();
  testWidgets('date filter widget', (WidgetTester tester) async {
    const Key innerKey = Key('inner');
    EventLocationMap inner1 = EventLocationMap(
        key: innerKey, snapshot: firebaseSnapshot);
    //await tester.pumpWidget(EventLocationMap(key: innerKey, snapshot: firebaseSnapshot));
    /*Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child:
        EventLocationMap(key: innerKey, snapshot: firebaseSnapshot)
    );
    await tester.pumpWidget(
        testWidget
    );*/
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    //var dateFilter = find.byKey(Key("date_filter"));
    expect(find.byKey(Key("date_filter")), findsOneWidget);
  });
  testWidgets('bus filter widget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("bus_stop_filter")), findsOneWidget);
  });
  testWidgets('bus stop title widget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("bus_stopt_title")), findsOneWidget);
  });
  testWidgets('date filter titlewidget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("date_filter_title")), findsOneWidget);
  });
  testWidgets('events map widget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("dublin-events-map")), findsOneWidget);
  });
  testWidgets('invalid key test', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("dublin-events-mapq")), findsNothing);
  });
  testWidgets('events root widget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("events_root")), findsOneWidget);
  });
  testWidgets('events card widget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("events_card")), findsOneWidget);
  });
  testWidgets('events card column widget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.byKey(Key("events_card_column")), findsOneWidget);
  });
  testWidgets('first date filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("All Upcoming Events"), findsOneWidget);
  });
  testWidgets('second date filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("Next 1 Week"), findsOneWidget);
  });
  testWidgets('third date filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("Next 2 Weeks"), findsOneWidget);
  });
  testWidgets('fourth date filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("Next 3 Weeks"), findsOneWidget);
  });
  testWidgets('first bus stop filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("No Bus Stops"), findsOneWidget);
  });
  testWidgets('second bus stop filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("Aviva Stadium"), findsOneWidget);
  });
  testWidgets('third bus stop filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("National Stadium"), findsOneWidget);
  });
  testWidgets('fourth bus stop filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("Gaiety Theatre"), findsOneWidget);
  });
  testWidgets('fifth bus stop filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("Bord Gais Energy Theatre"), findsOneWidget);
  });
  testWidgets('sixth bus stop filter', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("3Arena"), findsOneWidget);
  });
  testWidgets('invalid find text', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new EventLocationMap(snapshot: firebaseSnapshot))
    );
    await tester.pumpWidget(testWidget);
    expect(find.text("3Arenaasa"), findsNothing);
  });
}
