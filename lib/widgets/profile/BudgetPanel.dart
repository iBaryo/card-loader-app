import 'package:card_loader/models/Budget.dart';
import 'package:card_loader/repos/BudgetRepo.dart';
import 'package:card_loader/widgets/profile/BasePanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetPanel extends BasePanel<Budget> {
  BudgetPanel(BudgetRepo budgetRepo) : super(budgetRepo);

  @override
  String getTitleText() => 'Budget Management';

  @override
  String getSubTitleText() =>
      'Help you manage your budget so you can get the best of it';

  @override
  Future save(Budget budget) {
    budget.resetState();
    return super.save(budget);
  }

  @override
  Widget getBody(BuildContext context, Budget budget,
      void Function(VoidCallback cb) invokeChange) {
    return Column(
      children: <Widget>[
        createFrequencyInput(
            budget, BudgetFrequency.DAILY, 'Daily', invokeChange),
        createFrequencyInput(
            budget, BudgetFrequency.WEEKLY, 'Weekly', invokeChange),
        createFrequencyInput(
            budget, BudgetFrequency.MONTHLY, 'Monthly', invokeChange),
      ],
    );
  }

  Widget createFrequencyInput(Budget budget, BudgetFrequency freq, String txt,
          void Function(VoidCallback cb) invokeChange) =>
      CheckboxListTile(
        value: budget.settings.hasLimit(freq),
        onChanged: (val) => onModelChange(
            budget,
            (model) => val
                ? model.settings.limits[freq] = 1
                : model.settings.reset(freq),
            invokeChange),
        title: TextFormField(
          decoration: InputDecoration(
            icon: const Icon(Icons.attach_money),
            hintText: 'Enter your budget limit',
            labelText: '$txt Credit Limit',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          enabled: budget.settings.hasLimit(freq),
          validator: (val) => val.isEmpty || val == '0.0' ? 'required' : null,
          initialValue: (budget.settings.limits[freq] ?? 0).toString(),
          onChanged: (val) => onModelChange(
              budget,
              (model) => model.settings.limits[freq] = double.parse(val),
              invokeChange),
        ),
      );
}
