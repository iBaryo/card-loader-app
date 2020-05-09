import 'package:card_loader/models/CompanyCard.dart';
import 'package:card_loader/repos/CardRepo.dart';
import 'package:card_loader/widgets/profile/BasePanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DirectLoadPanel extends BasePanel<CompanyCard> {
  DirectLoadPanel(CardRepo cardRepo) : super(cardRepo);

  @override
  String getTitleText() => 'Direct Load';

  @override
  String getSubTitleText() => 'Details to enable direct usage of your budget.';

  @override
  Widget getBody(BuildContext context, CompanyCard card,
      void Function(VoidCallback cb) invokeChange) {
    return Column(
      children: <Widget>[
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.person),
            hintText: 'Enter your first name',
            labelText: 'First name',
          ),
          keyboardType: TextInputType.text,
          validator: (val) => val.isEmpty ? 'required' : null,
          initialValue: card.firstName,
          onChanged: (val) =>
              onModelChange(card, (card) => card.firstName = val, invokeChange),
        ),
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.person_outline),
            hintText: 'Enter your last name',
            labelText: 'Last name',
          ),
          keyboardType: TextInputType.text,
          validator: (val) => val.isEmpty ? 'required' : null,
          initialValue: card.lastName,
          onChanged: (val) =>
              onModelChange(card, (card) => card.lastName = val, invokeChange),        ),
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.credit_card),
            hintText: 'Enter your Cibus card number',
            labelText: 'Card Number',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          validator: (val) => val.isEmpty ? 'required' : null,
          initialValue: card.number,
          onChanged: (val) =>
              onModelChange(card, (card) => card.number = val, invokeChange),        ),
      ],
    );
  }
}
