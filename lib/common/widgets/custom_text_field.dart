import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.controller,
    this.labelText,
    required this.validator,
    super.key,
    this.obscureText = false,
    this.prefixIcon,
    this.hintText,
    this.keyboardType = TextInputType.text,
  });
  final TextEditingController controller;
  final String? labelText;
  final bool obscureText;
  final Icon? prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final String? hintText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscure = false;

  @override
  void initState() {
    _isObscure = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final borderRadius = BorderRadius.circular(16);
    final appTheme = Theme.of(context);
    final colorScheme = appTheme.colorScheme;
    final textTheme = appTheme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              widget.labelText!,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        TextFormField(
          controller: widget.controller,
          cursorColor: colorScheme.primary,
          style: textTheme.titleMedium,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: textTheme.titleMedium?.copyWith(
              color: Color(0xffD9D9D9),
            ),
            errorMaxLines: 4,
            isDense: false,
            prefixIcon: widget.prefixIcon,
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      onPressed:
                          () => setState(() {
                            _isObscure = !_isObscure;
                          }),
                      icon:
                          _isObscure
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                    )
                    : null,
            labelStyle: textTheme.titleSmall,
            filled: true,
          ),
          obscureText: _isObscure,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
        ),
      ],
    );
  }
}
