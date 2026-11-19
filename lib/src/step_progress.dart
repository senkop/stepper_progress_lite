import 'package:flutter/material.dart';

/// The state of a step relative to the current one.
enum StepStatus {
  /// Before the current step.
  done,

  /// The current step.
  active,

  /// After the current step.
  upcoming,
}

/// The state of step [index] when [current] is the active step.
StepStatus stepStateOf(int index, int current) {
  if (index < current) return StepStatus.done;
  if (index == current) return StepStatus.active;
  return StepStatus.upcoming;
}

/// A row (or column) of numbered circles joined by lines, with labels.
/// Finished steps show a check mark.
///
/// ```dart
/// StepProgress(
///   steps: const ['Cart', 'Address', 'Payment', 'Done'],
///   current: 2,
/// )
/// ```
class StepProgress extends StatelessWidget {
  /// Creates the indicator.
  const StepProgress({
    super.key,
    required this.steps,
    required this.current,
    this.subtitles,
    this.direction = Axis.horizontal,
    this.onStepTapped,
    this.activeColor,
    this.inactiveColor,
    this.size = 28,
  });

  /// Step labels.
  final List<String> steps;

  /// Index of the current step. Use `steps.length` to mark all as done.
  final int current;

  /// Optional second line under each label.
  final List<String>? subtitles;

  /// Horizontal or vertical.
  final Axis direction;

  /// Called with a step index when it is tapped.
  final ValueChanged<int>? onStepTapped;

  /// Color of done and active steps. Defaults to the primary color.
  final Color? activeColor;

  /// Color of upcoming steps and lines.
  final Color? inactiveColor;

  /// Circle diameter.
  final double size;

  @override
  Widget build(BuildContext context) {
    assert(subtitles == null || subtitles!.length == steps.length);
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? theme.colorScheme.outlineVariant;
    final horizontal = direction == Axis.horizontal;

    Widget circle(int i) {
      final state = stepStateOf(i, current);
      final filled = state != StepStatus.upcoming;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: state == StepStatus.done ? active : theme.colorScheme.surface,
          border: Border.all(color: filled ? active : inactive, width: 2),
        ),
        child: state == StepStatus.done
            ? Icon(Icons.check,
                size: size * 0.6, color: theme.colorScheme.onPrimary)
            : Text(
                '${i + 1}',
                style: TextStyle(
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.w600,
                  color: filled ? active : theme.colorScheme.onSurfaceVariant,
                ),
              ),
      );
    }

    Widget line(int i) => Container(
          width: horizontal ? null : 2,
          height: horizontal ? 2 : 28,
          margin: horizontal
              ? EdgeInsets.only(top: size / 2 - 1)
              : EdgeInsetsDirectional.only(start: size / 2 - 1),
          color: i < current ? active : inactive,
        );

    Widget label(int i) {
      final state = stepStateOf(i, current);
      return Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            steps[i],
            textAlign: horizontal ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: state == StepStatus.active
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: state == StepStatus.upcoming
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface,
            ),
          ),
          if (subtitles != null)
            Text(
              subtitles![i],
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
        ],
      );
    }

    Widget tappable(int i, Widget child) => onStepTapped == null
        ? child
        : InkWell(
            onTap: () => onStepTapped!(i),
            borderRadius: BorderRadius.circular(8),
            child: child,
          );

    if (horizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) Expanded(child: line(i)),
            tappable(
              i,
              SizedBox(
                width: 72,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [circle(i), const SizedBox(height: 6), label(i)],
                ),
              ),
            ),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) line(i),
          tappable(
            i,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [circle(i), const SizedBox(width: 12), label(i)],
            ),
          ),
        ],
      ],
    );
  }
}
