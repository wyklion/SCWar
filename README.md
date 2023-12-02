# SCWar 方圆大战

用Flutter + Flame开发。
https://wyklion.github.io/SCWar/
  
# 开发日志（2023）
不写了。。。

# 编译

WEB(gh-page)：
flutter build web -o docs --base-href=/SCWar/ --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/

WEB(vercel)：
flutter build web -o docs --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/

# 规则说明

### 初始状态
    初始准备炮塔1分。
    初始行必有一个资源。

### 数值信息
    炮塔总分：2*5区域里的炮数值总合
    资源基础分：10炮平均分在32开始基础分升到2，平均64，基础分到4。生成资源按概率生成1-3倍。

### 生成数值规则
    生成怪基础分：炮塔总分除以5取整。
    生成怪值：基础分的1倍到3倍之间，如果是大怪，最大炮塔的2倍-3倍之间。
    每5个小怪出一个双倍分小怪。
    资源值生成：60%基础分的1倍，30%基础分2倍，10%基础分4倍。
    一行最多大怪数量：炮塔分4分以下没有，100分以下1个，以上2个。
    一行怪最多占几格：炮分4以下2格，64以下3格，128以下4格，以上5格。

### 生成流程（每一行）
+  先生成大怪，在大怪数上限内，50%机率生成大怪。
+  还需生成的次数是：一行怪最多占几格减去大怪数*2
+    如果可以生成且剩三个格及以上，至少生成一个，之后50%机率生成（资源或怪）
        其中1/3机率生成炮资源（连续生成3个怪及以内不会生成资源。连续10个怪后必出资源）
        资源中1/4出随机2倍，3/4出普通资源
        2/3机率生成怪。

### 单位显示
    炮和资源16384开始显示16K。
    怪1000以上就显示K带一位小数。
    分数99999999以上显示三位小数带单位。