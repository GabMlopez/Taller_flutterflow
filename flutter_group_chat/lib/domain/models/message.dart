import 'package:flutter/material.dart';

class Message {
  final String id;
  final String user;
  final String content;
  final String timestamp;
  final String status;

  Message({required this.id, required this.user, required this.content, required this.timestamp, required this.status});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      user: json['user'],
      content: json['content'],
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }
}