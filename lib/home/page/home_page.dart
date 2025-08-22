import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'package:namer_app/validation/validation.dart';

class GeneratorPage extends StatelessWidget {
  final controller = Get.put(HomeController());
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      inputController.text = controller.current.value;
      inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: inputController.text.length),
      );

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 3, child: HistoryListView()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  labelText: 'Escribe un producto',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (InputValidation.isDuplicate(value, controller.history)) {
                    Get.snackbar('Error', 'Esta palabra ya fue agregada');
                    inputController.clear();
                    controller.clearCurrent();
                    return;
                  }
                  controller.setCurrent(value);
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.addCurrentToHistory,
                  icon: Icon(Icons.add),
                  label: Text('Agregar'),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.clearCurrent();
                    inputController.clear();
                  },
                  icon: Icon(Icons.clear),
                  label: Text('Limpiar'),
                ),
              ],
            ),
            Spacer(flex: 2),
          ],
        ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.favorites.isEmpty) {
        return Center(child: Text('No favorites yet.'));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Text('You have ${controller.favorites.length} favorites:'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 400 / 80,
              ),
              itemCount: controller.favorites.length,
              itemBuilder: (_, index) {
                final item = controller.favorites[index];
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () => controller.removeFavorite(item),
                  ),
                  title: Text(item),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class HistoryListView extends StatelessWidget {
  final controller = Get.find<HomeController>();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ShaderMask(
        shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: AnimatedList(
          key: controller.historyListKey,
          reverse: true,
          padding: EdgeInsets.only(top: 100),
          initialItemCount: controller.history.length,
          itemBuilder: (context, index, animation) {
            final item = controller.history[index];
            return SizeTransition(
              sizeFactor: animation,
              child: Center(
                child: TextButton.icon(
                  onPressed: () => controller.toggleFavorite(item),
                  icon: controller.favorites.contains(item)
                      ? Icon(Icons.favorite, size: 12)
                      : SizedBox(),
                  label: Text(item),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
