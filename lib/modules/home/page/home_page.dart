import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/validation/validation.dart';
import '../controller/home_controller.dart';

class GeneratorPage extends StatelessWidget {
  final controller = Get.put(HomeController());
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Color(0xFF0D47A1);
    final lightBlue = Color(0xFF64B5F6);

    return Obx(() {
      inputController.text = controller.current.value;
      inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: inputController.text.length),
      );

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, lightBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(flex: 3, child: HistoryListView()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildTextField(inputController),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.addCurrentToHistory,
                      icon: Icon(Icons.add),
                      label: Text('Agregar'),
                      style: _buttonStyle(Colors.white, primaryBlue),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.clearCurrent();
                        inputController.clear();
                      },
                      icon: Icon(Icons.clear),
                      label: Text('Limpiar'),
                      style: _buttonStyle(Colors.grey.shade200, Colors.black87),
                    ),
                  ],
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Escribe un producto',
        prefixIcon: Icon(Icons.edit),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (value) {
        if (InputValidation.isDuplicate(value, this.controller.history)) {
          Get.snackbar('Error', 'Esta palabra ya fue agregada');
          controller.clear();
          this.controller.clearCurrent();
          return;
        }
        this.controller.setCurrent(value);
      },
    );
  }

  ButtonStyle _buttonStyle(Color bgColor, Color fgColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Color(0xFF0D47A1);

    return Obx(() {
      if (controller.favorites.isEmpty) {
        return Center(
          child: Text(
            'No tienes favoritos aún.',
            style: TextStyle(color: primaryBlue, fontSize: 18),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Favoritos'),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 4.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: controller.favorites.length,
            itemBuilder: (_, index) {
              final item = controller.favorites[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => controller.removeFavorite(item),
                  ),
                  title: Text(item),
                ),
              );
            },
          ),
        ),
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
    final primaryBlue = Color(0xFF0D47A1);

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
            final isFav = controller.favorites.contains(item);

            return SizeTransition(
              sizeFactor: animation,
              child: Center(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(item),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : primaryBlue,
                      ),
                      onPressed: () => controller.toggleFavorite(item),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

