import 'package:kanji_app/design_system.dart';
import 'package:kanji_app/design_system/motion.dart';
import 'package:kanji_app/design_system/sliver_inset_pinned_header.dart';
import 'package:kanji_app/navigation/shell_chrome.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const AppBigTitleScaffold({
  super.key,
  required final String title,
  required final ScrollController scrollController,
  final bool showScrollToTopFab = true,
  final Widget? pinnedHeader,
  final Widget? bottomChild,
  required final List<Widget> slivers,
}) extends HookWidget {
  static const _scrollToTopThreshold = 300.0;

  static const _scrollToTopDistance = 500.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);

    final scrolled = useListenableSelector(
      scrollController,
      () =>
          scrollController.hasClients &&
          scrollController.offset > _scrollToTopThreshold,
    );

    final onTop =
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.isCurrentOf(context) ?? true);
    final offersScrollToTop = showScrollToTopFab && scrolled && onTop;

    final owner = useMemoized(Object.new);
    useEffect(() {
      final chrome = context.read<ShellChrome?>();
      if (chrome == null || !offersScrollToTop) {
        return null;
      }

      chrome.offerScrollToTop(owner, () {
        if (!scrollController.hasClients) {
          return;
        }
        if (scrollController.offset > _scrollToTopDistance) {
          scrollController.jumpTo(_scrollToTopDistance);
        }
        scrollController.springTo(0);
      });
      return () => chrome.withdrawScrollToTop(owner);
    }, [offersScrollToTop]);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverPadding(
            padding: viewPadding
                .copyWith(bottom: bottomChild == null ? null : 0)
                .add(const AppEdgeInsets.all(.medium)),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: AppPadding(
                    padding: const .symmetric(horizontal: .medium),
                    child: Text(
                      title,
                      style: theme.textTheme.displayLarge?.apply(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                if (pinnedHeader case final pinnedHeader?) ...[
                  AppUnit.xsmall.sliverGap,
                  SliverInsetPinnedHeader(
                    inset: floatingTopInsetOf(context),
                    child: pinnedHeader,
                  ),
                ],
                ...slivers,
              ],
            ),
          ),
          if (bottomChild != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                alignment: .bottomCenter,
                padding: viewPadding
                    .copyWith(top: 0)
                    .add(const AppEdgeInsets.all(.medium)),
                child: ConstrainedBox(
                  constraints: const .tightFor(width: .infinity),
                  child: bottomChild,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
