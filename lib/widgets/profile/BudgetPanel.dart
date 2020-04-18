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
      children: [
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.attach_money),
            hintText: 'Enter your budget limit',
            labelText: 'Credit Limit',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          validator: (val) => val.isEmpty || val == '0.0' ? 'required' : null,
          initialValue: budget.settings.limit.toString(),
          onChanged: (val) => onModelChange(
              budget,
              (model) => model.settings.limit = double.parse(val),
              invokeChange),
        ),
        Column(
          children: <Widget>[
            createFrequencyRadio(
                budget, BudgetFrequency.DAILY, 'Daily', invokeChange),
            createFrequencyRadio(
                budget, BudgetFrequency.WEEKLY, 'Weekly', invokeChange),
            createFrequencyRadio(
                budget, BudgetFrequency.MONTHLY, 'Monthly', invokeChange),
          ],
        ),
      ],
    );
  }

  RadioListTile<BudgetFrequency> createFrequencyRadio(
          Budget budget,
          BudgetFrequency freq,
          String txt,
          void Function(VoidCallback cb) invokeChange) =>
      RadioListTile<BudgetFrequency>(
        title: Text(txt),
        groupValue: budget.settings.frequency,
        value: freq,
        onChanged: (val) => onModelChange(
            budget, (model) => budget.settings.frequency = val, invokeChange),
      );
}
