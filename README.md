# SCWar 方圆大战

用Flutter + Flame开发。
https://scwar.netlify.app/

教ChatGpt写的介绍：

## 短介绍：

"《方圆大战》是一款深受策略游戏爱好者喜爱的创新之作。在这个以方形怪物与圆形炮塔为主角的颠覆性游戏中，您将挑战自己的战术智慧，通过合成圆形炮塔和巧妙的战术操作来抵挡方形怪物的进攻。拖动、合成、进攻，尽在《方圆大战》！"

英文版：
"Embark on a strategic journey with 'CircleSquare Clash,' a game that brings a fresh perspective to strategy gaming. Navigate the clash of shapes as you face off against square monsters and circular turrets. Drag, combine, and attack - all in the name of victory in 'CircleSquare Clash!'"
更短的:
Unleash strategic battles in 'CircleSquare Clash'! Command circle turrets, defend against square invaders, and merge for double power. Engage now!

## 稍长介绍：

"《方圆大战》是一款集合了策略、合成和挑战的创新游戏，让您在方与圆的碰撞中感受到不同寻常的游戏乐趣。游戏中，您面对着五列方形怪物，这些怪物将不断前行，而您的任务是通过合成圆形炮塔，精准攻击，有效地抵挡它们的入侵。

游戏特色：

策略合成系统： 利用合成系统，您可以通过将相同数字的圆形炮塔拖拽到一起合成，提升火力，增强攻击效果。策略性的合成决策将是您取得胜利的关键。

巧妙操作挑战： 游戏注重玩家的操作技巧，您需要时刻关注战场动态，巧妙地拖动和合成，精准攻击，以最小的代价抵挡怪物的前进。

升级和关卡挑战： 游戏提供多个关卡，随着关卡的升级，您将面临更加强大和复杂的敌人。通过不断升级炮塔，解锁新能力，挑战更高难度的关卡。

清新画面设计： 游戏采用清新简约的画面设计，呈现出独特的游戏风格，给玩家带来愉悦的视觉体验。

在《方圆大战》中，挑战您的战略思维，合成圆形炮塔，精准作战，打破传统游戏的框架，探索方与圆的战略新境界。快来加入这场前所未有的战斗，体验游戏的无尽乐趣！"

英文版：
"'CircleSquare Clash' is a unique fusion of strategy, synthesis, and challenge that delivers an extraordinary gaming experience. Confront five columns of square monsters relentlessly advancing towards you. Your mission: strategically synthesize circular turrets, unleash precise attacks, and effectively repel their invasion.

Game Features:

Strategic Synthesis System: Utilize the synthesis system to combine circular turrets with the same numeric values. Elevate your firepower and enhance your attacks by making strategic synthesis decisions, a key factor in securing victory.

Clever Tactical Challenges: The game emphasizes player skills and tactics. Stay vigilant, execute clever drags and syntheses, launch accurate attacks, and thwart the monsters' advance at minimal cost.

Upgrades and Level Challenges: 'CircleSquare Clash' offers multiple levels, each escalating in difficulty. Upgrade your turrets continuously, unlock new abilities, and take on higher difficulty levels for a more challenging gaming experience.

Fresh Visual Design: The game boasts a clean and minimalist visual design, presenting a unique gaming style that provides players with a delightful visual experience.

In 'CircleSquare Clash,' challenge your strategic thinking, synthesize circular turrets, engage in precise combat, break the mold of traditional games, and explore a new realm of strategic warfare. Join this unprecedented battle and immerse yourself in the endless fun of the game!"


# 开发记录（2023）

颜色都是 colordrop.io 上找的。
图标用 www.iconfont.cn 可以打包下载ttf，然后从json里找id手写个iconfont.dart。

github的io是半墙状态经常访问不了，后来试了vercel全墙。。最后用了netlify。
github的action挺好用，提交完代码等一分半钟就自己生成web包，然后自动提交。netlify又自动更新发布。

12.10晚上续费平果开发者帐号，以为瞬间生效，结果第二天才生效。

AppConnect协议，美国报税表

cocoaPods安装， 国外源不行。
gem sources --add https://gems.ruby-china.com --remove https://rubygems.org/
sudo gem install drb -v 2.0.5
sudo gem install activesupport -v 6.1.7.6
sudo gem install cocoapods

要先启动模拟器，再运行。pod下载也会有下不了的好像。
运行报错
[ERROR:flutter/shell/platform/darwin/graphics/FlutterDarwinContextMetalImpeller.mm(42)] Using the Impeller rendering backend.
Info.plist上要加上
<key>FLTEnableImpeller</key>
<false />
报一个什么系统错误，结果是广告没加plist。
还要加	<key>GADApplicationIdentifier</key> <key>SKAdNetworkItems</key>
ios声音报错
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: PlatformException(DarwinAudioError, Failed to set source. For troubleshooting, see https://github.com/bluefireteam/audioplayers/blob/main/troubleshooting.md, AVPlayerItem.Status.failed on setSourceUrl, null)
都转成mp3的就好了。

ios要三种规格的截图各三张。用了GIMP，就缩放。
隐私政策用免费生成网站：https://app.freeprivacypolicy.com/
数据收集填什么，因为用了admob。就选了粗略位置。



# 编译
本机测试
python3 -m http.server

<!-- WEB(gh-page)：
flutter build web -o docs --base-href=/SCWar/ --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ -->

WEB(netlify)：
flutter build web -o docs --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/

# 规则说明

### 初始状态
    初始准备炮塔1分。
    初始行必有一个资源。

### 生成数值规则
    生成怪基础分：炮塔总分除以5取整。
    小怪值：怪基础分的1倍到3倍之间
    大怪值：取最大炮塔0.3倍和基础分1.7倍的平均值为基础，生成基础的2到3倍之间。
        极限情况，最平均时全是1炮，大怪基础是(0.3+1.7)=2，算出大怪是4-6之间。
        只有一个5分炮，大怪基础(5*0.3+1.7)=3.2，大怪在6.4-9.6之间。
    炮分等级：总分从80开始是1级，每多一倍加1级。怪分成生有加成。
    怪分值加成：根据炮分等级加成*(1+0.002*_baseLevel)
    资源基础分：炮总分80（5炮平均分16）以上开始基础分升到2，5炮平均32，基础分到4。生成资源按概率生成1-3倍。
    资源值生成：60%基础分的1倍，30%基础分2倍，10%基础分4倍。
    一行最多大怪数量：炮塔分4分以下没有，100分以下1个，以上2个。
    一行怪最多占几格：炮分4以下2格，64以下3格，512以下4格，以上5格。

### 生成流程（每一行）
    /// 第二行         0 1 2 3 4
    ///                  下移
    /// 第一行         0 1 2 3 4
    ///                  下移
    /// 发送出现在屏幕上 0 1 2 3 4
    ///
    /// 有两行预生成行。每次生成时，先在第一行生成小怪。
    ///   在一行上限怪数内补充生成小怪/资源。
    ///   如果可以生成且剩三个格及以上，至少生成一个，之后50%机率生成东西
    ///     其中1/3机率生成炮资源（连续6个怪后必出资源）
    ///       资源中1/3出随机2倍，2/3出普通资源
    ///     2/3机率生成怪。
    /// 返回第一行数据给外部。
    /// 然后在第二行可生成位置（会被第一行大怪档住）生成大怪。
    ///   在大怪数上限内，1/4机率生成大怪。

### 单位显示
    炮和资源16384开始显示16K。
    怪1000以上就显示K带一位小数。
    分数99999999以上显示三位小数带单位。

### 关卡
    50关。
    初始炮分是1024的level次方。目标是初始的1024倍。
    初始炮塔给三个。