

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:simple3d/simple3d.dart';

import 'dart:ui';

import 'package:vector_math/vector_math_geometry.dart';
import 'package:vector_math/vector_math_lists.dart';

var aSphere;

main() {


  //MeshGeometry sphere = SphereGenerator().createSphere(2);;

  MeshGeometry sphere = CylinderGenerator().createCylinder(2, 2, 3);

  var q = sphere.getViewForAttrib('POSITION');
  final viewStride = sphere.stride ~/ sphere.buffer.elementSizeInBytes;
  Vector3List vert = Vector3List.view(sphere.buffer, 0,viewStride);
  Uint32List colors = Uint32List(sphere.indices!.length ~/ 3);

  for(int i = 0; i< colors.length; i++) {
    colors[i] = i % 2 == 0 ?  0xFFFF0000 : 0xFF00FF00;
  }

  aSphere = VertexModel(vert, sphere.indices!, colors);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPage(),
    );
  }
}

class MyGame extends CustomPainter {
  final World world;
  final double x;
  final double y;
  final double t;

  MyGame(this.world, this.x, this.y, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    world.input(x, y);
    world.update(t);
    world.render(t, canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MyPage extends StatefulWidget {
  _MyPageState createState() => _MyPageState();
}

class World {
  var _turn = 0.0;
  double _x;
  double _y;

  World(this._x, this._y);

  void input(double x, double y) {
    _x = x;
    _y = y;
  }

  VertexModelInstance w  = VertexModelInstance();
  View3d view0 = View3d(10000, 100, 100);
  View3d view2 = View3d(10000, 100, 100);

  View3d view3 = View3d(10000, 100, 100);
  View3d view4 = View3d(10000, 100, 100);


  double t = 0;
  void render(double dt, Canvas canvas, Size size) {
    w.model = aSphere;


    view0.dimensions.x =  size.width/2;
    view0.dimensions.y =  size.height/2;


    view2.dimensions.x =  size.width/2;
    view2.dimensions.y =  size.height/2;
    view2.pos.x = view0.dimensions.x;


    view3.dimensions.x =  size.width/2;
    view3.dimensions.y =  size.height/2;
    view3.pos.y = view0.dimensions.y;

    view4.dimensions.x =  size.width/2;
    view4.dimensions.y =  size.height/2;
    view4.pos.y = view0.dimensions.y;
    view4.pos.x = view0.dimensions.x;


    t+=.01;
    view0.update(10.0,0, 0,  0, 0.0,0.0);
    view0.prepareFrame();
    w.prepareFrame(0.0,0.0,0.0, 1.0,0.0,0.0, view0, t);

    view0.renderFrame(canvas);

    view2.update(0.0,0,10,  0, 0.0,0.0);
    view2.prepareFrame();
    w.prepareFrame(0.0,0.0,0.0, 1.0,0.0,0.0, view2, t);

    view2.renderFrame(canvas);

    view3.update(.01,-10, 0,  0, 0.0,0.0);
    view3.prepareFrame();
    w.prepareFrame(0.0,0.0,0.0, 1.0,0.0,0.0, view3, t);

    view3.renderFrame(canvas);

    view4.update(.01,10, 0,  0, 0.0,0.0);
    view4.prepareFrame();
    w.prepareFrame(0.0,0.0,0.0, 1.0,0.0,0.0, view4, t);

    view4.renderFrame(canvas);

  }

  void update(double t) {
    var rotationsPerSecond = 0.25;
    _turn += t * rotationsPerSecond;
  }
}

final aBox =  makeVertexModel([
  [
    [-1, 1, -1], // 0
    [ 1, 1, -1], // 1
    [ 1, 1,  1], // 2
    [-1, 1,  1], // 3
    [-1, -1, -1], // 4
    [ 1, -1, -1], // 5
    [1, -1,  1], // 6
    [-1, -1,  1], // 7
  ]    ,  [
    [Colors.red, [0, 1, 2]],
    [Colors.green, [0,2,3]],

    [Colors.red, [4, 5, 6]],
    [Colors.green, [4,6,7]],

    [Colors.red, [0, 3, 7]],
    [Colors.green, [0, 4, 7]],


    [Colors.red, [3, 6, 7]],
    [Colors.green, [2, 3, 6]],

    [Colors.red, [4, 5, 0]],
    [Colors.green, [5, 1, 0]],

    [Colors.red, [1, 2, 6]],
    [Colors.green, [1, 6, 5]],

  ]
]);

final aWedge = makeVertexModel([
  [
    [ 0, -1, 0],
    [ 0, 0, -3],
    [ 1, 0,  1],
    [-1, 0,  1]
  ],
  [
    [Colors.red,  [0,2,3]],
    [Colors.green, [0,1,3]],
    [Colors.yellowAccent, [0,1,2]],
    [Colors.indigoAccent, [1,2,3]],
  ]
]);


final r2 = sqrt(2.0)/2;

final aGem = makeVertexModel([
  [
    [0,1, 0],
    [r2, r2, 0],
    [1, 0, 0],
    [r2, -r2, 0],
    [0, -1, 0],
    [-r2, -r2, 0],
    [-1, 0, 0],
    [-r2, r2, 0],
    [0, 0, -2],
    [0, 0,  1],

  ],
  [
    [Colors.green, [0,1, 8]],
    [Colors.red, [1,2, 8]],
    [Colors.blue, [2,3, 8]],
    [Colors.deepOrange, [3,4, 8]],
    [Colors.amber, [4, 5, 8]],
    [Colors.indigo, [5,6, 8]],
    [Colors.green, [6,7, 8]],
    [Colors.cyanAccent, [7,0, 8]],
    [Colors.green, [0,1, 9]],
    [Colors.red, [1,2, 9]],
    [Colors.blue, [2,3, 9]],
    [Colors.deepOrange, [3,4, 9]],
    [Colors.amber, [4, 5, 9]],
    [Colors.indigo, [5,6, 9]],
    [Colors.green, [6,7, 9]],
    [Colors.cyanAccent, [7,0, 9]],

  ]
]
);


final aBird = makeVertexModel([
  [
    [0, 0, -1],
    [0, 1, 0],
    [0, 0, 4],
    [-.5, 0, .5],
    [-2, 0, 1],
    [.5, 0, .5],
    [2, 0, 1]
  ],  [
    [Color(0xFFF78E69), [0,1, 2]],
    [Color(0xFFF78E69), [0,1, 4]],
    [Color(0xFFF78E69), [4, 1, 3]],
    [Color(0xFFF78E69), [6,1, 5]],
    [Color(0xFF51513D), [3,2, 1]],
    [Color(0xFF51513D), [5,2, 1]],
    [Color(0xFFE3DC95), [0,3, 2]],
    [Color(0xFFE3DC95), [0,5, 2]],
    [Color(0xFFE3DCC2), [0,4, 3]],
    [Color(0xFFE3DCC2), [0,6, 5]],

  ]]);


class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  World world = new World(0.0, 0.0);
  final DateTime _initialTime = DateTime.now();
  double previous = 0.0;
  double pointerx = 0;
  double pointery =0;
  double get currentTime =>
      DateTime.now().difference(_initialTime).inMilliseconds / 1000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: pointerUpdate,
        onTapUp: pointerUpdate,
        onVerticalDragUpdate: pointerUpdate,
        onHorizontalDragUpdate: pointerUpdate,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext contex, Widget? child) {
            var curr = currentTime;
            var dt = curr - previous;
            previous = curr;

            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: MyGame(world, pointerx, pointery, dt),
              child: Center(
                child: Text(''),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    previous = currentTime;
    _controller = new AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
    _animation = new Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void pointerUpdate(details) {
    pointerx = details.globalPosition.dx;
    pointery = details.globalPosition.dy;
  }
}

class PaintBox extends CustomPainter {
  PaintBox(this.animation) : super(repaint: animation);
  final Animation<double> animation;
  VertexModelInstance w  = VertexModelInstance();
  View3d view = View3d(100, 100, 100);

  @override
  void paint(Canvas canvas, Size size) {

  }
  double t= 0;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return true;
  }
  
}
