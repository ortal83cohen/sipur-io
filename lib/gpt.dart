// // import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Sipur',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'sipur.ai'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late final OpenAI openAI;
//   String? string;
//   String? url;
//   final s =
//       "Write a children's book, 12 pages long, suitable for a 6 year old. The books main character is Nico, a clever boy that likes dragons, snakes and rock climbing, but please don't mention these explicitly in the book. The book should have a beginning, cliff hanger and happy end and the moral and writing style should be similar to the book 'the rabbit listened' by Cori Doerrfeld.";
//   @override
//   void initState() {
//     openAI = OpenAI.instance.build(
//         token: todo,
//         baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 15)),
//         enableLog: true);
//     super.initState();
//   }
//
//   void _chatComplete() async {
//     if (string != null) {
//       return;
//     }
//     final request = ChatCompleteText(messages: [
//       Map.of({"role": "user", "content": s})
//     ], maxToken: 200, model: GptTurboChatModel());
//
//     final response =
//         await openAI.onChatCompletion(request: request).catchError((err) {
//       if (err is OpenAIAuthError) {
//         print('OpenAIAuthError error ${err.data?.error.toMap()}');
//       }
//       if (err is OpenAIRateLimitError) {
//         print('OpenAIRateLimitError error ${err.data?.error.toMap()}');
//       }
//       if (err is OpenAIServerError) {
//         print('OpenAIServerError error ${err.data?.error.toMap()}');
//       }
//       return err;
//     });
//     for (var element in response!.choices) {
//       setState(() {
//         string = element.message?.content ?? "";
//       });
//       print("data -> ${element.message?.content}");
//     }
//     _generateImage();
//   }
//
//   String _page1() {
//     List<String> page = (string ?? "").split('Page 1:');
//     List<String> page1 = page[1].split('Page 2:');
//     return page1[0];
//   }
//
//   Future<void> _generateImage() async {
//     if (url != null) {
//       return;
//     }
//     final request = GenerateImage(
//         model: DallE2(),
//         _page1(),
//         1,
//         size: ImageSize.size256,
//         responseFormat: Format.url);
//     final GenImgResponse? response =
//         await openAI.generateImage(request).catchError((err) {
//       if (err is OpenAIAuthError) {
//         print('OpenAIAuthError error ${err.data?.error.toMap()}');
//       }
//       if (err is OpenAIRateLimitError) {
//         print('OpenAIRateLimitError error ${err.data?.error.toMap()}');
//       }
//       if (err is OpenAIServerError) {
//         print('OpenAIServerError error ${err.data?.error.toMap()}');
//       }
//       return err;
//     });
//     print("img url :${response?.data?.last?.url}");
//     setState(() {
//       url = response?.data?.last?.url ?? "";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Stack(
//           // Center is a layout widget. It takes a single child and positions it
//           // in the middle of the parent.
//           children: [
//             if (url != null) Image.network(url ?? ""),
//             ListView(
//               // mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   string ?? "",
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ],
//             ),
//           ]),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _chatComplete,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
