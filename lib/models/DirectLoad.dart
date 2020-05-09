import 'package:card_loader/models/CompanyCard.dart';

class DirectLoadConfig {
  final List<String> requiredFields;

  DirectLoadConfig(this.requiredFields);
}

class DirectLoad {
  DirectLoadConfig config;
  CompanyCard card;
  dynamic providerFields;

  DirectLoad({this.config, this.card, this.providerFields});

  isActive() =>
      (config?.requiredFields?.every((f) => providerFields[f] != null) ?? false) &&
      (card?.isActive() ?? false);
}
