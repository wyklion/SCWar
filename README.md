# SCWar 方圆大战

用Flutter + Flame开发。
https://scwar.netlify.app/
  
# 开发日志（2023）
不写了。。。

# 编译
本机测试
python3 -m http.server

<!-- WEB(gh-page)：
flutter build web -o docs --base-href=/SCWar/ --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/ -->

WEB(vercel)：
flutter build web -o docs --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=canvaskit/

# 规则说明

### 初始状态
    初始准备炮塔1分。
    初始行必有一个资源。

### 生成数值规则
    生成怪基础分：炮塔总分除以5取整。
    小怪值：基础分的1倍到3倍之间
    大怪值：取最大炮塔和基础分3倍的平均值为基础，生成基础的2到3倍之间。
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
    ///     其中1/3机率生成炮资源（连续生成2个怪及以内不会生成资源。连续10个怪后必出资源）
    ///       资源中1/3出随机2倍，2/3出普通资源
    ///     2/3机率生成怪。
    /// 返回第一行数据给外部。
    /// 然后在第二行可生成位置（会被第一行大怪档住）生成大怪。
    ///   在大怪数上限内，1/3机率生成大怪。

### 单位显示
    炮和资源16384开始显示16K。
    怪1000以上就显示K带一位小数。
    分数99999999以上显示三位小数带单位。