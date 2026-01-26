import 'package:flutter/material.dart';

/// Reusable Privacy Policy dialog that accepts plain text via `contentText`.
/// Now supports parameterized width and height:
///  - `width`: exact dialog width in logical pixels (optional)
///  - `height`: exact dialog height in logical pixels (optional)
///  - `maxHeight`: fallback maximum height when `height` is not provided
///
/// Behavior:
///  - If `width` is null, dialog fills the available width minus 32px insets.
///  - If `height` is null, `maxHeight` is used (default 560), but it will not exceed 80% of screen height.
class PrivacyPolicyDialog extends StatefulWidget {
  final String title;
  final String contentText;
  final String checkboxLabel;
  final String closeButtonText;
  final String agreeButtonText;
  final bool showAgreeButton;
  final bool requireScrollToEnd;
  final bool initialChecked;

  // Layout params
  final double? width; // exact width of dialog card (optional)
  final double? height; // exact height of dialog card (optional)
  final double maxHeight; // fallback maxHeight when height is null
  final EdgeInsetsGeometry padding;

  final Color? headerColor;
  final Color? backgroundColor;
  final VoidCallback? onAgree;
  final VoidCallback? onClose;
  final BorderRadius? borderRadius;
  final TextStyle? contentTextStyle;

  const PrivacyPolicyDialog({
    Key? key,
    this.title = 'Privacy Policy',
    required this.contentText,
    this.checkboxLabel = 'I have read and agreed to the privacy policy',
    this.closeButtonText = 'Close',
    this.agreeButtonText = 'Agree',
    this.showAgreeButton = false,
    this.requireScrollToEnd = false,
    this.initialChecked = false,
    this.width,
    this.height,
    this.maxHeight = 560,
    this.padding = const EdgeInsets.all(16),
    this.headerColor,
    this.backgroundColor,
    this.onAgree,
    this.onClose,
    this.borderRadius,
    this.contentTextStyle,
  }) : super(key: key);

  @override
  State<PrivacyPolicyDialog> createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  late final ScrollController _scrollController;
  late bool _isChecked;
  bool _isScrolledToEnd = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialChecked;
    _scrollController = ScrollController();
    if (widget.requireScrollToEnd) {
      _scrollController.addListener(_scrollListener);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollListener());
    }
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    final atBottom = (maxExtent - current) <= 4.0;
    if (atBottom != _isScrolledToEnd) {
      setState(() {
        _isScrolledToEnd = atBottom;
      });
    }
  }

  bool get _canAgree {
    if (!widget.showAgreeButton) return false;
    if (!_isChecked) return false;
    if (widget.requireScrollToEnd && !_isScrolledToEnd) return false;
    return true;
  }

  @override
  void dispose() {
    if (widget.requireScrollToEnd) {
      _scrollController.removeListener(_scrollListener);
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _close() {
    Navigator.of(context, rootNavigator: true).maybePop();
    widget.onClose?.call();
  }

  void _agree() {
    widget.onAgree?.call();
    Navigator.of(context, rootNavigator: true).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = widget.headerColor ?? const Color(0xFF0F3C36);
    final bgColor = widget.backgroundColor ?? Theme.of(context).dialogBackgroundColor;
    final radius = widget.borderRadius ?? const BorderRadius.all(Radius.circular(8));
    final textStyle = widget.contentTextStyle ??
        const TextStyle(fontSize: 14, height: 1.45, color: Colors.black87);

    // Split contentText by double-newline to create paragraph spacing
    final paragraphs = widget.contentText.split(RegExp(r'\n\n+'));

    // Calculate width/height fallback values
    final media = MediaQuery.of(context);
    final double horizontalInset = 32; // matches Dialog insetPadding default (16 left + 16 right)
    final double defaultWidth = media.size.width - horizontalInset;
    final double dialogWidth = widget.width != null ? widget.width!.clamp(0, media.size.width) : defaultWidth;

    // For height: if provided use it, else use min(widget.maxHeight, 80% of screen)
    final double maxAllowedHeight = media.size.height * 0.80;
    final double dialogHeight = widget.height ??
        (widget.maxHeight <= 0 ? maxAllowedHeight : widget.maxHeight.clamp(0, maxAllowedHeight));

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.vertical(top: radius.topLeft),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _close,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Body (text)
            Expanded(
              child: Padding(
                padding: widget.padding,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: paragraphs.map((p) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(p.trim(), style: textStyle),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (v) => setState(() => _isChecked = v ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isChecked = !_isChecked),
                      child: Text(
                        widget.checkboxLabel,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (widget.showAgreeButton)
                    ElevatedButton(
                      onPressed: _canAgree ? _agree : null,
                      child: Text(widget.agreeButtonText),
                    ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _close,
                    child: Text(widget.closeButtonText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}