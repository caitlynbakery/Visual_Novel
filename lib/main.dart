import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() {
  print('load the game widget');

  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasTappables {
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(70.0, 70.0);

  final double girlSize = 200;
  final double boySize = 220;
  bool turnAway = false;
  int dialogLevel = 0;
  int sceneLevel = 1;

  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize: 25));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    final textBoxHeight = 100;

//background2
    background2
      ..sprite = await loadSprite('city3.jpg')
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
        dialogTextPaint.render(
            canvas,
            'Erika [thinking]: I\'m late for my meeting presentation!',
            Vector2(10, size[1] - 80));
        break;
      case 2:
        dialogTextPaint.render(
            canvas,
            'Ken [thinking]: I need to hurry to work!',
            Vector2(10, size[1] - 80));
        break;
      case 3:
        dialogTextPaint.render(canvas, 'Erika: Oh! Sorry I bumped into you.',
            Vector2(10, size[1] - 80));
        add(dialogButton);
        break;
    }
    switch (dialogButton.scene2Level) {
      case 1:
      sceneLevel = 2;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Colors.brown);
        dialogTextPaint.render(canvas, 'Ken: No worries, by the way have we met before?',
            Vector2(10, size[1] - 80));
        if(turnAway){
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
            Paint()..color = Colors.brown);
        dialogTextPaint.render(canvas, 'Erika: Hrm, you look familiar as well... \n You\'re Ken right?',
            Vector2(10, size[1] - 80));
        break;
        case 3:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 90, 100),
            Paint()..color = Colors.brown);
        dialogTextPaint.render(canvas, 'Ken: Yea! We were childhood friends. \n I\'d love to catch up - here\'s my number!',
            Vector2(10, size[1] - 80));
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      print('we will move to the next screen');
      scene2Level++;
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}