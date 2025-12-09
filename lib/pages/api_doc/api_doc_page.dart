import 'package:flutter/material.dart';

/// pigeon 26.0.1 文件:
/// https://pub.dev/documentation/pigeon/latest/pigeon/
class ApiDocPage extends StatelessWidget {
  const ApiDocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Doc')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Subtitle('Classes'),
          _Item('ConfigurePigeon', subtitle: 'Metadata annotation used to configure how Pigeon will generate code. '),
          _Item('CppOptions', subtitle: 'Options that control how C++ code will be generated. '),
          _Item('DartOptions', subtitle: 'Options that control how Dart code will be generated. '),
          _Item('Error', subtitle: 'Represents an error as a result of parsing and generating code. '),
          _Item('EventChannelApi', subtitle: 'Metadata to annotate a pigeon API that contains event channels. '),
          _Item(
            'Float64List',
            subtitle:
                'A fixed-length list of IEEE 754 double-precision binary floating-point numbers that is viewable as a TypedData. ',
          ),
          _Item('FlutterApi', subtitle: 'Metadata to annotate a Pigeon API implemented by Flutter. '),
          _Item('GObjectOptions', subtitle: 'Options that control how GObject code will be generated. '),
          _Item('HostApi', subtitle: 'Metadata to annotate a Pigeon API implemented by the host-platform. '),
          _Item(
            'Int32List',
            subtitle: 'A fixed-length list of 32-bit signed integers that is viewable as a TypedData. ',
          ),
          _Item(
            'Int64List',
            subtitle: 'A fixed-length list of 64-bit signed integers that is viewable as a TypedData. ',
          ),
          _Item('JavaOptions', subtitle: 'Options that control how Java code will be generated. '),
          _Item('KotlinEventChannelOptions', subtitle: 'Options for Kotlin implementation of Event Channels. '),
          _Item('KotlinOptions', subtitle: 'Options that control how Kotlin code will be generated. '),
          _Item(
            'KotlinProxyApiOptions',
            subtitle: 'Options that control how Kotlin code will be generated for a specific ProxyApi. ',
          ),
          _Item('ObjcOptions', subtitle: 'Options that control how Objective-C code will be generated. '),
          _Item(
            'ObjCSelector',
            subtitle:
                'Metadata to annotation methods to control the selector used for objc output. The number of components in the provided selector must match the number of arguments in the annotated method. For example: @ObjcSelector(\'divideValue:by:\') double divide(int x, int y); ',
          ),
          _Item('ParseResults', subtitle: 'A collection of an AST represented as a Root and Error\'s. '),
          _Item('Pigeon', subtitle: 'Tool for generating code to facilitate platform channels usage. '),
          _Item('PigeonOptions', subtitle: 'Options used when configuring Pigeon. '),
          _Item('ProxyApi', subtitle: 'Metadata to annotate a ProxyAPI. '),
          _Item('SwiftClass', subtitle: 'Metadata to annotate data classes to be defined as class in Swift output. '),
          _Item('SwiftEventChannelOptions', subtitle: 'Options for Swift implementation of Event Channels. '),
          _Item(
            'SwiftFunction',
            subtitle: 'Metadata to annotate methods to control the signature used for Swift output. ',
          ),
          _Item('SwiftOptions', subtitle: 'Options that control how Swift code will be generated. '),
          _Item(
            'SwiftProxyApiOptions',
            subtitle: 'Options that control how Swift code will be generated for a specific ProxyApi. ',
          ),
          _Item(
            'TaskQueue',
            subtitle:
                'Metadata annotation to control how handlers are dispatched for HostApi\'s. Note that the TaskQueue API might not be available on the target version of Flutter, see also: https://docs.flutter.dev/development/platform-integration/platform-channels. ',
          ),
          _Item('Uint8List', subtitle: 'A fixed-length list of 8-bit unsigned integers. '),
          _Subtitle('Enums'),
          _Item(
            'TaskQueueType',
            subtitle: 'Type of TaskQueue which determines how handlers are dispatched for HostApi\'s. ',
          ),
          _Subtitle('Constants'),
          _Item('async → const Object', subtitle: 'Metadata to annotate a Api method as asynchronous '),
          _Item(
            'attached → const Object',
            subtitle: 'Metadata to annotate the field of a ProxyApi as an Attached Field. ',
          ),
          _Item('static → const Object', subtitle: 'Metadata to annotate a field of a ProxyApi as static. '),
        ],
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.text, {this.subtitle});

  final String text;

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text, style: TextStyle(color: Colors.blue)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}
