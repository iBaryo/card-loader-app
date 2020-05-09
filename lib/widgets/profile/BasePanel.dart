import 'package:card_loader/models/IActive.dart';
import 'package:card_loader/repos/BaseRepo.dart';
import 'package:card_loader/utils/Debouncer.dart';
import 'package:flutter/material.dart';

abstract class BasePanel<T extends IActive> {
  BaseRepo<T> _repo;
  Future<T> _modelFuture;
  Debouncer _debouncer = Debouncer(milliseconds: 300);

  bool isExpanded;
  bool isEnabled;
  bool isLoading = false;

  BasePanel(this._repo) {
    _modelFuture = getModel();
  }

  Future<ExpansionPanel> getPanel(
      BuildContext context, void Function(VoidCallback cb) invokeChange) async {
    final model = await _modelFuture;

    if (isEnabled == null) {
      isEnabled = model.isActive();
    }

    if (isExpanded == null) {
      isExpanded = isEnabled;
    }

    return ExpansionPanel(
        isExpanded: isExpanded || isEnabled,
        canTapOnHeader: true,
        headerBuilder: (context, isExpanded) => SwitchListTile(
              title: Row(
                children: [
                  Text(getTitleText()),
                  isLoading ? CircularProgressIndicator() : Container()
                ],
              ),
              subtitle: isExpanded ? Text(getSubTitleText()) : null,
              value: isEnabled,
              onChanged: (value) {
                isEnabled = value;
                _onAsyncAction(
                    () => isEnabled ? onEnabled(model) : onDisabled(),
                    invokeChange);
              },
            ),
        body: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: getBody(context, model, invokeChange)));
  }

  Future onDisabled() => clear();

  Future onEnabled(T model) => save(model);

  onModelChange(T model, void Function(T model) updateAction,
      void Function(VoidCallback cb) invokeChange) async {
    _debouncer.run(() {
      try {
        updateAction(model);
        isEnabled = true;
        if (shouldSave(model)) {
          _onAsyncAction(() => save(model), invokeChange);
        }
        else {
          invokeChange(() {});
        }
      } catch (e) {
        // ignore.
      }
    });
  }

  bool shouldSave(T model) => isEnabled && model.isActive();

  Future _onAsyncAction(Future Function() action,
      void Function(VoidCallback cb) invokeChange) async {
    invokeChange(() {
      isLoading = true;
    });
    try {
      await action();
    } catch (e) {
      print(e);
    } finally {
      invokeChange(() {
        isLoading = false;
      });
    }
  }

  Future<T> getModel() => _repo.get();

  Future save(T model) => _repo.set(model);

  Future clear() => _repo.clear();

  String getTitleText();

  String getSubTitleText();

  Widget getBody(BuildContext context, T model,
      void Function(VoidCallback cb) invokeChange);
}
