import 'package:flutter/material.dart';
import 'package:scwar/config/config.dart';
import 'package:scwar/config/game_config.dart';
import 'package:scwar/game/game.dart';
import 'package:scwar/layers/layer_util.dart';
import 'package:scwar/utils/iconfont.dart';
import 'package:scwar/utils/number_util.dart';

class TitleComponent extends StatefulWidget {
  final SCWarGame game;
  const TitleComponent({super.key, required this.game});

  @override
  TitleComponentState createState() => TitleComponentState();
}

class TitleComponentState extends State<TitleComponent>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    double scale = widget.game.scale;
    double rd = (-15 + 15 * _animation.value) / scale;
    double cd = (15 - 15 * _animation.value) / scale;
    return Stack(children: [
      Positioned(
        top: 100 / scale,
        left: 150 / scale,
        child: Container(
          width: 150 / scale,
          height: 150 / scale,
          decoration: BoxDecoration(
            color: ColorMap.enemy,
            borderRadius: BorderRadius.circular(20),
          ),
          transform: Matrix4.translationValues(
            rd,
            rd,
            0,
          ),
          child: Center(
            child: Text(
              '2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50 / scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 170 / scale,
        left: 240 / scale,
        child: GestureDetector(
          onDoubleTap: () {
            game.changeTestMode();
          },
          child: Container(
            width: 150 / scale,
            height: 150 / scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorMap.tower,
            ),
            transform: Matrix4.translationValues(
              cd,
              cd,
              0,
            ),
            child: Center(
              child: Text(
                'K',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50 / scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TestSwitchButton extends StatefulWidget {
  final SCWarGame game;
  const TestSwitchButton({super.key, required this.game});
  @override
  TestSwitchButtonState createState() => TestSwitchButtonState();
}

class TestSwitchButtonState extends State<TestSwitchButton> {
  bool enable = true;
  @override
  Widget build(BuildContext context) {
    enable = Config.testMode;
    double scale = widget.game.scale;
    return TextButton(
        // icon: Icon(
        //   size: 40 / scale,
        //   Iconfont.soundOn,
        //   color: enable ? Colors.white : const Color(0xFF848484),
        // ),
        onPressed: () {
          setState(() {
            game.changeTestMode();
          });
        },
        child: Text(
          'TEST',
          style: TextStyle(
            fontSize: 25 / scale,
            fontWeight: FontWeight.bold,
            color: enable ? Colors.white : const Color(0xFF848484),
          ),
        ));
  }
}

Widget makePlayButton(SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            game.gameManager.soundManager.playCick();
            game.start();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3292b8), // 按钮背景颜色
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(55 / scale),
            ),
            fixedSize: Size(270 / scale, 110 / scale),
            foregroundColor: const Color(0xFF4be4c5),
            textStyle: TextStyle(
              color: const Color(0xFFa7f2a7),
              fontSize: 80 / scale,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  blurRadius: 5,
                  color: Color(0xff003333),
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          child: const Text('PLAY'),
        ),
      ],
    ),
  );
}

Widget makeLevelButton(SCWarGame game) {
  double scale = game.scale;
  return Center(
    child: SizedBox(
      height: 300 / scale,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            game.gameManager.soundManager.playCick();
            game.goToLevel();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4baea0), // 按钮背景颜色
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5 / scale),
            ),
            fixedSize: Size(180 / scale, 60 / scale),
            foregroundColor: const Color(0xFF7DCEA0),
            textStyle: TextStyle(
              fontSize: 40 / scale,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  blurRadius: 3,
                  color: Color(0xff003333),
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          child: const Text('LEVEL'),
        ),
      ),
    ),
  );
}

Widget makeHighScore(SCWarGame game) {
  double scale = game.scale;
  return Align(
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      height: 100 / scale,
      child: Column(
        children: [
          Text(
            'HighScore: ${NumberUtil.getScoreString(game.playerData.highScore)}',
            style: TextStyle(
              color: const Color(0xFFf1f0cf), //ColorMap.highScore,
              fontSize: 30 / scale,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            Config.version,
            style: TextStyle(
              fontSize: 18 / scale,
              color: const Color(0xFF535353),
            ),
          ),
        ],
      ),
    ),
  );
}

class KefuComponent extends StatelessWidget {
  final SCWarGame game;
  final VoidCallback onOk;
  const KefuComponent({
    super.key,
    required this.game,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    double scale = game.scale;
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Container(
          color: const Color.fromARGB(130, 0, 0, 0),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 300 / scale,
                height: 200 / scale,
                color: const Color(0xFF7FB3D5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120 / scale,
                      child: Center(
                        child: Text(
                          'Email me: wyklion@qq.com',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xFF3f7b70),
                              fontSize: 25 / scale,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    makeIconButton(game, Iconfont.ok, 'Got it', 30,
                        color: const Color(0xFF6FCF97), () {
                      onOk();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeComponent extends StatefulWidget {
  final SCWarGame game;
  const HomeComponent({super.key, required this.game});
  @override
  HomeComponentState createState() => HomeComponentState();
}

class HomeComponentState extends State<HomeComponent> {
  bool openKefu = false;
  @override
  Widget build(BuildContext context) {
    double scale = game.scale;
    List<Widget> stacks = [];
    stacks.add(makePlayButton(game));
    if (game.localStorage.hasGame()) {
      stacks.add(Center(
        child: SizedBox(
          width: 200 / scale,
          height: 120 / scale,
          child: Align(
            alignment: Alignment.topRight,
            child: Text(
              'continue',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 25 / scale,
              ),
            ),
          ),
        ),
      ));
    }
    stacks.add(makeLevelButton(game));
    stacks.add(makeHighScore(game));
    stacks.add(TitleComponent(game: game));
    // if (!Config.release) {
    //   stacks.add(
    //     Positioned(
    //       top: 100 / scale,
    //       right: 40 / scale,
    //       child: TestSwitchButton(game: game),
    //     ),
    //   );
    // }
    stacks.add(
      Positioned(
        left: 20 / scale,
        bottom: 45 / scale,
        child: IconButton(
          icon: Icon(
            size: 40 / scale,
            Iconfont.kefu,
            color: const Color(0xFF9ED9D2),
          ),
          onPressed: () {
            game.gameManager.soundManager.playCick();
            setState(() {
              openKefu = true;
            });
          },
        ),
      ),
    );
    if (openKefu) {
      stacks.add(KefuComponent(
          game: game,
          onOk: () {
            setState(() {
              openKefu = false;
            });
          }));
    }
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Stack(children: stacks),
      ),
    );
  }
}

Widget buidlHomeOverlay(BuildContext buildContext, SCWarGame game) {
  return HomeComponent(game: game);
}
