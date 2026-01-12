import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Channels')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Stay in sync everywhere',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Configure default email, enable push notifications, and choose how you want to be reminded.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          SwitchListTile.adaptive(
            value: true,
            onChanged: (_) {},
            title: const Text('Push notifications'),
            subtitle:
                const Text('Uses your device notifications to keep you on track'),
          ),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            value: false,
            onChanged: (_) {},
            title: const Text('Email digests'),
            subtitle:
                const Text('Receive a daily summary of upcoming reminders'),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mail_outline),
            label: const Text('Connect email provider'),
          ),
        ],
      ),
    );
  }
}
