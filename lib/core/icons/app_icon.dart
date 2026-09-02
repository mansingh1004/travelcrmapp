import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import 'app_icon_data.dart';

export 'app_icon_data.dart';

/// The prototype's line icons — 24×24, 1.7px stroke, `currentColor`.
///
/// Ported as SVG rather than redrawn with Material icons so the stroke weight
/// and geometry match the design exactly, which is what "clean 1.7px stroke
/// line icons throughout" asks for.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 20,
    this.color = AppColors.ink,
    this.semanticLabel,
  });

  /// A key from [AppIconData.paths], e.g. `'home'`, `'chevR'`, `'checkC'`.
  final String name;
  final double size;
  final Color color;

  /// Required by the accessibility rule for any icon that carries meaning on
  /// its own. Decorative icons pass null and are hidden from screen readers.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final body = AppIconData.paths[name];

    if (body == null) {
      assert(false, 'Unknown icon "$name"');
      return SizedBox.square(dimension: size);
    }

    final svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'width="$size" height="$size">$body</svg>';

    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}

/// Icon names, so call sites are checked at compile time instead of relying on
/// string literals.
abstract final class Ic {
  static const home = 'home';
  static const users = 'users';
  static const calendar = 'calendar';
  static const package = 'package';
  static const chat = 'chat';
  static const menu = 'menu';
  static const bell = 'bell';
  static const user = 'user';
  static const search = 'search';
  static const filter = 'filter';
  static const sort = 'sort';
  static const plus = 'plus';
  static const phone = 'phone';
  static const wa = 'wa';
  static const chevronRight = 'chevR';
  static const chevronDown = 'chevD';
  static const back = 'back';
  static const check = 'check';
  static const checkCircle = 'checkC';
  static const alert = 'alert';
  static const close = 'x';
  static const clock = 'clock';
  static const pin = 'pin';
  static const bed = 'bed';
  static const car = 'car';
  static const camera = 'camera';
  static const plane = 'plane';
  static const wallet = 'wallet';
  static const file = 'file';
  static const chart = 'chart';
  static const cog = 'cog';
  static const help = 'help';
  static const logout = 'logout';
  static const edit = 'edit';
  static const download = 'download';
  static const send = 'send';
  static const trash = 'trash';
  static const drag = 'drag';
  static const dots = 'dots';
  static const star = 'star';
  static const flame = 'flame';
  static const receipt = 'receipt';
  static const shield = 'shield';
  static const globe = 'globe';
  static const grid = 'grid';
  static const building = 'building';
  static const refresh = 'refresh';
  static const clip = 'clip';
  static const trend = 'trend';
  static const target = 'target';
  static const inbox = 'inbox';
}
