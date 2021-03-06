import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/game.dart';

void main() {
  print('load the game widget');

  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasTappables {
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent phone = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  SpriteComponent background3 = SpriteComponent();
  SpriteComponent background4 = SpriteComponent();
  SpriteComponent ring = SpriteComponent();
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(70.0, 70.0);

  final double girlSize = 200;
  final double boySize = 220;
  bool turnAway = false;
  bool girlTurnAway = false;
  int dialogLevel = 0;
  int sceneLevel = 1;

  bool musicPlaying = false;

  TextPaint dialogTextPaint =
      TextPaint(style: const TextStyle(fontSize: 25, color: Colors.black));

  TextPaint finalPaint =
      TextPaint(style: const TextStyle(fontSize: 30, color: Colors.black));

  @override
  Color backgroundColor() {
    return const Color(0xFFd6a88a);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    final textBoxHeight = 100;

    FlameAudio.bgm.initialize();

//background2
    background2
      ..sprite = await loadSprite('city3.jpg')
      ..size = Vector2(size[0], size[1] - 100);

    background3
      ..sprite = await loadSprite('office.webp')
      ..size = Vector2(size[0], size[1] - 100);

    background4
      ..sprite = await loadSprite('bakery.jpg')
      ..size = Vector2(size[0], size[1] - 100);

    add(background
      ..sprite = await loadSprite('city2.jpg')
      ..size = Vector2(size[0], size[1] - 1));

    print('load game assets');
    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(girlSize, girlSize)
      ..y = screenHeight - girlSize - textBoxHeight
      ..anchor = Anchor.topCenter;
    add(girl);

    boy
      ..sprite = await loadSprite('guy2.png')
      ..size = Vector2(boySize, boySize)
      ..x = screenWidth - boySize
      ..y = screenHeight - boySize - textBoxHeight
      ..anchor = Anchor.topCenter
      ..flipHorizontally();
    add(boy);

    phone
      ..sprite = await loadSprite('phone.png')
      ..size = Vector2(50, 50);

    ring
      ..sprite = await loadSprite('ring.png')
      ..size = Vector2(50, 50);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position =
          Vector2(size[0] - buttonSize[0] - 10, size[1] - buttonSize[1] - 10);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (girl.x < size[0] / 2 - 140) {
      girl.x += 35 * dt;
      if (girl.x > 50 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (girl.x > 120 && dialogLevel == 1) {
        dialogLevel = 2;
      }
    } else if (turnAway == false && sceneLevel == 1) {
      boy.flipHorizontally();

      turnAway = true;
      if (dialogLevel == 2) {
        dialogLevel = 3;
      }
    }

    if (boy.x > size[0] / 2 - 30 && sceneLevel == 1) {
      boy.x -= 35 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (dialogLevel) {
      case 1:
        if (!musicPlaying) {
          FlameAudio.bgm.play('track1.mp3');
          musicPlaying = true;
        }

        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0], 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(
            canvas,
            'Erika [thinking]: I\'m late for my meeting presentation!',
            Vector2(10, size[1] - 80));
        break;
      case 2:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0], 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(
            canvas,
            'Ken [thinking]: I need to hurry to work!',
            Vector2(10, size[1] - 80));
        break;
      case 3:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(canvas, 'Erika: Oh! Sorry I bumped into you.',
            Vector2(10, size[1] - 80));
        add(dialogButton);
        break;
    }
    switch (dialogButton.scene2Level) {
      case 1:
        sceneLevel = 2;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(
            canvas,
            'Ken: No worries, by the way have we met before?',
            Vector2(10, size[1] - 80));
        if (turnAway) {
          boy.flipHorizontally();
          boy.x = boy.x + 150;
          turnAway = false;

          remove(background);
          remove(boy);
          remove(girl);
          add(background2);
          add(boy);
          add(girl);
        }
        break;
      case 2:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(
            canvas,
            'Erika: Hrm, you look familiar as well... \n You\'re Ken right?',
            Vector2(10, size[1] - 80));
        break;
      case 3:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(
            canvas,
            'Ken: Yea! We were childhood friends. \n I\'d love to catch up - here\'s my number!',
            Vector2(10, size[1] - 80));

        break;
    }
    switch (dialogButton.scene2Level) {
      case 4:
        sceneLevel = 3;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        remove(background2);
        remove(boy);
        remove(girl);
        add(background3);
        girl.x = size.x / 2;
        add(girl);
        dialogTextPaint.render(
            canvas,
            '[thinking] That was such a suprise meeting Ken! \nI should give him a call soon.',
            Vector2(10, size[1] - 80));
        break;
      case 5:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        phone.x = girl.x + 30;
        phone.y = girl.y + 50;
        add(phone);
        dialogTextPaint.render(
            canvas, '*ringing* *ringing*', Vector2(10, size[1] - 80));
        break;
      case 6:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(
            canvas,
            'Hi Ken! Let\'s meet at Paris cafe at 4:30.',
            Vector2(10, size[1] - 80));
        break;
    }
    switch (dialogButton.scene2Level) {
      case 7:
        sceneLevel = 4;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        remove(background3);
        remove(phone);
        remove(girl);
        add(background4);
        girl.x = size.x / 2 - 20;
        add(girl);
        add(boy);
      

    //     if (!musicPlaying) {
    //       if (!FlameAudio.bgm.isPlaying) {
    //  FlameAudio.bgm.play('track2.mp3');
    //       musicPlaying = true;
    //       }
     
    //     }
        dialogTextPaint.render(
            canvas,
            'Ken: Thanks for the invite! Do you want to get dinner?',
            Vector2(10, size[1] - 80));
        break;
      case 8:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        girl.x = size.x / 2 - 100;
        if (girlTurnAway == false) {
          girl.flipHorizontally();
          girlTurnAway = true;
        }
        ring.x = girl.x + 20;
        ring.y = girl.y + 50;
        add(ring);
        dialogTextPaint.render(
            canvas,
            'Erika: Ah, sorry. I\'m actually engaged.',
            Vector2(10, size[1] - 80));
        break;
      case 9:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        dialogTextPaint.render(
            canvas, 'Ken: Do you love the guy?', Vector2(10, size[1] - 80));
        break;
      case 10:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Color(0xFFd6a88a));
        remove(ring);
        dialogTextPaint.render(canvas, 'Erika: It\'s an arranged marriage...',
            Vector2(10, size[1] - 80));
        break;
      case 11:
        remove(background4);

        canvas.drawRect(Rect.fromLTWH(0, size[1] - 101, size[0], 101),
            Paint()..color = Color(0xFFd6a88a));

        finalPaint.render(
            canvas, 'To be continued', Vector2(250, size[1] - 80));
   if (musicPlaying) {
          FlameAudio.bgm.stop();
          musicPlaying = false;
        }
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      print('we will move to the next screen');
      if (scene2Level < 11) {
        scene2Level++;
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
