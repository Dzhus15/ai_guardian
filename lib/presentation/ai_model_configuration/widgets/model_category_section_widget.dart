import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import './model_card_widget.dart';

class ModelCategorySectionWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onToggleExpansion;
  final Function(String, String, bool) onToggleModel;
  final Function(String, String, String, dynamic) onUpdateParameter;
  final Function(Map<String, dynamic>) onShowModelDetails;

  const ModelCategorySectionWidget({
    super.key,
    required this.category,
    required this.onToggleExpansion,
    required this.onToggleModel,
    required this.onUpdateParameter,
    required this.onShowModelDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = category["isExpanded"] as bool;
    final models = category["models"] as List;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: _getCategoryIcon(category["id"]),
              color: AppTheme.accentColor,
              size: 24,
            ),
            title: Text(
              category["name"],
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            subtitle: Text(
              category["description"],
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            trailing: CustomIconWidget(
              iconName: isExpanded ? 'expand_less' : 'expand_more',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onTap: onToggleExpansion,
          ),
          if (isExpanded) ...[
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: models
                    .map<Widget>((model) => ModelCardWidget(
                          model: model,
                          categoryId: category["id"],
                          onToggleModel: onToggleModel,
                          onUpdateParameter: onUpdateParameter,
                          onShowDetails: () => onShowModelDetails(model),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'computer_vision':
        return 'visibility';
      case 'audio_analysis':
        return 'hearing';
      case 'behavioral_detection':
        return 'psychology';
      case 'custom_models':
        return 'extension';
      default:
        return 'smart_toy';
    }
  }
}
