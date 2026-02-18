import 'dart:convert';
import 'package:flutter/foundation.dart';

// Helper to sanitize potentially malformed JSON from LLMs
String sanitizeJson(String raw) {
  // Remove markdown code blocks if present
  String clean = raw.replaceAll(RegExp(r'```json|```'), '').trim();
  
  // Sometimes LLMs return text before/after JSON; try to find the start/end braces
  final startIndex = clean.indexOf('{');
  final endIndex = clean.lastIndexOf('}');
  
  if (startIndex != -1 && endIndex != -1) {
    clean = clean.substring(startIndex, endIndex + 1);
  }
  
  return clean;
}
